/**
 * AuthController
 *
 * @module      :: Controller
 * @description	:: Provides the base authentication
 *                 actions used to make waterlock work.
 *
 * @docs        :: http://waterlock.ninja/documentation
 */

module.exports = require('waterlock').waterlocked({

    'registration': function(req, res) {
        res.view('members/registration');

        /* used for nested controllers
         res.view('members/registration');
         */
    },

    'login': function(req, res) {
        res.view();
    },

    /**
     * Create a third-party authentication endpoint
     *
     * @param {Object} req
     * @param {Object} res
     */
    provider: function (req, res) {
        passport.endpoint(req, res);
    },

    // route used to [post] verify fields from form before submit
    validation: function(req, res) {
        var params = req.params.all();
        User.findOne({
            or: [
                {name: {like:  params.name}},
                {email: {like: params.email}}
            ]
        }).exec(function(err, user){
            if(err) {
                waterlock.logger.debug(err);
                res.serverError();
            }
            if(!user) {

                return res.ok({valid: true});
            }
            else{
                waterlock.logger.debug('Name is in use!');
                return res.ok({valid: false});
            }
        });
    },

    /**
     * Create a authentication callback endpoint
     *
     * This endpoint handles everything related to creating and verifying Pass-
     * ports and users, both locally and from third-aprty providers.
     *
     * Passport exposes a login() function on req (also aliased as logIn()) that
     * can be used to establish a login session. When the login operation
     * completes, user will be assigned to req.user.
     *
     * For more information on logging in users in Passport.js, check out:
     * http://passportjs.org/guide/login/
     *
     * @param {Object} req
     * @param {Object} res
     */
    callback: function (req, res) {
        function tryAgain () {
            // If an error was thrown, redirect the user to the login which should
            // take care of rendering the error messages.
            req.flash('form', req.body);
            res.redirect(req.param('action') === 'register' ? '/register' : '/login');
        }

        passport.callback(req, res, function (err, user) {
            if (err) return tryAgain();
            req.login(user, function (loginErr) {
                if (loginErr) return tryAgain();
                req.session.user = user;
                req.session.authenticated = true;

                user.online = true;
                user.save(function(err, user) {
                    if(err) {
                        waterlock.logger.debug(err);
                        return next(err);
                    }
                    user.action = " signed-up and logged-in.";

                    User.publishCreate(user);

                    waterlock.logger.debug('user login success');
                    return res.redirect('/account/details/'+user.id);
                });
            });
        });
    }
});