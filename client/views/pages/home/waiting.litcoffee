Autoform callback hooks

    AutoForm.hooks
      getInLine:
        after:
          method: (error, result) ->
            if error?
              console.log err
            else
              Session.set 'queueEntry', result

    Template.waiting.helpers
      nameSchema: -> NameSchema
      lineLength: ->

Hacks, should probably be using Tracker for this

        lineLength = this.queueMeta.nextTicketNumber - this.queueMeta.currentlyServingTicketNumber - 1
        lineLength = 0 if lineLength < 0
        return lineLength
      numberOfTicketsBeforeYou: ->
        this.queueEntry?.ticketNumber - this.queueMeta.currentlyServingTicketNumber
      html: -> this.queueMeta.html
      isBeingServed: ->
        return no if not this.queueEntry?

Get new gifUrl

        isBeingServed = this.queueEntry._id is this.queueMeta?.currentlyServingQueueId
        if not isBeingServed
          Session.set 'gifUrl', null
          Session.set 'queueId', null
        return isBeingServed

    Template.waiting.events
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

      Template.waiting.rendered = ->
        $('body').css 'background-color', '#eee'
