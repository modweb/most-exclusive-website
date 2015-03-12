# Route Controllers

    @RouteControllers =
      queue: RouteController.extend
        waitOn: -> [
          Meteor.subscribe 'queueMeta'
          Meteor.subscribe 'top10Posts'
        ]
        data: ->
          queueMeta: QueueMeta.findOne()
          posts: Posts.find().fetch()
