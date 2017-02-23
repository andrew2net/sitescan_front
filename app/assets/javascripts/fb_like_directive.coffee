angular.module 'app'
.directive 'n4FbLike', ['$location', ($location)->
  {
    restrict: 'A'
    link: (scope, element, attrs)->
      element.attr 'class', 'fb-like'
      element.attr 'data-layout', 'button'
      element.attr 'data-action', 'like'
      element.attr 'data-share', true
      element.attr 'data-show-face', true
      element.attr 'data-size', 'large'
      scope.$on '$locationChangeStart', (event, newUrl, toParams)->
        element.attr 'data-href', newUrl
  }
]
