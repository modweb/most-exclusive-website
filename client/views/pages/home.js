Template.home.onCreated(function (){
  this.autorun( () => {
    queueId = Session.get('queueId')
    isBeingServed = Session.get('isBeingServed')
    this.subscribe('queueMeta');
    this.subscribe('topPosts', queueId, isBeingServed);
    this.subscribe('singleQueue', queueId);
    this.subscribe('queueCount');
    this.subscribe('mostRecentPosts');
  });
});
