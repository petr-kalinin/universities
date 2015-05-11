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
