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
  .config ['$stateProvider', '$locationProvider', '$urlRouterProvider',
  ($stateProvider, $locationProvider, $urlRouterProvider)->
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
        response: ['$state', '$stateParams', '$http',
        ($state, $stateParams, $http)->
          $http.get '/api/product', params: $stateParams
        ]
      }
    }
    notFoundState = {
      name: '404'
      templateUrl: '/views/not_found'
      controller: 'NotFoundCtrl'
    }
    $stateProvider.state mainState
    $stateProvider.state catalogState
    $stateProvider.state productState
    $stateProvider.state notFoundState

    $urlRouterProvider.otherwise ($injector, $location)->
      state = $injector.get '$state'
      state.go '404'
      $location.path()

    $locationProvider.html5Mode(true)
    return
]
.run ['$rootScope', '$state', '$window', '$timeout',
  ($rootScope, $state, $window, $timeout)->
    $rootScope.$on '$stateChangeError',
    (event, toState, toParams, fromState, fromParams, error)->
      $state.go('404') if error.status == 404
      $rootScope.loader = false
      return

    loaders = document.querySelectorAll '.loader-container'
    for loader in loaders
      loader.setAttribute 'ng-show', 'loader'

    $rootScope.loader = true
    $rootScope.showLoader = -> $rootScope.loader = true

    $rootScope.$on '$locationChangeStart',
    (event, newUrl, oldUrl, newState, oldState)->
      $timeout ->
        $rootScope.loader = false
      if $window.ga and newUrl
        $window.ga 'set', 'page', newUrl
        if $window.yaCounter42739879
          $window.yaCounter42739879.hit newUrl, { referer: oldUrl }

    # $rootScope.$on '$locationChangeSuccess',
    # (event, toSatae, toParams, fromState, fromParams)->
    #   $rootScope.loader = false
]
