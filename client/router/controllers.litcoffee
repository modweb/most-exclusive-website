# Route Controllers

    @RouteControllers =
      example: RouteController.extend
        waitOn: -> Meteor.subscribe 'example'
        data: -> someDataExample: ExampleCollection.find()
