angular.module 'app'
.controller 'footerCtrl', ['$scope', ($scope)->
  $scope.promt = 'Write us'
  em = 'andriano'
  $scope.showem = ->
    $scope.em = em
    $scope.em += '\u0040'
    $scope.em += 'ngs.ru'
    $scope.promt = ''
]
