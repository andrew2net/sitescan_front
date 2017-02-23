angular.module 'app'
.directive 'n4Description', [->
  {
    restrict: 'A'
    link: (scope, element)->
      element.attr 'name', 'description'
      scope.$watch 'description', (newValue)-> element.attr 'content', newValue
  }
]
