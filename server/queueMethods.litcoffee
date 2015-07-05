# Super secret queue methods

    @QueueMethods =
      popAndServeNextTicket: ->

Move the current connection to the processed queue

TODO: get postID

        queueMeta = QueueMeta.findOne()

Update object, extended at various point for updating the QueueMeta in one swoop

        update =
          $set: {}

If `theOnlyConnectionAllowedIn` is set to something, check if the connection
has expired and process the connection if it has.

        if queueMeta.theOnlyConnectionAllowedIn isnt undefined

          previousConnection = queueMeta.theOnlyConnectionAllowedIn
          previousConnectionDidntPosted = not queueMeta.hasCurrentConnectionPosted

Return if timeCurrentTicketExpires is in the future (hasn't expired)

          hasntExpired = queueMeta.timeCurrentTicketExpires > moment.utc().toDate()
          return if hasntExpired

Okay then, the current connection has expired, time to get bumped.
Insert the processed connection into the ProcessedQueue

          try

Calculate how long the connection had to wait in line.

            waitTimeSeconds = moment.utc().diff (moment.utc queueMeta.theOnlyConnectionAllowedIn.timeEnqueued), 'seconds'

Make the processed object.

            processed =
              connection: queueMeta.theOnlyConnectionAllowedIn
              waitTimeSeconds: waitTimeSeconds

Insert the processed connection to `QueueProcessed`

            QueueProcessed.insert processed
          catch err
            console.log err

Remove the connection from the `Queue`

          criteria = _id: queueMeta.currentlyServingQueueId
          Queue.remove criteria

Update `QueueMeta` stats and ticket number.

          try
            totalWaitTimeSeconds = queueMeta.totalWaitTimeSeconds + waitTimeSeconds
            currentlyServingTicketNumber = queueMeta.currentlyServingTicketNumber + 1
            _.extend update.$set,
              currentlyServingTicketNumber: currentlyServingTicketNumber
              hasCurrentConnectionPosted: no
              totalWaitTimeSeconds: totalWaitTimeSeconds
          catch err
            console.log err

Lookup the lowest ticket # waiting in the `Queue`

        nextConnection = Queue.findOne {}, { sort: { 'ticketNumber': 1 } }

Set the allowed connection and expireTime if one exists

If there is a nextConnection (i.e. someone waiting in line), then serve them.
Otherwise clear out theOnlyConnectionAllowedIn.

        if nextConnection?
          timeCurrentTicketExpires = moment.utc()
          timeCurrentTicketExpires.add 1, 'minutes'
          _.extend update.$set,
            theOnlyConnectionAllowedIn: nextConnection
            timeCurrentTicketExpires: timeCurrentTicketExpires.toDate()
            currentlyServingTicketNumber: nextConnection.ticketNumber
            currentlyServingQueueId: nextConnection._id

If there is no nextConnection, unset theOnlyConnectionAllowedIn.
Note, fake data is filled in to pass schema, even though we're $unset'ing

        else
          update.$unset = theOnlyConnectionAllowedIn: ""

        criteria = _id: queueMeta._id

Delete `update.$set` if it's empty

        if _.isEmpty update.$set
          delete update.$set

If `update` isn't empty, update!

        if not _.isEmpty update
          QueueMeta.update criteria, update


TODO: keep it DRY; logic isn't exactly shared and want to keep update atomic to
avoid extraneous DDP messages.

## Disconnect dead connections, remove from queue

      cleanUpDeadConnections: ->

A connection is dead if keepAlive > 5 minutes ago

        timeTwoMinutesAgoUtc = moment.utc().subtract('2', 'minutes').toDate()
        criteria =
          timeKeepAlive:
            $lt: timeTwoMinutesAgoUtc

        deadQueue = Queue.find criteria
        deadQueue.forEach (queue) ->
          criteria =
            _id: queue._id
          Queue.remove criteria

Calculate how long the connection had to wait in line.

          waitTimeSeconds = moment.utc().diff (moment.utc queue.timeEnqueued), 'seconds'

Make the processed object.

          processed =
            connection: queue
            waitTimeSeconds: waitTimeSeconds
            diconnect: yes
          QueueProcessed.insert processed

          queueMeta = QueueMeta.findOne()

          totalWaitTimeSeconds = queueMeta.totalWaitTimeSeconds + waitTimeSeconds

          criteria =
            _id: queueMeta._id
          action =
            $set:
              totalWaitTimeSeconds: totalWaitTimeSeconds
          QueueMeta.update criteria, action
