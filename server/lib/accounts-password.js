(function () {

////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                //
// packages/accounts-password/email_templates.js                                                  //
//                                                                                                //
////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                  //
/**                                                                                               // 1
 * @summary Options to customize emails sent from the Accounts system.                            // 2
 * @locus Server                                                                                  // 3
 */                                                                                               // 4
Accounts.emailTemplates = {                                                                       // 5
  from: "Meteor Accounts <no-reply@meteor.com>",                                                  // 6
  siteName: Meteor.absoluteUrl().replace(/^https?:\/\//, '').replace(/\/$/, ''),                  // 7
                                                                                                  // 8
  resetPassword: {                                                                                // 9
    subject: function(user) {                                                                     // 10
      return "How to reset your password on " + Accounts.emailTemplates.siteName;                 // 11
    },                                                                                            // 12
    text: function(user, url) {                                                                   // 13
      var greeting = (user.profile && user.profile.name) ?                                        // 14
            ("Hello " + user.profile.name + ",") : "Hello,";                                      // 15
      return greeting + "\n"                                                                      // 16
        + "\n"                                                                                    // 17
        + "To reset your password, simply click the link below.\n"                                // 18
        + "\n"                                                                                    // 19
        + url + "\n"                                                                              // 20
        + "\n"                                                                                    // 21
        + "Thanks.\n";                                                                            // 22
    }                                                                                             // 23
  },                                                                                              // 24
  verifyEmail: {                                                                                  // 25
    subject: function(user) {                                                                     // 26
      return "How to verify email address on " + Accounts.emailTemplates.siteName;                // 27
    },                                                                                            // 28
    text: function(user, url) {                                                                   // 29
      var greeting = (user.profile && user.profile.name) ?                                        // 30
            ("Hello " + user.profile.name + ",") : "Hello,";                                      // 31
      return greeting + "\n"                                                                      // 32
        + "\n"                                                                                    // 33
        + "To verify your account email, simply click the link below.\n"                          // 34
        + "\n"                                                                                    // 35
        + url + "\n"                                                                              // 36
        + "\n"                                                                                    // 37
        + "Thanks.\n";                                                                            // 38
    }                                                                                             // 39
  },                                                                                              // 40
  enrollAccount: {                                                                                // 41
    subject: function(user) {                                                                     // 42
      return "An account has been created for you on " + Accounts.emailTemplates.siteName;        // 43
    },                                                                                            // 44
    text: function(user, url) {                                                                   // 45
      var greeting = (user.profile && user.profile.name) ?                                        // 46
            ("Hello " + user.profile.name + ",") : "Hello,";                                      // 47
      return greeting + "\n"                                                                      // 48
        + "\n"                                                                                    // 49
        + "To start using the service, simply click the link below.\n"                            // 50
        + "\n"                                                                                    // 51
        + url + "\n"                                                                              // 52
        + "\n"                                                                                    // 53
        + "Thanks.\n";                                                                            // 54
    }                                                                                             // 55
  }                                                                                               // 56
};                                                                                                // 57
                                                                                                  // 58
////////////////////////////////////////////////////////////////////////////////////////////////////

}).call(this);






(function () {

////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                //
// packages/accounts-password/password_server.js                                                  //
//                                                                                                //
////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                  //
///                                                                                               // 559
/// EMAIL VERIFICATION                                                                            // 560
///                                                                                               // 561
                                                                                                  // 562
                                                                                                  // 563
// send the user an email with a link that when opened marks that                                 // 564
// address as verified                                                                            // 565
                                                                                                  // 566
/**                                                                                               // 567
 * @summary Send an email with a link the user can use verify their email address.                // 568
 * @locus Server                                                                                  // 569
 * @param {String} userId The id of the user to send email to.                                    // 570
 * @param {String} [email] Optional. Which address of the user's to send the email to. This address must be in the user's `emails` list. Defaults to the first unverified email in the list.
 */                                                                                               // 572
Accounts.sendVerificationEmail = function (userId, address) {                                     // 573
  // XXX Also generate a link using which someone can delete this                                 // 574
  // account if they own said address but weren't those who created                               // 575
  // this account.                                                                                // 576
                                                                                                  // 577
  // Make sure the user exists, and address is one of their addresses.                            // 578
  var user = Meteor.users.findOne(userId);                                                        // 579
  if (!user)                                                                                      // 580
    throw new Error("Can't find user");                                                           // 581
  // pick the first unverified address if we weren't passed an address.                           // 582
  if (!address) {                                                                                 // 583
    var email = _.find(user.emails || [],                                                         // 584
                       function (e) { return !e.verified; });                                     // 585
    address = (email || {}).address;                                                              // 586
  }                                                                                               // 587
  // make sure we have a valid address                                                            // 588
  if (!address || !_.contains(_.pluck(user.emails || [], 'address'), address))                    // 589
    throw new Error("No such email address for user.");                                           // 590
                                                                                                  // 591
                                                                                                  // 592
  var tokenRecord = {                                                                             // 593
    token: Random.secret(),                                                                       // 594
    address: address,                                                                             // 595
    when: new Date()};                                                                            // 596
  Meteor.users.update(                                                                            // 597
    {_id: userId},                                                                                // 598
    {$push: {'services.email.verificationTokens': tokenRecord}});                                 // 599
                                                                                                  // 600
  // before passing to template, update user object with new token                                // 601
  Meteor._ensure(user, 'services', 'email');                                                      // 602
  if (!user.services.email.verificationTokens) {                                                  // 603
    user.services.email.verificationTokens = [];                                                  // 604
  }                                                                                               // 605
  user.services.email.verificationTokens.push(tokenRecord);                                       // 606
                                                                                                  // 607
  var verifyEmailUrl = Accounts.urls.verifyEmail(tokenRecord.token);                              // 608
                                                                                                  // 609
  var options = {                                                                                 // 610
    to: address,                                                                                  // 611
    from: Accounts.emailTemplates.verifyEmail.from                                                // 612
      ? Accounts.emailTemplates.verifyEmail.from(user)                                            // 613
      : Accounts.emailTemplates.from,                                                             // 614
    subject: Accounts.emailTemplates.verifyEmail.subject(user),                                   // 615
    text: Accounts.emailTemplates.verifyEmail.text(user, verifyEmailUrl)                          // 616
  };                                                                                              // 617
                                                                                                  // 618
  if (typeof Accounts.emailTemplates.verifyEmail.html === 'function')                             // 619
    options.html =                                                                                // 620
      Accounts.emailTemplates.verifyEmail.html(user, verifyEmailUrl);                             // 621
                                                                                                  // 622
  if (typeof Accounts.emailTemplates.headers === 'object') {                                      // 623
    options.headers = Accounts.emailTemplates.headers;                                            // 624
  }                                                                                               // 625
                                                                                                  // 626
  Email.send(options);                                                                            // 627
};                                                                                                // 628
                                                                                                  // 629
// Take token from sendVerificationEmail, mark the email as verified,                             // 630
// and log them in.                                                                               // 631
Meteor.methods({verifyEmail: function (token) {                                                   // 632
  var self = this;                                                                                // 633
  return Accounts._loginMethod(                                                                   // 634
    self,                                                                                         // 635
    "verifyEmail",                                                                                // 636
    arguments,                                                                                    // 637
    "password",                                                                                   // 638
    function () {                                                                                 // 639
      check(token, String);                                                                       // 640
                                                                                                  // 641
      var user = Meteor.users.findOne(                                                            // 642
        {'services.email.verificationTokens.token': token});                                      // 643
      if (!user)                                                                                  // 644
        throw new Meteor.Error(403, "Verify email link expired");                                 // 645
                                                                                                  // 646
      var tokenRecord = _.find(user.services.email.verificationTokens,                            // 647
                               function (t) {                                                     // 648
                                 return t.token == token;                                         // 649
                               });                                                                // 650
      if (!tokenRecord)                                                                           // 651
        return {                                                                                  // 652
          userId: user._id,                                                                       // 653
          error: new Meteor.Error(403, "Verify email link expired")                               // 654
        };                                                                                        // 655
                                                                                                  // 656
      var emailsRecord = _.find(user.emails, function (e) {                                       // 657
        return e.address == tokenRecord.address;                                                  // 658
      });                                                                                         // 659
      if (!emailsRecord)                                                                          // 660
        return {                                                                                  // 661
          userId: user._id,                                                                       // 662
          error: new Meteor.Error(403, "Verify email link is for unknown address")                // 663
        };                                                                                        // 664
                                                                                                  // 665
      // By including the address in the query, we can use 'emails.$' in the                      // 666
      // modifier to get a reference to the specific object in the emails                         // 667
      // array. See                                                                               // 668
      // http://www.mongodb.org/display/DOCS/Updating/#Updating-The%24positionaloperator)         // 669
      // http://www.mongodb.org/display/DOCS/Updating#Updating-%24pull                            // 670
      Meteor.users.update(                                                                        // 671
        {_id: user._id,                                                                           // 672
         'emails.address': tokenRecord.address},                                                  // 673
        {$set: {'emails.$.verified': true},                                                       // 674
         $pull: {'services.email.verificationTokens': {token: token}}});                          // 675
                                                                                                  // 676
      return {userId: user._id};                                                                  // 677
    }                                                                                             // 678
  );                                                                                              // 679
}});                                                                                              // 680
                                                                                                  // 681
///                                                                                               // 779
/// PASSWORD-SPECIFIC INDEXES ON USERS                                                            // 780
///                                                                                               // 781
Meteor.users._ensureIndex('emails.validationTokens.token',                                        // 782
                          {unique: 1, sparse: 1});                                                // 783
Meteor.users._ensureIndex('services.password.reset.token',                                        // 784
                          {unique: 1, sparse: 1});                                                // 785
                                                                                                  // 786
////////////////////////////////////////////////////////////////////////////////////////////////////

}).call(this);
