# Super secret queue methods

    @QueueMethods =
      popQueue: ->

Move the current connection to the processed queue

TODO: get postID

        queueMeta = QueueMeta.findOne()

        processed =
          connection: queueMeta.theOnlyConnectionAllowedIn
          waitTimeSeconds: (moment.utc()).seconds() - (moment.utc connection.timeEnqueued).seconds()

Remove the connection

        criteria =
          connectionId: connection.id

        Queue.remove criteria

Get the next connection.

        criteria =
          ticketNumber = queueMeta.currentTicketNumber + 1

        nextConnection = Queue.findOne criteria

Set the allowed connection if one exists

        update = $set: {}

        if nextConnection?
          _.extend update.$set,
            theOnlyConnectionAllowedIn: nextConnection

Bump the `currentTicketNumber`

        _.extend update.$set,
          nextTicketNumber: queueMeta.currentTicketNumber + 1

        criteria =
          _id: queueMeta._id

        QueueMeta.update criteria, update
