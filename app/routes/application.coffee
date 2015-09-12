ApplicationRoute = Ember.Route.extend
  
  beforeModel: ->
    Notification.requestPermission() if Notification?

`export default ApplicationRoute`
