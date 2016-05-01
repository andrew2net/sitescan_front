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
      $scope.expand = 'expand_less' if $scope.hasValue

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
      model_options = "ng-model-options='{getterSetter: true"
      h = '<div class="filter-item" layout="column">'
      unless scope.ngModel.type == 4
        h += "<div class='md-body-2' ng-class=\"{'active-filter-item':"

        # If attribute's id is 0 then it is price.
        if scope.ngModel.id == 0
          h += "true}\" style='margin-left:5px'"
          show = 'true'
        else
          h += "hasValue}\" ng-click='toggleShow()' aria-label='Expand'>
          <md-icon>{{expand}}</md-icon"
          show = "expand=='expand_less'"
        h += ">{{ ngModel.name.join(', ') }}</div><div ng-style='style'
        ng-show=#{ show }>"
      switch scope.ngModel.type
        when 1
          model_options += ", debounce: {default: 500, blur: 0}}'"
          h += "<input type='text' ng-model='ngModel.val_min'
          #{model_options} placeholder='{{ngModel.min}}'></input> -
          <input type='text' ng-model='ngModel.val_max' #{ model_options }
          placeholder='{{ngModel.max}}'></input><div style='height:14px'></div>"
        when 3, 5
          h += "<div ng-repeat='option in ngModel.options'>
              <md-checkbox class='md-body-1' ng-model='option.checked'
              ng-disabled='option.disabled' #{ model_options }}' ng-click='clear()'>
              {{option.value}}</md-checkbox></div>"
        when 4
          h += "<md-checkbox ng-repeat='option in [ngModel]' ng-model='option.val'
          ng-disabled='option.disabled'
          #{ model_options }}' ng-click='clear()'>{{option.name.join(', ')}}
          </md-checkbox>"
      unless scope.ngModel.type == 4
        h += '<div></div></div>'
      h += '</div>'

      element.replaceWith $compile(h)(scope)
      return
  }
]
