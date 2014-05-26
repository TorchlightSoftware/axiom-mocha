error = require 'tea-error'

AxiomConnectError = error 'AxiomConnectError'

class NoRouteError extends AxiomConnectError
  name: 'AxiomConnectError/NoRouteError'

  constructor: (context, start) ->
    {path} = context
    message = "No route for: '#{path}'"

    super message, context, start

module.exports = {NoRouteError}
