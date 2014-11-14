class App extends App('members.users')
  constructor: ->
    return []

class Config extends Config('members.users')
  constructor: ($stateProvider)->
    $stateProvider.state 'members.users',
      url: '/members'
      views:
        'breadcrumb':
          templateUrl: 'common/breadcrumb/breadcrumb.tpl.html'
        'content':
          controller: 'UserCtrl'
          templateUrl: 'frontend/members/users/user.tpl.html'
      data:
        pageTitle: 'Members'
        ncyBreadcrumbParent: 'members.dash'
        ncyBreadcrumbLabel: 'Members'

class UserCtrl extends Controller('members.users')
  constructor: ($scope, $sails, lodash, config, titleService, UserModel, $filter, ngTableParams)->
    $scope.newUser = {}
    $scope.users = []
    $scope.currentUser = config.currentUser

    $scope.destroyUser = (user) ->
      UserModel.deleteUser(user).then (model) ->
        # lodash.remove($scope.todos, {id: todo.id})

    $scope.createUser = (newUser) ->
      console.log 'new ', newUser
      newUser.user = config.currentUser.id
      UserModel.create(newUser).then (model) ->
        $scope.newUser.title = ""

    UserModel.getAll($scope).then (models) ->
      $scope.users = models.data
###
      data = $scope.users
      console.log "data ", data
###
###
      $scope.tableParams = new ngTableParams(
        page: 1 # show first page
        count: 25 # count per page
        sorting:
          title: "asc"
      ,
        total: data.length
        getData: ($defer, params) ->
          orderedData = (if params.sorting() then $filter("orderBy")(data, $scope.tableParams.orderBy()) else data)
          $defer.resolve orderedData.slice((params.page() - 1) * params.count(), params.page() * params.count())
      )###
