# Route Controllers

    @RouteControllers =
      queue: RouteController.extend
        waitOn: ->
          if Meteor.isClient
            queueId = Session.get 'queueId'
            isBeingServed = Session.get 'isBeingServed'
            result =
              [
                Meteor.subscribe 'queueMeta'
                Meteor.subscribe 'topPosts', queueId, isBeingServed
                Meteor.subscribe 'singleQueue', queueId
                Meteor.subscribe 'queueCount'
                Meteor.subscribe 'top10Posts'
              ]
        data: ->
          result =
            queueMeta: QueueMeta.findOne()
            posts: _.sortBy Posts.find().fetch(), (post) -> -post.ticketNumber
            queueEntry: Queue.findOne()
            lineLength: Counts.get 'queueCount'
