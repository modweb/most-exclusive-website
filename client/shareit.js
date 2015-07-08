ShareIt.configure({
  sites: {
    'facebook': {
      'appId': Meteor.settings.public.facebook.appId
    }
  },
  iconOnly: true,
  applyColors: true,
  faSize: '4x',
  classes: 'btn btn-info btn-fab btn-raised',
  useGoogle: false
});
