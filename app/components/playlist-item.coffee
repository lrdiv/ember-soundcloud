PlaylistItemComponent = Ember.Component.extend

  playlistClasses: 'album-list-item'

  albumArt: Ember.computed 'playlist.artwork_url', ->
    # Check the playlist record for artwork
    playlistArt = @get 'playlist.artwork_url'
    return playlistArt if playlistArt?

    # If the playlist artwork is empty, try the first track
    firstTrack = @get('playlist.tracks').get 'firstObject'
    trackArt = firstTrack.get 'artwork_url' if firstTrack?
    return trackArt if trackArt?

    # If the first track has no artwork, try the last track, then just give up
    lastTrack = @get('playlist.tracks').get 'lastObject'
    trackArt = lastTrack.get 'playlist.artwork_url' if lastTrack?
    return trackArt

  formattedArtwork: Ember.computed 'albumArt', ->
    if @get 'albumArt'
      # Reformat the artwork URL to get a bigger version of the image
      url = @get 'albumArt'
      splitURL = url.split '-large'
      return splitURL[0] + '-t500x500' + splitURL[1]

  actions:
    setAsPlaylist: (playlist) ->
      @sendAction 'action', playlist

`export default PlaylistItemComponent`
