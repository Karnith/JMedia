class App extends App('landing.about')
  constructor: ->
    return []

class config extends Config('landing.about')
  constructor: ($stateProvider) ->
    $stateProvider.state 'landing.about',
      url: '/about'
      views:
        'breadcrumb':
          templateUrl: 'common/breadcrumb/breadcrumb.tpl.html'
        'content':
          controller: 'AboutCtrl'
          templateUrl: 'frontend/frontpage/about/about.tpl.html'
      data:
        ncyBreadcrumbParent: 'landing.home'
        ncyBreadcrumbLabel: 'About'

class AboutCtrl extends Controller('landing.about')
  constructor: ($scope, titleService) ->
    titleService.setTitle 'About'