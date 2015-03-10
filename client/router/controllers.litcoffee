# Route Controllers

Example controller


    @RouteControllers =
      queue: RouteController.extend
        waitOn: -> Meteor.subscribe 'queue'
        data: -> []
