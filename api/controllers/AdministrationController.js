/**
 * AdministrationController
 *
 * @description :: Server-side logic for managing administrations
 * @help        :: See http://links.sailsjs.org/docs/controllers
 */

module.exports = {
    index: function(req, res) {
        res.view();
    },
    // route to [get] and show all users
    users: function(req, res, next) {
        User.find(function foundUsers(err, users) {
            if(err) {
                waterlock.logger.debug(err);
                return req.serverError();
            }
            res.view({
                users: users
            });
        });
    },
    // route to [post] user id to delete user record from user/auth collections
    destroy: function(req, res, next) {
        var params = req.params.all();
//        User.unsubscribe(req.socket, params.id);
        User.findOneById(params.id).exec(function(err, usr) {
            if(err) {
                waterlock.logger.debug(err);
                return res.redirect('/administration/users');
            }
            if(!usr) {
                waterlock.logger.debug('User doesn\'t exist.');
                return res.redirect('/administration/users');
            }

            User.destroy({id: usr.id}).exec(function(err, record) {
                if(err) {
                    waterlock.logger.debug(err);
                    return res.redirect('/administration/users');
                }
                var auth = record.map(function(rId){ return rId.id;});
                Auth.destroy({user: auth}).exec(function(err){
                    if(err) {
                        waterlock.logger.debug(err);
                        return res.redirect('/administration/users');
                    }

                    Passport.destroy({user: usr.id}).exec(function(err){
                        if(err) {
                            waterlock.logger.debug(err);
                            return res.redirect('/administration/users');
                        }

                        User.publishUpdate(usr.id, {
                            id: usr.id,
                            name: usr.name,
                            action: ' has been destroyed.'
                        });

                        User.publishDestroy(usr.id);
                        res.redirect('/administration/users');
                    });
                });
            });
        });
    }
};

