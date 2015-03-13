# Publications

    Meteor.publish 'queueMeta', ->
      QueueMeta.find()
    Meteor.publish 'top10Posts', ->
      Posts.find {}, {sort: {ticketNumber: -1}, limit: 10 }
