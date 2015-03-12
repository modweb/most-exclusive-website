# Super secret queue methods

    @QueueMethods =
      popAndServeNextTicket: ->

Move the current connection to the processed queue

TODO: get postID

        queueMeta = QueueMeta.findOne()

Save `currentlyServingTicketNumber` for potential updating if we bump the queue

        currentlyServingTicketNumber = queueMeta.currentlyServingTicketNumber

Update object, extended at various point for updating the QueueMeta

        update =
          $set: {}

If the currentlyServingTicketNumber is 0, skip attempting to archive the conneciton to ProcessedQueue

        if queueMeta.theOnlyConnectionAllowedIn isnt undefined

Return if there is no connection to pop or the timeCurrentTicketExpires hasn't expired

          hasntExpired = queueMeta.timeCurrentTicketExpires > moment.utc().toDate()
          return if hasntExpired

Insert the processed connection into the ProcessedQueue

          processed =
            connection: queueMeta.theOnlyConnectionAllowedIn
            waitTimeSeconds: (moment.utc()).seconds() - (moment.utc queueMeta.theOnlyConnectionAllowedIn.timeEnqueued).seconds()

          QueueProcessed.insert processed

Remove the connection

          criteria =
            connectionId: queueMeta.theOnlyConnectionAllowedIn.connectionId

          Queue.remove criteria

Now serving the next ticket number, and this ticket hasn't posted

          currentlyServingTicketNumber += 1
          _.extend update.$set,
            currentlyServingTicketNumber: currentlyServingTicketNumber
            hasCurrentConnectionPosted: no

Try to serve the next connection

        criteria = ticketNumber: currentlyServingTicketNumber
        nextConnection = Queue.findOne criteria

Set the allowed connection and expireTime if one exists

If there is a nextConnection (i.e. someone waiting in line), then serve them.
Otherwise clear out theOnlyConnectionAllowedIn.

        if nextConnection?
          timeCurrentTicketExpires = moment.utc()
          timeCurrentTicketExpires.add 1, 'minutes'
          _.extend update.$set,
            theOnlyConnectionAllowedIn: nextConnection
            timeCurrentTicketExpires: timeCurrentTicketExpires.toDate()

Set up timeout function to pop queue

          delayPop = Meteor.setTimeout QueueMethods.popAndServeNextTicket, 1000

If there is no nextConnection, unset theOnlyConnectionAllowedIn.
Note, fake data is filled in to pass schema, even though we're $unset'ing

        else
          update.$unset = theOnlyConnectionAllowedIn: ""

        criteria = _id: queueMeta._id


        QueueMeta.update criteria, update

TODO: keep it DRY; logic isn't exactly shared and want to keep update atomic to
avoid extraneous DDP messages.

      serveCurrentTicket: ->

Lookup the queue (only one for now)

        queueMeta = QueueMeta.findOne()

Get the next connection.

        criteria =
          ticketNumber: queueMeta.currentlyServingTicketNumber

        nextConnection = Queue.findOne criteria

Set the allowed connection and expireTime if one exists

        if nextConnection?
          timeCurrentTicketExpires = moment.utc()
          timeCurrentTicketExpires.add 1, 'minutes'
          update =
            $set:
              theOnlyConnectionAllowedIn: nextConnection
              timeCurrentTicketExpires: timeCurrentTicketExpires.toDate()
          criteria = _id: queueMeta._id

Set up timeout function to pop queue

          delayPop = Meteor.setTimeout QueueMethods.popAndServeNextTicket, 1000

          QueueMeta.update criteria, update
