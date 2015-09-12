ApplicationController = Ember.Controller.extend

  player: Ember.inject.service()

  actions:
    goToArtist: ->
      artist = @get('player.artistName')
      @transitionToRoute('artist', artist) if artist.length

`export default ApplicationController`
