class @ControllerWithTitle extends RouteController
    title: ->
        ""

    onAfterAction: ->
        thisTitle = @title()
        if !!@title()
            thisTitle = thisTitle + " — "
        thisTitle = thisTitle + "Обзор университетов"
        SEO.set title: thisTitle
