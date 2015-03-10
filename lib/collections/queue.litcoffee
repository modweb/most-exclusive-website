# Queue Collection

ConnectionSchema has an ascending index on `ticketNumber`

    ConnectionSchema = new SimpleSchema
      ticketNumber:
        type: Number
        index: 1
      connectionId:
        type: Number
      name:
        type: String
      timeEnqueued:
        type: Date

    QueueMetaSchema = new SimpleSchema
      theOnlyConnectionAllowedIn:
        type: ConnectionSchema
        optional: yes
      currentTicketNumber:
        type: Number
      averageWaitTimeSeconds:
        type: Number
        optional: yes
      totalWaitTimeSeconds:
        type: Number
        optional: yes
      nextTicketNumber:
        type: Number
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

    Queue = new Meteor.Collection 'queue'
    Queue.attachSchema ConnectionSchema

There is only ever one Queue Meta.

    QueueMeta = new Meteor.Collection 'queueMeta'
    QueueMeta.attachSchema QueueMetaSchema

    QueueProcess = new Meteor.Collection 'queueProcessed'
    QueueProcess.attachSchema QueueProcessedSchema

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
          ticketNumber: ticketNumber
          connectionId: this.connection.id
          name: name
          timeEnqueued: new Date Date.UTC()

Push onto the queue

        Queue.insert connection

Update the queueMeta

        nextTicketNumber += 1
        criteria =
          _id: queueMeta._id
        update =
          $set: nextTicketNumber: nextTicketNumber

        QueueMeta.update criteria, update
