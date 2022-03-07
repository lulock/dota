--------------------------------------------------------------------------------------
-- this script handles control of Viper bot                                         --
--  . Think() - Called every frame. Completely takes over bots.                     --
--    . currently ticks planner's root node.                                        --
-- NOTE: Valve limits which Lua modules are available in secure Lua VM              --
-- (i.e. io module unavailable) so store plan as a json string in lua file instead. --
--------------------------------------------------------------------------------------

require ( GetScriptDirectory().."/Dependencies" )

local file = require ( GetScriptDirectory().."/planner/simpleplan" ) -- json string
-- local norms = require ( GetScriptDirectory().."/OperA/simplemodel" ) -- json string
local norms = require ( GetScriptDirectory().."/OperA/IM/scenes/priorityfarm" ) -- json string

local planner = Planner( file ) -- load plan from json string
local flag = true
print("Printing plan for", GetBot():GetUnitName()) 
printTable(planner.root.drives) -- DEBUG

local opera = Opera( norms, planner ) -- load plan from json string
print("witch doctor position is", POSITIONS[ GetBot():GetUnitName() ])

GetBot().Plan = {["plan"] = 0}

require ( GetScriptDirectory().."/Team" )

function Think()

	-- do nothing if dead
	if not GetBot():IsAlive() then
        return
    end
	
	if TEAM and flag then 
		print("WD exists...", WD)
		print("TEAM exists...", TEAM)
		TEAM[5] = planner
		print("plan at idx 5 is ", TEAM[5])
		flag = false 
		print("plan for this bot is ", GetBot().Plan)
		print("this WD bot is ", GetBot())
		print("this playerID is ", GetBot():GetPlayerID())
	end


	if DotaTime() >= -80 then
		if opera.units == nil then
			opera.units = _G['GetUnits']() --call function (by name) in the global namespace
		end
		
		planner.root:tick() -- Return values (SUCCESS, RUNNING, or FAILURE) handled by parent nodes.
		opera:update()
	end
end