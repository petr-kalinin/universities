Meteor.startup ->
    vkdata = AuthparamsCollection.findOne({service: "vk"})

    ServiceConfiguration.configurations.remove
        service: 'vk'

    ServiceConfiguration.configurations.insert
        service: 'vk'
        appId:   vkdata.appId
        secret:  vkdata.secret
        scope: "notify"

