ApplicationRoute = Ember.Route.extend

  renderTemplate: ->
    @_super()
    @render 'player',
      into: 'application'
      outlet: 'player'
      controller: 'player'

`export default ApplicationRoute`
