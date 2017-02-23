angular.module 'app'
.directive 'n4FbMeta', ['$compile', ($compile)->
  {
    restrict: 'A'
    link: (scope, url, attrs)->
      url.attr 'property', 'og:url'
      scope.$on '$locationChangeStart', (event, newUrl)->
        url.attr 'content', newUrl

      type = angular.element '<meta property="og:type" content="website" />'
      url.after type
      scope.$watch 'fbType', (newVal)-> type.attr newVal

      title = angular.element """<meta property="og:title"
      content="Best price search service."/>"""
      type.after title
      # scope.$watch 'title', (newVal)-> title.attr 'content', newVal

      description = angular.element '<meta property="og:description" />'
      title.after description
      scope.$watch 'description', (newVal)-> description.attr 'content', newVal
  }
]
