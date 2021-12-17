--------------------------------------------------------------------------------------
-- this script handles control of Shadow Fiend bot                                  --
--  . Think() - Called every frame. Completely takes over bots.                     --
--    . currently ticks planner's root node.                                        --
-- NOTE: Valve limits which Lua modules are available in secure Lua VM              --
-- (i.e. io module unavailable) so store plan as a json string in lua file instead. --
--------------------------------------------------------------------------------------

require ( GetScriptDirectory().."/Dependencies" )

local file = require ( GetScriptDirectory().."/planner/simpleplan" ) -- json string
local norms = require ( GetScriptDirectory().."/OperA/IM/scenes/priorityfarm" ) -- json string

local planner = Planner( file ) -- load plan from json string
printTable(planner.root.drives) -- DEBUG

local opera = Opera( norms, planner ) -- load plan from json string
-- for _,norm in pairs(opera.norms) do
-- 	--print('norm name is', norm.name)-- DEBUG
-- 	norm:validate()
-- end
-- bot = GetBot() -- this is probably not necessary

function Think()

	-- check action queue length and what the action is ... 
	if GetBot():NumQueuedActions() > 5 then
		print("current action type is ", GetBot():GetCurrentActionType())
		print("and plan's active drive is ", planner.root.currentDriveName)
	end

	-- do nothing if dead
	if not GetBot():IsAlive() then
		return
	end
	
	-- below does not work. cheats not allowed by bots i guess. 
	-- if GetGameState() == GAME_STATE_PRE_GAME then
	-- 	GetBot():ActionImmediate_Chat( '-startgame', true )
	-- end
	
	if DotaTime() >= -80 then
		if opera.units == nil then
			opera.units = _G['GetUnits']() --call function (by name) in the global namespace
		end
		
		planner.root:tick() -- Return values (SUCCESS, RUNNING, or FAILURE) handled by parent nodes.
		opera:update()
		
	end
end