Template.allUniversities.helpers
    universities1: ->
        Universities.findAll(true)
        
    canCreate: ->
        Universities.canCreate()

