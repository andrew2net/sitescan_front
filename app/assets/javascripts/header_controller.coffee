angular.module 'app'
.controller 'HeaderCtrl', [
  '$scope', '$http', '$q', '$state', '$stateParams', '$timeout',
  ($scope, $http, $q, $state, $stateParams, $timeout)->
    $scope.searchText = null
    $scope.searchItem = null
    # $scope.routeParams = $routeParams
    searchChanged = new Event 'searchChanged'

    $scope.getMatches = (searchText)->
      deferred = $q.defer()
      $http.post '/api/suggest_products', {
        text: searchText, path: $stateParams.path
      }
        .then (resp)->
          deferred.resolve resp.data
          return
      deferred.promise

    $scope.findProducts = (searchText)->
      st = if searchText then searchText else null
      document.getElementById('search-text').blur()
      $state.go 'catalog', search: st
      document.dispatchEvent searchChanged if $state.current.name == 'catalog'
      return

    $scope.clearSearch = ->
      $scope.searchText = ''
      $state.go '.', search: null
      document.dispatchEvent searchChanged
      return

    getSearchTextFromUrl = ->
      $scope.searchText = $stateParams.search
      return

    $scope.$on '$stateChangeSuccess', getSearchTextFromUrl

    return
  ]
