`import secrets from 'mc-ember/utils/secrets'`

ArtistRoute = Ember.Route.extend

  player: Ember.inject.service()

  beforeModel: (transition) ->
    # Initialize soundcloud before hitting API
    SC.initialize
      client_id: secrets.soundcloud_api_key
      redirect_url: '#'

  model: (params) ->
    self = this
    artist = params.artist
    # Set the artist name
    @get('player').set('artistName', artist)

    @controllerFor 'application'
      .set 'artistName', artist
    # Create an ArrayProxy to resolve our promise with
    playlistProxy = Ember.ArrayProxy.create content: []

    return new Ember.RSVP.Promise (resolve, reject) ->
      SC.get "/users/#{artist}/playlists", (playlists) ->
        if playlists.length
          self.resetStore()
          self.get('player').set 'artistUsername', playlists[0].user.username
          # Loop over playlists and create records in store
          playlists.forEach (item, index, arr) ->
            playlist = self.createPlaylist(item, playlistProxy)
            # Loop over tracks and create records in store
            item.tracks.forEach (track, index, arr) ->
              track = self.createTrack(track, playlist)
          # Get the content of our ArrayProxy to resolve our promise with
          playlists = playlistProxy.get 'content'
          resolve(playlists)
        else
          # If there are not playlists, call the errorHandler function which
          # shows alert and redirects to index
          reject(self.errorHandler(artist))

  resetStore: ->
    # Clear out the store. Only the current artist's playlists and tracks should
    # exist
    @store.unloadAll 'playlist'
    @store.unloadAll 'track'

  createPlaylist: (playlist, arr) ->
    # Create the empty record, set the properties and then push it into the
    # playlist ArrayProxy
    record = @store.createRecord 'playlist', {}
    record.setProperties
      id: playlist.id
      title: playlist.title
      artwork_url: playlist.artwork_url
      permalink: playlist.permalink
    arr.pushObject record
    return record

  createTrack: (track, playlist) ->
    # Create the empty record, set the properties and then set the playlist
    # association
    record = @store.createRecord 'track', {}
    record.setProperties track
    record.set 'playlist', playlist
    return record

  errorHandler: (artist) ->
    # Set error text on the controller if the artist was not found or had zero
    # playlists
    @controllerFor 'index'
      .set 'errorText', "Artist #{artist} is invalid or does not have any playlists."

    # Transition back to the index route
    @transitionTo 'index'

`export default ArtistRoute`
