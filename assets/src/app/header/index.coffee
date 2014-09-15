class App extends App('sailng.header')
  constructor: ->
    return []

class HeaderCtrl extends Controller('sailng.header')
  constructor: ($scope, $state, config)->
    $scope.currentUser = config.currentUser
    navItems = [
      title: "Todos"
      translationKey: "navigation:todos"
      url: "/todos"
      cssClass: "fa fa-tasks fa-lg"
    ]
    $scope.navItems = navItems