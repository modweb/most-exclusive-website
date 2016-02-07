# Queue Collection

GetNameSchema is used to create the autoform to take a ticket.

    @NameSchema = new SimpleSchema
      name:
        type: String
        label: 'Name'
        max: 100

ConnectionSchema has an ascending index on `ticketNumber`

    ConnectionSchema = new SimpleSchema
      ticketNumber:
        type: Number
        index: 1
      name:
        type: String
        max: 100
      timeEnqueued:
        type: Date
      timeKeepAlive:
        type: Date
        optional: yes
        index: 1
      connectionId:
        type: String
        optional: yes

    QueueMetaSchema = new SimpleSchema
      theOnlyConnectionAllowedIn:
        type: ConnectionSchema
        optional: yes
      hasCurrentConnectionPosted:
        type: Boolean
      currentlyServingTicketNumber:
        type: Number
      currentlyServingQueueId:
        type: String
        optional: yes
      timeCurrentTicketExpires:
        type: Date
      averageWaitTimeSeconds:
        type: Number
      totalWaitTimeSeconds:
        type: Number
      totalVisitors:
        type: Number
      nextTicketNumber:
        type: Number
      html:
        type: String
        optional: yes
      headerHTML:
        type: String
        optional: yes
      footerHTML:
        type: String
        optional: yes
      isActive:
        type: Boolean
        defaultValue: yes
        optional: yes

    QueueProcessedSchema = new SimpleSchema
      connection:
        type: ConnectionSchema
      waitTimeSeconds:
        type: Number
      postID:
        type: String
        max: 20
        optional: yes
      disconnect:
        type: Boolean
        optional: yes

    @Queue = new Meteor.Collection 'queue'
    Queue.attachSchema ConnectionSchema

There is only ever one Queue Meta.

    @QueueMeta = new Meteor.Collection 'queueMeta'
    QueueMeta.attachSchema QueueMetaSchema

    @QueueProcessed = new Meteor.Collection 'queueProcessed'
    QueueProcessed.attachSchema QueueProcessedSchema

    Meteor.methods
      getInQueue: (doc) ->

        return if this.isSimulation

Validate doc

        check doc, NameSchema

Get the next ticketNumber

        queueMeta = QueueMeta.findOne()

        if not queueMeta?
          Meteor.Error 'no-queue-meta', "There is no queue meta, something's wrong."

        if not queueMeta.isActive
          throw new Meteor.Error 'queue-inactive', "Queue is inactive, you can't take tickets right now."

        nextTicketNumber = queueMeta.nextTicketNumber

Create queue object

        now = moment.utc().toDate()
        connection =
          ticketNumber: nextTicketNumber
          name: doc.name
          timeEnqueued: now
          timeKeepAlive: now
          connectionId: this.connection.id

Check if connection is already queued

        critieria =
          connectionId: this.connection.id

        count = (Queue.find critieria).count()
        if count isnt 0
          throw new Meteor.Error 'get-outta-hereeeee', "Yo Mr. or Mrs. l33t, don't spoil the fun by trying to take lots of tickets."

Push onto the queue

        queueId = Queue.insert connection

Increment nextTicketNumber (because we've pulled the current next ticket number)

        nextTicketNumber += 1
        criteria =
          _id: queueMeta._id
        update =
          $set: nextTicketNumber: nextTicketNumber

        QueueMeta.update criteria, update

Send a notification email, unblock

        this.unblock()

        try
          if Meteor.settings.notifyEmail? and Meteor.settings.mailgunOptions?
            Mailguns = new Mailgun Meteor.settings.mailgunOptions
            Mailguns.send
              to: Meteor.settings.notifyEmail
              from: 'notify@mostexclusivewebsite.com'
              subject: 'Ticket Pulled!'
              text: "Ticket ##{connection.ticketNumber}. #{Meteor.absoluteUrl()}"
        catch error
          console.log error

        return queueId

      keepAlive: (_id) ->
        return if this.isSimulation
        criteria =
          _id: _id
        action =
          $set:
            timeKeepAlive: moment.utc().toDate()

        Queue.update criteria, action
