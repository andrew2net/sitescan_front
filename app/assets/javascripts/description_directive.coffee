angular.module 'app'
.directive 'n4Description', [->
  {
    # scope: { n4Description: '=' }
    # template: '<meta name="description" content="{{n4Description}}">'
    link: (scope, element)->
      element.attr 'name', 'description'
      scope.$watch 'description', (newValue)-> element.attr 'content', newValue
  }
]
