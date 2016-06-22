angular.module 'app'
.controller 'CatalogCtrl', [
  '$scope'
  '$rootScope'
  '$http'
  '$routeParams'
  '$animate'
  '$timeout'
  '$location'
  'response'
  ($scope, $rootScope, $http, $routeParams, $animate, $timeout, $location,
  response)->
    $scope.search = ''

    assignData = (response)->
      $scope.products = response.data.products
      $scope.category = response.data.category
      $rootScope.title = response.data.category
      $rootScope.breadcrumbs = response.data.breadcrumbs
      $scope.subcategories = response.data.subcategories
      $timeout ->
        $scope.notFound = $scope.products.length == 0
        return
      , 300


    loadCatalog = ->
      $scope.notFound = false
      $scope.products = []
      products = document.querySelector('.catalog-product')
      $animate.leave products if products
      $http.get '/api/catalog', params: $routeParams
      .then (response)->
        assignData response
        return
      return

    $scope.clearFilter = ->
      $location.search 'o', null
      $location.search 'n', null
      $location.search 'b', null
      $location.search 'search', null
      return

    setSearchForLinks = (url)->
      $scope.searchText = $routeParams.search
      search = url.match /\?.*$/
      $scope.search = if search then search[0] else ''
      return

    $scope.$on '$locationChangeSuccess', (ev, url)->
      setSearchForLinks(url)
      loadCatalog()
      return

    setSearchForLinks($location.url())
    assignData response
    return
]
