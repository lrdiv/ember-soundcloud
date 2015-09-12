ApplicationController = Ember.Controller.extend

  player: Ember.inject.service()

  actions:
    goToArtist: ->
      if @get('player.artistName').length
        # Action that redirects to the artist route and passes the username as a
        # param
        artist = @get 'player.artistName'
        @transitionToRoute 'artist', artist

`export default ApplicationController`
