ArtistPlaylistRoute = Ember.Route.extend
  
  player: Ember.inject.service()

  model: (params) ->
    playlists = @store.peekAll 'playlist'
      .findBy 'permalink', params.playlist

  setupController: (controller, playlist) ->
    tracks = playlist.get 'tracks'
    track = tracks.get 'firstObject'
    @get('player').set 'tracks', tracks
    @get('player').selectTrack(track, 0, true) if track?

`export default ArtistPlaylistRoute`
