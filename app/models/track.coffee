Track = DS.Model.extend
  playlist: DS.belongsTo 'playlist'

  artwork_url: DS.attr 'string'
  created_at: DS.attr 'date'
  duration: DS.attr 'string'
  title: DS.attr 'string'
  uri: DS.attr 'string'

`export default Track`
