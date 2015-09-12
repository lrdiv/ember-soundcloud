PlayerService = Ember.Service.extend

  isExpanded: false
  trackSortProperties: ['created_at:desc']

  # sortedTracks: Ember.computed.sort 'tracks', 'trackSortProperties'
  sortedTracks: Ember.computed.alias 'tracks'

  formattedArtwork: Ember.computed 'currentTrack.artwork_url', ->
    if @get 'currentTrack.artwork_url'
      url = @get 'currentTrack.artwork_url'
      splitURL = url.split '-large'
      return splitURL[0] + '-t300x300' + splitURL[1]

  togglePlayer: ->
    @toggleProperty 'isCollapsed'
    return false

  selectTrack: (track, index, play) ->
    self = this
    SC.streamStopAll()

    self.set 'currentTrack', track
    play = true unless play?

    self.get('tracks').setEach 'playingTrack', false
    self.set('isBuffering', true)
    track.set('playingTrack', true)

    trackPath = track.get('uri')

    trackIndex = index + 1
    nextTrack = self.get('sortedTracks').nextObject(trackIndex, track)
    @set('nextTrack', nextTrack)

    SC.stream trackPath,
      # Update track position for potential scrubber in future
      whileplaying: ->
        self.set 'currentTrackPosition', this.position

      # Update buffering state
      , onbufferchange: ->
        self.set 'isBuffering', this.isBuffering

      # Set isPlaying to false when song finishes
      , onfinish: ->
        self.set 'isPlaying', false
        # If there is a next track, play it.
        self.selectTrack(self.get('nextTrack'), index) if self.get('nextTrack')?

      # Set the sound on the controller, set isPlaying to true and start
      # playing the sound
      , (sound) ->
        self.set 'isPlaying', true
        sound.play()
        if play
          # Show a desktop notification
          if Notification? and Notification.permission == "granted"
            notificationTitle = self.get('artistUsername')
            notificationOptions =
              body: track.get 'title'
              icon: self.get 'formattedArtwork'

            trackNotification = new Notification notificationTitle, notificationOptions
            setTimeout trackNotification.close.bind(trackNotification), 5000
        else
          sound.pause()
          self.set 'isPlaying', false

`export default PlayerService`
