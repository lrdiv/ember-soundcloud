PlaylistController = Ember.ObjectController.extend

  albumArt: ( ->
    playlistArt = @get 'artwork_url'
    return playlistArt if playlistArt?

    firstTrack = @get('tracks').get 'firstObject'
    trackArt = firstTrack.get 'artwork_url' if firstTrack?
    return trackArt if trackArt?

    lastTrack = @get('tracks').get 'lastObject'
    trackArt = lastTrack.get 'artwork_url' if lastTrack?
    return trackArt
  ).property 'artwork_url'

  formattedArtwork: ( ->
    if @get 'albumArt'
      url = @get 'albumArt'
      splitURL = url.split '-large'
      return splitURL[0] + '-t500x500' + splitURL[1]
  ).property 'albumArt'

`export default PlaylistController`
