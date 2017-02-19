angular.module 'app'
.directive 'loader', [ ->
  {
    template: """<div class="loader-container">
    <div class="uil-ripple-css"><div></div><div></div></div>"""
  }
]
