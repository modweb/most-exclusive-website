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
      connectionId:
        type: String
        max: 20
      name:
        type: String
        max: 100
      timeEnqueued:
        type: Date

    QueueMetaSchema = new SimpleSchema
      theOnlyConnectionAllowedIn:
        type: ConnectionSchema
        optional: yes
      hasCurrentConnectionPosted:
        type: Boolean
      currentlyServingTicketNumber:
        type: Number
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

    QueueProcessedSchema = new SimpleSchema
      connection:
        type: ConnectionSchema
      waitTimeSeconds:
        type: Number
      postID:
        type: String
        max: 20
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

Check that the connection is not already in the queue.

        criteria =
          connectionId: this.connection.id

        if (Queue.find criteria).count() isnt 0
          Meteor.Error 'ditch-attempt', "Don't try to cut in line...it's not nice."

Get the next ticketNumber

        queueMeta = QueueMeta.findOne()

        if not queueMeta?
          Meteor.Error 'no-queue-meta', "There is no queue meta, something's wrong."

        nextTicketNumber = queueMeta.nextTicketNumber

Create queue object

        connection =
          ticketNumber: nextTicketNumber
          connectionId: this.connection.id
          name: doc.name
          timeEnqueued: moment.utc().toDate()

Push onto the queue

        Queue.insert connection

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

        return connection

      updateConnectionId: (oldConnectionId) ->
        return if this.isSimulation
        this.unblock()
        newConnectionId = this.connection.id
        return if not newConnectionId? or not oldConnectionId?
        criteria =
          connectionId: oldConnectionId
        action =
          $set:
            connectionId: newConnectionId

        Queue.update criteria, action

Update QueueMeta (TODO: way around lots of failed updates?)

        criteria =
          'theOnlyConnectionAllowedIn.connectionId': oldConnectionId
        action =
          $set:
            'theOnlyConnectionAllowedIn.connectionId': newConnectionId

        QueueMeta.update criteria, action
