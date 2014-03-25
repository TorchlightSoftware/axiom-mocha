path = require 'path'
fs = require 'fs'

should = require 'should'
axiom = require 'axiom'
request = require 'request'
logger = require 'torch'
_ = require 'lodash'

server = require '..'
{port} = server.config.run

projectDir = path.join(__dirname, '../sample')

retriever = _.clone require('../node_modules/axiom/lib/retriever')
retriever.projectRoot = projectDir

describe 'run', ->
  beforeEach ->
    axiom.init {}, retriever
    #axiom.wireUpLoggers [{writer: 'console', level: 'debug'}]
    axiom.load 'server', server

  afterEach ->
    axiom.reset()

  it 'should do nothing', ->

  it 'should start the server', (done) ->

    # when the end of the 'start' lifecycle is reached
    axiom.respond "server.run/connect", (args, fin) ->
      fin()

      # then the server should respond to requests
      request {
        url: "http://localhost:#{port}"
        json: true
      }, (err, res, body) ->
        should.not.exist err
        should.exist body
        body.should.eql {greeting: 'hello, world'}
        done()

    # given the run command is initiated
    axiom.request "server.run", {}, (err, result) ->
      should.not.exist err

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
