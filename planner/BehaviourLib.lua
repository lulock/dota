--------------------------------------------------------------------------------------
-- NOTE: this is a WIP. Mostly tester code.                                         --
--                                                                                  --
-- this is the Behaviour Library class                                              --
-- a Behaviour Library is:                                                          --
--  . shared amongst all agents                                                     --
--  . where actions and senses are defined                                          --
--                                                                                  --
-- dota bot scripting api:                                                          --
--     https://developer.valvesoftware.com/wiki/Dota_Bot_Scripting                  --
--                                                                                  --
-- for more on the Behaviour Library see:                                           --
--      http://www.cs.bath.ac.uk/~jjb/web/posh.html                                 --
--------------------------------------------------------------------------------------

BehaviourLib = Class{ }

-- AGENT --
local bot = GetBot() -- gets bot this script is currently running on

-- MEMORY -- 
local targetLoc = nil
local targetCreep = nil

-- HELPER FUNCTIONS --
function getEnemyTeam(team)
    if team == TEAM_RADIANT then 
        return TEAM_DIRE
    else
        return TEAM_RADIANT
    end
end

local enemyTeam = getEnemyTeam(bot:GetTeam())

-- ACTIONS --

-- TODO: select location to place ward and set targetLoc
function SelectWardLocation()
    targetLoc = GetRuneSpawnLocation( RUNE_POWERUP_1 ) -- temp at rune location
    print('SelectWardLocation', targetLoc)
    if targetLoc then
        return 'success'
    else
        return 'running'
    end
end

-- select and set targetLoc as location along lane
function SelectLaneLocation()
    targetLoc = GetLocationAlongLane( LANE_MID , 0.5 )
    print('location along mid-lane is', GetLocationAlongLane( LANE_MID , 0.5 ))
    return 'success'
end

-- TODO: select closest tower to targetLoc
function SelectLaneTowerLocation()
    return RandomVector( 700 )
end

-- moves to targetLoc location
function GoToLocation()
    print('GoToLocation')
    bot:Action_MoveToLocation( targetLoc )
    if bot:GetLocation() == targetLoc then
        return 'success'
    else
        return 'running'
    end
    -- add condition if times up, return failure
end

-- gets lane front and moves to location
function GoToCreepWave()
    print('GoToCreepWave')
    local laneLocation = GetLaneFrontLocation(bot:GetTeam(), LANE_MID, -200)
    bot:Action_MoveToLocation(laneLocation);

    -- bot:Action_MoveToLocation( targetLoc )
    if bot:GetLocation() == laneLocation then
        return 'success'
    else
        return 'running'
    end
    -- TODO: add condition if times up, return failure
end

-- TODO: drop the observer ward
function PlaceObserverWard()
    print('PlaceObserverWard')
    -- drop observer ward item
    -- Action_DropItem( hItem, vLocation )
    -- ActionPush_DropItem( hItem, vLocation )
    -- ActionQueue_DropItem( hItem, vLocation )
    return 'success' -- for now
end

-- selects base as safe location
function SelectSafeLocation()
    print('SelectSafeLocation')
    -- { hUnit, ... } GetNearbyTowers( nRadius, bEnemies ) --Returns a table of towers, sorted closest-to-furthest. nRadius must be less than 1600.
    -- nearbyAlliedTowers = bot:GetNearbyTowers(700, false) --for now, return nearby allied towers

    local base = GetAncient(GetTeam())
    print('base is:', base)
    
    local baseLoc = base:GetLocation()
    print('base location is:', baseLoc)

    targetLoc = baseLoc or RandomVector( 700 ) -- and run towards first one otherwise run in random direciton lol.
    
    print('current targetLoc is', targetLoc)
    --TODO: ASSERT TYPE
    return 'success'
end

-- does nothing
function Idle()
    print('Idle function fired')
    return 'success'
end

-- sets creepTarget as creep with lowest health around
function SelectTarget()
    print('SelectTarget function fired')

    local enemiesNearby = bot:GetNearbyCreeps(700, true)
    print('There are', #enemiesNearby, 'nearby enemy creeps')

    for _,v in pairs(enemiesNearby) do
        print('enemy creep', v,'health is: ', v:GetHealth()/v:GetMaxHealth())
        if v:GetHealth()/v:GetMaxHealth() < 0.3 then
            targetCreep = v
            print('target creep is', targetCreep, 'returning success')
            return 'success'
        end
    end

    print('select target failed.')
    return 'failure'
end

-- right click attacks targetCreep once
function RightClickAttack()
    print('RightClickAttack function fired')
    bot:Action_AttackUnit(targetCreep, true)
    return 'success'
end

-- SENSES --

-- check if hero has health below 80%
function HasLowHealth()
    local currentHealth = bot:GetHealth()/bot:GetMaxHealth()
    print('health is:', currentHealth)

    return currentHealth < 0.8 and 1 or 0
end

-- check if any enemy hero is within 700 unit radius
function EnemyNearby()
    local nearbyEnemyHeroes = bot:GetNearbyHeroes(700, true, BOT_MODE_NONE)
    print('EnemyNearby', (#nearbyEnemyHeroes > 0))

    return #nearbyEnemyHeroes > 0 and 1 or 0
end

-- TODO: check if observer ward available
function HasObserverWard()
    print('HasObserverWard sense fired')
    return 1
end

-- check team's desire to farm
function FarmLaneDesire()
    print('FarmLaneDesire sense fired')
    print('GetFarmLaneDesire', GetFarmLaneDesire(bot:GetAssignedLane()))

    return GetFarmLaneDesire(bot:GetAssignedLane()) > 0 and 1 or 0
end

-- TODO: currently checks distance from lane front but should check assigned lane instead
function IsCorrectLane()
    print('IsCorrectLane sense fired')
    print('bots assigned lane is:', bot:GetAssignedLane())
    
    local dist = GetUnitToLocationDistance( bot, GetLaneFrontLocation( bot:GetTeam() , bot:GetAssignedLane(), 0) )


    local botDistanceDownAssignedLane = GetAmountAlongLane(bot:GetAssignedLane(), bot:GetLocation()).distance 
    
    if dist < 500 then --500 might not be the right number
        print('in assigned lane')
        return 1
    else -- either > 500 or something went wrong :) 
        print('not in assigned lane')
        return 0
    end
end

-- TODO: check if distance to target location is walkable 
function IsWalkableDistance()
    print('IsWalkableDistance sense fired')
    return 1
end

-- TODO: check if it is farming time
function IsFarmingTime()
    print('IsFarmingTime sense fired')
    
    -- API functions to use:
    --- float DotaTime()
    --- Returns the game time. Matches game clock. Pauses with game pause.
    
    --- float GameTime()
    --- Returns the time since the hero picking phase started. Pauses with game pause.
    
    --- float RealTime()
    --- Returns the real-world time since the app has started. Does not pause with game pause.
    
    return 1
end

-- TODO: check if it is safe to farm
function IsSafeToFarm()
    print('IsSafeToFarm sense fired')
    return 1
end

-- TODO: check if teleportation scroll is available
function IsScrollAvailable()
    print('IsScrollAvailable sense fired')
    return 0
end

-- TODO: check if target is dead
function IsLastHit()
    print('IsLastHit sense fired')
    return 0
end

-- TODO: check if this hero has highest position around
function HasHighestPriorityAround()
    print('HasHighestPriorityAround sense fired')
    -- print('getpriority does this work', bot:GetPriority()) -- it does not
    return 1
end

-- TODO: check if creeps within right click range
function CreepWithinRightClickRange()
    print('CreepWithinRightClickRange sense fired')
    return 1
end

-- TODO: check if creeps can be last hit
function CreepCanBeLastHit()
    print('CreepCanBeLastHit sense fired')
    return 1
end

-- checks if there are any enemy creeps within 700 unit radius
function EnemyCreepNearby()
    print('EnemyCreepNearby sense fired')
    local enemiesNearby = bot:GetNearbyCreeps(700, true) -- returns a table of lane creeps, sorted closest-to-furthest. nRadius must be less than 1600.
    print('There are', #enemiesNearby, 'nearby enemy creeps')

    return #enemiesNearby > 0 and 1 or 0
end