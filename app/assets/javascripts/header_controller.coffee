angular.module 'app'
.controller 'HeaderCtrl', [
  '$scope', '$http', '$q', '$location', '$routeParams', '$timeout',
  ($scope, $http, $q, $location, $routeParams, $timeout)->
    $scope.searchText = null
    $scope.searchItem = null
    $scope.routeParams = $routeParams

    $scope.getMatches = (searchText)->
      deferred = $q.defer()
      $http.post '/api/suggest_products', {
        text: searchText, path: $routeParams.path
      }
        .then (resp)->
          deferred.resolve resp.data
          return
      deferred.promise

    $scope.findProducts = (searchText)->
      unless searchText
        $location.search search: null
        return
      document.getElementById('search-text').blur()
      unless $location.path().match /^\/catalog/
        $location.path '/catalog'
      $location.search {search: searchText}
      return

    $scope.clearSearch = ->
      $scope.searchText = ''
      $location.search search: null
      return

    getSearchTextFromUrl = ->
      $timeout ->
        $scope.searchText = $routeParams.search
        return
      , 100
      return

    $scope.$on '$routeChangeSuccess', ->
      getSearchTextFromUrl()
      return

    getSearchTextFromUrl()

    return
  ]
