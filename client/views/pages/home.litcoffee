Autoform callback hooks

    updateClock = (timeCurrentTicketExpires) ->
      clock = ($ '.countdown-clock').FlipClock
        autoStart: yes
        countdown: yes
        clockFace: 'MinuteCounter'
      time = Math.round (timeCurrentTicketExpires - new Date()) / 1000
      time = 0 if time < 0
      clock.setTime time
      clock.start() if time > 0

    Template.home.helpers
      lineLength: ->
        lineLength = this.queueMeta.nextTicketNumber - this.queueMeta.currentlyServingTicketNumber - 1
        lineLength = 0 if lineLength < 0
        return lineLength
      queueEntry: ->
        Session.get 'queueEntry'
      totalWaitTime: ->
        hours = (this.queueMeta.totalWaitTimeSeconds / 3600).toFixed 4
        "#{hours} hours"
      averageWaitTime: ->
        duration = moment.duration this.queueMeta.averageWaitTimeSeconds, 'seconds'
        duration.humanize()
      isBeingServed: ->
        queueEntry = Session.get 'queueEntry'
        return if not queueEntry?

Get new gifUrl

        Session.set 'gifUrl',"http://thecatapi.com/api/images/get?format=src&type=jpg&size=med&time=#{new Date().getTime()}"

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

      'click .submit-feedback': (event) ->
        console.log 'clicked!'
        $('#feedbackModal').modal 'hide'

    Template.home.rendered = ->
      Tracker.autorun ->
        updateClock QueueMeta.findOne()?.timeCurrentTicketExpires
