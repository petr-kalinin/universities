Template.home.helpers
  universities: ->
    UniversitiesCollection.find {}, sort: {name: 1}

