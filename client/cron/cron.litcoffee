Client cron jobs

Keep alive if queued

    Meteor.startup ->
      Meteor.setInterval ->
        queue = Queue.findOne()
        Meteor.call 'keepAlive', queue._id if queue?
      , 60000
