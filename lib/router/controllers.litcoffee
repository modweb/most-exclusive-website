# Route Controllers

    @RouteControllers =
      queue: RouteController.extend
        waitOn: -> [
          Meteor.subscribe 'queueMeta'
          Meteor.subscribe 'topPosts'
        ]
        data: ->
          queueMeta: QueueMeta.findOne()
          posts: Posts.find({}, {sort: ticketNumber: -1}).fetch()

Posts.find({}, {sort: ticketNumber: -1}).fetch()
