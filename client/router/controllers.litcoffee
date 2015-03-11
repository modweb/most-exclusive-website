# Route Controllers

    @RouteControllers =
      queue: RouteController.extend
        waitOn: -> Meteor.subscribe 'queueMeta'
        data: -> queueMeta: QueueMeta.findOne()
      exclusive: RouteController.extend
        waitOn: -> [
          Meteor.subscribe 'queueMeta'
          Meteor.subscribe 'exclusive'
        ]
        data: ->
          queueMeta: QueueMeta.findOne()
          exclusive: Posts.find().fetch()
