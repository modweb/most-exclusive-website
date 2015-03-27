# Publications

    Meteor.publish 'queueMeta', ->
      QueueMeta.find()
    Meteor.publish 'topPosts', ->
      queueMeta = QueueMeta.findOne()
      if this.connection.id is queueMeta.theOnlyConnectionAllowedIn?.connectionId
        Posts.find {}, {sort: {ticketNumber: -1}, limit: 100 }
      else
        Posts.find {}, {sort: {ticketNumber: -1}, limit: 1 }
