should = require 'should'
fs = require 'fs'
logger = require 'torch'

describe 'before', ->
  it 'should call a helper', (done) ->
    @request 'helpers.helper', {}, (err, data) =>
      should.not.exist err
      should.exist data?.result, 'expected result'
      data.result.should.eql "I'm helping!"
      done()

  # wish there were some way to do this without resorting to global state
  it 'should run before/after steps', ->
    {history} = @retrieve 'extensions/helpers'

    should.exist history.before, 'expected before'
    should.exist history.beforeEach, 'expected beforeEach'
    should.exist history.afterEach, 'expected afterEach'
    #should.exist history.after, 'expected after'
