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

          criteria = connectionId: queueMeta.theOnlyConnectionAllowedIn.connectionId
          Queue.remove criteria

Update `QueueMeta` stats and ticket number.

          try
            averageWaitTimeSeconds = Math.round (((queueMeta.currentlyServingTicketNumber - 1) * queueMeta.averageWaitTimeSeconds) + waitTimeSeconds) / queueMeta.currentlyServingTicketNumber
            totalWaitTimeSeconds = queueMeta.totalWaitTimeSeconds + waitTimeSeconds
            currentlyServingTicketNumber = queueMeta.currentlyServingTicketNumber + 1
            _.extend update.$set,
              currentlyServingTicketNumber: currentlyServingTicketNumber
              hasCurrentConnectionPosted: no
              averageWaitTimeSeconds: averageWaitTimeSeconds
              totalWaitTimeSeconds: totalWaitTimeSeconds
          catch err
            console.log err

Lookup the lowest ticket # waiting in the `Queue`

        nextConnection = Queue.findOne {}, $sort: ticketNumber: 1

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

## Disconnect, remove from queue

    Meteor.onConnection (connection) ->
      connection.onClose ->

Remove the connection from the `Queue`

          criteria = connectionId: connection.id
          Queue.remove criteria
