angular.module 'app'
.controller 'MainCtrl', [
  '$scope'
  '$rootScope'
  '$http'
  '$interval'
  '$animate'
  '$timeout'
  '$document'
  ($scope, $rootScope, $http, $interval, $animate, $timeout, $document)->
    # $http.get '/api/popular_categories'
    # .then (response)->
    #   $rootScope.title = ''
    #   $rootScope.breadcrumbs = []
    #   $scope.categories = response.data
    #   return

    $rootScope.description = 'Best mobile phone offers. Smartphone brands. Cost of smartphones.'
    $rootScope.fbType = 'website'

    brands = []
    brand_idxs = [] # Ids of elements curretly animated.
    rotate2 = (i, n)->
      $animate.addClass brands[i].brand, 'rotate'
      .then ->
        brands[i].items[n].style.display = 'none'
        brands[i].items[0].style.display = 'initial'
        $animate.removeClass brands[i].brand, 'rotate'
      .then ->
        idx = brand_idxs.indexOf i
        brand_idxs.splice idx, 1

    rotate1 = ->
      if brand_idxs.length
        i = Math.floor Math.random() * brands.length
        if brand_idxs.indexOf(i) > -1
          i++
          i = 0 unless brands.length > i
      else
        i = 0
      brand = brands[i]
      brand_idxs.push i

      $animate.addClass brand.brand, 'rotate'
      .then ->
        max_n = brand.items.length - 1
        n = Math.floor Math.random() * (max_n - 1) + 1
        brand.items[0].style.display = 'none'
        brand.items[n].style.display = 'initial'
        $animate.removeClass brand.brand, 'rotate'
        .then -> $timeout rotate2, 2500, true, i, n

    $http.get '/api/brands'
    .then (response)->
      $rootScope.breadcrumbs = []
      $scope.brands = response.data
      $timeout ->
        brands = Array.prototype.map.call($document[0].getElementsByClassName('brand'), (b)->
          items = b.getElementsByTagName 'a'
          {brand: b, items: items}
        ).filter (a)-> a.items.length > 1
      $interval rotate1, 4000 if $scope.brands.length

    return
]
