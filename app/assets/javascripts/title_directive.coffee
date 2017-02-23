angular.module 'app'
  .directive 'n4Title', [->
    {
      restrict: 'A'
      link: (scope, element)->
        scope.$watch 'title', (newValue)->
          title = ['Best price search service']
          title.push newValue if newValue
          element.html title.join(' | ')
    }
  ]
