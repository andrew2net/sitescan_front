angular.module 'app'
  .directive 'n4Title', [->
    {
      scope: {n4Title: '='}
      link: (scope, element)->
        scope.$watch 'n4Title', (newValue)->
          title = ['SiteScan']
          title.push newValue if newValue
          element.html title.join(' | ')
    }
  ]
