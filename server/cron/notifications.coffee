class BasicNotifier
    sendNotifications: ->
        notifications = Notifications.findNonNotified(@method)
        userData = {}
        for n in notifications.fetch()
            user = n.user
            if not (userData[user]?)
                userData[user] = []
            userData[user].push n
            Notifications.findById(n._id).markAsNotified(@method)
        for user, data of userData
            count = data.length
            links = (Notifications.findById(n._id).link() for n in data)
            console.log count, links
            @notifyUser(user, count, links)
            
class EmailNotifier extends BasicNotifier
    method: "email"

    notifyUser: (user, count, links) ->
        decl = declension(count, ["новое уведомление", "новых уведомления", "новых уведомлений"])
        subject = "У вас " + count + " " + decl
        text = "Здравствуйте!\n\nУ вас " + count + " " + decl + ".\n\n" +
                "Перейдите по ссылке " + Meteor.absoluteUrl() + "user/" + user + " , чтобы просмотреть все уведомления, " +
                "или по отдельным ссылкам ниже: \n\n" +
                links.join("\n")
        try
            Users.findById(user).sendEmail(subject, text)
        catch e
            if not ((e instanceof Meteor.Error) and (e.error == "email-not-verified"))
                throw e
            else console.log "User email is not verified"

class VkNotifier extends BasicNotifier
    method: "vk"
            
    notifyUser: (user, count, links) ->
        decl = declension(count, ["новое уведомление", "новых уведомления", "новых уведомлений"])
        text = "Здравствуйте!\n\nУ вас " + count + " " + decl + ".\n\n" +
                "Перейдите по ссылке " + Meteor.absoluteUrl() + "user/" + user + " , чтобы просмотреть все уведомления, " +
                "или по отдельным ссылкам ниже: \n\n" +
                links.join("\n")
        vkNotifier.request 'secure.sendNotification', {user_id: Users.findById(user).services.vk.id, message: text},

SyncedCron.add
    name: 'sendEmailNotifications',
    schedule: (parser) ->
        return parser.text('every 10 seconds');
    job: -> 
        (new EmailNotifier()).sendNotifications()

SyncedCron.add
    name: 'sendVkNotifications',
    schedule: (parser) ->
        return parser.text('every 10 seconds');
    job: -> 
        (new VkNotifier()).sendNotifications()
