Template.home.helpers
    universities: ->
        Universities.findAll(true)
        
    canCreate: ->
        Universities.canCreate()

