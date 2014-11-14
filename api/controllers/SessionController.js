/**
 * SessionController
 *
 * @description :: Server-side logic for managing sessions
 * @help        :: See http://links.sailsjs.org/docs/controllers
 */
var bcrypt = require('bcryptjs');
module.exports = {
/*
    'new': function(req, res) {
        res.view('session/new');
    },
*/

    'login': function(req, res, next) {
        var params = req.params.all(),
            usernamePasswordRequiredError;
        if (!params.email || !params.password) {
            usernamePasswordRequiredError = [
                {
                    name: 'usernamePasswordRequired',
                    message: 'You must enter both a username and password.'
                }];

            req.session.flash = {
                err: usernamePasswordRequiredError
            };

            return res.redirect('/register');
        }

        User.findOneByEmail(params.email).populate('auth').exec(function(err, user){
            if(err) {
                waterlock.logger.debug(err);
                return next(err);
            }
            if (user) {
                req.session.user = user;
                if(bcrypt.compareSync(params.password, user.auth.password)){

                    req.session.authenticated = true;

                    user.online = true;
                    delete (req.session.user.auth);
                    user.save(function(err, user) {
                        if(err) {
                            waterlock.logger.debug(err);
                            return next(err);
                        }

                        User.publishUpdate(user.id, {
                            loggedIn: true,
                            id: user.id,
                            name: user.name,
                            action: ' has logged in.'
                        });


                        if (req.session.user.admin) {
                            res.redirect('/users');
                            return;
                        }
                        waterlock.logger.debug('user login success');
                        res.redirect('/profile/details/' + user.id);
                    });
                }else{
                    if(err) {
                        waterlock.logger.debug(err);
                        return res.redirect('/register')
                    }
                    return res.redirect('/register');
                }
            } else {
                //TODO redirect to register
                if(err) {
                    waterlock.logger.debug(err);
                    return res.redirect('/register');
                }
                return res.redirect('/register');
            }
        });
    },

    logout: function(req, res, next) {
        User.findOne(req.session.user.id, function foundUsers(err, user) {
            var userId = req.session.user.id;

            if(user) {
                User.update(userId, {
                        online: false
                    },
                    function(err) {
                        if(err) {
                            waterlock.logger.debug(err);
                            return next(err);
                        }

                        User.publishUpdate(userId, {
                            loggedIn: false,
                            id: user.id,
                            name: user.name,
                            action: ' has logged out.'
                        });

                    req.session.destroy();

                    waterlock.logger.debug('user logout');

                    res.redirect('/');
                });
            } else {
                req.session.destroy();
                waterlock.logger.debug('user logout');

                res.redirect('/');
            }
        });
    }
};