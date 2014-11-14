/**
 * User
 *
 * @module      :: Model
 * @description :: This is the base user model
 * @docs        :: http://waterlock.ninja/documentation
 */

module.exports = {

    attributes: require('waterlock').models.user.attributes({

        /* e.g.
        nickname: 'string'
        */
        //      uid: { type: 'json' },

        username: {
          type: 'string',
          unique: true
        },

        name: {
          type: 'string',
          required: true
        },

        title: {
          type: 'string',
          defaultsTo: 'Need a title?'
        },

        email: {
           type: 'string',
           email: true,
           required: true,
           unique: true
        },

        online: {
          type: 'boolean',
          defaultsTo: false
        },

        admin: {
          type: 'boolean',
          defaultsTo: false
        },

        passports : {
          collection: 'Passport',
          via: 'user'
        }
    }),
  
    beforeCreate: require('waterlock').models.user.beforeCreate,
    beforeUpdate: require('waterlock').models.user.beforeUpdate,

    getAll: function() {
        return User.find()
            .then(function (models) {
                return [models];
            });
    },

    getOne: function(id) {
        return User.findOne(id)
            .then(function (model) {
                return [model];
            });
    }
};
