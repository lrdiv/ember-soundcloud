Playlist = DS.Model.extend
  tracks: DS.hasMany 'track'

  artwork_url: DS.attr 'string'
  created_at: DS.attr 'date'
  title: DS.attr 'string'

`export default Playlist`
