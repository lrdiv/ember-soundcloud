ArtistPlaylistRoute = Ember.Route.extend
  model: (params) ->
    playlists = @store.all 'playlist'
      .findBy 'permalink', params.playlist

  afterModel: (playlist) ->
    tracks = playlist.get 'tracks'
    track = tracks.get 'firstObject'
    @controllerFor('player').set 'tracks', tracks if track?
    @controllerFor('player').send 'selectTrack', track if track?

`export default ArtistPlaylistRoute`
