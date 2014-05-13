### Iron-router configuration ###
Router.configure
  layoutTemplate: 'layout'
  loadingTemplate: 'loading'

### filters ###
filters =
  isLoggedIn: ->
    Router.go 'home' unless Meteor.loggingIn() or Meteor.user()

Router.onBeforeAction filters.isLoggedIn,
  except: [ 'home', 'about' ] #public routes go here