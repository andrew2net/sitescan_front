angular.module 'app', [
  'ui.router'
  'ngMaterial'
  'ngMessages'
  'ngAnimate'
]
  .controller 'NotFoundCtrl', ['$rootScope', ($rootScope)->
    $rootScope.title = '404'
    $rootScope.breadcrumbs = []
    return
  ]
  .config ['$stateProvider', '$locationProvider',
  ($stateProvider, $locationProvider)->
    mainState = {
      name: 'main'
      url: '/'
      controller: 'MainCtrl'
      templateUrl: '/views/main'
    }
    catalogState = {
      name: 'catalog'
      url: '/catalog/:path?page&o&b&n&search'
      params: {
        page: {
          value: '1'
          squash: true
        }
        path: {
          value: null
          squash: true
        }
      }
      controller: 'CatalogCtrl'
      templateUrl: '/views/catalog'
      reloadOnSearch: false
      resolve: {
        response: ['$stateParams', '$http', ($stateParams, $http)->
          $http.get '/api/catalog', params: $stateParams
        ]
      }
    }
    productState = {
      name: 'product'
      url: '/product/:path?p'
      controller: 'ProductCtrl'
      templateUrl: '/views/product'
      reloadOnSearch: false
      resolve: {
        response: ['$stateParams', '$http', ($stateParams, $http)->
          $http.get '/api/product', params: $stateParams
        ]
      }
    }
    $stateProvider.state mainState
    $stateProvider.state catalogState
    $stateProvider.state productState
    # $routeProvider
    #   .when '/', {
    #     templateUrl: '/views/main'
    #     controller: 'MainCtrl'
    #   }
    #   .when '/catalog/:path?', {
    #     templateUrl: '/views/catalog'
    #     controller: 'CatalogCtrl'
    #     reloadOnSearch: false
    #     resolve: {
    #       response: ['$route', '$http', ($route, $http)->
    #         $http.get '/api/catalog', params: $route.current.params
    #       ]
    #     }
    #   }
    #   .when '/product/:path', {
    #     templateUrl: '/views/product'
    #     controller: 'ProductCtrl'
    #     reloadOnSearch: false
    #     resolve: {
    #       response: ['$route', '$http', ($route, $http)->
    #         $http.get '/api/product', params: $route.current.params
    #       ]
    #     }
    #   }
    #   .when '/not_found', {
    #     templateUrl: '/views/not_found'
    #     controller: 'NotFoundCtrl'
    #   }
    #   .otherwise {
    #     templateUrl: '/views/not_found'
    #     controller: 'NotFoundCtrl'
    #   }
    $locationProvider.html5Mode(true)
    return
]
  .run ['$rootScope', '$location', ($rootScope, $location)->
    $rootScope.$on '$routeChangeError', (event, current, previous, error)->
      $location.path('/not_found').replace() if error.status == 404
      return
  ]
