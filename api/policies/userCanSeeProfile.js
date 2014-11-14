/**
 * Policy: userCanSeeProfile.js
 * Description: profile policy for sailsjs
 *
 * Created by mmarino on 8/15/2014.
 */
module.exports = function(req, res, ok) {
    var params = req.params.all();
    if (!req.session.user) {
        res.redirect('/members/login');
        return;
    }

    var sessionUserMatchesId = req.session.user.id.toString() === params.id;
    var isAdmin = req.session.user.admin;
/*
    console.log(sessionUserMatchesId);
    console.log(req.session.user.id);
    console.log(req.param('id'));
*/
    // The requested id does not match the user's id,
    // and this is not an admin
    if (!(sessionUserMatchesId || isAdmin)) {
        var noRightsError = [{name: 'noRights', message: 'You must be an admin.'}];
        req.session.flash = {
            err: noRightsError
        };
        res.redirect('/members/login');
        return;
    }

    ok();

};