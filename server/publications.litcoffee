# Publications

    Meteor.publish 'queueMeta', ->
      if Meteor.settings.queueMetaId?
        criteria =
          _id: Meteor.settings.queueMetaId
      else
        criteria = {}
      QueueMeta.find criteria

    Meteor.publish 'singleQueue', (_id) ->
      if _id?
        Queue.find _id: _id
      else
        [ ]

    Meteor.publish 'topPosts', (queueId) ->
      if queueId?
        if Meteor.settings.queueMetaId?
          criteria =
            _id: Meteor.settings.queueMetaId
        else
          criteria = {}
        queueMeta = QueueMeta.findOne criteria
        if queueId is queueMeta?.currentlyServingQueueId
          return Posts.find {}, {sort: {ticketNumber: -1}, limit: 100 }
      return [ ]

    Meteor.publish 'top10Posts', ->
      Posts.find {}, { sort: {ticketNumber: -1}, limit: 10 }

    Meteor.publish 'queueCount', ->
      Counts.publish this, 'queueCount', Queue.find()
      return undefined
