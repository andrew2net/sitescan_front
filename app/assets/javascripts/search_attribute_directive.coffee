angular.module 'app'
.directive 'searchAttribute',
[ '$compile', '$state', '$stateParams', '$filter',
  ($compile, $state, $stateParams, $filter)->
    {
      controller: ['$scope', ($scope)->
        $scope.colorName = ''
        attributeChanged = new Event 'attributeChanged'

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
            $scope.colorName = ''
          else
            $scope.currentOption = opt.id
            if $scope.attr.widget == 1
              calcColor(opt.clr)
              $scope.colorName = opt.value
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
          $state.go 'product', p: p
          document.dispatchEvent attributeChanged
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

        $scope.$on '$routeUpdate', ->
          $scope.filteredOptions = getFilteredOptions()
          return

        optsFromUrl = angular.fromJson $stateParams.p
        $scope.currentOption = optsFromUrl[$scope.attr.id] if optsFromUrl
        if $scope.attr.widget == 1 and $scope.currentOption
          opt = $filter('filter')($scope.attr.options,
            {id: $scope.currentOption}, true)
          if opt.length and opt[0].clr
            calcColor opt[0].clr
            $scope.colorName = opt[0].value
        $scope.filteredOptions = getFilteredOptions()

        return
      ]
      scope: true #{attr: '=searchAttribute'}
      link: (scope, element, attrs)->
        h = """
        <div layout='row' layout-align='start center'>
          <div flex=35>
            {{attr.name.join(', ')}}
            <span class='md-body-2' style='margin-left: 20px'>
              {{colorName}}
            </span>
          </div>
          <div>
        """
        switch scope.attr.widget
          when 1 # When the attribute is color.
            h += """
            <md-button class='md-fab md-mini color-widget' title='{{opt.value}}'
            ng-click="setCurrentOption(opt)"
            ng-style="{background:'#'+opt.clr,color:color}"
            ng-repeat='opt in filteredOptions'>
              <i class="material-icons" ng-show='opt.id==currentOption'>check</i>
            </md-button>
            """
          else
            h += """
            <md-button ng-class='{"md-raised":opt.id!=currentOption,
            "search-attr-active":opt.id==currentOption}'
            ng-click="setCurrentOption(opt)"
            ng-repeat='opt in filteredOptions'>
              {{opt.value}}
            </md-button>
            """
        h += '</div></div>'
        element.replaceWith $compile(h)(scope)
    }
  ]
