/* global Counts, QueueMeta */
Template.ticketer.helpers({
  lineLength: () => Counts.get('queueCount'),
  currentlyServingTicketNumber: () => QueueMeta.findOne().currentlyServingTicketNumber
});
