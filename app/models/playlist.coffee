Playlist = DS.Model.extend
  tracks: DS.hasMany 'track'

  artwork_url: DS.attr 'string'
  created_at: DS.attr 'date'
  permalink: DS.attr 'string'
  title: DS.attr 'string'

`export default Playlist`
