Class = require 'utils/class'
require 'planner/Action'
require 'planner/ActionPattern'
require 'planner/Competence'
require 'planner/CompetenceElement'
require 'planner/Drive'
require 'planner/DriveCollection'
require 'planner/Sense'
file = require 'planner/simpleplan2'
require 'planner/Planner'
json = require 'utils/json'

p = Planner(file)
dc = p:buildPlanner()