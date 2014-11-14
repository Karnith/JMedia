/**
 * AccountController
 *
 * @description :: Server-side logic for managing accounts
 * @help        :: See http://links.sailsjs.org/docs/controllers
 */

module.exports = {

    // route to create user, user auth and associate them
    register: function(req, res) {
        var params = req.params.all(),
            auth = {
                email: params.email,
                password: params.password
            },
            userObj = {
                name: params.name,
                title: params.title,
                email: params.email
            };

        User.create(userObj)
            .exec(function (err, user){
                if (err){
                    waterlock.logger.debug(err);
                    req.session.flash = {
                        err: err
                    };

                    return res.redirect('/registration');
                }
                req.session.user = user;
                req.session.authenticated = true;
                waterlock.engine.attachAuthToUser(auth, user, function (err) {
                    if (err) {
                        waterlock.logger.debug(err);
                        res.redirect('/registration');
                    }
                    user.online = true;
                    user.save(function (err, user) {
                        if (err) {
                            sailsLog('err', err);
                            return next(err);
                        }

                        user.action = " signed-up and logged-in.";

                        User.publishCreate(user);

                        waterlock.logger.debug('user login success');
//                        return res.redirect('/account/details/'+user.id);
                        return res.redirect('/members');
                    });
                });
            });
    },

    // route to [get] and show user
    details: function(req, res, next) {
        var params = req.params.all();
        User.findOne(params.id, function foundUser(err, user) {
            if(err) {
                waterlock.logger.debug(err);
                return req.serverError();
            }
            if(!user) {
                waterlock.logger.debug('User not found.');
                return next();
            }
            res.view({
                user: user
            });

            /* for future use with nested controllers and models. need to specify path to view before
                the local is provided.
                        res.view('account/details', {
                            user: user
                        });
            */
        });
    },
    // route used to [get] user fields for edit
    edit: function(req, res, next) {
        var params = req.params.all();
        User.findOne(params.id, function foundUser(err, user) {
            if(err) {
                waterlock.logger.debug(err);
                return req.serverError();
            }
            if(!user) {
                waterlock.logger.debug('User not found.');
                return next();
            }

            res.view({
                user: user
            })
        })
    },
    // route to [post] edited fields and save to user/auth collections
    update: function(req, res, next) {
        var params = req.params.all(),
            userObj = {
                name: params.name,
                title: params.title,
                email: params.email
            },
            authObj = {
                email: params.email,
                password: params.password
            },
            admin = false,
            adminParam = params.admin;

        if (req.session.user.admin) {
            if (typeof adminParam !== 'undefined') {
                if (adminParam === 'unchecked') {
                    admin = false;
                } else  if (adminParam[1] === 'on') {
                    admin = true;
                }
            }
            userObj.admin = admin;
        }

        User.update(params.id, userObj).exec(function(err) {
            if (err) {
                waterlock.logger.debug(err);
                return res.redirect('/profile/edit/' + params.id);
            }

            if(!authObj.password || authObj.password === 'undefined') {
                delete (authObj.password);
            }

            Auth.update({user: req.session.user.id}, authObj).exec( function(err){
                if(err){
                    waterlock.logger.debug(err);
                    return res.redirect('/profile/edit/' + params.id);
                }
                req.session.user.email = params.email;
                res.redirect('/profile/details/' + params.id);
            });
        });
    },

    // route to [post] user id to delete user record from user/auth collections
    destroy: function(req, res, next) {
        var params = req.params.all();
        User.unsubscribe(req.socket, params.id);
        User.findOneById(params.id).exec(function(err, usr) {
            if(err) {
                waterlock.logger.debug(err);
                return res.redirect('/');
            }
            if(!usr) {
                waterlock.logger.debug('User doesn\'t exist.');
                return res.redirect('/registration');
            }

            User.destroy({id: usr.id}).exec(function(err, record) {
                if(err) {
                    waterlock.logger.debug(err);
                    return res.redirect('/');
                }
                var auth = record.map(function(rId){ return rId.id;});
                Auth.destroy({user: auth}).exec(function(err){
                    if(err) {
                        waterlock.logger.debug(err);
                        return res.redirect('/');
                    }

                    User.publishUpdate(usr.id, {
                        id: usr.id,
                        name: usr.name,
                        action: ' has been destroyed.'
                    });

                    User.publishDestroy(usr.id);
                    res.redirect('/');
                });
            });
        });
    }
};

