ArtistController = Ember.ArrayController.extend

  needs: ['player']
  player: Ember.computed.alias 'controllers.player'

  sortProperties: ['created_at:desc']
  sortedPlaylists: Ember.computed.sort 'model', 'sortProperties'

  actions:
    setAsPlaylist: (playlist) ->
      # Get all tracks in the playlist, set them on
      # the PlayerController, then cache the first
      # track so we can autoplay
      tracks = playlist.get 'tracks'
      track = tracks.get 'firstObject'
      @get('player').set 'tracks', tracks if track?
      @get('player').send 'selectTrack', track, 0 if track?

`export default ArtistController`
