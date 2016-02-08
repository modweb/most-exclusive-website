/* global Counts, QueueMeta */
Template.ticketer.helpers({
  lineLength: () => Counts.get('queueCount'),
  currentlyServingTicketNumber: () => (QueueMeta.findOne().currentlyServingTicketNumber).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')
});
