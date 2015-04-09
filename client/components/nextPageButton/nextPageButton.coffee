Template.nextPageButton.helpers
    loaded: ->
        ctrl = Router.current()
        if ctrl.pageable
            ctrl.loaded(@name)
        else
            true

Template.nextPageButton.events
    'click .NextPageButton': (event) ->
        ctrl = Router.current()
        if ctrl.pageable
            ctrl.incLimit(@name, @perPage)