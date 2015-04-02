Template.navigation.helpers
    isActive: (path, id) ->
        if id
            path = path + "/" + id
        currentPath = Iron.Location.get().path
        res = ("/" + path == currentPath)
        if res
            'active'
        else 
            ''
            
    currentUniversity: ->
        router = Router.current()
        if not (router && router.name() == 'university' && router.data())
            return name: '', active: ''
        return  name: router.data().name, active: 'active'
            
    universities: ->
        Universities.findAll true
