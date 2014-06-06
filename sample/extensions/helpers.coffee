fs = require 'fs-extra'

history = []

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
      history.push 'before'
      done()

    after: (args, done) ->
      history.push 'after'
      done()

    beforeEach: (args, done) ->
      history.push 'beforeEach'
      done()

    afterEach: (args, done) ->
      history.push 'afterEach'
      done()

  history: history
