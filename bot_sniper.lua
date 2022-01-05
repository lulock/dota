-- --------------------------------------------------------------------------------------
-- -- this script handles control of Viper bot                                         --
-- --  . Think() - Called every frame. Completely takes over bots.                     --
-- --    . currently ticks planner's root node.                                        --
-- -- NOTE: Valve limits which Lua modules are available in secure Lua VM              --
-- -- (i.e. io module unavailable) so store plan as a json string in lua file instead. --
-- --------------------------------------------------------------------------------------

-- require ( GetScriptDirectory().."/Dependencies" )

-- local file = require ( GetScriptDirectory().."/planner/simpleplan" ) -- json string
-- -- local norms = require ( GetScriptDirectory().."/OperA/simplemodel" ) -- json string
-- local norms = require ( GetScriptDirectory().."/OperA/IM/scenes/priorityfarm" ) -- json string

-- local planner = Planner( file ) -- load plan from json string
-- printTable(planner.root.drives) -- DEBUG

-- local opera = Opera( norms, planner ) -- load plan from json string

-- function Think()

-- 	-- do nothing if dead
-- 	if not GetBot():IsAlive() then
--         return
--     end

-- 	if DotaTime() >= -80 then
-- 		if opera.units == nil then
-- 			opera.units = _G['GetUnits']() --call function (by name) in the global namespace
-- 		end
		
-- 		-- every 5 seconds print gold
-- 		if DotaTime() % 5 == 0 then 
-- 			print(GetBot():GetUnitName(), "," ,GetBot():GetLevel(), ",", GetBot():GetGold())
-- 		end

-- 		planner.root:tick() -- Return values (SUCCESS, RUNNING, or FAILURE) handled by parent nodes.
-- 		opera:update()
-- 	end
-- end