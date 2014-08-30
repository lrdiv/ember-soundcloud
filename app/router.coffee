Router = Ember.Router.extend
  location: McEmberENV.locationType

Router.map ->
  @route 'index', { path: '/' }

`export default Router`
