angular.module 'app'
.controller 'FilterCtrl',
[
  '$scope',
  '$http',
  '$routeParams',
  '$location',
  '$timeout',
  '$filter',
  ($scope, $http, $routeParams, $location, $timeout, $filter)->

    ###
    Update filter's option.
    @param value - new value to set.
    @param id - attribute's id.
    ###
    updateOption = (value, id)->
      idx = optionsChecked.indexOf(id)
      if value
        optionsChecked.push id if idx == -1
      else
        optionsChecked.splice idx, 1 if idx != -1
      if optionsChecked.length
        $location.search('o', optionsChecked.join ',')
      else
        $location.search('o', null)
      $timeout ->
        $scope.$emit 'reloadCatalog'
        getConstraints()
        return
      return

    ###
    Retrieve filter attribute's constraints from server.
    ###
    getConstraints = ->
      $http.get '/api/filter_constraints', params: $routeParams
        .then (response)->
          angular.forEach response.data, (constraint)->
            item = $filter('filter')($scope.filter_items, {id: constraint.id}, true)
            if item.length
              switch item[0].type
                when 1
                  item[0].min = constraint.min
                  item[0].max = constraint.max
                when 3, 5
                  angular.forEach item[0].options, (opt)->
                    opt.disabled = constraint.options.indexOf(opt.id) > -1
                    return
                when 4
                  item[0].disabled = constraint.disabled
            return
          return
      return

    ###
    Set number attribute parametrs in url.
    ###
    updateNumberLocation = (id, name, value)->
      n = angular.fromJson $routeParams.n
      if n and n[id]
        if isFinite value
          n[id][name] = value
        else
          delete n[id][name]
          if angular.equals {}, n[id]
            delete n[id]
      else if n and angular.isNumber value
        n[id] = {}
        n[id][name] = value
      else if isFinite value
        n = {}
        n[id] = {}
        n[id][name] = value
      if angular.equals {}, n
        n = null
      else
        n = angular.toJson n, false
      $location.search 'n', n
      $timeout ->
        $scope.$emit 'reloadCatalog'
        getConstraints()
        return
      return

    ###
    Setter/getter for minnimum value of filter's number attribute.
    ###
    getSetNumValMin = (newValue)->
      if arguments.length
        if newValue > this._val_max and this._val_max or newValue > this.max
          return this._val_min
        updateNumberLocation this.id, 'min', parseFloat newValue
        this._val_min = newValue
      else
        this._val_min

    ###
    Setter/getter for maximum value of filter's number attribute.
    ###
    getSetNumValMax = (newValue)->
      if arguments.length
        if ( newValue < this._val_min or newValue < this.min ) and newValue
          return this._val_max
        updateNumberLocation this.id, 'max', parseFloat newValue
        this._val_max = newValue
      else
        this._val_max

    getSetBool = (newValue)->
      if arguments.length
        if $routeParams.b
          b = $routeParams.b.split ','
        else
          b = []
        i = b.indexOf this.id.toString()
        if newValue and i == -1
          b.push this.id
        else if not newValue and i > -1
          b.splice i, 1
        b = if b.length
          b.join ','
        else
          null
        $location.search 'b', b
        $timeout ->
          $scope.$emit 'reloadCatalog'
          getConstraints()
          return
        this._val = newValue
      else
        this._val
        
    setFilterFromUrl = ->
      if $routeParams.n
        n = angular.fromJson $routeParams.n
        angular.forEach n, (v, k)->
          item = $filter('filter')($scope.filter_items, {id: parseInt(k)}, true)
          if item.length
            item[0]._val_min = v.min
            item[0]._val_max = v.max
          return
      if $routeParams.b
        b = $routeParams.b.split ','
        angular.forEach b, (v)->
          item = $filter('filter')($scope.filter_items, {id: parseInt(v)})
          if item.length
            item[0]._val = true
      return

    $scope.$on 'clearFilter', ->
      $location.search 'o', null
      $location.search 'n', null
      $location.search 'b', null
      optionsChecked = []
      $timeout ->
        angular.forEach $scope.filter_items, (v)->
          switch v.type
            when 1
              v._val_min = v._val_max = null
            when 4
              v._val = false
            when 3, 5
              angular.forEach v.options, (o)->
                o._checked = false
                return
          return
        $scope.$emit 'reloadCatalog'
        getConstraints()
        return
      return

    # Get checked filter's options from url.
    if $routeParams.o
      optionsChecked = $routeParams.o.split(',').map (id)-> parseInt id
    else
      optionsChecked = []
  
    $http.get '/api/filter', params: {path: $routeParams.path}
    .then (response)->
      angular.forEach response.data, (attr)->
        switch attr.type
          when 1
            attr.val_min = getSetNumValMin
            attr.val_max = getSetNumValMax
          when 3, 5
            angular.forEach attr.options, (opt)->
              opt._checked = optionsChecked.indexOf(opt.id) != -1
              opt.checked = (newValue)->
                if arguments.length
                  updateOption newValue, opt.id
                  this._checked = newValue
                else
                  this._checked
              return
          when 4
            attr._val = false
            attr.val = getSetBool
        return
      $scope.filter_items = response.data

      setFilterFromUrl()
      getConstraints()
      return
    return
]
