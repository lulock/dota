--------------------------------------------------------------------------------------
-- NOTE: this is a WIP. Mostly tester code.                                         --
--                                                                                  --
-- this is the Behaviour Library class                                              --
-- a Behaviour Library is:                                                          --
--  . shared amongst all agents                                                     --
--  . where actions and senses are defined                                          --
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


function getEnemyTeam(team)
    if team == TEAM_RADIANT then 
        return TEAM_DIRE
    else
        return TEAM_RADIANT
    end
end

local enemyTeam = getEnemyTeam(bot:GetTeam())

-- ACTIONS --
function SelectWardLocation()
    targetLoc = GetRuneSpawnLocation( RUNE_POWERUP_1 ) -- temp at rune location
    print('SelectWardLocation', targetLoc)
    if targetLoc then
        return 'success'
    else
        return 'running'
    end
end

function SelectLaneLocation()
    targetLoc = GetLocationAlongLane( LANE_MID , 0.5 )
    print('location along mid-lane is', GetLocationAlongLane( LANE_MID , 0.5 ))
    return 'success'
end

function SelectLaneTowerLocation()
    return RandomVector( 700 )
end

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
    -- add condition if times up, return failure
end

function PlaceObserverWard()
    print('PlaceObserverWard')
    bot:Action_PickUpRune( RUNE_POWERUP_1 )
    return 'success' -- for now
    -- drop observer ward item
    -- Action_DropItem( hItem, vLocation )
    -- ActionPush_DropItem( hItem, vLocation )
    -- ActionQueue_DropItem( hItem, vLocation )

    -- Command a bot to drop the specified item and the provided location
end

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

-- Idle does nothing.
function Idle()
    print('Idle function fired')
    return 'success'
end

-- SelectTarget sets creepTarget as creep with lowest health around.
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

function RightClickAttack()
    print('RightClickAttack function fired')
    bot:Action_AttackUnit(targetCreep, true)
    return 'success'
end

-- SENSES --
function HasLowHealth()
    local currentHealth = bot:GetHealth()/bot:GetMaxHealth()
    print('health is:', currentHealth)

    return currentHealth < 0.8 and 1 or 0
end

function EnemyNearby()
    local nearbyEnemyHeroes = bot:GetNearbyHeroes(700, true, BOT_MODE_NONE)
    print('EnemyNearby', (#nearbyEnemyHeroes > 0))

    return #nearbyEnemyHeroes > 0 and 1 or 0
    -- { hUnit, ... } GetNearbyHeroes( nRadius, bEnemies, nMode)
    -- Returns a table of heroes, sorted closest-to-furthest, that are in the specified mode. If nMode is BOT_MODE_NONE, searches for all heroes. If bEnemies is true, nMode must be BOT_MODE_NONE. nRadius must be less than 1600.
end

function HasObserverWard()
    print('HasObserverWard sense fired')
    return 1
end

function FarmLaneDesire()
    print('FarmLaneDesire sense fired')
    print('GetFarmLaneDesire', GetFarmLaneDesire(bot:GetAssignedLane()))

    return GetFarmLaneDesire(bot:GetAssignedLane()) > 0 and 1 or 0
end

function IsCorrectLane()
    -- currently checks distance from lane front but should check assigned lane instead
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

function IsWalkableDistance()
    print('IsWalkableDistance sense fired')
    return 1
end

function IsFarmingTime()
    print('IsFarmingTime sense fired')
    return 1
end

function IsSafeToFarm()
    print('IsSafeToFarm sense fired')
    return 1
end

function IsScrollAvailable()
    print('IsScrollAvailable sense fired')
    return 0
end

function IsLastHit()
    print('IsLastHit sense fired')
    --here check if target is dead
    return 0
end

function HasHighestPriorityAround()
    print('HasHighestPriorityAround sense fired')
    -- print('getpriority does this work', bot:GetPriority()) -- it does not
    return 1
end

function CreepWithinRightClickRange()
    print('CreepWithinRightClickRange sense fired')
    return 1
end

function CreepCanBeLastHit()
    print('CreepCanBeLastHit sense fired')
    return 1
end

function EnemyCreepAround()
--     { hUnit, ... } GetNearbyLaneCreeps( nRadius, bEnemies )
-- Returns a table of lane creeps, sorted closest-to-furthest. nRadius must be less than 1600.
    print('EnemyCreepAround sense fired')
    local enemiesNearby = bot:GetNearbyCreeps(700, true)
    print('There are', #enemiesNearby, 'nearby enemy creeps')

    return #enemiesNearby > 0 and 1 or 0
end
