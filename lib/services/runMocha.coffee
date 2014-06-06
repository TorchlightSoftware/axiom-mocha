module.exports =
  required: ['mocha']
  service: ({mocha}, done) ->

    mocha.run (failures) ->
      process.on 'exit', ->
        process.exit(failures)

      done()
