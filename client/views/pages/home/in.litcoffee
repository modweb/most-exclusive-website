    Template.in.helpers
      postFormSchema: -> PostFormSchema
      hasPosted: -> QueueMeta.findOne()?.hasCurrentConnectionPosted
      gifUrl: -> Session.get 'gifUrl'
      html: -> QueueMeta.findOne()?.html
      posts: ->
        postsSort = (post) -> -post.ticketNumber
        posts = _.sortBy(Posts.find().fetch(), postsSort)

    Template.in.rendered = ->
      $('body').css 'background-color', '#b2ebf2'
