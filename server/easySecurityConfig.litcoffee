    Meteor.startup ->

      EasySecurity.config
        general: { type: 'rateLimit', ms: 1000 }
        maxQueueLength: 2
