/* global FlowRouter, BlazeLayout */

FlowRouter.route('/', {
  name: 'home',
  action: () => BlazeLayout.render('layout', { content: 'home' })
});
