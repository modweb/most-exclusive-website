    Template.home.helpers
      lineLength: ->
          this.queueMeta.nextTicketNumber - this.queueMeta.currentlyServingTicketNumber
      queueEntry: ->
        Session.get 'queueEntry'
      isBeingServed: ->
        queueEntry = Session.get 'queueEntry'
        return if not queueEntry?

Clear queueEntry if queueMeta.currentlyServingTicketNumber is > queueEntry.ticketNumber

        if this.queueMeta.currentlyServingTicketNumber > queueEntry.ticketNumber
          Session.set 'queueEntry', null

        this.queueMeta.currentlyServingTicketNumber is queueEntry.ticketNumber and
        this.queueMeta.timeCurrentTicketExpires > moment.utc().toDate()

    Template.home.events
      'click .queueInLine': (event) ->

Return immediatly if the user is already queued. More logic on the server, but
this will help.

        return if (Session.get 'queueEntry')?

Call the meteor method to get queued.

        Meteor.call 'getInQueue', 'fakeName', (error, result) ->
          if error?
            console.log err
          else
            Session.set 'queueEntry', result
