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

      $scope.expand = 'expand_more'
      $scope.style = {}

      switch $scope.ngModel.type
        when 1
          $scope.style.maxHeight = '52px'
        when 3, 5
          $scope.style.maxHeight = $scope.ngModel.options.length * 39 + 10 + 'px'
      
      $scope.hasValue = hasValue $scope.ngModel
      $scope.expand = 'expand_less' if $scope.hasValue or $scope.ngModel.id == 0

      $scope.toggleShow = ->
        $element
        $scope.expand = if $scope.expand == 'expand_less'
          'expand_more'
        else
          'expand_less'
        return

      $scope.$watch 'ngModel', (newValue)->
        $scope.hasValue = hasValue(newValue)
        return
      , true

      $scope.clear = ->
        if this.option and this.option.disabled
          if this.option._checked
            this.option.checked(false)
          else if this.option._val
            this.option.val(false)
        return
      return
    ]
    scope: { ngModel: '=' }
    link: (scope, element, attrs)->
      h = '<div class="filter-item" layout="column">'
      switch scope.ngModel.type
        when 1
          mopts = "ng-model-options='{getterSetter: true,
            debounce: {default: 500, blur: 0}}'"
          if scope.ngModel.id == 0
            h += """
            <div class='md-body-2 active-filter-item' style='margin-left:5px'>
              {{ngModel.name.join(', ')}}
            </div>
            """
          else
            h += """
            <div class='md-body-2' ng-class='{"active-filter-item": hasValue}'
              ng-click='toggleShow()' aria-label='Expand'>
              <div layout='row'>
                <md-icon flex>{{expand}}</md-icon>
                <div flex='90'>{{ngModel.name.join(',')}}</div>
              </div>
            </div>
            """
          h += """
          <div ng-style='style' ng-show='expand=="expand_less"'>
            <input type='text' ng-model='ngModel.val_min' #{mopts}
              placeholder='{{ngModel.min}}' /> -
            <input type='text' ng-model='ngModel.val_max' #{mopts}
              placeholder='{{ngModel.max}}' />
            <div style='height:14px'></div>
            <div></div>
          </div>
          """
        when 3,5
          h += """
          <div class='md-body-2' ng-class='{"active-filter-item": hasValue}'
            ng-click='toggleShow()' aria-label='Expand'>
            <div layout='row'>
              <md-icon flex>{{expand}}</md-icon>
              <div flex='90'>{{ngModel.name.join(', ')}}</div>
            </div>
          </div>
          <div ng-style='style' ng-show='expand=="expand_less"'>
            <div ng-repeat='option in ngModel.options'>
              <md-checkbox class='md-body-1' ng-model='option.checked'
              ng-disabled='option.disabled' ng-model-options={getterSetter:true}
              ng-click='clear()'>
                {{option.value}}
              </md-checkbox>
            </div>
            <div></div>
          </div>
          """
        when 4
          h += """
          <md-checkbox class="md-body-2" ng-repeat='option in [ngModel]'
          ng-model='option.val' ng-disabled='option.disabled'
          ng-model-options='{getterSetter:true}' ng-click='clear()'>
            {{option.name.join(', ')}}
          </md-checkbox>
          """
      h += '</div>'

      element.replaceWith $compile(h)(scope)
      return
  }
]
