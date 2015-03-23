Template.addUniversity.events
  "submit .new-university": (event) ->
    name = event.target.name.value
    UniversitiesCollection.create name
    event.target.name.value = ""
    false
