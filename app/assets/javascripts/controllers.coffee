angular.module 'app'
.controller 'MainCtrl', ['$scope', '$http', ($scope, $http)->

  $http.get '/api/popular_categories'
  .then (response)->
    $scope.categories = response.data
    return

  return
]
.controller 'CatalogCtrl', ['$scope', '$http', '$routeParams', '$animate',
($scope, $http, $routeParams, $animate)->
  loadCatalog = ->
    products = document.querySelector('.catalog-product')
    $animate.leave products if products
    $http.get '/api/catalog', params: $routeParams
    .then (response)->
      $scope.products = response.data.products
      $scope.category = response.data.category
      return
    return

  $scope.$on 'reloadCatalog', ->
    loadCatalog()
    return

  loadCatalog()
  return
]
.controller 'FilterCtrl', ['$scope', '$http', '$routeParams', '$location', '$timeout',
  ($scope, $http, $routeParams, $location, $timeout)->

    updateOption = (newValue, id)->
      idx = optionsChecked.indexOf(id)
      if newValue
        optionsChecked.push id if idx == -1
      else
        optionsChecked.splice idx, 1 if idx != -1
      if optionsChecked.length
        $location.search('o', optionsChecked.join ',')
      else
        $location.search('o', null)
      $timeout ->
        $scope.$emit 'reloadCatalog'
      return

    if $routeParams.o
      optionsChecked = $routeParams.o.split(',').map (id)-> parseInt id
    else
      optionsChecked = []

    $http.get '/api/filter', params: {path: $routeParams.path}
    .then (response)->
      angular.forEach response.data, (attr)->
        angular.forEach attr.options, (opt)->
          switch attr.type
            when 3, 5
              opt._checked = optionsChecked.indexOf(opt.id) != -1
              opt.checked = (newValue)->
                if arguments.length
                  updateOption newValue, opt.id
                  this._checked = newValue
                else
                  this._checked
          return
        return
      $scope.filter_items = response.data
      false
    false
]
