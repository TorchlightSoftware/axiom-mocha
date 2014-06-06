Mocha = require 'mocha'
nomad = require 'nomad'
logger = require 'torch'
_ = require 'lodash'
minimatch = require 'minimatch'
{relative} = require 'path'

module.exports =
  service: (args, done) ->
    context = @

    # get a new Mocha instance
    mocha = new Mocha {
      compilers: 'coffee:coffee-script/register'
      ui: 'bdd'
      reporter: 'spec'
    }

    # add our helper environment to mocha
    mocha.suite.beforeAll 'addContext', (fin) ->
      _.merge @, context.appUtils, context.appRetriever
      fin()

    # send out 'before' signal to any extensions that will respond to it
    mocha.suite.beforeAll 'delegateBefore', _.partial(context.delegate, 'before', {})
    mocha.suite.afterAll 'delegateBefore', _.partial(context.delegate, 'after', {})
    mocha.suite.beforeEach 'delegateBeforeEach', _.partial(context.delegate, 'beforeEach', {})
    mocha.suite.afterEach 'delegateBeforeEach', _.partial(context.delegate, 'afterEach', {})

    # if we have a file specified then limit the search
    if @config.file
      pattern = "**/#{@config.file}*"
      filter = (name) =>
        name = relative @appRetriever.root, name
        minimatch name, pattern

    # add our tests to mocha
    nomad.walk {
      processFile: (filename, next) ->
        mocha.addFile(filename)
        next()
      filter: filter

    }, @rel('tests'), (err) ->
      done(err, {mocha})

    mocha.grep(@config.grep) if @config.grep
