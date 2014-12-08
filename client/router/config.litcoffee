# Iron-router configuration

    Router.configure
      layoutTemplate: 'layout'
      loadingTemplate: 'loading'

## Filters

    filters =
      isLoggedIn: ->
        Router.go 'home' unless Meteor.loggingIn() or Meteor.user()

    Router.onBeforeAction filters.isLoggedIn,
      except: [ 'home', 'about', 'atSignIn' ] #public routes go here

## useraccounts:core routes

    AccountsTemplates.configureRoute 'signIn'
    AccountsTemplates.configureRoute 'forgotPwd'
    AccountsTemplates.configureRoute 'changePwd'
