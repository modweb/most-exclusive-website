# Header helpers

## sign in, log out nav link

    Template.header.helpers
      atNavText: ->
        if Meteor.user()
          AccountsTemplates.texts.navSignOut
        else
          AccountsTemplates.texts.navSignIn

    Template.header.events
      'click #at-nav-link': (event) ->
        if Meteor.user() then AccountsTemplates.logout()
