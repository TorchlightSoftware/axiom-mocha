_ = require 'lodash'

module.exports = (err, options={}) ->
  defaults =
    includeDetails: true
    includeStack: true
    includeMessage: true

  {includeDetails, includeStack, includeMessage} = _.defaults options, defaults

  # Set up the response value
  body = {}

  # Build the 'body' object as indicated by the
  # values of the inclusion flags.
  if includeMessage
    body.message = err.message

  if includeStack
    body.stack = err.stack

  if includeDetails
    _.merge body, err

  return body
