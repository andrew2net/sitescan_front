angular.module 'app', ['ngRoute' , 'ngMaterial', 'ngMessages', 'ngAnimate']
.config ['$routeProvider', '$locationProvider', ($routeProvider, $locationProvider)->
  $routeProvider
  .when '/', {
    templateUrl: '/views/main'
    controller: 'MainCtrl'
  }
  .when '/catalog/:path', {
    templateUrl: '/views/catalog'
    controller: 'CatalogCtrl'
    reloadOnSearch: false
  }
  $locationProvider.html5Mode(true)
]
