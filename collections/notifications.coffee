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

Notifications =
    createFromComment: (comment) ->
        user = Reviews.findById(comment.review).author
        baseDoc = user: user, type: "comment", event: comment._id
        @collection.insert baseDoc
        
    findByUser: (user) ->
        @collection.find {
            user: user._id
        }, sort: {createdAt: 1}

    collection: NotificationsCollection
    
@Notifications = Notifications
