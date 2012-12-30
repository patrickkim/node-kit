connect_assets = require "connect-assets"
assets_path = "#{__dirname}/../app/assets"

module.exports = (app, express) ->
  app.use express.logger("dev")

  # Enable formatted and uncompress html
  app.locals.pretty = true

  # Enable dependency based asset loading
  app.use connect_assets(src: "#{__dirname}/../app/assets")

  app.use express.errorHandler(
    dumpExceptions: true
    showStack: true
  )