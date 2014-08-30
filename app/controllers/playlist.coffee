PlaylistController = Ember.ObjectController.extend

  albumArt: ( ->
    # Check the playlist record for artwork
    playlistArt = @get 'artwork_url'
    return playlistArt if playlistArt?

    # If the playlist artwork is empty, try the first
    # track
    firstTrack = @get('tracks').get 'firstObject'
    trackArt = firstTrack.get 'artwork_url' if firstTrack?
    return trackArt if trackArt?

    # If the first track has no artwork, try the last
    # track, then just give up
    lastTrack = @get('tracks').get 'lastObject'
    trackArt = lastTrack.get 'artwork_url' if lastTrack?
    return trackArt
  ).property 'artwork_url'

  formattedArtwork: ( ->
    if @get 'albumArt'
      # Reformat the artwork URL to get a bigger
      # version of the image
      url = @get 'albumArt'
      splitURL = url.split '-large'
      return splitURL[0] + '-t500x500' + splitURL[1]
  ).property 'albumArt'

`export default PlaylistController`
