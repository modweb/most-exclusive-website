# Iron-router configuration

    Router.configure
      layoutTemplate: 'layout'
      loadingTemplate: 'loading'

## Filters

    filters =
      isLoggedIn: ->
        Router.go 'home' unless Meteor.loggingIn() or Meteor.user()

Login filter, except public routes

    Router.onBeforeAction filters.isLoggedIn,
      except: [
        'home'
        'about'
        'atSignIn'
        'atSignUp'
        'atForgotPwd'
        'atResetPwd'
        'atVerifyEmail'
        'atEnrollAccount'
        'atChangePwd'
      ]
