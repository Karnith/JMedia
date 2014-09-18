class App extends App('members.dash')
  constructor: ->
    return []

class config extends Config('members.dash')
  constructor: ($stateProvider) ->
    $stateProvider.state 'members.dash',
      url: '/members'
      views:
        '':
          controller: 'MembersDashCtrl'
          templateUrl: 'members/membersdash/index.tpl.html'

class MembersDashCtrl extends Controller('members.dash')
  constructor: ($scope, titleService) ->
    titleService.setTitle 'Members Dashboard'