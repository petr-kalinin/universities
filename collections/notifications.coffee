notificationsSchema = SimpleSchema.build SimpleSchema.timestamp,
  'user':
    type: String
    index: true
  'type':
    type: String
  'event':
    type: String

NotificationsCollection = new Mongo.Collection 'notifications'
NotificationsCollection.attachSchema notificationsSchema

NotificationsCollection.allow
    insert: (userId, doc) ->
        Meteor.isServer

NotificationsCollection.helpers
    isComment: ->
        @type == "comment"
        
    comment: ->
        if (!@isComment)
            throw new Meteor.Error "wrong-notification-type", "Notification is not a comment"
        Comments.findById(@event)
            

Notifications =
    createFromComment: (comment) ->
        user = Reviews.findById(comment.review).author
        baseDoc = user: user, type: "comment", event: comment._id
        @collection.insert baseDoc
        
    findByUser: (user) ->
        if user?._id
            @collection.find {
                user: user._id
            }, sort: {createdAt: 1}
        else
            undefined

    collection: NotificationsCollection
    
@Notifications = Notifications
