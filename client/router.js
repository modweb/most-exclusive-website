Router.configure({
  layoutTemplate: 'layout',
  loadingTemplate: 'loading'
});

RouteController = {};
RouteController.home = 

Router.map( function () {
  
  this.route('home', {
    path: '/'
  });
  
  this.route('about', {
    path: 'about'
  });
  
});