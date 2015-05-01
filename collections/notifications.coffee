notificationsSchema = SimpleSchema.build SimpleSchema.timestamp,
    'user':
        type: String
        index: true
    'type':
        type: String
    'event':
        type: String
    'notified':
        type: Boolean
    'read':
        type: Boolean

NotificationsCollection = new Mongo.Collection 'notifications'
NotificationsCollection.attachSchema notificationsSchema

NotificationsCollection.allow
    insert: (userId, doc) ->
        Meteor.isServer
    update: (userId, doc, fields, modifier) ->
        if not (_.isEqual(fields, ["read", "updatedAt"]))
            return false
        trDoc = NotificationsCollection._transform doc
        trDoc.canUpdate()

NotificationsCollection.helpers
    canUpdate: ->
        user = Users.currentUser()
        user && (user._id == @user)
        
    isComment: ->
        @type == "comment"
        
    comment: ->
        if (!@isComment)
            throw new Meteor.Error "wrong-notification-type", "Notification is not a comment"
        Comments.findById(@event)
        
    markAsRead: ->
        if !@canUpdate()
            throw new Meteor.Error "permission-denied", "Can't mark notification as read"
        Notifications.collection.update _id: @_id,
            $set:
                read: true
            

Notifications =
    createFromComment: (comment) ->
        user = Reviews.findById(comment.review).author
        baseDoc = user: user, type: "comment", event: comment._id, read: false, notified: false
        @collection.insert baseDoc
        
    findByUser: (user) ->
        if user?._id
            @collection.find {
                user: user._id
            }, sort: {createdAt: -1}
        else
            undefined
            
    findMyUnread: ->
        if Users.currentUser()
            @collection.find {
                user: Users.currentUser()._id,
                read: false
            }, sort: {createdAt: -1}
        else
            undefined

    collection: NotificationsCollection
    
@Notifications = Notifications
