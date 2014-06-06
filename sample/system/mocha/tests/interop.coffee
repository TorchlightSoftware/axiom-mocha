should = require 'should'
fs = require 'fs'
logger = require 'torch'

{history} = require '../../../extensions/helpers'

describe 'before', ->
  it 'should create a helper', (done) ->
    @request 'helpers.helper', {}, (err, data) ->
      should.not.exist err
      should.exist data?.result, 'expected result'
      data.result.should.eql "I'm helping!"
      done()

  it 'should run before/after steps', ->
    history.should.eql ['before', 'beforeEach', 'afterEach', 'beforeEach']
