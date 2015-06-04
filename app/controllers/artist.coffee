ArtistController = Ember.ArrayController.extend

  needs: ['player']
  player: Ember.computed.alias 'controllers.player'

  sortProperties: ['created_at:desc']
  sortedPlaylists: Ember.computed.sort 'model', 'sortProperties'

`export default ArtistController`
