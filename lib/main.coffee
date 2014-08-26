law = require 'law'
logger = require 'torch'
{join} = require 'path'

rel = (args...) -> join __dirname, args...

module.exports =
  config:
    testsDir: 'test'

  extends:
    loadMocha: ['server.test/load']
    runMocha: ['server.test/run']
    #'unloadMocha': ['server.run/unload']

  controls:
    before: 'server.test/before'
    beforeEach: 'server.test/beforeEach'
    afterEach: 'server.test/afterEach'
    after: 'server.test/after'

  # Services used by the extension
  services: law.load rel('services')
