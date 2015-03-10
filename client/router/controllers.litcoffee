# Route Controllers

Example controller


    @RouteControllers =
      queue: RouteController.extend
        waitOn: -> Meteor.subscribe 'queueMeta'
        data: -> QueueMeta.findOne()
