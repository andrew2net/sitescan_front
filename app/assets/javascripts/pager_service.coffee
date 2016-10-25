angular.module 'app'
  .factory 'PagerService', [->
    service = {
      GetPager: (totalItems, currentPage, pageSize)->
        currentPage = currentPage or 1
        pageSize = pageSize or 10
        totalPages = Math.ceil totalItems / pageSize
        if totalPages < 11
          startPage = 1
          endPage = totalPages || startPage
        else
          if currentPage < 7
            startPage = 1
            endPage = 10
          else if currentPage + 5 > totalPages
            startPage = totalPages - 9
            endPage = totalPages
          else
            startPage = currentPage - 5
            endPage = currentPage + 4
        pages = (num for num in [startPage..endPage])
        {
          totalItems: totalItems
          currentPage: currentPage
          pageSize: pageSize
          totalPages: totalPages
          startPage: startPage
          endPage: endPage
          pages: pages
        }
    }
  ]
