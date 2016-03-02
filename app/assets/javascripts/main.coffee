angular.module 'app', ['ngRoute' , 'ngMaterial']
.config ['$routeProvider', '$locationProvider', ($routeProvider, $locationProvider)->
  $routeProvider
  .when '/', {
    templateUrl: '/views/main'
    controller: 'MainCtrl'
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