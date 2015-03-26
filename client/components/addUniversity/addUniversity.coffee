Template.addUniversity.events
  "submit .new-university": (event) ->
    name = event.target.name.value
    Universities.create name
    event.target.name.value = ""
    false
