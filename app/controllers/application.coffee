ApplicationController = Ember.Controller.extend
  
  artistName: null

  actions:
    goToArtist: ->
      if @get('artistName').length
        # Action that redirects to the artist route
        # and passes the username as a param
        artist = @get 'artistName'
        @transitionToRoute 'artist', artist

`export default ApplicationController`
