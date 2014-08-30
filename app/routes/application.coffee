ApplicationRoute = Ember.Route.extend

  activate: ->
    SC.initialize
      client_id: McEmberENV.soundcloud_client_id
      redirect_url: '#'

  renderTemplate: ->
    @_super()
    @render 'player',
      into: 'application'
      outlet: 'player'
      controller: 'player'

`export default ApplicationRoute`
