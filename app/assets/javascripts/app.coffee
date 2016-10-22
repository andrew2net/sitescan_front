angular.module 'app', [
  'ngRoute'
  'ngMaterial'
  'ngMessages'
  'ngAnimate'
]
  .controller 'NotFoundCtrl', ['$rootScope', ($rootScope)->
    $rootScope.title = '404'
    $rootScope.breadcrumbs = []
    return
  ]
  .config ['$routeProvider', '$locationProvider',
  ($routeProvider, $locationProvider)->
    $routeProvider
      .when '/', {
        templateUrl: '/views/main'
        controller: 'MainCtrl'
      }
      .when '/catalog/:path?', {
        templateUrl: '/views/catalog'
        controller: 'CatalogCtrl'
        reloadOnSearch: false
        resolve: {
          response: ['$route', '$http', ($route, $http)->
            $http.get '/api/catalog', params: $route.current.params
          ]
        }
      }
      .when '/product/:path', {
        templateUrl: '/views/product'
        controller: 'ProductCtrl'
        reloadOnSearch: false
        resolve: {
          response: ['$route', '$http', ($route, $http)->
            $http.get '/api/product', params: $route.current.params
          ]
        }
      }
      .when '/not_found', {
        templateUrl: '/views/not_found'
        controller: 'NotFoundCtrl'
      }
      .otherwise {
        templateUrl: '/views/not_found'
        controller: 'NotFoundCtrl'
      }
    $locationProvider.html5Mode(true)
]
  .run ['$rootScope', '$location', ($rootScope, $location)->
    $rootScope.$on '$routeChangeError', (event, current, previous, error)->
      $location.path('/not_found').replace() if error.status == 404
      return
  ]
