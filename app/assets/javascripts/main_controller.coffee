angular.module 'app'
.controller 'MainCtrl', ['$scope', '$rootScope', '$http',
($scope, $rootScope, $http)->
  # $http.get '/api/popular_categories'
  # .then (response)->
  #   $rootScope.title = ''
  #   $rootScope.breadcrumbs = []
  #   $scope.categories = response.data
  #   return

  $http.get '/api/brands'
  .then (response)->
    $rootScope.title = ''
    $rootScope.breadcrumbs = []
    $scope.brands = response.data

  return
]
