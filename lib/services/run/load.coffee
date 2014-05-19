connect = require 'connect'
_ = require 'lodash'

getErrorBody = require '../../getErrorBody'

module.exports =
  service: (args, done) ->

    app = connect()
    app.use (req, res, next) ->
      res.setHeader "Access-Control-Allow-Origin", "*"
      next()
    app.use connect.compress()
    app.use connect.responseTime()
    app.use connect.favicon()
    app.use connect.query()
    app.use connect.cookieParser()
    app.use connect.static @config.paths.public

    app.use connect.urlencoded()
    app.use connect.json()

    # respond to requests
    app.use (req, res, next) =>
      {body, query, cookies, url} = req
      args = _.merge {}, query, cookies, body

      # connect to message bus
      @axiom.request "default#{url}", args, (err, result) =>

        if (err instanceof Error)
          responseBody = getErrorBody err, @config.options

          # how will 404 look?

          statusCode = 500

        else
          responseBody = _.clone result
          delete responseBody.statusCode

          statusCode = result.statusCode or 200

        contentType = 'application/json'

        res.writeHead statusCode, contentType
        res.end (JSON.stringify responseBody)

    @axiom.request 'run/startServer', {app}, done

    #load = (prop) =>
      #filepath = @config.law[prop]
      #return @util.retrieve(filepath)

    #rawServices = law.load @util.rel(@config.law.services)
    #@services = law.create {
      #services: rawServices
      #jargon: try load('jargon')
      #policy: try load('policy')
    #}

    ## bind all services to the axiom context
    #for name, service of @services
      #@services[name] = service.bind(@)

    ## connect the services to REST routes
    #app.use lawAdapter {
      #services: @services
      #routeDefs: try load('routeDefs')
      #options: @config.law.adapterOptions
    #}
