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
    Getter/setter for maximum value of filter's number attribute.
    ###
    getSetNumValMax = (newValue)->
      if arguments.length
        if ( newValue < this._val_min or newValue < this.min ) and newValue
          return this._val_max
        updateNumberLocation this.id, 'max', parseFloat newValue
        this._val_max = newValue
      else
        this._val_max

    ###
    Getter/setter for filter's option and list of options attributes.
    @param newValue - new value to set.
    ###
    updateOption = (newValue)->
      if arguments.length
        if $routeParams.o
          optionsChecked = $routeParams.o.split ','
        else
          optionsChecked = []
        idx = optionsChecked.indexOf(this.id.toString())
        if newValue
          optionsChecked.push this.id if idx == -1
        else
          optionsChecked.splice idx, 1 if idx != -1
        if optionsChecked.length
          $location.search('o', optionsChecked.join ',')
        else
          $location.search('o', null)
        this._checked = newValue
      else
        this._checked

    ###
    Getter/setter for bollean filter's attribute.
    @param newValue - new value to set.
    ###
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
        this._val = newValue
      else
        this._val

    ###
    Retrive attribute from url and set filter parametrs.
    ###
    setFilterFromUrl = ->
      n = angular.fromJson $routeParams.n if $routeParams.n
      o = $routeParams.o.split(',').map((id)-> parseInt id) if $routeParams.o
      b = $routeParams.b.split(',').map((id)-> parseInt id) if $routeParams.b
      angular.forEach $scope.filter_items, (item)->
        switch item.type
          when 1
            if n and ( v = n[item.id] )
              item._val_min = v.min
              item._val_max = v.max
            else
              item._val_min = item._val_max = null
          when 3,5
            if o
              angular.forEach item.options, (option)->
                option._checked = o.indexOf(option.id) > -1
                return
            else
              angular.forEach item.options, (option)->
                option._checked = false
          when 4
            if b
              item._val = b.indexOf(item.id) > - 1
            else
              item._val = false
        return
      return

    $scope.$on '$locationChangeSuccess', ->
      setFilterFromUrl()
      getConstraints()
      false

    $http.get '/api/filter', params: {path: $routeParams.path}
    .then (response)->
      angular.forEach response.data, (attr)->
        switch attr.type
          when 1
            attr.val_min = getSetNumValMin
            attr.val_max = getSetNumValMax
          when 3, 5
            angular.forEach attr.options, (opt)->
              opt.checked = updateOption
          when 4
            attr.val = getSetBool
        return
      $scope.filter_items = response.data

      setFilterFromUrl()
      getConstraints()
      return
    return
]
