angular.module 'app'
.controller 'CatalogCtrl', [
  '$scope'
  '$rootScope'
  '$http'
  '$route'
  '$routeParams'
  '$animate'
  '$timeout'
  '$location'
  'PagerService'
  'response'
  ($scope, $rootScope, $http, $route, $routeParams, $animate, $timeout, $location,
  PagerService, response)->
    $scope.pager = {}
    $scope.pager.currentPage = parseInt($routeParams.page) or 1

    assignData = (resp)->
      $scope.products = resp.data.products
      $scope.category = resp.data.category
      $rootScope.title = resp.data.category
      $rootScope.breadcrumbs = resp.data.breadcrumbs
      $scope.subcategories = resp.data.subcategories
      # $scope.pager.totalItems = resp.data.total_items
      # page = parseInt $location.search().page
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
      params = $routeParams
      params.page = $scope.pager.currentPage
      $http.get '/api/catalog', params: params
      .then (resp)->
        assignData resp
        return
      return

    $scope.clearFilter = ->
      $location.search 'o', null # options
      $location.search 'n', null # numerics
      $location.search 'b', null # boolean
      # $location.search 'search', null
      return

    # Returns serch path of url for links.
    searchParamsStr = (search)->
      delete search.path
      params = for key, val of search
        "#{key}=#{val}"
      if params.length
        "?#{params.join '&'}"
      else
        ''

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
      $location.search 'page', page
      $scope.pager.currentPage = page
      return

    # Returns page's url.
    $scope.pageUrl = (page)->
      page = pageCheck page
      search = $location.search()
      search.page = page
      "/catalog/#{$routeParams.path}#{searchParamsStr search}"

    # Returns subcategory's url.
    $scope.subcatUrl = (path)->
      search = $location.search()
      delete search.page
      "/catalog/#{path}#{searchParamsStr search}"

    # Listen to filter's changes.
    $scope.$on '$locationChangeSuccess', (ev, url)->
      if $route.current.controller == 'CatalogCtrl'
        loadCatalog()
      return

    assignData response
    return
]
