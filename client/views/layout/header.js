Template.header.helpers({
  activeRouteClass: function (/* route names */) {
    //turn args into a regular javascript array
    var args = Array.prototype.slice.call(arguments, 0);
    // remove the hash added by at the end by Handlebars
    args.pop();
    // temporary hack for 0.8.0
    return false;
    var active = _.any(args, function(name) {
      return Router.current().route.name === name;
    });
    
    return active && 'active';
  }
});