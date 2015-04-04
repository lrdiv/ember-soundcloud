`import config from './config/environment'`

Router = Ember.Router.extend
  location: config.locationType

Router.map ->
  @route 'index', { path: '/' }
  @route 'artist', { path: '/:artist' }

`export default Router`
