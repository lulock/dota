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

local flag = false
local tower1 = GetTower(TEAM_RADIANT, TOWER_MID_1)
local tower2 = GetTower(TEAM_DIRE, TOWER_MID_1)
local towerLoc = tower1:GetLocation()
towerLoc.z = tower1:GetBoundingRadius()

local vStart = GetBot():GetLocation()
local vEnd = tower2:GetLocation()

-- has two parameters: a distance of the path, 
-- and a table that contains all the waypoints of the path. If the pathfind fails, it will call that function with a distance of 0 and an empty waypoint table.
function printPath(dist, waypoints)
	print('distance is', dist, 'and waypoints length is', waypoints)
end

function Think()

	DebugDrawCircle( tower1:GetLocation(), tower1:GetBoundingRadius(), 255, 0, 0 )
	
	if flag then 
		local tAvoidanceZones = AddAvoidanceZone( towerLoc, 100 )
		GeneratePath( vStart, vEnd, {tAvoidanceZones}, printPath )
		print( #GetAvoidanceZones() )

		flag = false
	end

	-- int AddAvoidanceZone( vLocationAndRadius )

	-- Adds an avoidance zone for use with GeneratePath(). Takes a Vector with x and y as a 2D location, and z as as radius. Returns a handle to the avoidance zone.
	-- RemoveAvoidanceZone( hAvoidanceZone )

	-- Removes the specified avoidance zone.
	-- GeneratePath( vStart, vEnd, tAvoidanceZones, funcCompletion )

	-- Pathfinds from vStar to vEnd, avoiding all the specified avoidance zones and the ones specified with AddAvoidanceZone. Will call funcCompltion when done, which is a function that 

	-- DebugDrawLine( vStart, vEnd, nRed, nGreen, nBlue )

	-- Draws a line from vStar to vEnd in the specified color for one frame.
	-- DebugDrawCircle( vCenter, fRadius, nRed, nGreen, nBlue )

	-- Draws a circle at vCenter with radius fRadius in the specified color for one frame.
	-- DebugDrawText( fScreenX, fScreenY, sText, nRed, nGreen, nBlue )

	-- Draws the specified text at fScreenX, fScreenY on the screen in the specified color for one frame.

	-- check action queue length and what the action is ... 
	-- do nothing if dead
	if not GetBot():IsAlive() then
		return
	end
	
	-- if GetBot():GetCurrentActionType() == BOT_ACTION_TYPE_IDLE and GetBot():NumQueuedActions() == 0 then GetBot():ActionPush_MoveDirectly( GetBot():GetLocation() + RandomVector( -50 ) ) end
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