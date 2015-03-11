Template.addUniversity.events
  "submit .new-university": (event) ->
    name = event.target.name.value
    UniversitiesCollection.insert name: name
    event.target.name.value = ""
    false
