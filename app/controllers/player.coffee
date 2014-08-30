PlayerController = Ember.Controller.extend

  isExpanded: false
  trackSortProperties: ['created_at:desc']

  # sortedTracks: Ember.computed.sort 'tracks', 'trackSortProperties'
  sortedTracks: Ember.computed.alias 'tracks'

  formattedArtwork: ( ->
    if @get 'currentTrack.artwork_url'
      url = @get 'currentTrack.artwork_url'
      splitURL = url.split '-large'
      return splitURL[0] + '-t300x300' + splitURL[1]
  ).property 'currentTrack.artwork_url'
    
  actions:

    togglePlayer: ->
      @toggleProperty 'isCollapsed'
      return false

    selectTrack: (track, index, play) ->
      self = this
      play = true unless play?
      # Set all other tracks as not playing
      self.get('tracks').setEach 'playingTrack', false
      self.set 'isBuffering', true
      track.set 'playingTrack', true
      # Get the track URI for streaming
      trackPath = track.get 'uri'
      
      # If a track is already playing, stop it
      prevTrack = @get 'currentTrackObject'
      prevTrack.destruct() if prevTrack? 
      self.set 'currentTrack', track

      # Set the next track so that it can autoplay on current
      # track completion
      unless @get 'externalPlay'
        index = index + 1
        # Get the next track from the playlist
        nextTrack = @get('sortedTracks').nextObject(index, track)
        # And set it on our controller
        self.set 'nextTrack', nextTrack
      
      # Stream the track with callback to update position
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
          self.send('selectTrack', self.get('nextTrack'), index) if self.get('nextTrack')?
        
        # Set the sound on the controller, set isPlaying to true
        # and start playing the sound
        , (sound) ->
          self.set 'currentTrackObject', sound
          self.set 'isPlaying', true
          sound.play()
          unless play
            sound.pause()
            self.set 'isPlaying', false

`export default PlayerController`
