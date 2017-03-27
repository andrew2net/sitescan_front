angular.module 'app'
.controller 'MainCtrl', ['$scope', '$rootScope', '$http',
($scope, $rootScope, $http)->
  # $http.get '/api/popular_categories'
  # .then (response)->
  #   $rootScope.title = ''
  #   $rootScope.breadcrumbs = []
  #   $scope.categories = response.data
  #   return

  $rootScope.description = 'Best mobile phone offers. Smartphone brands. Cost of smartphones.'
  $rootScope.fbType = 'website'

  $http.get '/api/brands'
  .then (response)->
    $rootScope.title = 'Best price search service.'
    $rootScope.breadcrumbs = []
    $scope.brands = response.data

  return
]
