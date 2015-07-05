Autoform callback hooks

    AutoForm.hooks
      getInLine:
        after:
          method: (error, result) ->
            if error?
              console.log err
            else
              Session.set 'queueEntry', result

    Template.waiting.helpers
      nameSchema: -> NameSchema
      queued: ->
        this.queueEntry?
      html: -> this.queueMeta.html
      isBeingServed: ->
        return no if not this.queueEntry?

Get new gifUrl

        isBeingServed = this.queueEntry._id is this.queueMeta?.currentlyServingQueueId
        if not isBeingServed
          Session.set 'gifUrl', null
          Session.set 'queueId', null
        return isBeingServed

    Template.waiting.events
      'click .queueInLine': (event) ->

Return immediatly if the user is already queued. More logic on the server, but
this will help.

        return if (Session.get 'queueEntry')?

Call the meteor method to get queued.

        Meteor.call 'getInQueue', 'fakeName', (error, result) ->
          if error?
            console.log err
          else
            Session.set 'queueEntry', result

      Template.waiting.rendered = ->
        $('body').css 'background-color', '#eee'
