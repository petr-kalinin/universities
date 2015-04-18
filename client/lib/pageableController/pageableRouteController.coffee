varName = (inst, name = null) ->
    name = name && "_#{name}" || ""
    "#{inst.constructor.name}#{name}_limit"

class @PagableRouteController extends ControllerWithTitle
    pageable: true
    perPage: 10

    limit: (name = null) ->
        Session.get(varName(@, name)) || @perPage

    incLimit: (name = null, inc = null) ->
        inc ||= @perPage
        Session.set varName(@, name), (@limit(name) + inc)

    resetLimit: (name = null) ->
        Session.set varName(@, name), null

    loaded: (name = null) ->
        true