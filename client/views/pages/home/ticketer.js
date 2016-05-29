/* global Counts, QueueMeta */
Template.ticketer.helpers({
  lineLength: () => Counts.get('queueCount'),
  currentlyServingTicketNumber: () => (QueueMeta.findOne().currentlyServingTicketNumber).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ','),
  ticketNumber: function () {
    if (Queue.findOne() !== null) {
      return Queue.findOne().ticketNumber.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
    }
  }
});
