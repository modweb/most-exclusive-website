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

    Template.home.rendered = ->
      Tracker.autorun ->
        updateClock QueueMeta.findOne()?.timeCurrentTicketExpires
