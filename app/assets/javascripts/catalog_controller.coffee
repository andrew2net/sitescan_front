angular.module 'app'
.controller 'CatalogCtrl', [
  '$scope'
  '$rootScope'
  '$http'
  '$state'
  '$stateParams'
  '$animate'
  '$timeout'
  'response'
  ($scope, $rootScope, $http, $state, $stateParams, $animate, $timeout,
  response)->
    $scope.path = $stateParams.path
    $scope.pager = {}
    $scope.pager.currentPage = parseInt($stateParams.page) or 1
    $scope.searchText = $stateParams.search

    assignData = (resp)->
      $scope.products = resp.data.products
      $scope.category = resp.data.category
      $rootScope.title = resp.data.category || 'Best offers catalog'
      $rootScope.description = resp.data.description || 'Fid the best offers and the lowest prices here.'
      $rootScope.breadcrumbs = resp.data.breadcrumbs
      $rootScope.fbType = 'product.group'
      $scope.subcategories = resp.data.subcategories
      $scope.pager.totalItems = resp.data.total_items
      $timeout ->
        $scope.notFound = $scope.products.length == 0
        return
      , 300
      return

    loadCatalog = ->
      $scope.notFound = false
      $scope.products = []
      products = document.querySelector('.catalog-product')
      $animate.leave products if products
      params = $state.params
      $scope.pager.currentPage = params.page
      $http.get '/api/catalog', params: params
      .then (resp)->
        assignData resp
        return
      return

    $scope.clearFilter = ->
      $state.go '.', {o: null, n: null, b: null}, {notify: false}
      loadCatalog()
      return

    $scope.setPage = (page)-> $state.go '.', {page: page}, {notify: false}

    $scope.getPageHref = (page)-> $state.href($state.current, page: page)

    reloadOnChangeCondition = (ev)->
      $scope.searchText = $stateParams.search
      $state.go '.', {page: 1}, {notify: false}
      return

    $scope.$on '$locationChangeSuccess',
      (event, newUrl, oldUrl, newState, oldState)->
        loadCatalog()

    $scope.$on 'filterChanged', reloadOnChangeCondition
    $scope.$on 'searchChanged', reloadOnChangeCondition

    assignData response
    return
]
