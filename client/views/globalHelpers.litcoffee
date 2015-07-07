    Template.registerHelper 'totalWaitTimeMinutes', ->
      minutes = (QueueMeta.findOne()?.totalWaitTimeSeconds / 60).toFixed 0
      "#{minutes} minutes"

    Template.registerHelper 'totalWaitTimeYears', ->
      secondsInYear = 31556900
      years = (QueueMeta.findOne()?.totalWaitTimeSeconds / secondsInYear ).toFixed 2
      "#{years} years"

    Template.registerHelper 'nameAllowedIn', ->
      QueueMeta.findOne()?.theOnlyConnectionAllowedIn?.name

    Template.registerHelper 'isBeingServed', ->
      queueEntry = Queue.findOne()
      queueMeta = QueueMeta.findOne()

Update timeCurrentTicketExpires hackily here...

      timeCurrentTicketExpires = Session.get 'timeCurrentTicketExpires'
      if timeCurrentTicketExpires isnt queueMeta?.timeCurrentTicketExpires
        Session.set 'timeCurrentTicketExpires', queueMeta?.timeCurrentTicketExpires

Not being served in either queueEntry or queueMeta are non-existant

      return no if not (queueEntry? and queueMeta?)
      now = moment().utc().toDate()
      isBeingServed = queueEntry._id is queueMeta?.currentlyServingQueueId and
        queueMeta.timeCurrentTicketExpires > now
      if isBeingServed
        cachedIsBeingServed = Session.get 'isBeingServed'
        Session.set 'isBeingServed', yes if cachedIsBeingServed is undefined or no
      return isBeingServed
