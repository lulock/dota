--------------------------------------------------------------------------------------
-- this script handles control of Viper		 bot									--
-- 		. Think() - Called every frame. Completely takes over bots.					--
--			. currently ticks planner's root node.									--
-- NOTE: Valve limits which Lua modules are available in secure Lua VM 				--
-- (i.e. io module unavailable) so store plan as a json string in lua file instead.	--
--------------------------------------------------------------------------------------

require ( GetScriptDirectory().."/Dependencies" )

local file = require ( GetScriptDirectory().."/planner/simpleplan" ) -- json string

local plan = Planner( file ) -- load plan from json string
local dc = plan:buildPlanner() -- build planner from leaves to root

PrintTable(dc.drives) -- DEBUG

bot = GetBot() -- this is probably not necessary

function Think()
	plan:tickRoot(dc) -- Return values ('success', 'running', or 'failure') handled by parent nodes.
end