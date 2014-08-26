assert = require 'assert'
{inspect} = require 'util'
_ = require 'lodash'

module.exports =

  # extend isEqual: skip comparison if an object key doesn't exist in the subset
  isSubsetOf: (set, subset, path=[]) ->
    return [] unless subset?
    return [{set, subset, path: path.join('.')}] unless set?

    # get rid of mongoose data type hell
    set = set.toObject() if set._doc?
    set = @walk set, @convertObjectID

    subset = subset.toObject() if subset._doc?
    subset = @walk subset, @convertObjectID


    if (typeof set is 'object') and (typeof subset is 'object')
      return _.flatten (
        for k, v of subset
          @isSubsetOf set[k], v, path.concat(k)
      )
    else
      if set is subset
        return []
      else
        return [{set, subset, path: path.join('.')}]

  assertSubsetOf: (set, subset) ->
    mismatches = @isSubsetOf set, subset
    assert _.isEmpty(mismatches), "\nSet did not include subset.  Mismatches:\n#{inspect mismatches}"

  getType: (obj) ->
    ptype = Object.prototype.toString.call(obj).slice 8, -1
    if ptype is 'Object'
      return obj.constructor.name.toString()
    else
      return ptype

  walk: (data, fn, path=[]) ->
    dataType = @getType(data)
    switch dataType
      when 'Array'
        @walk(d, fn, path.concat(i)) for d, i in data
      when 'Object'
        result = {}
        for k, v of data
          result[k] = @walk(v, fn, path.concat(k))
        result
      else
        fn(data, path)

  convertObjectID: (data) ->
    if @getType(data) is 'ObjectID'
      return data.toString()
    else
      return data

_.bindAll module.exports, ['convertObjectID', 'walk']
