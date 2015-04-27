notificationsSchema = SimpleSchema.build SimpleSchema.timestamp,
  'user':
    type: String
    index: true
  'type':
    type: String
  'from':
    type: String

NotificationsCollection = new Mongo.Collection 'notifications'
NotificationsCollection.attachSchema notificationsSchema

NotificationsCollection.helpers

Notifications =

    collection: NotificationsCollection
    
@Notifications = Notifications
