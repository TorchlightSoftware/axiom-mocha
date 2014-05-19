path = require 'path'
fs = require 'fs'

should = require 'should'
axiom = require 'axiom'
request = require 'request'
logger = require 'torch'
_ = require 'lodash'

connect = require '..'
{port} = connect.config

projectDir = path.join(__dirname, '../sample')

describe 'run', ->
  beforeEach ->
    axiom.wireUpLoggers [{writer: 'console', level: 'info'}]
    axiom.init {}, {root: projectDir}

  afterEach ->
    axiom.reset()

  it 'should start the server', (done) ->

    # when the end of the 'start' lifecycle is reached
    axiom.respond "server.run/run", (args, fin) ->

      # then the server should respond to requests
      request {
        url: "http://localhost:#{port}/hello"
        json: true

      }, (err, res, body) ->

        should.not.exist err
        should.exist body
        body.should.eql {greeting: 'hello, world'}
        done()

      fin()

    # given the run command is initiated
    axiom.request "server.run", {}, (err, result) ->
      should.not.exist err

    # and a responder exists
    axiom.respond 'connect.default/hello', (args, fin) ->
      fin null, {greeting: 'hello, world'}

  it 'services should receive axiom context', (done) ->

    # when the end of the 'start' lifecycle is reached
    axiom.respond "server.run/connect", (args, fin) ->
      fin()

      # and I call a service
      @services.returnContext {}, (err, {context}) ->

        # then that service should receive the axiom context
        should.exist context.util
        done()

    # given the run command is initiated
    axiom.request "server.run", {}, (err, result) ->
      should.not.exist err
