    @FeedbackSchema = new SimpleSchema
      message:
        type: String
        max: 2000
        autoform:
          rows: 3
      timeCreated:
        type: Date
        autoValue: ->
          if this.isInsert
            return moment.utc().toDate()
          else
            this.unset()
        optional: yes
      email:
        type: String
        optional: yes

    @Feedback = new Mongo.Collection 'feedback'

    Meteor.methods
      sendFeedback: (doc) ->
        this.unblock()
        check doc, FeedbackSchema

Return on the client

        return if this.inSimulation

        FeedbackSchema.clean doc
        Feedback.insert doc

Send email

        if Meteor.settings?.feedbackEmail? and Meteor.settings?.mailgunOptions?
          Mailguns = new Mailgun Meteor.settings.mailgunOptions
          Mailguns.send
            to: Meteor.settings.feedbackEmail
            from: 'feedback@mostexclusivewebsite.com'
            subject: "Feedback from #{doc.email}"
            text: "#{doc.message}"
