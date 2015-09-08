AutoForm hooks

    Meteor.startup ->
      AutoForm.addHooks 'getInLine',
        after:
          method: (error, _id) ->

TODO: handle errors...

            if _id?
              Meteor.subscribe 'singleQueue', _id, (result) ->
                Session.set 'queueId', _id

      AutoForm.addHooks 'postForm',
        before:
          method: (doc) ->
            doc.queueId = Queue.findOne()._id
            Session.set 'gifUrl',"http://thecatapi.com/api/images/get?format=src&type=gif&size=med&time=#{new Date().getTime()}"
            return doc
