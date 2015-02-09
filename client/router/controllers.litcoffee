# Route Controllers

Example controller

```
@RouteControllers =
  example: RouteController.extend
    waitOn: -> Meteor.subscribe 'example'
    data: -> someDataExample: ExampleCollection.find()
```
