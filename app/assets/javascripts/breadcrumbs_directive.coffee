angular.module 'app'
  .directive 'breadcrumbs', [ ->
    {
      scope: {breadcrumbs: '='}
      link: (scope, element, attrs)->
        scope.$watch 'breadcrumbs', ->
          return unless scope.breadcrumbs
          h = scope.breadcrumbs.map (bc)->
            if angular.isObject bc
              "<a href='#{bc.path}'>#{bc.name}</a>"
            else
              bc
          element.html h.join '<i class="material-icons">chevron_right</i>'
        return
    }
  ]
