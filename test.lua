--------------------------------------------------------------------------------------
-- this file is to test building a planner outside of dota 2                        --
--------------------------------------------------------------------------------------

Class = require 'utils/class'
require 'planner/elements/Action'
require 'planner/elements/ActionPattern'
require 'planner/elements/Competence'
require 'planner/elements/CompetenceElement'
require 'planner/elements/Drive'
require 'planner/elements/DriveCollection'
require 'planner/elements/Sense'
file = require 'planner/simpleplan2'
require 'planner/Planner'
json = require 'utils/json'

p = Planner(file)