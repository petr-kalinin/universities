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
        if (router?.getUniversity)
            return univ: router.getUniversity(),  active: 'active'
        return undefined
            
    universities: ->
        Universities.findAll true
        
    currentUser: ->
        Users.currentUser()