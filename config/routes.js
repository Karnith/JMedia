/**
 * Route Mappings
 * (sails.config.routes)
 *
 * Your routes map URLs to views and controllers.
 *
 * If Sails receives a URL that doesn't match any of the routes below,
 * it will check for matching files (images, scripts, stylesheets, etc.)
 * in your assets directory.  e.g. `http://localhost:1337/images/foo.jpg`
 * might match an image file: `/assets/images/foo.jpg`
 *
 * Finally, if those don't match either, the default 404 handler is triggered.
 * See `api/responses/notFound.js` to adjust your app's 404 logic.
 *
 * Note: Sails doesn't ACTUALLY serve stuff from `assets`-- the default Gruntfile in Sails copies
 * flat files from `assets` to `.tmp/public`.  This allows you to do things like compile LESS or
 * CoffeeScript for the front-end.
 *
 * For more information on configuring custom routes, check out:
 * http://sailsjs.org/#/documentation/concepts/Routes/RouteTargetSyntax.html
 */

module.exports.routes = {

    /***************************************************************************
    *                                                                          *
    * Make the view located at `views/homepage.ejs` (or `views/homepage.jade`, *
    * etc. depending on your default view engine) your home page.              *
    *                                                                          *
    * (Alternatively, remove this and add an `index.html` file in your         *
    * `assets` directory)                                                      *
    *                                                                          *
    ***************************************************************************/

    /**
     * We set the default language for all routes
     * **/
    '/*': function(req, res, next) {
        // res.setLocale(req.param('lang') || sails.config.i18n.defaultLocale);
        res.setLocale(sails.config.i18n.defaultLocale);
        return next();
    },

    'get /': 'HomeController.index',
//    '/': {view: 'index'},

    /*
    '/admin/users': 'AdministrationController.users',
    '/admin': 'AdministrationController.index',
    'post /admin/destroy': 'AdministrationController.destroy',
    */
    /* for future use of nested controllers and models, req.param() = :param, eg. req.param('id') = :id
    '/members/registration': {controller: 'auth/MembersController', action: 'registration'},
    '/members/register': {controller: 'auth/MembersController', action: 'register'},
    'post /members/validation': {controller: 'auth/MembersController', action: 'validation'},
    '/account/details/:id': {controller: 'user/AccountController', action: 'details'},
    */
    'post /auth/reset': 'AuthController.reset',
    'get /auth/reset': 'AuthController.reset',
    'get /auth/:provider': 'AuthController.provider',
    'get /auth/:provider/callback': 'AuthController.callback',
    'get /auth/:provider/:action': 'AuthController.callback',

    /***************************************************************************
    *                                                                          *
    * Custom routes here...                                                    *
    *                                                                          *
    *  If a request to a URL doesn't match any of the custom routes above, it  *
    * is matched against Sails route blueprints. See `config/blueprints.js`    *
    * for configuration options and examples.                                  *
    *                                                                          *
    ***************************************************************************/

    /**
     * User routes
     */
    'get /api/user': 'UserController.getAll',
    'get /api/user/:id': 'UserController.getOne',
//    'get /api/user/subscribe': 'UserController.subscribe',
    'post /api/user': 'UserController.create',


    // If a request to a URL doesn't match any of the custom routes above, it is matched
    // against Sails route blueprints.  See `config/blueprints.js` for configuration options
    // and examples.
    'get /about': 'HomeController.index',
    'get /home': 'HomeController.index',
    'get /login': 'HomeController.index',
//    'get /members': 'HomeController.index',
//    'get /users': 'HomeController.index',
    'get /register': 'HomeController.index'

};
