ArtistController = Ember.Controller.extend

  player: Ember.inject.service()

  sortProperties: ['created_at:desc']
  sortedPlaylists: Ember.computed.sort 'model', 'sortProperties'

`export default ArtistController`
