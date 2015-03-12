# Queue Collection

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
      getInQueue: (name) ->

        return if Meteor.isClient

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
          name: name
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

If the current serving ticket is equal to the newest connection ticket number,
then we should serve that ticket. That is, the latest connection in the queue is
the only connection in the queue.

        if connection.ticketNumber is queueMeta.currentlyServiceTicketNumber
          QueueMethods.serveCurrentTicket()

        return connection
