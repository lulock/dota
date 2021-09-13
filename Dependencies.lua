--------------------------------------------------------------------------------------
-- this is where all dependencies live (:                                           --
--------------------------------------------------------------------------------------

-- utility functions
Class = require ( GetScriptDirectory().."/utils/class" )
json = require ( GetScriptDirectory().."/utils/json" )

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
require ( GetScriptDirectory().."/BehaviourLib" )
require ( GetScriptDirectory().."/Constants" )