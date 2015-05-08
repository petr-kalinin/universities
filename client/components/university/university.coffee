Template.university.helpers
    categories: ->
        Categories.findTopLevel()

    root: ->
        Categories.findRoot()
