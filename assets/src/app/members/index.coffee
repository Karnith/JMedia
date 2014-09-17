class App extends App('members')
  constructor: ->
    return [
      'members.dash'
      'members.users'
    ]

class config extends Config('members')
  constructor: ($stateProvider) ->
    $stateProvider.state 'members',
      abstract: true
      template: '<ui-view/>'
      controller: 'MembersCtrl'


class MembersCtrl extends Controller('members')
  constructor: ($scope, titleService) ->
    titleService.setTitle 'Members'