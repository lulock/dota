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

require 'OperA/Scene'

function test()
    local team = {
        {1,5},
        {3,4}
    }
    local resultSense = Sense('IsFarmingTime', 0, 'bool')
    print('result sense is:', resultSense.name, resultSense.value, resultSense.comparator)
    
    local norms = {
        Norm('farm', {} , 'last_hit', 'OBLIGED' )
    }

    -- farming scene involves one core and one support role
    -- the result is farming time done
    -- the norms and rules involve:
    --  . support always being within reasonable radius of core
    --  . core last hitting
    farmingScene = Scene('farming', team, resultSense, norms)
    farmingScene:activate()

end