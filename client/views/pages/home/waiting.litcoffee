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
      lineLength: ->

Hacks, should probably be using Tracker for this

        lineLength = this.queueMeta.nextTicketNumber - this.queueMeta.currentlyServingTicketNumber - 1
        lineLength = 0 if lineLength < 0
        return lineLength
      queueEntry: ->
        Session.get 'queueEntry'
      html: -> this.queueMeta.html
      isBeingServed: ->
        queueEntry = Session.get 'queueEntry'
        return if not queueEntry?

Get new gifUrl

        Session.set 'gifUrl',"http://thecatapi.com/api/images/get?format=src&type=jpg&size=med&time=#{new Date().getTime()}"

Clear queueEntry if queueMeta.currentlyServingTicketNumber is > queueEntry.ticketNumber

        if this.queueMeta.currentlyServingTicketNumber > queueEntry.ticketNumber
          Session.set 'queueEntry', null

        this.queueMeta.currentlyServingTicketNumber is queueEntry.ticketNumber and
          this.queueMeta.timeCurrentTicketExpires > moment.utc().toDate()

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
