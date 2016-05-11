angular.module 'app'
  .controller 'ProductCtrl', [
    '$scope'
    '$http'
    '$routeParams'
    '$animate'
    '$timeout'
  ($scope, $http, $routeParams, $animate, $timeout)->
    $scope.selectedImg = nextImgIdx = $scope.thumbsPosition = 0

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

    getProduct = ->
      $http.get '/api/product', params: $routeParams

    $scope.$on '$routeUpdate', ->
      getProduct()
        .then (response)->
          $scope.product.price = response.data.product.price
          $scope.product.options = response.data.product.options
      false

    getProduct()
      .then (response)->
        $scope.product = response.data.product
        return
    return
  ]
