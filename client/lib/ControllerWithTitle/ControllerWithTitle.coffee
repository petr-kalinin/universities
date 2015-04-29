class @ControllerWithTitle extends RouteController
    title: ->
        ""

    onAfterAction: ->
        thisTitle = @title()
        if !!@title()
            thisTitle = thisTitle + " — "
        else 
            thisTitle = ""
        thisTitle = thisTitle + "Обзор университетов"
        SEO.set title: thisTitle
