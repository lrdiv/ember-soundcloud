import Ember from 'ember';
import Resolver from 'ember/resolver';
import loadInitializers from 'ember/load-initializers';

Ember.MODEL_FACTORY_INJECTIONS = true;

var App = Ember.Application.extend({
  modulePrefix: 'mc-ember', // TODO: loaded via config
  Resolver: Resolver,
  rootElement: '#soundcloud-root'
});

loadInitializers(App, 'mc-ember');

export default App;
