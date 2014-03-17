Router.configure({
  layoutTemplate: 'layout',
  loadingTemplate: 'loading'
});

Router.map( function () {
  
  this.route('home', {
    path: '/'
  });
  
});