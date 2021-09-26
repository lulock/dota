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
local targetHero = nil
local interval = 10
local ability = bot:GetAbilityByName( "witch_doctor_voodoo_restoration" )
local thresholdTarget = 2*bot:GetAttackDamage()

-- HELPER FUNCTIONS --
function getEnemyTeam(team)
    if team == TEAM_RADIANT then 
        return TEAM_DIRE
    else
        return TEAM_RADIANT
    end
end

function adjustThreshold(delta)
    thresholdTarget = thresholdTarget * delta
end

local enemyTeam = getEnemyTeam(bot:GetTeam())


function ExtrapolateHealth( unit, interval )
    -- Get the health of a unit in the future if all the current units keep attacking it.
    local nearbyEnemies = {}
    nearbyEnemies.append(unit:GetNearbyCreeps( 500, true ))
    nearbyEnemies.append(unit:GetNearbyHeroes( 700, true, BOT_MODE_NONE ))
    nearbyEnemies.append(unit:GetNearbyTowers( 500, true ))

    local expectedDamage = 0;
    if ( nearbyEnemies ~= nil ) then
        for _, enemy in pairs( nearbyEnemies ) do
            if ( enemy:GetAttackTarget() == unit ) then
                expectedDamage = expectedDamage + enemy:GetEstimatedDamageToTarget(
                    true, unit, interval, DAMAGE_TYPE_PHYSICAL );
            end
        end
    end

    return math.max( 0, unit:GetHealth() - expectedDamage );
end

-- ACTIONS --

function GoToCore()
    local targetAlly = nil
    if POSITIONS[bot:GetUnitName()] == 2 then
        targetAlly = GetTeamMember(1)
    end

    if targetAlly ~= nil then
        bot:Action_MoveToLocation(targetAlly:GetLocation() + RandomVector(RandomFloat(-100,100)))
    end
end

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
    -- bot:Action_ClearActions( false )
    print('GoToCreepWave')
    local laneLocation = GetLaneFrontLocation(bot:GetTeam(), LANE_MID, -200)
    targetLoc = laneLocation
    bot:Action_MoveToLocation(laneLocation + RandomVector(RandomFloat(-100,100))) 

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

-- does nothing
function CowardlyRetreat()
    print('CowardlyRetreat function fired')
    local base = GetAncient(GetTeam())
    print('base is:', base)
    
    local baseLoc = base:GetLocation()
    print('base location is:', baseLoc)
    
    return 'success'
end

-- sets creepTarget as creep with lowest health around
function SelectTarget()
    print('SelectTarget function fired')

    -- float GetAttackDamage()
    -- Returns actual attack damage (with bonuses) of the unit.
    
    -- int GetAttackRange()
    -- Returns the range at which the unit can attack another unit.
    
    -- int GetAttackSpeed()
    -- Returns the attack speed value of the unit.
    
    -- float GetSecondsPerAttack()
    -- Returns the number of seconds per attack (including backswing) of the unit.

    -- float GetEstimatedDamageToTarget( bCurrentlyAvailable, hTarget, fDuration, nDamageTypes )
    -- Gets an estimate of the amount of damage that this unit can do to the specified unit. If bCurrentlyAvailable is true, it takes into account mana and cooldown status.

    local enemyCreepsNearby = bot:GetNearbyCreeps(700, true)
    print('There are', #enemyCreepsNearby, 'nearby enemy creeps')
    
    for _,creep in pairs(enemyCreepsNearby) do
        print('enemy creep', creep,'health is: ', creep:GetHealth())
        print('enemy creep', creep,'health ratio is: ', creep:GetHealth()/creep:GetMaxHealth())
        print('and bot attack damage is', bot:GetAttackDamage())
        print('creeps actual incoming damage is', creep:GetActualIncomingDamage( bot:GetAttackDamage(), DAMAGE_TYPE_PHYSICAL ))
        print('estimated damage to target', bot:GetEstimatedDamageToTarget( false, creep, 5, DAMAGE_TYPE_PHYSICAL ))
        print('extrapolated health is', ExtrapolateHealth( creep, 1000 ))

        -- Gets an estimate of the amount of damage that this unit can do to the specified unit. If bCurrentlyAvailable is true, it takes into account mana and cooldown status.
        if creep:GetHealth() <= thresholdTarget then
            targetCreep = creep
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

function SelectHeroToHeal()
    print('SelectHero function fired')
    local alliedHeroesNearby = bot:GetNearbyHeroes(1600, false)
    print('There are', #alliedHeroesNearby, 'nearby allied heroes')
    
    for _,hero in pairs(alliedHeroesNearby) do
        print('hero', hero,'health is: ', hero:GetHealth())
        print('hero', hero,'health ratio is: ', hero:GetHealth()/hero:GetMaxHealth())

        if hero:GetHealth()/hero:GetMaxHealth() <= 0.5 and bot:GetUnitName() ~= hero:GetUnitName() then
            targetHero = hero
            print('target hero is', targetHero, 'returning success')
            return 'success'
        end
    end

    print('select target hero failed.')
    return 'failure' 
end

function CastHealingAbility()
    print('CastHealingAbility function fired')
    bot:ActionPush_UseAbilityOnEntity(ability, targetHero);
    return 'success'
end

function GoToCore()
    print('GoToCore function fired')
    bot:Action_MoveToLocation();
    return 'success'
end

-- returns table of unit handles in order of position (role)
function GetUnits()
    local units = { }

    for i=1,5 do
        local member = GetTeamMember( i )
        print('index is', i, 'and member is', member)

        if member ~= nil then
            local membername = member:GetUnitName()
            print('membername is', membername)
            local pos = POSITIONS[ membername ]
            units[pos] = member
        end
    end
    
    return units
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

-- check if it is farming time
function IsFarmingTime()
    print('IsFarmingTime sense fired')
    print('dota time is', DotaTime())
    
    -- API functions to use:
    --- float DotaTime()
    --- Returns the game time. Matches game clock. Pauses with game pause.
    
    --- float GameTime()
    --- Returns the time since the hero picking phase started. Pauses with game pause.
    
    --- float RealTime()
    --- Returns the real-world time since the app has started. Does not pause with game pause.
    local time = DotaTime()
    return time < 10 * 60 and 1 or 0 -- for now, farming time is first 10 mins (laning phase)
end

-- THIS IS A DUMMY FUNCTION USED TO TEST OPERA
function IsWardingTime()
    print('IsWardingTime sense fired')
    print('dota time is', DotaTime())
    
    local time = DotaTime()
    return ( time < 0 and time > -80 ) and 1 or 0 -- for now, farming time is first 10 mins (laning phase)
end

-- check if it is safe to farm
function IsSafeToFarm()
    print('IsSafeToFarm sense fired')

    return bot:WasRecentlyDamagedByAnyHero( interval ) and 0 or 1 -- for now, it's safe to farm if no hero is attacking bot
end

-- check if teleportation scroll is available
function IsScrollAvailable()
    print('IsScrollAvailable sense fired')

    return GetItemStockCount( "item_tpscroll" ) > 0 and 1 or 0
end

-- check if target is dead
function IsLastHit()
    print('IsLastHit sense fired')
    print('check if target creep has been killed', targetCreep:IsAlive())
    return targetCreep:IsAlive() and 1 or 0
end

-- TODO: check if this hero has highest position around
function HasHighestPriorityAround()
    print('HasHighestPriorityAround sense fired')
    print('unit name is', bot:GetUnitName())

    -- first, get all allied heroes nearby. 
    alliesNearby = bot:GetNearbyHeroes( 1600, false, BOT_MODE_NONE) -- within 700 unit radius, BOT_MODE_NONE specifies all heroes
    
    -- remove this bot unit from allied heroes list
    table.remove(alliesNearby, 1) 
    print('after table remove', alliesNearby, 'has size', #alliesNearby) 

    if #alliesNearby > 0 then
        for _,ally in pairs(alliesNearby) do
            print('bot', bot:GetUnitName(), 'position is', POSITIONS[bot:GetUnitName()])
            print('ally', ally:GetUnitName(), 'position is', POSITIONS[ally:GetUnitName()])
            return POSITIONS[bot:GetUnitName()] <= POSITIONS[ally:GetUnitName()] and 1 or 0
        end
    else
        print('unit', bot:GetUnitName(),'has highest priority')
        return 1 -- no allies around, return true
    end
--     { hUnit, ... } GetNearbyHeroes( nRadius, bEnemies, nMode)
-- Returns a table of heroes, sorted closest-to-furthest, that are in the specified mode. If nMode is BOT_MODE_NONE, searches for all heroes. If bEnemies is true, nMode must be BOT_MODE_NONE. nRadius must be less than 1600.

end

-- TODO: check if creeps within right click range
function CreepWithinRightClickRange()
    print('CreepWithinRightClickRange sense fired')
    
    -- int GetAttackRange()
    -- Returns the range at which the unit can attack another unit.
    print('this bots attack range is ', bot:GetAttackRange())
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
    print('There are', #enemiesNearby, 'enemy creeps near')
    print(bot:GetUnitName())

    return #enemiesNearby > 0 and 1 or 0
end


-- float GetAttackPoint()

-- Returns the point in the animation where a unit will execute the attack.
-- float GetLastAttackTime()

-- Returns the time that the unit last executed an attack.
-- hUnit GetAttackTarget()

-- Returns a the attack target of the unit.
-- int GetAcquisitionRange()

-- Returns the range at which this unit will attack a target.
-- int GetAttackProjectileSpeed()

-- Returns the speed of the unit's attack projectile.

-- checks if healing ability is available
function IsHealingAbilityAvailable()
    return ability:IsFullyCastable() and 1 or 0
end

function IsFarFromCarry()
    local targetAlly = nil
    if POSITIONS[bot:GetUnitName()] == 2 then
        targetAlly = GetTeamMember(1)
    end
    print('farm from carry returns', GetUnitToUnitDistance(bot, targetAlly))
    return (GetUnitToUnitDistance(bot, targetAlly) > 250) and 1 or 0
end



-- Action_UseAbility( hAbility )
-- ActionPush_UseAbility( hAbility )
-- ActionQueue_UseAbility( hAbility )

-- Command a bot to use a non-targeted ability or item
-- Action_UseAbilityOnEntity( hAbility, hTarget )
-- ActionPush_UseAbilityOnEntity( hAbility, hTarget )
-- ActionQueue_UseAbilityOnEntity( hAbility, hTarget )

-- Command a bot to use a unit targeted ability or item on the specified target unit
-- Action_UseAbilityOnLocation( hAbility, vLocation )
-- ActionPush_UseAbilityOnLocation( hAbility, vLocation )
-- ActionQueue_UseAbilityOnLocation( hAbility, vLocation )

-- Command a bot to use a ground targeted ability or item on the specified location
-- Action_UseAbilityOnTree( hAbility, iTree )
-- ActionPush_UseAbilityOnTree( hAbility, iTree )
-- ActionQueue_UseAbilityOnTree( hAbility, iTree )

-- Command a bot to use a tree targeted ability or item on the specified tree
-- Action_PickUpRune( nRune )
