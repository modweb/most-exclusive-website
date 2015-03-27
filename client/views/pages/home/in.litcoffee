    Template.in.helpers
      postFormSchema: -> PostFormSchema
      hasPosted: -> this.queueMeta.hasCurrentConnectionPosted
      gifUrl: -> Session.get 'gifUrl'

    Template.in.rendered = ->
      $('body').css 'background-color', '#b2ebf2'
      Meteor.subscribe 'topPosts'
