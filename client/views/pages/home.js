Template.home.onCreated(function (){
  this.autorun( () => {
    queueId = Session.get('queueId')
    isBeingServed = Session.get('isBeingServed')
    this.subscribe('queueMeta');
    this.subscribe('singleQueue', queueId);
    this.subscribe('queueCount');
    this.subscribe('mostRecentPosts');
  });
});

Template.home.helpers({
  posts: function () {
    var postsSort = function (post) {
      return -post.ticketNumber;
    };
    return _.sortBy(Posts.find().fetch(), postsSort);
  }
});
