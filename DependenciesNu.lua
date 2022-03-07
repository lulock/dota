--------------------------------------------------------------------------------------
-- this is where all dependencies live (:                                           --
--------------------------------------------------------------------------------------
function GetScriptDirectory()
    return "C:/Program Files (x86)/Steam/steamapps/common/dota 2 beta/game/dota/scripts/vscripts/bots/"
end

-- utility functions
Class = require ( GetScriptDirectory().."/utils/class" )
json = require ( GetScriptDirectory().."/utils/json" )

-- opera
o = require ( GetScriptDirectory().."/OperA/Opera" )
require ( GetScriptDirectory().."/OperA/Norm" )
require ( GetScriptDirectory().."/OperA/Rule" )
require ( GetScriptDirectory().."/OperA/Scene" )

-- planner
p = require ( GetScriptDirectory().."/planner/Planner" )

-- elements
require ( GetScriptDirectory().."/planner/elements/Action" )
require ( GetScriptDirectory().."/planner/elements/ActionPattern" )
require ( GetScriptDirectory().."/planner/elements/Sense" )
require ( GetScriptDirectory().."/planner/elements/Drive" )
require ( GetScriptDirectory().."/planner/elements/DriveCollection" )
require ( GetScriptDirectory().."/planner/elements/Competence" )
require ( GetScriptDirectory().."/planner/elements/CompetenceElement" )

-- behaviour library and global constants
-- require ( GetScriptDirectory().."/BehaviourLib" )
require ( GetScriptDirectory().."/Constants" )

-- require("C:/Program Files (x86)/Steam/steamapps/common/dota 2 beta/game/dota/scripts/vscripts/bots/Constants")