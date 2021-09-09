--------------------------------------------------------------------------------------
-- this script handles control of Shadow Fiend bot                                  --
--  . Think() - Called every frame. Completely takes over bots.                     --
--    . currently ticks planner's root node.                                        --
-- NOTE: Valve limits which Lua modules are available in secure Lua VM              --
-- (i.e. io module unavailable) so store plan as a json string in lua file instead. --
--------------------------------------------------------------------------------------

require ( GetScriptDirectory().."/Dependencies" )

local file = require ( GetScriptDirectory().."/planner/simpleplan2" ) -- json string

local planner = Planner( file ) -- load plan from json string
PrintTable(planner.root.drives) -- DEBUG

-- bot = GetBot() -- this is probably not necessary

function Think()
	planner.root:tick() -- Return values ('success', 'running', or 'failure') handled by parent nodes.
end
