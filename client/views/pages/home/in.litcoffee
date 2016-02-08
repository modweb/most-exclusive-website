    Template.in.helpers
      postFormSchema: -> PostFormSchema
      hasPosted: -> QueueMeta.findOne()?.hasCurrentConnectionPosted
      gifUrl: -> Session.get 'gifUrl'
      html: -> QueueMeta.findOne()?.html

    Template.in.rendered = ->
      $('body').css 'background-color', '#b2ebf2'
