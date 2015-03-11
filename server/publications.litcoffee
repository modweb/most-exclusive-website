# Publications

    Meteor.publish 'queueMeta', ->
      QueueMeta.find()
    Meteor.publish 'top10Posts', ->
      Posts.find().limit 10
