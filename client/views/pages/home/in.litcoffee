    Template.in.helpers
      postFormSchema: -> PostFormSchema
      hasPosted: -> this.queueMeta.hasCurrentConnectionPosted
      gifUrl: -> Session.get 'gifUrl'
      html: -> this.queueMeta.html

    Template.in.rendered = ->
      $('body').css 'background-color', '#b2ebf2'
