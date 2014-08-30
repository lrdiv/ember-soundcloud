SoundcloudPlayerComponent = Ember.Component.extend

  tagName: 'div'
  classNames: ['soundcloud-player']

  track: null
  sound: null
  position: 0
  isPaused: false

  # PROPERTIES AND OBSERVERS FOR SCRUBBER RELATED STUFF
  
  percentPlayed: ( ->
    percent = 0
    percent = ( ( @get('position') / @get('track').get('duration') ) * 100 ) if @get('track')?
    return percent
  ).property 'track.duration', 'position'

  setPercentPlayed: ( ->
    percent = @get 'percentPlayed'
    this.$('.progress-bar').css 'width', "#{percent}%"
  ).observes 'percentPlayed', 'position'

  formattedPosition: ( ->
    position = @get 'position'
    res = @formatTime(position)
    return res
  ).property 'position'

  formattedDuration: ( ->
    duration = @get 'track.duration'
    res = @formatTime(duration)
    return res
  ).property 'track.duration'

  formatTime: (time) ->
    time = if isNaN(time) then 0 else time 
    timeObject = new Date(time)
    minutes = timeObject.getMinutes().toString()
    seconds = timeObject.getSeconds().toString()
    seconds = if seconds.length < 2 then "0#{seconds}" else seconds
    return "#{minutes}:#{seconds}"

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

`export default SoundcloudPlayerComponent`
