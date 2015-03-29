Template.user.helpers
    name: ->
        this.profile?.name
        
    vkHref: ->
        a = this.services?.vk?.id 
        if a
            "http://vk.com/id" + a
        else 
            ""
            
    vkPhoto: ->
        a = this.services?.vk?.photo
        a ? a : ""
            
