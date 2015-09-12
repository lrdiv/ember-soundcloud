TrackPlayerComponent = Ember.Component.extend

  player: Ember.inject.service()

  tagName: 'div'
  classNames: ['soundcloud-player']

  track: null
  sound: null
  position: 0
  isPaused: false

  # PROPERTIES AND OBSERVERS FOR SCRUBBER RELATED STUFF
  
  percentPlayed: Ember.computed 'track.duration', 'position', ->
    percent = 0
    percent = ( ( @get('position') / @get('track').get('duration') ) * 100 ) if @get('track')?
    return percent

  setPercentPlayed: Ember.observer 'percentPlayed', 'position', ->
    percent = @get 'percentPlayed'
    this.$('.progress-bar').css 'width', "#{percent}%"

  formattedPosition: Ember.computed 'position', ->
    position = @get 'position'
    res = @formatTime(position)
    return res

  formattedDuration: Ember.computed 'track.duration', ->
    duration = @get 'track.duration'
    res = @formatTime(duration)
    return res

  formatTime: (time) ->
    date = new Date(null)
    seconds = time / 1000
    seconds = if isNaN(seconds) then 0 else seconds
    date.setSeconds(seconds)
    return date.toISOString().substr(11, 8)

  actions:
    pauseTrack: ->
      @get('sound').pause()
      @set 'isPlaying', false
      @set 'isPaused', true

    resumeTrack: ->
      @get('sound').resume()
      @set 'isPlaying', true
      @set 'isPaused', false

    playTrack: ->
      @get('sound').play()
      @set 'isPlaying', true
      @set 'isPaused', false
    
    nextTrack: ->
      @get('player').playNextTrack()
    
    prevTrack: ->
      @get('player').playPrevTrack()

`export default TrackPlayerComponent`
