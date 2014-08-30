IndexController = Ember.ArrayController.extend
  
  needs: ['player']
  player: Ember.computed.alias 'controllers.player'
  
  sortProperties: ['created_at:desc']
  sortedPlaylists: Ember.computed.sort 'playlists', 'sortProperties'
  noArtist: Ember.computed.empty 'artistName'
  noPlaylists: Ember.computed.empty 'playlists'

  showHelpText: ( ->
    return @get('noArtist') and @get('noPlaylists') and !@get('audioError')
  ).property 'noArtist', 'audioError'

  actions:

    setArtist: ->
      @set 'audioLoading', true
      @set 'audioError', false
      self = this

      artist = @get 'artistName'
      SCPlaylists = Ember.ArrayProxy.create content: []
      
      # Wrap our soundcloud api call in a promise
      return new Ember.RSVP.Promise (resolve, reject) ->
        SC.get "/users/#{artist}/playlists", (playlists) ->
          if playlists.length
            self.store.unloadAll 'playlist'
            self.store.unloadAll 'track'
            # Loop over each playlist and create an object in the store
            playlists.forEach (playlistItem, index, arr) ->
              playlist = self.store.createRecord 'playlist', {}
              # Only set some basic properties on the playlist
              playlist.setProperties
                id: playlistItem.id
                title: playlistItem.title
                artwork_url: playlistItem.artwork_url
              # Push the playlist into our ArrayProxy  
              SCPlaylists.pushObject playlist
              
              # Loop over each track in the playlist and create an object
              # in the store
              playlistItem.tracks.forEach (trackItem, index, arr) ->
                track = self.store.createRecord 'track', {}
                # Set track properties based on the object returned from SC
                # and set the playlist manually
                track
                  .setProperties trackItem
                  .set 'playlist', playlist
            
            # Set playlists on controller 
            playlists = SCPlaylists.get 'content'
            self.set 'playlists', playlists
            # Get the tracks from the most recent playlist
            tracks = playlists.get('firstObject').get 'tracks'
            # Get the first track from the most recent playlist
            track = tracks.get 'firstObject'
            # Set tracks on player controller and trigger our selectTrack action
            self.get('player')
              .set 'tracks', tracks
              .send 'selectTrack', track, 0, false

            # Resolve promise with content of ArrayProxy
            self.set 'audioLoading', false
            resolve(SCPlaylists.get 'content')

          else
            self.set 'audioError', true
            self.set 'audioLoading', false
            resolve()

    setAsPlaylist: (playlist) ->
      tracks = @store.all('track').filterBy 'playlist', playlist
      track = tracks.get 'firstObject'
      @get('player').set 'tracks', tracks if track?
      @get('player').send 'selectTrack', track, 0 if track?

`export default IndexController`
