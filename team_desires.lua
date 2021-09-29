-- Team Level Desires
-- If you'd like to supply team-level desires, you can implement the following functions in a team_desires.lua file:

-- TeamThink() - Called every frame. Provides a single think call for your entire team.
-- UpdatePushLaneDesires() - Called every frame. Returns floating point values between 0 and 1 that represent the desires for pushing the top, middle, and bottom lanes, respectively.
-- UpdateDefendLaneDesires() - Called every frame. Returns floating point values between 0 and 1 that represent the desires for defending the top, middle, and bottom lanes, respectively.
-- UpdateFarmLaneDesires() - Called every frame. Returns floating point values between 0 and 1 that represent the desires for farming the top, middle, and bottom lanes, respectively.
-- UpdateRoamDesire() - Called every frame. Returns a floating point value between 0 and 1 and a unit handle that represents the desire for someone to roam and gank a specified target.
-- UpdateRoshanDesire() - Called every frame. Returns a floating point value between 0 and 1 that represents the desire for the team to kill Roshan.
-- If any of these functions are not implemented, it will fall back to the default C++ implementation.

--------------------------------------------------------------------------------------

-- require ( GetScriptDirectory().."/Dependencies" )

-- local norms = require ( GetScriptDirectory().."/OperA/simplemodel" ) -- json string

-- print('IN TEAM DESIRES')
-- -- local opera = {}

-- function TeamThink()

--     -- if opera == nil and PLANS[GetTeam()][2] ~= nil then
--     --     -- immediately append built plan to global table of team plans ... 
--     --     print('GLOBAL PLANNERS FOR OPERA')
--     --     for i,v in pairs( PLANS[GetTeam()] ) do print(i,v) end

--     --     opera = Opera( norms, PLANS[GetTeam()][2] ) -- load plan from json string
--     -- end

-- end