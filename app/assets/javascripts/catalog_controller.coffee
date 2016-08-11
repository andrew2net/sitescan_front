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

    assignData = (resp)->
      $scope.products = resp.data.products
      $scope.category = resp.data.category
      $rootScope.title = resp.data.category
      $rootScope.breadcrumbs = resp.data.breadcrumbs
      $scope.subcategories = resp.data.subcategories
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
      .then (resp)->
        assignData resp
        return
      return

    $scope.clearFilter = ->
      $location.search 'o', null # options
      $location.search 'n', null # numerics
      $location.search 'b', null # boolean
      $location.search 'search', null
      return

    setSearchForLinks = (url)->
      $scope.searchText = $routeParams.search
      search = url.match /\?.*$/
      $scope.search = if search then search[0] else ''
      return

    $scope.$on '$locationChangeSuccess', (ev, url)->
      if url.match /\/catalog(\/|$)/
        setSearchForLinks(url)
        loadCatalog()
      return

    setSearchForLinks($location.url())
    assignData response
    return
]
