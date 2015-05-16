Meteor.startup ->
    smtp = AuthparamsCollection.findOne({service: "smtp"})

#    username: 'your_username',   
#    password: 'your_password',   
#    server:   'smtp.gmail.com',  
#    port: 25 

    process.env.MAIL_URL = 'smtp://' + encodeURIComponent(smtp.username) + ':' + encodeURIComponent(smtp.password) + '@' +    encodeURIComponent(smtp.server) + ':' + smtp.port;

#    Email.send
#        from: smtp.username,
#        to: "petr@kalinin.nnov.ru",
#        subject: "Meteor Can Send Emails via Gmail",
#        text: "Its pretty easy to send emails via gmail."

    Accounts.emailTemplates.from = 'Обзор университетов <universities@kalinin.nnov.ru>'
    Accounts.emailTemplates.siteName = 'Обзор университетов'

    Accounts.emailTemplates.verifyEmail.subject = (user) ->
        'Подтвердите свой адрес электронной почты'

    Accounts.emailTemplates.verifyEmail.text = (user, url) ->
        'Здравствуйте!\n\n'+
        'Вы или кто-то еще добавил этот адрес к своему аккаунту на сайте ' + Meteor.absoluteUrl() + '.\n' +
        'Перейдите по следующей ссылке, чтобы подтвердить адрес электронной почты: ' + url + '\n' +
        'Если вы не добавляли этот адрес, ничего делать не требуется.'
