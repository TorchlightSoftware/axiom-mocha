_ = require 'lodash'
Router = require 'routes'
logger = require 'torch'

module.exports = (routes) ->

  # Group list of routes by path, so our dispatching can
  # be secondarily based on HTTP method.
  grouped = _.groupBy routes, (r) -> r.path

  # Transform an array of routes into a 'resource' object
  makeResource = (result, pathRoutes, path) ->
    resourceMap = {}
    for r in pathRoutes
      resourceMap[r.method] = r.serviceName

    result[path] = resourceMap

  # Transform the grouped routes into resources
  resources = _.transform grouped, makeResource

  # Set the HTTP method mappings to be the matches
  # for their parent URL paths.
  router = Router()
  for path, resource of resources
    router.addRoute path, resource

  return router
