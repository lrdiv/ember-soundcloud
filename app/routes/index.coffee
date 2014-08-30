IndexRoute = Ember.Route.extend

  model: ->
    @store.all 'playlist'

`export default IndexRoute`
