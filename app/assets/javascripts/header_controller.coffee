angular.module 'app'
.controller 'HeaderCtrl', [
  '$scope', '$http', '$q', '$state', '$stateParams', '$timeout',
  ($scope, $http, $q, $state, $stateParams, $timeout)->
    $scope.searchText = null
    $scope.searchItem = null
    # $scope.routeParams = $routeParams
    searchChanged = new Event 'searchChanged'

    $scope.getMatches = (searchText)->
      # deferred = $q.defer()
      $http.post '/api/suggest_products', {
        text: searchText, path: $stateParams.path
      }
        .then (resp)->
          # deferred.resolve
          resp.data
      # deferred.promise

    $scope.keypress = (event, searchText)->
      $scope.findProducts searchText if event.keyCode == 13

    # goToCatalog = true
    $scope.findProducts = (searchText)->
      # if goToCatalog
      st = if searchText then searchText else null
      # document.getElementById('search-text').blur()
      $state.go 'catalog', search: st
      document.dispatchEvent searchChanged if $state.is 'catalog'
      # else
      #   goToCatalog = true
      # return

    $scope.clearSearch = ->
      $scope.searchText = null
      $state.go '.', search: null
      document.dispatchEvent searchChanged
      return

    getSearchTextFromUrl = ->
      $scope.isHome = $state.is 'main'
      if $state.current.name == 'catalog'
        $scope.searchText = $stateParams.search
      else
        # goToCatalog = $scope.searchItem == null
        $scope.searchText = $scope.searchItem = null
      return

    $scope.$on '$stateChangeSuccess', getSearchTextFromUrl

    return
  ]
