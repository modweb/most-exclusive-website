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

    Meteor.publish 'mostRecentPosts', ->
      Posts.find {}, { sort: {ticketNumber: -1}, limit: 5 }

    Meteor.publish 'queueCount', ->
      Counts.publish this, 'queueCount', Queue.find()
      return undefined
