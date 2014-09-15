/**
 * MembersController
 *
 * @description :: Server-side logic for managing members
 * @help        :: See http://links.sailsjs.org/docs/controllers
 */

module.exports = {

    // reset password page
    reset: function(req, res) {
        res.view();
    },

    //change password page
    password: function(req, res) {
        res.view();
    },

    index: function(req, res) {
        res.view()
    }
};

