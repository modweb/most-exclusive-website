# Route Controllers

    @RouteControllers =
      queue: RouteController.extend
        waitOn: ->
          if Meteor.isClient
            queueId = Session.get 'queueId'
            result =
              [
                Meteor.subscribe 'queueMeta'
                Meteor.subscribe 'topPosts'
                Meteor.subscribe 'singleQueue', queueId
              ]
        data: ->
          result =
            queueMeta: QueueMeta.findOne()
            posts: _.sortBy Posts.find().fetch(), (post) -> -post.ticketNumber
            queueEntry: Queue.findOne()
