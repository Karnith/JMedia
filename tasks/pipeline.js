/**
 * grunt/pipeline.js
 *
 * The order in which your css, javascript, and template files should be
 * compiled and linked from your views and static HTML files.
 *
 * (Note that you can take advantage of Grunt-style wildcard/glob/splat expressions
 * for matching multiple files.)
 */



// CSS files to inject in order
//
// (if you're using LESS with the built-in default config, you'll want
//  to change `assets/styles/importer.less` instead.)
var cssFilesToInject = [
  'vendor/angular-rx-data-table/dist/styles/rx-data-table.min.css',
  'vendor/angular-xeditable/dist/css/xeditable.css',
  'vendor/angular/angular-csp.css',
  'vendor/bootstrapValidator/dist/css/bootstrapValidator.min.css',
  'vendor/fontawesome/css/font-awesome.min.css',
  'vendor/ng-table/ng-table.css',
  'styles/neon.css',
  'styles/**/*.css'
];


// Client-side javascript files to inject in order
// (uses Grunt-style wildcard/glob/splat expressions)
var jsFilesToInject = [

    'vendor/jquery/dist/*.min.js',
    'vendor/gsap/**/*.js',
    'themes/default/js/bootstrap.js',

    // Load sails.io before everything else
    'vendor/socket.io-client/socket.io.js',
    'js/dependencies/sails.io.js',
    'js/socketConfig.js',

    // Dependencies like jQuery, or Angular are brought in here
    'js/dependencies/**/*.js',
    'vendor/angular/**/*.js',
    'vendor/angular-bootstrap/**/*.min.js',
    'vendor/angular-ui-router/**/*.min.js',
    'vendor/angular-ui-utils/**/*.min.js',
    'vendor/angular-sails/**/*.min.js',
    'vendor/moment/**/*.min.js',
    'vendor/angular-moment/**/*.min.js',
    'vendor/angular-translate/**/*.min.js',
    'vendor/angular-translate-loader-static-files/**/*.min.js',
    'vendor/ng-table/**/*.js',
    'vendor/isotope/**/*.js',
    'vendor/**/*.js',
    'src/**/*.js',
//    'src/app/app.js',

//    'themes/default/js/gsap/main-gsap.js',
    'themes/default/js/joinable.js',
    'themes/default/js/resizeable.js',
    'themes/default/js/neon-api.js',
    'themes/default/js/neon-custom.js',
//    'themes/default/js/neon-demo.js',

    // All of the rest of your client-side js files
    // will be injected here in no particular order.
    'js/**/*.js'
];

// Client-side HTML templates are injected using the sources below
// The ordering of these templates shouldn't matter.
// (uses Grunt-style wildcard/glob/splat expressions)
//
// By default, Sails uses JST templates and precompiles them into
// functions for you.  If you want to use jade, handlebars, dust, etc.,
// with the linker, no problem-- you'll just want to make sure the precompiled
// templates get spit out to the same file.  Be sure and check out `tasks/README.md`
// for information on customizing and installing new tasks.
var ngTemplateFilesToInject = [
  'src/app/**/*tpl.html'
];
var templateFilesToInject = [
  'templates/**/*.html'
];



// Prefix relative paths to source files so they point to the proper locations
// (i.e. where the other Grunt tasks spit them out, or in some cases, where
// they reside in the first place)
module.exports.ngTemplateFilesToInject = ngTemplateFilesToInject.map(function(path) {
  return 'assets/' + path;
});
module.exports.cssFilesToInject = cssFilesToInject.map(function(path) {
    return 'app/' + path;
});
module.exports.jsFilesToInject = jsFilesToInject.map(function(path) {
    return 'app/' + path;
});

/*
module.exports.cssFilesToInject = cssFilesToInject.map(function(path) {
  return '.tmp/public/' + path;
});
module.exports.jsFilesToInject = jsFilesToInject.map(function(path) {
  return '.tmp/public/' + path;
});
*/
module.exports.templateFilesToInject = templateFilesToInject.map(function(path) {
  return 'assets/' + path;
});
