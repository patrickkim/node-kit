#= require vendor/jquery-2.0.3
#= require vendor/kinetic-4.7.4
#= require vendor/jade-runtime
#= require vendor/underscore-1.5.2
#= require vendor/backbone-1.1.0

#= require src/giddyapps

#= require_tree ../templates
#= require_tree models
#= require_tree views

$ ->
  GiddyApps.initialize()
