angular.module 'app'
.directive 'breadcrumbs', [ ->
  {
    template: "<breadcrumb ng-repeat='breadcrumb in breadcrumbs' />"
    scope: true
    # link: (scope, element, attrs)->
    #   scope.$watch 'breadcrumbs', ->
    #     return unless scope.breadcrumbs
    #     h = scope.breadcrumbs.map (bc)->
    #       if angular.isObject bc
    #         "<a ui-sref='catalog({bc.path})'>#{bc.name}</a>"
    #       else
    #         bc
    #     element.html h.join '<i class="material-icons">chevron_right</i>'
    #   return
  }
]
.directive 'breadcrumb', [ ->
  {
    template: """
    <a ui-sref='catalog({path: breadcrumb.path, o: breadcrumb.options})'
      ng-click='showLoader()'
      ng-if='breadcrumb.path'>{{breadcrumb.name}}</a>
    <span ng-if='!breadcrumb.path'>{{breadcrumb}}</span>
    <i ng-if='!$last' class='material-icons'>chevron_right</i>
    """
  }
]
