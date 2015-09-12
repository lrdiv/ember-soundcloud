ArtistIndexRoute = Ember.Route.extend

  player: Ember.inject.service()

  setupController: (controller, model) ->
    @_super controller, model
    # Get the model's first playlist and track to have something loaded in the
    # player outlet, without having to autoplay
    tracks = model
      .get 'firstObject'
      .get 'tracks'
    track = tracks.get 'firstObject'
    @get('player').set('tracks', tracks)
    @get('player').selectTrack(track, 0, false)

`export default ArtistIndexRoute`
