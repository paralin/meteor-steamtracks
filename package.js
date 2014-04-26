Package.describe({
  summary: "SteamTracks: the modern Steam API."
});

Package.on_use(function (api, where) {
  api.use('coffeescript');
  api.use('http');
  api.add_files('steamtracks.coffee', ['server']);
  api.export('SteamTracks');
});
