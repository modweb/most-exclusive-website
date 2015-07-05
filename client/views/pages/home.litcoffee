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
      totalWaitTime: ->
        minutes = (this.queueMeta.totalWaitTimeSeconds / 60).toFixed 2
        "#{minutes} minutes"
      nameAllowedIn: ->
        return this.queueMeta?.theOnlyConnectionAllowedIn?.name
      isBeingServed: ->
        return no if not this.queueEntry?
        now = moment().utc().toDate()
        isBeingServed = this.queueEntry._id is this.queueMeta?.currentlyServingQueueId and
          this.queueMeta.timeCurrentTicketExpires > now

      'click .submit-feedback': (event) ->
        $('#feedbackModal').modal 'hide'

    Template.home.rendered = ->
      Tracker.autorun ->
        updateClock QueueMeta.findOne()?.timeCurrentTicketExpires
