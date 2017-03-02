angular.module 'app'
.directive 'breadcrumbs', [ ->
  {
    template: """
    <a href='/'><i class='glyphicon glyphicon-home'></i></a>
    <i class='glyphicon glyphicon-menu-right' style='font-size:12px'></i>
    <breadcrumb ng-repeat='breadcrumb in breadcrumbs' />
    """
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
    <i ng-if='!$last' style='font-size:12px' class='glyphicon glyphicon-menu-right'></i>
    """
  }
]
