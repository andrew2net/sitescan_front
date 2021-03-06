angular.module 'app'
.controller 'ProductCtrl', [
  '$scope'
  '$rootScope'
  '$http'
  '$stateParams'
  '$animate'
  '$timeout'
  '$filter'
  'response'
($scope, $rootScope, $http, $stateParams, $animate, $timeout, $filter, response)->
  $scope.selectedImg = nextImgIdx = $scope.thumbsPosition = 0
  $scope.price = {}
  $rootScope.fbType = 'product.item'

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
      $scope.thumbsStyle = {left: $scope.thumbsPosition * -60 + 'px'}
    return

  $scope.attrValue = (link, attr)->
    opts = $filter('filter')(attr.options, (v)-> v.id == link.attrs[attr.id])
    if opts[0] then opts[0].value else ''

  assignData = (resp)->
    $scope.product = resp.data
    $rootScope.description = "#{$scope.product.name.join ' '} best deals."
    calcPrice()
    $rootScope.title = resp.data.name.join ' '
    $rootScope.breadcrumbs = resp.data.breadcrumbs
    return

  getProduct = ->
    $http.get '/api/product', params: $stateParams
    .then (resp)->
      assignData resp
      return

  $scope.filterLinks = (link)->
    ret = true
    angular.forEach $scope.selectedAttrs, (v, k)->
      ret = ret and link.attrs[k] == v
      return
    ret

  calcPrice = ->
    $scope.selectedAttrs = angular.fromJson $stateParams.p
    $scope.filteredLinks = $filter('filter')($scope.product.links,
      $scope.filterLinks)

    s = 0
    prices = $scope.filteredLinks.map (l)->
        s += parseFloat l.price
        l.price

    $scope.price.min = Math.min.apply(null, prices)
    $scope.price.max = Math.max.apply(null, prices)
    $scope.price.avr = prices.length and (s / prices.length)
    return

  # document.addEventListener 'attributeChanged', calcPrice
  $scope.$on 'attributeChanged', calcPrice

  assignData response

  return
]
