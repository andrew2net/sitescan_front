angular.module 'app'
.controller 'MainCtrl', ['$scope', '$http', ($scope, $http)->

  $http.get '/api/popular_categories'
  .then (response)->
    $scope.categories = response.data
    return

  return
]
.controller 'CatalogCtrl', [
  '$scope'
  '$http'
  '$routeParams'
  '$animate'
  '$timeout'
  '$location'
  ($scope, $http, $routeParams, $animate, $timeout, $location)->
    loadCatalog = ->
      $scope.notFound = false
      $scope.products = []
      products = document.querySelector('.catalog-product')
      $animate.leave products if products
      $http.get '/api/catalog', params: $routeParams
      .then (response)->
        $scope.products = response.data.products
        $scope.category = response.data.category
        $scope.subcategories = response.data.subcategories
        $timeout ->
          $scope.notFound = $scope.products.length == 0
          return
        , 300
        return
      return

    $scope.clearFilter = ->
      $location.search 'o', null
      $location.search 'n', null
      $location.search 'b', null
      return

    $scope.$on '$locationChangeSuccess', ->
      loadCatalog()
      return

    loadCatalog()
    return
]
