angular.module 'app'
.controller 'MainCtrl', ['$scope', '$rootScope', '$http',
($scope, $rootScope, $http)->
  # $http.get '/api/popular_categories'
  # .then (response)->
  #   $rootScope.title = ''
  #   $rootScope.breadcrumbs = []
  #   $scope.categories = response.data
  #   return

  $rootScope.description = 'Best price search service. Find where to buy cheap.'
  $http.get '/api/brands'
  .then (response)->
    $rootScope.title = 'Find the best price for smartphones'
    $rootScope.breadcrumbs = []
    $scope.brands = response.data

  return
]
