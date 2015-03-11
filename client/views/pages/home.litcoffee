    Template.home.helpers
      lineLength: ->
          this.queueMeta.nextTicketNumber - this.queueMeta.currentlyServingTicketNumber - 1
      queueEntry: -> Session.get 'queueEntry'

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
