# Exclusive posts

`PostFormSchema` is used to generate autoforms, we'll submit to methods and fill
in the reset of the data.

    @PostFormSchema = new SimpleSchema
      message:
        type: String
        max: 200
        autoform:
          rows: 3

    PostSchema = new SimpleSchema
      name:
        type: String
      message:
        type: String
        max: 200
      timeCreated:
        type: Date
        autoValue: ->
          if this.isInsert
            return moment.utc().toDate()
          else
            this.unset()
      connectionId:
        type: String
        max: 20
      ticketNumber:
        type: Number
        index: 1

    @Posts = new Meteor.Collection 'posts'
    Posts.attachSchema PostSchema


## Posts Meteor Methods

    Meteor.methods
      postMessage: (doc) ->

        check doc, PostFormSchema

Return on the client

        return if Meteor.isClient

Get the queueMeta

        queueMeta = QueueMeta.findOne()
        throw new Meteor.Error 'queueMeta', 'Could not find queueMeta.' if not queueMeta?

Check that the connection is theOnlyConnectionAllowedIn

        isAllowedIn = this.connection.id is queueMeta.theOnlyConnectionAllowedIn?.connectionId
        throw new Meteor.Error 'no-access', "You're not allowed to do that until you're in." if not isAllowedIn

Check that the connection hasn't already posted a message

        throw new Meteor.Error 'dup-post', "You're only allowed to post once." if queueMeta.hasCurrentConnectionPosted

Check that the connection hasn't expired

        throw new Meteor.Error 'expired', "You're time expired, post faster." if queueMeta.timeCurrentTicketExpires < moment.utc().toDate()

Mark queueMeta as hasCurrentConnectionPosted

        criteria = _id: queueMeta._id
        update = $set: hasCurrentConnectionPosted: yes

        QueueMeta.update criteria, update

Post message

        post =
          name: queueMeta.theOnlyConnectionAllowedIn.name
          message: doc.message
          connectionId: queueMeta.theOnlyConnectionAllowedIn.connectionId
          ticketNumber: queueMeta.theOnlyConnectionAllowedIn.ticketNumber

        Posts.insert post
