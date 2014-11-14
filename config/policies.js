/**
 * Policy Mappings
 * (sails.config.policies)
 *
 * Policies are simple functions which run **before** your controllers.
 * You can apply one or more policies to a given controller, or protect
 * its actions individually.
 *
 * Any policy file (e.g. `api/policies/authenticated.js`) can be accessed
 * below by its filename, minus the extension, (e.g. "authenticated")
 *
 * For more information on how policies work, see:
 * http://sailsjs.org/#/documentation/concepts/Policies
 *
 * For more information on configuring policies, check out:
 * http://sailsjs.org/#/documentation/reference/sails.config/sails.config.policies.html
 */


module.exports.policies = {

  /***************************************************************************
  *                                                                          *
  * Default policy for all controllers and actions (`true` allows public     *
  * access)                                                                  *
  *                                                                          *
  ***************************************************************************/

//    '*': ['flash'],
    '*': [true]

  /***************************************************************************
  *                                                                          *
  * Here's an example of mapping some policies to run before a controller    *
  * and its actions                                                          *
  *                                                                          *
  ***************************************************************************/

/*
    PostController: {
        restricted: ['sessionAuth'],
        open: true,
        jwt: ['hasJsonWebToken']
    },
    UserController: {
        'subscribe': ['flash', 'sessionAuth'],
        '*': ['sessionAuth']
    },
    AccountController: {
//        'details': ['userCanSeeProfile', 'passport'],
//        'edit': ['flash', 'userCanSeeProfile', 'passport'],
//        'update': ['userCanSeeProfile', 'passport'],
        '*': ['flash', 'userCanSeeProfile']
    },
    AdminController: {
        '*': ['admin', 'flash']
    },
    MembersController: {
        */
/*
         'login': ['flash'],
         'registration': ['flash'],
         *//*

        'validation': [true],
        'reset': [true],
        'password': [true],
        '*': ['flash']

    },
    AuthController: {
        'reset': [true],
        'provider': [true, 'passport'],
        'callback': [true, 'passport']
    }
*/

    /* for future use with nested controllers. use path to controller, eg. user/UserController
    'user/UserController': {
        'subscribe': ['flash', 'sessionAuth'],
        'jwt': ['sessionAuth']
    },
    'user/AccountController': {
    //        'details': ['userCanSeeProfile', 'passport'],
    //        'edit': ['flash', 'userCanSeeProfile', 'passport'],
    //        'update': ['userCanSeeProfile', 'passport'],
        '*': ['flash', 'userCanSeeProfile', 'passport']
    },
    'sysman/AdminController': {
        '*': ['admin', 'flash']
    },
    'auth/MembersController': {
        'login': ['flash'],
        'registration': ['flash'],
        'validation': [true],
        'reset': [true],
        'password': [true],
        '*': ['flash']
    },
    'auth/AuthController': {
        'reset': [true],
        'provider': [true, 'passport'],
        'callback': [true, 'passport']
    }
*/
};
