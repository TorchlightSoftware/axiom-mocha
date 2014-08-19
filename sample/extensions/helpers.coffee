fs = require 'fs-extra'
logger = require 'torch'

history = {}

module.exports =

  extends:
    createHelper: ['server.test/before']
    before: ['server.test/before']
    after: ['server.test/after']
    beforeEach: ['server.test/beforeEach']
    afterEach: ['server.test/afterEach']

  services:
    createHelper: (args, done) ->
      @respond 'helper', (args, fin) ->
        fin null, {result: "I'm helping!"}
      done()

    before: (args, done) ->
      history.before = true
      done()

    after: (args, done) ->
      history.after = true
      done()

    beforeEach: (args, done) ->
      history.beforeEach = true
      done()

    afterEach: (args, done) ->
      history.afterEach = true
      done()

  history: history
