# a mixin for collection helpers
@BooleanProperty =
    _booleanProperty: (name, def) ->
        if not (Session.get(@_booleanPropertyName(name))?)
            if not (def?)
                def = false
            Session.set(@_booleanPropertyName(name), def)
            return def
        Session.get(@_booleanPropertyName(name))
        
    _toggleBooleanProperty: (name, def) ->
        if @_booleanProperty(name, @collapsedByDefault)
            Session.set(@_booleanPropertyName(name), false)
        else 
            Session.set(@_booleanPropertyName(name), true)
