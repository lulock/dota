--------------------------------------------------------------------------------------
-- this is where all dependencies live (:                                           --
--------------------------------------------------------------------------------------

Class = require ( GetScriptDirectory().."/utils/class" )
json = require ( GetScriptDirectory().."/utils/json" )
p = require ( GetScriptDirectory().."/planner/Planner" )

require ( GetScriptDirectory().."/planner/Action" )
require ( GetScriptDirectory().."/planner/ActionPattern" )
require ( GetScriptDirectory().."/planner/Sense" )
require ( GetScriptDirectory().."/planner/Drive" )
require ( GetScriptDirectory().."/planner/DriveCollection" )
require ( GetScriptDirectory().."/planner/Competence" )
require ( GetScriptDirectory().."/planner/CompetenceElement" )

require ( GetScriptDirectory().."/planner/BehaviourLib" ) -- to be moved
require ( GetScriptDirectory().."/Constants" )