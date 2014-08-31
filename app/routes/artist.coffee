ArtistRoute = Ember.Route.extend

  needs: ['player']
  player: Ember.computed.alias 'controllers.player'

  beforeModel: ->
    # Initialize soundcloud before hitting API
    SC.initialize
      client_id: window.soundcloud_api_key
      redirect_url: '#'
  
  model: (params) ->
    self = this
    artist = params.artist
    # Set the artist name on the ApplicationController
    @controllerFor 'application'
      .set 'artistName', artist
    # Create an ArrayProxy to resolve our promise with
    playlistProxy = Ember.ArrayProxy.create content: []
    
    return new Ember.RSVP.Promise (resolve, reject) ->
      SC.get "/users/#{artist}/playlists", (playlists) ->
        if playlists.length
          self.resetStore()
          # Loop over playlists and create records in store
          playlists.forEach (item, index, arr) ->
            playlist = self.createPlaylist(item, playlistProxy)
            # Loop over tracks and create records in store
            item.tracks.forEach (track, index, arr) ->
              track = self.createTrack(track, playlist)
          # Get the content of our ArrayProxy to resolve our
          # promise with
          playlists = playlistProxy.get 'content'
          resolve(playlists)
        else
          # If there are not playlists, call the errorHandler
          # function which shows alert and redirects to index
          reject(self.errorHandler(artist))

  setupController: (controller, model) ->
    @_super controller, model
    # Get the model's first playlist and track to
    # have something loaded in the player outlet,
    # without having to autoplay
    tracks = model
      .get 'firstObject'
      .get 'tracks'
    track = tracks.get 'firstObject'
    @controllerFor 'player'
      .set 'tracks', tracks
      .send 'selectTrack', track, 0, false
    controller

  resetStore: ->
    # Clear out the store. Only the current
    # artist's playlists and tracks should exist
    @store.unloadAll 'playlist'
    @store.unloadAll 'track'

  createPlaylist: (playlist, arr) ->
    # Create the empty record, set the properties
    # and then push it into the playlist ArrayProxy
    record = @store.createRecord 'playlist', {}
    record.setProperties
      id: playlist.id
      title: playlist.title
      artwork_url: playlist.artwork_url
    arr.pushObject record
    return record

  createTrack: (track, playlist) ->
    # Create the empty record, set the properties
    # and then set the playlist association
    record = @store.createRecord 'track', {}
    record
      .setProperties track
      .set 'playlist', playlist
    return record

  errorHandler: (artist) ->
    # Set error text on the controller if the artist
    # was not found or had zero playlists
    @controllerFor 'index'
      .set 'errorText', "Artist #{artist} is invalid or does not have any playlists."

    # Transition back to the index route
    @transitionTo 'index'

`export default ArtistRoute`
