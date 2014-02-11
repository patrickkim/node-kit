express     = require "express"
ect         = require "ect"

# App Config
config      = require "#{__dirname}/config"
env         = process.env.NODE_ENV || "development"
port        = process.env.PORT || config[env].port

# Global paths
static_path      = "#{__dirname}/../public"
lib_path         = "#{__dirname}/lib"
# vendor_path      = "#{__dirname}/../vendor"
helpers_path     = "#{__dirname}/helpers"
models_path      = "#{__dirname}/models"
views_path       = "#{__dirname}/views"
controllers_path = "#{__dirname}/controllers"

# Frontend Template compilation
templates_path   = "#{__dirname}/assets/templates"

module.exports = (app) ->

  console.log config
  app.settings.app_name = config.shared_settings.app_name

  # -- Load Environment Settings
  require("#{config_path}/#{env}") app, express

  # -- Set Port
  app.set "port", port

  # -- Database Settings


  # -- Define view engine with its options, Using ect for backend templates.
  # see: http://ectjs.com/
  ect_engine = ect(watch: true, root: views_path, ext: ".ect")

  app.set "views", views_path
  app.set "view engine", "ect"
  app.engine("ect", ect_engine.render)
  app.enable "jsonp callback"

  # -- Parses x-www-form-urlencoded request bodies (and json)
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.cookieParser()

  # CORS middleware
  # see: http://stackoverflow.com/questions/7067966/how-to-allow-cors-in-express-nodejs
  app.use (req, res, next) ->
    res.header "Access-Control-Allow-Origin", "*"
    res.header "Access-Control-Allow-Methods", "GET,PUT,POST,DELETE"
    res.header "Access-Control-Allow-Headers", "Content-Type, Authorization"
    res.header "Cache-Control", "private, max-age=0"
    res.header "Expires", new Date().toUTCString()
    if "OPTIONS" is req.method then res.send 200 else next()

  # -- Express Static Resources
  app.use express.static(static_path)
  app.use express.favicon("#{static_path}/icons/favicon.ico")

  # -- Express routing
  app.use app.router

  # -- Booting up App Assets
  auto_loader = require "#{lib_path}/auto_loader"
  auto_loader.autoload(lib_path, app)
  auto_loader.autoload(helpers_path, app)
  auto_loader.autoload(models_path, app)
  auto_loader.autoload(controllers_path, app)

  # -- Routes
  require("#{config_path}/routes") app