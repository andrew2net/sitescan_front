angular.module 'app'
.controller 'ProductCtrl', [
  '$scope'
  '$rootScope'
  '$http'
  '$routeParams'
  '$animate'
  '$timeout'
  '$filter'
($scope, $rootScope, $http, $routeParams, $animate, $timeout, $filter)->
  $scope.selectedImg = nextImgIdx = $scope.thumbsPosition = 0
  $scope.price = {}

  imgElm = document.getElementById 'product-img'
  $animate.on 'addClass', imgElm,
    (element, phase)->
      if phase == 'close'
        $timeout ->
          $scope.selectedImg = nextImgIdx
          $scope.hideImg = false
          return
      return

  $scope.selectImg = (idx)->
    unless $scope.selectedImg == idx
      nextImgIdx = idx
      $scope.hideImg = true
      $scope.thumbsMove 1 if idx > $scope.thumbsPosition + 3
    return

  $scope.thumbsMove = (dir)->
    if $scope.thumbsPosition > 0 and dir < 0 or
    $scope.thumbsPosition < $scope.product.images.length - 4 and dir > 0
      $scope.thumbsPosition += dir
      $scope.thumbsStyle = {top: $scope.thumbsPosition * -67 + 'px'}
    return

  $scope.attrValue = (link, attr)->
    opts = $filter('filter')(attr.options, { id: link.attrs[attr.id]}, true)
    opts[0].value

  getProduct = ->
    $http.get '/api/product', params: $routeParams

  $scope.filterLinks = (link)->
    ret = true
    angular.forEach $scope.selectedAttrs, (v, k)->
      ret = ret and link.attrs[k] == v
      return
    ret

  calcPrice = ->
    $scope.selectedAttrs = angular.fromJson $routeParams.p
    $scope.filteredLinks = $filter('filter')($scope.product.links,
      $scope.filterLinks)

    s = 0
    prices = $scope.filteredLinks.map (l)->
        s += parseInt l.price
        l.price

    $scope.price.min = Math.min.apply(null, prices)
    $scope.price.max = Math.max.apply(null, prices)
    $scope.price.avr = prices.length and (s / prices.length)
    return

  $scope.$on '$routeUpdate', ->
    calcPrice()
    return

  getProduct()
    .then (response)->
      $scope.product = response.data
      calcPrice()
      $rootScope.title = response.data.name.join ' '
      $rootScope.breadcrumbs = response.data.breadcrumbs
      return

  return
]
