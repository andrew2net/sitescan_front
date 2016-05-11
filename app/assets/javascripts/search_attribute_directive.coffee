angular.module 'app'
  .directive 'searchAttribute', ['$compile', '$location', '$routeParams'
  ($compile, $location, $routeParams)->
    {
      controller: ['$scope', ($scope)->
        if $routeParams.p
          optsFromUrl = JSON.parse $routeParams.p
          $scope.currentOption = optsFromUrl[$scope.attr.id]

        $scope.setCurrentOption = (id)->
          if id == $scope.currentOption
            $scope.currentOption = null
          else
            $scope.currentOption = id
          p = $routeParams.p
          p = JSON.parse p if p
          if p
            if $scope.currentOption
              p[$scope.attr.id] = id
            else
              delete p[$scope.attr.id]
              p = null if angular.equals {}, p
          else if $scope.currentOption
            p = {}
            p[$scope.attr.id] = id
          p = JSON.stringify p if p
          $location.search 'p', p
          return
        return
      ]
      scope: {attr: '=searchAttribute'}
      link: (scope, element, attrs)->
        h = """
        <div layout='row' layout-align='start center'>
          <div>{{attr.name.join(', ')}}</div>
          <div flex-offset=5>
        """
        switch scope.attr.widget
          when 1 # When the attribute is color.
            h += """
            <md-button ng-class='{"md-raised":opt.id!=currentOption,
            "search-attr-active":opt.id==currentOption}'
            ng-click="setCurrentOption(opt.id)"
            ng-repeat='opt in attr.options'>
              {{opt.value}}
            </md-button>
            """
          else
            h += """
            <md-button ng-class='{"md-raised":opt.id!=currentOption,
            "search-attr-active":opt.id==currentOption}'
            ng-click="setCurrentOption(opt.id)"
            ng-repeat='opt in attr.options'>
              {{opt.value}}
            </md-button>
            """
        h += '</div></div>'
        element.replaceWith $compile(h)(scope)
    }
  ]
