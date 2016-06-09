angular.module 'app'
.controller 'SearchCtrl', [
  '$scope', '$routeParams', '$http', ($scope, $routeParams, $http)->
    loadCatalog = ->
      $http.get '/api/search_product', params: $routeParams
        .then (resp)->
          $scope.products = resp.data.products
    return
]
