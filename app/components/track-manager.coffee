ScPlayerComponent = Ember.Component.extend

  player: Ember.inject.service()
  
  actions:
    playTrack: (track) ->
      @get('player').selectTrack(track)

`export default ScPlayerComponent`
