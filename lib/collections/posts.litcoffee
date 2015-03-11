# Exclusive posts

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

    @Posts = new Meteor.Collection 'posts'
    Posts.attachSchema PostSchema
