angular.module 'app'
.directive 'filterItem', ['$compile', '$timeout', ($compile, $timeout)->
  {
    controller: ['$scope', '$element', ($scope, $element)->
      hasValue = (model)->
        switch model.type
          when 1
            return model.val_min() || model.val_max()
          when 3, 5
            for option in model.options
              if option._checked
                return true
        false

      $scope.expand = 'down'
      $scope.style = {}

      switch $scope.ngModel.type
        when 1
          $scope.style.maxHeight = '52px'
        when 3, 5
          $scope.style.maxHeight = $scope.ngModel.options.length * 39 + 10 + 'px'

      $scope.hasValue = hasValue $scope.ngModel
      $scope.expand = 'up' if $scope.hasValue or $scope.ngModel.id == 0

      $scope.toggleShow = ->
        $element
        $scope.expand = if $scope.expand == 'up' then 'down' else 'up'
        return

      $scope.$watch 'ngModel', (newValue)->
        # newValue.val false if newValue.type == 4 and newValue.disabled

        $scope.hasValue = hasValue(newValue)
        return
      , true

      # $scope.clear = ->
      #   if this.option and this.option.disabled
      #     if this.option._checked
      #       this.option.checked(false)
      #     else if this.option._val
      #       this.option.val(false)
      #   return
      return
    ]
    templateUrl: 'filterItem.html'
    scope: { ngModel: '=' }
  }
]
