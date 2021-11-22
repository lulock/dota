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
local log = '' 
local start = GameTime()
-- AGENT --
local bot = GetBot() -- gets bot this script is currently running on

-- MEMORY -- 
local targetLoc = nil
local target = nil
local targetAllyHero = nil
local interval = 10
local ability = bot:GetAbilityByName( "witch_doctor_voodoo_restoration" )
local thresholdTarget = 2*bot:GetAttackDamage()

-- default selected ability is first ability but this might be passive ... 
local selectedAbility = bot:GetAbilityInSlot( 0 )

-- HELPER FUNCTIONS --

function dump() -- this is super inefficient. 
    if GameTime() - start > 5 then
        print(log)
        log = ''
        start = GameTime()
    end 
end

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
    table.insert(nearbyEnemies, unit:GetNearbyCreeps( 500, true ))
    table.insert(nearbyEnemies, unit:GetNearbyHeroes( 700, true, BOT_MODE_NONE))
    table.insert(nearbyEnemies, unit:GetNearbyTowers( 500, true ))

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
        return 'success'
    else
        return 'failure'
    end
end

-- TODO: select location to place ward and set targetLoc
function SelectWardLocation()
    targetLoc = GetRuneSpawnLocation( RUNE_POWERUP_1 ) -- temp at rune location
    --print '\n','SelectWardLocation',targetLoc
    if targetLoc then
        return 'success'
    else
        return 'running'
    end
end

-- select and set targetLoc as location along lane
function SelectLaneLocation()
    targetLoc = GetLocationAlongLane( LANE_MID , 0.5 )
    --print  '\n','location along mid-lane is',GetLocationAlongLane( LANE_MID , 0.5 )
    return 'success'
end

-- TODO: select closest tower to targetLoc
function SelectLaneTowerLocation()
    return RandomVector( 700 )
end

-- moves to targetLoc location
function GoToLocation()
    --print  '\n',('GoToLocation')
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
    --print  '\n',('GoToCreepWave')
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
    --print  '\n',('PlaceObserverWard')
    -- drop observer ward item
    -- Action_DropItem( hItem, vLocation )
    -- ActionPush_DropItem( hItem, vLocation )
    -- ActionQueue_DropItem( hItem, vLocation )
    return 'success' -- for now
end

-- selects base as safe location
function SelectSafeLocation()
    --print  '\n',('SelectSafeLocation')
    -- { hUnit, ... } GetNearbyTowers( nRadius, bEnemies ) --Returns a table of towers, sorted closest-to-furthest. nRadius must be less than 1600.
    -- nearbyAlliedTowers = bot:GetNearbyTowers(700, false) --for now, return nearby allied towers

    local base = GetAncient(GetTeam())
    --print  '\n','base is:',base
    
    local baseLoc = base:GetLocation()
    --print  '\n','base location is:',baseLoc

    targetLoc = baseLoc or RandomVector( 700 ) -- and run towards first one otherwise run in random direciton lol.
    
    --print  '\n','current targetLoc is',targetLoc
    --TODO: ASSERT TYPE
    return 'success'
end

-- does nothing
function Idle()
    --print  '\n',('Idle function fired')
    return 'success'
end

-- does nothing
function CowardlyRetreat()
    --print  '\n',('CowardlyRetreat function fired')
    local base = GetAncient(GetTeam())
    --print  '\n','base is:',base
    
    local baseLoc = base:GetLocation()
    --print  '\n','base location is:',baseLoc
    
    return 'success'
end

-- sets creepTarget as creep with lowest health around
function SelectTarget()
    --print  '\n',('SelectTarget function fired')

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
    --print  '\n','There are',#enemyCreepsNearby,'nearby enemy creeps'
    
    for _,creep in pairs(enemyCreepsNearby) do
        --print  '\n','enemy creep',creep ..'health is: ',creep:GetHealth()
        --print  '\n','enemy creep'.. creep,'health ratio is: ',creep:GetHealth()/creep:GetMaxHealth()
        --print  '\n','and bot attack damage is',bot:GetAttackDamage()
        --print  '\n','creeps actual incoming damage is',creep:GetActualIncomingDamage( bot:GetAttackDamage(), DAMAGE_TYPE_PHYSICAL )
        --print  '\n','estimated damage to target',bot:GetEstimatedDamageToTarget( false, creep, 5, DAMAGE_TYPE_PHYSICAL )

        -- Gets an estimate of the amount of damage that this unit can do to the specified unit. If bCurrentlyAvailable is true, it takes into account mana and cooldown status.
        if creep:GetHealth() <= thresholdTarget then
            target = creep
            
            -- Target setting and getting is available in the API omg 🙄
            bot:SetTarget( creep )

            --print  '\n','target creep is',bot:GetTarget( ),'returning success'
            return 'success'
        end
    end
    
    -- SetTarget( hUnit )

    -- Sets the target to be a specific unit. Doesn't actually execute anything, just potentially useful for communicating a target between modes/items.
    -- hUnit GetTarget()

    -- Gets the target that's been set for a unit.

    --print  '\n',('select target failed.')
    return 'failure'
end

-- dodge attack
function EvadeAttack()
    local iproj = bot:GetIncomingTrackingProjectiles()
    if iproj ~= nil then 
        print('incoming attack at location and is dodgeable?', iproj[1].location, iproj[1].is_dodgeable)
        if iproj[1].is_dodgeable then
            -- Action_MoveDirectly( vLocation )
            -- ActionPush_MoveDirectly( vLocation )
            -- ActionQueue_MoveDirectly( vLocation )

            -- Command a bot to move to the specified location, bypassing the bot pathfinder. Identical to a user's right-click.
            bot:Action_MoveDirectly( RandomVector(100) )
        end
    end
end

-- select enemy hero target
function SelectHeroTarget()
    --print  '\n',('SelectHeroTarget function fired')

    -- first check if any enemy heroes nearby
    local enemyHeroesNearby = bot:GetNearbyHeroes(700, true, BOT_MODE_NONE)
    --print  '\n','There are',#enemyHeroesNearby,'nearby enemy heroes'

    -- TODO: check each hero's target, if they are farming / harassing high priority ally, then select that hero.
    if #enemyHeroesNearby > 0 then

        for _,hero in pairs(enemyHeroesNearby) do
            
            -- if this hero has a target, then attack
            if hero:GetAttackTarget() ~= nil then
                --print  '\n','target hero is targetting',hero:GetAttackTarget():GetUnitName()
                -- location, caster, player, ability, is_dodgeable, is_attack
                target = hero
                bot:SetTarget( hero )
                --print  '\n','target hero is',bot:GetTarget( ):GetUnitName(),'returning success'
                return 'success'
            end

        end

        -- otherwise just target the closest enemy 
        target = enemyHeroesNearby[1]
        bot:SetTarget( target )
        --print  '\n','target hero is',bot:GetTarget( ):GetUnitName(),'returning success'
        return 'success'

    end
    
    -- else
    --print  '\n',('select target failed.')
    return 'failure'
end

-- right click attacks target once
function RightClickAttack()
    --print  '\n',('RightClickAttack function fired')
    bot:Action_AttackUnit(bot:GetTarget(), true)
    return 'success'
end

-- select ability to case
function SelectAbility()
    --print  '\n',('SelectAbility function fired')

    -- first check if ultimate is available
    local ult = bot:GetAbilityInSlot( ULTIMATE[ bot:GetUnitName() ] )
    if ult:IsFullyCastable() then
        selectedAbility = ult
        print('selected ability is ', ult:GetName())
        return 'success'
    else
        for i = 0, 23 do
            a = bot:GetAbilityInSlot( i )
            if a ~= nil and not a:IsPassive() and a:IsFullyCastable() then
                selectedAbility = a 
                print('selected ability is ', a:GetName())
                return 'success'
            end
        end
    end
    print('could not select ability, return failure')
    return 'failure'
end

-- cast ability on target once
function CastAbility()
    -- Active abilities must be used in order to apply their effects. 
    -- Active abilities can consume mana, have cooldowns, 
    -- and usually have some method of targeting related to them. 
    -- The majority of abilities are active abilities. 
    -- They can be activated by pressing their associated Hotkey.

    print('CastAbility function fired')
    if selectedAbility:GetTargetType() == 0 then
        bot:Action_UseAbility( selectedAbility )
        return 'success'
    end

    -- EvadeAttack() -- testing evade
    bot:Action_UseAbilityOnEntity( selectedAbility , bot:GetTarget() )
    return 'success'
end

-- selects allied hero to heal
function SelectHeroToHeal()
    --print  '\n',('SelectHero function fired')
    local alliedHeroesNearby = bot:GetNearbyHeroes(1600, false)
    --print  '\n','There are',#alliedHeroesNearby,'nearby allied heroes'
    
    for _,hero in pairs(alliedHeroesNearby) do
        --print  '\n','hero',hero,'health is: ',hero:GetHealth()
        --print  '\n','hero',hero,'health ratio is: ',hero:GetHealth()/hero:GetMaxHealth()

        if hero:GetHealth()/hero:GetMaxHealth() <= 0.5 and bot:GetUnitName() ~= hero:GetUnitName() then
            targetAllyHero = hero
            --print  '\n','target hero is',targetAllyHero,'returning success'
            return 'success'
        end
    end

    --print  '\n',('select target hero failed.')
    return 'failure' 
end

function CastHealingAbility()
    --print  '\n',('CastHealingAbility function fired')
    bot:ActionPush_UseAbilityOnEntity(ability, targetAllyHero);
    return 'success'
end

-- returns table of unit handles in order of position (role)
function GetUnits()
    local units = { }

    for i=1,5 do
        local member = GetTeamMember( i )
        --print  '\n','index is',i,'and member is',member

        if member ~= nil then
            local membername = member:GetUnitName()
            --print  '\n','membername is',membername
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
    --print  '\n','health is:',currentHealth

    return currentHealth < 0.8 and 1 or 0
end

-- check if any enemy hero is within 700 unit radius
function EnemyNearby()
    local nearbyEnemyHeroes = bot:GetNearbyHeroes(700, true, BOT_MODE_NONE)
    --print  '\n','EnemyNearby',tostring(#nearbyEnemyHeroes > 0)

    return #nearbyEnemyHeroes > 0 and 1 or 0
end

-- TODO: check if observer ward available
function HasObserverWard()
    --print  '\n',('HasObserverWard sense fired')
    return 1
end

-- check team's desire to farm
function FarmLaneDesire()
    --print  '\n',('FarmLaneDesire sense fired')
    --print  '\n','GetFarmLaneDesire',GetFarmLaneDesire(bot:GetAssignedLane())

    return GetFarmLaneDesire(bot:GetAssignedLane()) > 0 and 1 or 0
end

-- TODO: currently checks distance from lane front but should check assigned lane instead
function IsCorrectLane()
    --print  '\n',('IsCorrectLane sense fired')
    --print  '\n','bots assigned lane is:',bot:GetAssignedLane()
    
    local dist = GetUnitToLocationDistance( bot, GetLaneFrontLocation( bot:GetTeam() , bot:GetAssignedLane(), 0) )


    local botDistanceDownAssignedLane = GetAmountAlongLane(bot:GetAssignedLane(), bot:GetLocation()).distance 
    
    if dist < 500 then --500 might not be the right number
        --print  '\n',('in assigned lane')
        return 1
    else -- either > 500 or something went wrong :) 
        --print  '\n',('not in assigned lane')
        return 0
    end
end

-- TODO: check if distance to target location is walkable 
function IsWalkableDistance()
    --print  '\n',('IsWalkableDistance sense fired')
    return 1
end

-- check if it is farming time
function IsFarmingTime()
    --print  '\n',('IsFarmingTime sense fired')
    --print  '\n','dota time is',DotaTime()
    
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
    --print  '\n',('IsWardingTime sense fired')
    --print  '\n','dota time is',DotaTime()
    
    local time = DotaTime()
    return ( time < 0 and time > -80 ) and 1 or 0 -- for now, farming time is first 10 mins (laning phase)
end

-- check if it is safe to farm
function IsSafeToFarm()
    --print  '\n',('IsSafeToFarm sense fired')

    return bot:WasRecentlyDamagedByAnyHero( interval ) and 0 or 1 -- for now, it's safe to farm if no hero is attacking bot
end

-- check if teleportation scroll is available
function IsScrollAvailable()
    --print  '\n',('IsScrollAvailable sense fired')

    return GetItemStockCount( "item_tpscroll" ) > 0 and 1 or 0
end

-- check if target is dead
function IsLastHit()
    --print  '\n',('IsLastHit sense fired')
    --print  '\n','check if target creep has been killed',tostring(target:IsAlive())
    return target:IsAlive() and 1 or 0
end

-- TODO: check if this hero has highest position around
function HasHighestPriorityAround()
    --print  '\n',('HasHighestPriorityAround sense fired')
    --print  '\n','unit name is',bot:GetUnitName()

    -- first, get all allied heroes nearby. 
    alliesNearby = bot:GetNearbyHeroes( 1600, false, BOT_MODE_NONE) -- within 700 unit radius, BOT_MODE_NONE specifies all heroes
    
    -- remove this bot unit from allied heroes list
    table.remove(alliesNearby, 1) 
    --print  '\n','after table remove',alliesNearby,'has size',#alliesNearby 

    if #alliesNearby > 0 then
        for _,ally in pairs(alliesNearby) do
            --print  '\n','bot',bot:GetUnitName(),'position is',POSITIONS[bot:GetUnitName()]
            --print  '\n','ally',ally:GetUnitName(),'position is',POSITIONS[ally:GetUnitName()]
            return POSITIONS[bot:GetUnitName()] <= POSITIONS[ally:GetUnitName()] and 1 or 0
        end
    else
        --print  '\n','unit',bot:GetUnitName(),'has highest priority'
        return 1 -- no allies around, return true
    end
--     { hUnit, ... } GetNearbyHeroes( nRadius, bEnemies, nMode)
-- Returns a table of heroes, sorted closest-to-furthest, that are in the specified mode. If nMode is BOT_MODE_NONE, searches for all heroes. If bEnemies is true, nMode must be BOT_MODE_NONE. nRadius must be less than 1600.

end

-- TODO: check if creeps within right click range
function CreepWithinRightClickRange()
    --print  '\n',('CreepWithinRightClickRange sense fired')
    
    -- int GetAttackRange()
    -- Returns the range at which the unit can attack another unit.
    --print  '\n','this bots attack range is ',bot:GetAttackRange()
    return 1
end

-- TODO: check if creeps can be last hit
function CreepCanBeLastHit()
    --print  '\n',('CreepCanBeLastHit sense fired')
    return 1
end

-- checks if there are any enemy creeps within 700 unit radius
function EnemyCreepNearby()
    --print  '\n',('EnemyCreepNearby sense fired')
    local enemiesNearby = bot:GetNearbyCreeps(700, true) -- returns a table of lane creeps, sorted closest-to-furthest. nRadius must be less than 1600.
    --print  '\n','There are',#enemiesNearby,'enemy creeps near'
    --print  '\n',(bot:GetUnitName())

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
    --print  '\n','farm from carry returns',GetUnitToUnitDistance(bot, targetAlly)
    return (GetUnitToUnitDistance(bot, targetAlly) > 250) and 1 or 0
end

-- checks if any ability is levelled up and castable
function IsAbilityCastable()
    for i = 0, 23 do
        a = bot:GetAbilityInSlot( i )
        if a ~= nil and a:IsFullyCastable() and not a:IsPassive() then
            return 1 -- at least one ability can be cast
        end
    end
    return 0 -- parsed through all abilities and none are castable
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
