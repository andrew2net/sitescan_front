angular.module 'app', ['ngRoute' , 'ngMaterial', 'ngMessages']
.config ['$routeProvider', '$locationProvider', ($routeProvider, $locationProvider)->
  $routeProvider
  .when '/', {
    templateUrl: '/views/main'
    controller: 'MainCtrl'
  }
  .when '/catalog/:path', {
    templateUrl: '/views/catalog'
    controller: 'CatalogCtrl'
  }
  $locationProvider.html5Mode(true)
]
.controller 'MainCtrl', ['$scope', '$http', ($scope, $http)->

  $http.get '/api/popular_categories'
  .then (response)->
    $scope.categories = response.data
    return

  return
]
.controller 'CatalogCtrl', ['$scope', '$http', '$routeParams', ($scope, $http, $routeParams)->
  $http.get '/api/catalog', params: { path: $routeParams.path }
  .then (response)->
    $scope.products = response.data.products
    $scope.category = response.data.category
    return
  return
]