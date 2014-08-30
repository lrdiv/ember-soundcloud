Router = Ember.Router.extend
  location: McEmberENV.locationType

Router.map ->
  @route 'index', { path: '/' }
  @route 'artist', { path: '/:artist' }

`export default Router`
