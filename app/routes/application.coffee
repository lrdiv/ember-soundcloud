ApplicationRoute = Ember.Route.extend
  
  beforeModel: ->
    Notification.requestPermission() if Notification?

  renderTemplate: ->
    @_super()
    @render 'player',
      into: 'application'
      outlet: 'player'
      controller: 'player'

`export default ApplicationRoute`
