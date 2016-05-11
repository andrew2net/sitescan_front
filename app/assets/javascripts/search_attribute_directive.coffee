angular.module 'app'
  .directive 'searchAttribute', ['$compile', '$location', '$routeParams'
  ($compile, $location, $routeParams)->
    {
      controller: ['$scope', ($scope)->
        if $routeParams.o
          optsFromUrl = $routeParams.o.toString().split ','
          for opt in $scope.attr.options
            idx = optsFromUrl.indexOf opt.id.toString()
            if idx > -1
              $scope.currentOption = opt.id
              break

        $scope.setCurrentOption = (id)->
          if id == $scope.currentOption
            $scope.currentOption = null
          else
            $scope.currentOption = id
          $location.search 'o', $scope.currentOption
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
