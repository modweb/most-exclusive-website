# Publications

    Meteor.publish 'queueMeta', ->
      if Meteor.settings.queueMetaId?
        criteria =
          _id: Meteor.settings.queueMetaId
      else
        criteria = {}
      QueueMeta.find(criteria)

    Meteor.publish 'topPosts', ->
      Posts.find {}, {sort: {ticketNumber: -1}, limit: 10 }
