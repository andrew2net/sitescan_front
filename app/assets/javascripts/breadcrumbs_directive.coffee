angular.module 'app'
.directive 'breadcrumbs', [ ->
  {
    template: "<breadcrumb ng-repeat='breadcrumb in breadcrumbs' />"
    scope: true
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
