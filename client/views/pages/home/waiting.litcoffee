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
      queued: -> Queue.findOne()?
      ticketNumber: -> Queue.findOne()?.ticketNumber.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')
      nextTicketNumber: -> QueueMeta.findOne()?.nextTicketNumber.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')
      html: -> QueueMeta.findOne()?.html
      isActive: -> QueueMeta.findOne()?.isActive
      isBeingServed: ->
        return no if not Queue.findOne()?

Get new gifUrl

        isBeingServed = Queue.findOne()?._id is QueueMeta.findOne()?.currentlyServingQueueId
        if not isBeingServed
          Session.set 'gifUrl', null
          Session.set 'queueId', null
        return isBeingServed
      queueMeta: -> QueueMeta.findOne()

      Template.waiting.rendered = ->
        $('body').css 'background-color', '#eee'
