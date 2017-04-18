angular.module 'app'
.directive 'searchAttribute',
[ '$compile', '$state', '$stateParams', '$filter',
  ($compile, $state, $stateParams, $filter)->
    {
      controller: ['$scope', ($scope)->
        $scope.selectedValue = ''

        # Calc color for check symbol.
        calcColor = (hexcolor)->
          r = parseInt hexcolor.substr(0,2), 16
          g = parseInt hexcolor.substr(2,2), 16
          b = parseInt hexcolor.substr(4,2), 16
          yiq = (r*299 + g*587 + b*114)/1000
          $scope.color = if yiq > 128 then 'black' else 'white'
          return

        $scope.setCurrentOption = (opt)->
          if opt.id == $scope.currentOption
            $scope.currentOption = null
            $scope.selectedValue = ''
          else
            $scope.currentOption = opt.id
            if $scope.attr.widget == 1
              calcColor(opt.clr)
              $scope.selectedValue = opt.value
          p = $stateParams.p
          p = JSON.parse p if p
          if p
            if $scope.currentOption
              p[$scope.attr.id] = opt.id
            else
              delete p[$scope.attr.id]
              p = null if angular.equals {}, p
          else if $scope.currentOption
            p = {}
            p[$scope.attr.id] = opt.id
          p = JSON.stringify p if p
          $state.go 'product', p: p, { location: 'replace' }
          $scope.$emit 'attributeChanged'
          return

        getFilteredLinks = ->
          optsFromUrl = angular.fromJson $stateParams.p
          delete optsFromUrl[$scope.attr.id] if optsFromUrl
          $filter('filter')($scope.product.links, (link)->
            ret = true
            angular.forEach optsFromUrl, (v, k)->
              ret = ret and link.attrs[k] == v
              return
            ret
          )

        getFilteredOptions = ->
          filteredLinks = getFilteredLinks()
          $filter('filter')($scope.attr.options, (option)->
            opt = {}
            opt[$scope.attr.id] = option.id
            linkOpt = $filter('filter')(filteredLinks, {attrs: opt})
            linkOpt.length > 0
          )

        $scope.$on '$locationChangeSuccess', ->
          $scope.filteredOptions = getFilteredOptions()
          return

        optsFromUrl = angular.fromJson $stateParams.p
        $scope.currentOption = optsFromUrl[$scope.attr.id] if optsFromUrl
        if $scope.attr.widget == 1 and $scope.currentOption
          opt = $filter('filter')($scope.attr.options,
            {id: $scope.currentOption}, true)
          if opt.length and opt[0].clr
            calcColor opt[0].clr
            $scope.selectedValue = opt[0].value
        $scope.filteredOptions = getFilteredOptions()

        return
      ]
      scope: {attr: '=searchAttribute', product: '='}
      templateUrl: 'searchAttribute.html'
    }
  ]
