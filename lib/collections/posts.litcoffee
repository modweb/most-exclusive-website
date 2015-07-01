# Exclusive posts

`PostFormSchema` is used to generate autoforms, we'll submit to methods and fill
in the reset of the data.

    @PostFormSchema = new SimpleSchema
      message:
        type: String
        max: 200
        autoform:
          rows: 3
      link:
        type: String
        regEx: SimpleSchema.RegEx.Url
        optional: yes

    PostSchema = new SimpleSchema
      name:
        type: String
      message:
        type: String
        max: 200
      link:
        type: String
        regEx: SimpleSchema.RegEx.Url
        optional: yes
      html:
        type: String
        optional: yes
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

Try to get noembed content

        callback = (error, result) ->
          console.log error if error?
          if not error? and result?.data?.html? then html = result.data.html

Post message

          post =
            name: queueMeta.theOnlyConnectionAllowedIn.name
            message: doc.message
            link: doc.link
            connectionId: queueMeta.theOnlyConnectionAllowedIn.connectionId
            ticketNumber: queueMeta.theOnlyConnectionAllowedIn.ticketNumber

          if html?
            _.extend post, html: html
            _.extend update.$set, html: html
          else
            _.extend update, $unset: html: 'unset'

          QueueMeta.update criteria, update
          Posts.insert post

        if doc.link?
          getUrl = "http://noembed.com/embed?url=#{doc.link}"
          HTTP.get getUrl, callback
        else
          callback()
