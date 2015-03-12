Autoform callback hooks

    updateClock = (timeCurrentTicketExpires) ->
      clock = ($ '.countdown-clock').FlipClock
        autoStart: yes
        countdown: yes
        clockFace: 'MinuteCounter'
      time = Math.round (timeCurrentTicketExpires - new Date()) / 1000
      time = 0 if time < 0
      clock.setTime time
      clock.start()
    AutoForm.hooks
      getInLine:
        after:
          method: (error, result) ->
            if error?
              console.log err
            else
              Session.set 'queueEntry', result

    Template.home.helpers
      postFormSchema: -> PostFormSchema
      nameSchema: -> NameSchema
      hasPosted: -> this.queueMeta.hasCurrentConnectionPosted
      lineLength: ->

Hacks, should probably be using Tracker for this

        updateClock this.queueMeta.timeCurrentTicketExpires
        lineLength = this.queueMeta.nextTicketNumber - this.queueMeta.currentlyServingTicketNumber - 1
        lineLength = 0 if lineLength < 0
        return lineLength
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

    Template.home.rendered = ->
      updateClock this.data.queueMeta.timeCurrentTicketExpires
