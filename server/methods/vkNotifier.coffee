Meteor.startup ->
    vkdata = AuthparamsCollection.findOne service: "vk"

    VK = Meteor.npmRequire 'vksdk'
    vk = new VK
        'appId'     : vkdata.appId,
        'appSecret' : vkdata.secret
        
    res = vk.setSecureRequests(true)
    console.log "vk"
    console.log res
    
    vk.requestServerToken();

    vk.on 'serverTokenReady', (_o) ->
        console.log(_o)
        vk.setToken(_o.access_token)
    
        vk.request 'secure.sendNotification', {user_id: 12025501, message: "test"}, 
            (_dd) ->
                console.log _dd

        
    @VkNotifier = (userId) ->
        true