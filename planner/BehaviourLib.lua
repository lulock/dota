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
    targetLoc = GetLocationAlongLane( LANE_MID , 0.0 )
    print('location along mid-lane is', GetLocationAlongLane( LANE_MID , 0.0 ))
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
    -- targetLoc = RandomVector( 700 ) -- and run towards first one otherwise run in random direciton lol.
    return 'success'
end

function Idle()
    print('Idle function fired')
    return 'success'
end

-- SENSES --
function EnemyNearby()
    nearbyEnemyHeroes = bot:GetNearbyHeroes(700, true, BOT_MODE_NONE)
    print('EnemyNearby', (#nearbyEnemyHeroes > 0))

    return #nearbyEnemyHeroes > 0 and 1 or 0
    -- { hUnit, ... } GetNearbyHeroes( nRadius, bEnemies, nMode)
    -- Returns a table of heroes, sorted closest-to-furthest, that are in the specified mode. If nMode is BOT_MODE_NONE, searches for all heroes. If bEnemies is true, nMode must be BOT_MODE_NONE. nRadius must be less than 1600.
end

function HasObserverWard()
    print('Has observer ward sense fired')
    return 1
end

function InCorrectLane()
    -- correct lane is LANE_MID for now
    print('InCorrectLane sense fired')
    print('distance between bot current location and lane_mid is:', GetAmountAlongLane( LANE_MID, bot:GetLocation() ).distance)
    return 0
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

function InCorrectLane()
    print('IsScrollAvailable')
    return 0
end