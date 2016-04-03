angular.module 'app'
.directive 'filterItem', ['$compile', ($compile)->
  {
    controller: ['$scope', '$element', ($scope, $element)->
      $scope.expand = 'expand_more'
      $scope.style = {}
      switch $scope.ngModel.type
        when 3, 5
          $scope.style.maxHeight = $scope.ngModel.options.length * 39 + 'px'
          for option in $scope.ngModel.options
            if option._checked
              $scope.expand = 'expand_less'
              break
      $scope.toggleShow = ->
        $element
        $scope.expand = if $scope.expand == 'expand_less'
          'expand_more'
        else
          'expand_less'
        return
      return
    ]
    scope: { ngModel: '=' }
    link: (scope, element, attrs)->
      h = '<div class="filter-item" layout="column">' +
      '<div class="md-body-2" ng-click="toggleShow()" aria-label="Expad">' +
      '<md-icon>{{expand}}</md-icon>{{ ngModel.name }}</div>' +
      '<div ng-style="style" ng-show="expand==\'expand_less\'">'
      switch scope.ngModel.type
        when 3, 5
          h += '<div ng-repeat="option in ngModel.options">' +
              '<md-checkbox class="md-body-1" ng-model="option.checked" ng-model-options="{getterSetter: true}">' +
              '{{option.value}}</md-checkbox></div>'
      h += '</div></div>'

      element.replaceWith $compile(h)(scope)
      return
  }
]
