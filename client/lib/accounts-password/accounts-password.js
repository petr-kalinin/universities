(function () {

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                            //
// packages/accounts-password/password_client.js                                                              //
//                                                                                                            //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                              //
// Verifies a user's email address based on a token originally                                                // 242
// created by Accounts.sendVerificationEmail                                                                  // 243
//                                                                                                            // 244
// @param token {String}                                                                                      // 245
// @param callback (optional) {Function(error|undefined)}                                                     // 246
                                                                                                              // 247
/**                                                                                                           // 248
 * @summary Marks the user's email address as verified. Logs the user in afterwards.                          // 249
 * @locus Client                                                                                              // 250
 * @param {String} token The token retrieved from the verification URL.                                       // 251
 * @param {Function} [callback] Optional callback. Called with no arguments on success, or with a single `Error` argument on failure.
 */                                                                                                           // 253
Accounts.verifyEmail = function(token, callback) {                                                            // 254
  if (!token)                                                                                                 // 255
    throw new Error("Need to pass token");                                                                    // 256
                                                                                                              // 257
  Accounts.callLoginMethod({                                                                                  // 258
    methodName: 'verifyEmail',                                                                                // 259
    methodArguments: [token],                                                                                 // 260
    userCallback: callback});                                                                                 // 261
};                                                                                                            // 262
                                                                                                              // 263
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}).call(this);
