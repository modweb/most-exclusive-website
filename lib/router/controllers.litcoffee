# Route Controllers

    @RouteControllers =
      queue: RouteController.extend
        waitOn: -> [
          Meteor.subscribe 'queueMeta'
          Meteor.subscribe 'topPosts'
        ]
        data: ->
          status = Meteor.status()
          if Session.equals('connectionId', null) and Meteor.default_connection._lastSessionId?
            Session.set 'connectionId', Meteor.default_connection._lastSessionId
          else if Meteor.default_connection._lastSessionId?
            oldConnectionId = Session.get 'connectionId'
            Meteor.call 'updateConnectionId', oldConnectionId if oldConnectionId isnt Meteor.default_connection._lastSessionId
            Session.set 'connectionId', Meteor.default_connection._lastSessionId
          result =
            queueMeta: QueueMeta.findOne()
            posts: _.sortBy Posts.find().fetch(), (post) -> -post.ticketNumber
