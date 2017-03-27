angular.module 'app'
.controller 'CatalogCtrl', [
  '$scope'
  '$rootScope'
  '$http'
  '$state'
  '$stateParams'
  '$animate'
  '$timeout'
  'PagerService'
  'response'
  ($scope, $rootScope, $http, $state, $stateParams, $animate, $timeout,
  PagerService, response)->
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
      $scope.pager = PagerService.GetPager resp.data.total_items,
        $scope.pager.currentPage
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
      params.page = $scope.pager.currentPage
      $http.get '/api/catalog', params: params
      .then (resp)->
        assignData resp
        return
      return

    $scope.clearFilter = ->
      $state.go '.', {o: null, n: null, b: null}, {notify: false}
      loadCatalog()
      return

    pageCheck = (page)->
      if page < 1
        1
      else if page > $scope.pager.totalPages
        $scope.pager.totalPages
      else
        page

    $scope.setPage = (page, ev)->
      page = pageCheck page
      ev.preventDefault()
      $state.go '.', {page: page}, {notify: false}
      $scope.pager.currentPage = page
      loadCatalog()
      return

    # Listen to filter's changes.
    # $scope.$on '$stateChangeSuccess', (ev, toSt, toPar, frSt, frPar)->
    #   if toSt.controller == 'CatalogCtrl'
    #     loadCatalog()
    #   return

    reloadOnChangeCondotion = (ev)->
      $scope.searchText = $stateParams.search
      $scope.pager.currentPage = 1
      $state.go '.', {page: 1}, {notify: false}
      loadCatalog()
      return

    document.addEventListener 'filterChanged', reloadOnChangeCondotion
    document.addEventListener 'searchChanged', reloadOnChangeCondotion

    assignData response
    return
]
