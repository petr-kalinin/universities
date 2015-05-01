Template.notification.helpers
    notificationClass: ->
        if (@read && UI._templateInstance().wasRead)
            undefined
        else 
            "list-group-item-info"

Template.notification.rendered = ->
    this.wasRead = this.data.read
    this.data.markAsRead()