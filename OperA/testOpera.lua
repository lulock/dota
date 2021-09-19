Class = require 'utils/class'
require 'planner/elements/Action'
require 'planner/elements/ActionPattern'
require 'planner/elements/Competence'
require 'planner/elements/CompetenceElement'
require 'planner/elements/Drive'
require 'planner/elements/DriveCollection'
require 'planner/elements/Sense'
require 'planner/Planner'
json = require 'utils/json'

file = require 'OperA/simplemodel'
require 'OperA/Opera'
require 'OperA/Norm'

o = Opera(file)