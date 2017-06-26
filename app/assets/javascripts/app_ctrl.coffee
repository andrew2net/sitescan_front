angular.module 'app'
.controller 'AppCtrl', [->
  header = document.getElementById 'header'
  banner = document.getElementById 'banner'
  headerRect = header.getBoundingClientRect()
  bannerRect = banner.getBoundingClientRect()
  # bannerHeight = bannerRect.bottom - headerRect.bottom

  # window.addEventListener 'scroll', (e)->
  #   if !header.style.position and window.scrollY >= bannerRect.height # headerRect.bottom >= bannerRect.bottom
  #     header.style.position = 'relative'
  #     header.style.top = bannerRect.height + 'px'
  #   else if header.style.position and window.scrollY < bannerRect.height
  #     header.style.position = ''
  #     header.style.top = ''
]
