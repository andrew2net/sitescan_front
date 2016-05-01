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
  ($scope, $http, $routeParams, $animate, $timeout)->
    loadCatalog = ->
      $scope.notFound = false
      $scope.products = []
      products = document.querySelector('.catalog-product')
      $animate.leave products if products
      $http.get '/api/catalog', params: $routeParams
      .then (response)->
        $scope.products = response.data.products
        $scope.category = response.data.category
        $timeout ->
          $scope.notFound = $scope.products.length == 0
          return
        , 300
        return
      return

    $scope.clearFilter = ->
      $scope.$broadcast 'clearFilter'
      return

    $scope.$on 'reloadCatalog', ->
      loadCatalog()
      return

    loadCatalog()
    return
]
