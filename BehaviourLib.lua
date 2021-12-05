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
-- local ability = GetBot():GetAbilityByName( "witch_doctor_voodoo_restoration" )
local thresholdTarget = 2*GetBot():GetAttackDamage()

-- default selected ability is first ability but this might be passive ... 
local selectedAbility = GetBot():GetAbilityInSlot( 0 )

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

local enemyTeam = getEnemyTeam(GetBot():GetTeam())


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
    if POSITIONS[GetBot():GetUnitName()] == 2 then
        targetAlly = GetTeamMember(1)
    end

    if targetAlly ~= nil then
        GetBot():Action_MoveToLocation(targetAlly:GetLocation() + RandomVector(RandomFloat(-100,100)))
        return SUCCESS
    else
        return FAILURE
    end
end

-- TODO: select location to place ward and set targetLoc
function SelectWardLocation()
    targetLoc = GetRuneSpawnLocation( RUNE_POWERUP_1 ) -- temp at rune location
    --print '\n','SelectWardLocation',targetLoc
    if targetLoc then
        return SUCCESS
    else
        return RUNNING
    end
end

-- select and set targetLoc as location along lane
function SelectLaneLocation()
    targetLoc = GetLocationAlongLane( GetBot():GetAssignedLane() , 0.5 )
    --print  '\n','location along mid-lane is',GetLocationAlongLane( LANE_MID , 0.5 )
    return SUCCESS
end

-- TODO: select closest tower to targetLoc
function SelectLaneTowerLocation()
    return RandomVector( 700 )
end

-- moves to targetLoc location
function GoToLocation()
    GetBot():Action_MoveToLocation( targetLoc )
    if GetBot():GetLocation() == targetLoc then
        return SUCCESS
    else
        return RUNNING
    end
    -- add condition if times up, return failure
end

-- gets lane front and moves to location
function GoToCreepWave()
    -- GetBot():Action_ClearActions( false )
    local laneLocation = GetLaneFrontLocation(GetBot():GetTeam(), GetBot():GetAssignedLane(), -200)
    targetLoc = laneLocation
    GetBot():Action_MoveToLocation(laneLocation + RandomVector(RandomFloat(-100,100))) 

    -- GetBot():Action_MoveToLocation( targetLoc )
    if GetBot():GetLocation() == laneLocation then
        return SUCCESS
    else
        return RUNNING
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
    return SUCCESS -- for now
end

-- selects base as safe location
function SelectSafeLocation()
    --print  '\n',('SelectSafeLocation')
    -- { hUnit, ... } GetNearbyTowers( nRadius, bEnemies ) --Returns a table of towers, sorted closest-to-furthest. nRadius must be less than 1600.
    -- nearbyAlliedTowers = GetBot():GetNearbyTowers(700, false) --for now, return nearby allied towers

    local base = GetAncient(GetTeam())
    --print  '\n','base is:',base
    
    local baseLoc = base:GetLocation()
    --print  '\n','base location is:',baseLoc

    targetLoc = baseLoc or RandomVector( 700 ) -- and run towards first one otherwise run in random direciton lol.
    
    --print  '\n','current targetLoc is',targetLoc
    --TODO: ASSERT TYPE
    return SUCCESS
end

-- does nothing
function Idle()
    --print  '\n',('Idle function fired')
    return SUCCESS
end

-- does nothing
function CowardlyRetreat()
    --print  '\n',('CowardlyRetreat function fired')
    local base = GetAncient(GetTeam())
    --print  '\n','base is:',base
    
    local baseLoc = base:GetLocation()
    --print  '\n','base location is:',baseLoc
    
    return SUCCESS
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

    local enemyCreepsNearby = GetBot():GetNearbyCreeps(700, true)
    --print  '\n','There are',#enemyCreepsNearby,'nearby enemy creeps'
    
    for _,creep in pairs(enemyCreepsNearby) do
        --print  '\n','enemy creep',creep ..'health is: ',creep:GetHealth()
        --print  '\n','enemy creep'.. creep,'health ratio is: ',creep:GetHealth()/creep:GetMaxHealth()
        --print  '\n','and bot attack damage is',GetBot():GetAttackDamage()
        --print  '\n','creeps actual incoming damage is',creep:GetActualIncomingDamage( GetBot():GetAttackDamage(), DAMAGE_TYPE_PHYSICAL )
        --print  '\n','estimated damage to target',GetBot():GetEstimatedDamageToTarget( false, creep, 5, DAMAGE_TYPE_PHYSICAL )

        -- Gets an estimate of the amount of damage that this unit can do to the specified unit. If bCurrentlyAvailable is true, it takes into account mana and cooldown status.
        if creep:GetHealth() <= thresholdTarget then
            target = creep
            
            -- Target setting and getting is available in the API omg 🙄
            GetBot():SetTarget( creep )

            --print  '\n','target creep is',GetBot():GetTarget( ),'returning success'
            return SUCCESS
        end
    end
    
    -- SetTarget( hUnit )

    -- Sets the target to be a specific unit. Doesn't actually execute anything, just potentially useful for communicating a target between modes/items.
    -- hUnit GetTarget()

    -- Gets the target that's been set for a unit.

    --print  '\n',('select target failed.')
    return FAILURE
end

-- dodge attack
function EvadeAttack()
    local iproj = GetBot():GetIncomingTrackingProjectiles()
    if iproj ~= nil then 
        --print('incoming attack at location and is dodgeable?', iproj[1].location, iproj[1].is_dodgeable)
        if iproj[1].is_dodgeable then
            -- Action_MoveDirectly( vLocation )
            -- ActionPush_MoveDirectly( vLocation )
            -- ActionQueue_MoveDirectly( vLocation )

            -- Command a bot to move to the specified location, bypassing the bot pathfinder. Identical to a user's right-click.
            GetBot():Action_MoveDirectly( RandomVector(100) )
        end
    end
end

-- select enemy hero target
function SelectHeroTarget()
    --print  '\n',('SelectHeroTarget function fired')

    -- first check if any enemy heroes nearby
    local enemyHeroesNearby = GetBot():GetNearbyHeroes(700, true, BOT_MODE_NONE)
    --print  '\n','There are',#enemyHeroesNearby,'nearby enemy heroes'

    -- TODO: check each hero's target, if they are farming / harassing high priority ally, then select that hero.
    if #enemyHeroesNearby > 0 then

        for _,hero in pairs(enemyHeroesNearby) do
            
            -- if this hero has a target, then attack
            if hero:GetAttackTarget() ~= nil then
                --print  '\n','target hero is targetting',hero:GetAttackTarget():GetUnitName()
                -- location, caster, player, ability, is_dodgeable, is_attack
                target = hero
                GetBot():SetTarget( hero )
                --print  '\n','target hero is',GetBot():GetTarget( ):GetUnitName(),'returning success'
                return SUCCESS
            end

        end

        -- otherwise just target the closest enemy 
        target = enemyHeroesNearby[1]
        GetBot():SetTarget( target )
        --print  '\n','target hero is',GetBot():GetTarget( ):GetUnitName(),'returning success'
        return SUCCESS

    end
    
    -- else
    --print  '\n',('select target failed.')
    return FAILURE
end

-- right click attacks target once
function RightClickAttack()
    --print  '\n',('RightClickAttack function fired')
    GetBot():Action_AttackUnit(GetBot():GetTarget(), true)
    return SUCCESS
end

-- select ability to case
function SelectAbility()
    --print  '\n',('SelectAbility function fired')

    -- first check if ultimate is available
    local ult = GetBot():GetAbilityInSlot( ULTIMATE[ GetBot():GetUnitName() ] )
    if ult:IsFullyCastable() then
        selectedAbility = ult
        --print('selected ability is ', ult:GetName())
        return SUCCESS
    else
        for i = 0, 23 do
            a = GetBot():GetAbilityInSlot( i )
            if a ~= nil and not a:IsPassive() and a:IsFullyCastable() and a:GetAbilityDamage() > 0 then
                selectedAbility = a 
                --print('selected ability is ', a:GetName())
                --print('selected ability damage is ', a:GetAbilityDamage())
                return SUCCESS
            end
        end
    end
    --print('could not select ability, return failure')
    return FAILURE
end

-- cast ability on target once
function CastAbility()
    -- Active abilities must be used in order to apply their effects. 
    -- Active abilities can consume mana, have cooldowns, 
    -- and usually have some method of targeting related to them. 
    -- The majority of abilities are active abilities. 
    -- They can be activated by pressing their associated Hotkey.

    --print('CastAbility function fired')
    if selectedAbility:GetTargetType() == 0 then
        GetBot():Action_UseAbility( selectedAbility )
        return SUCCESS
    end

    -- EvadeAttack() -- testing evade
    GetBot():Action_UseAbilityOnEntity( selectedAbility , GetBot():GetTarget() )
    return SUCCESS
end

-- selects allied hero to heal TODO: Check the need for this. Voodoo Restoration takes NO TARGET. but perhaps healing salve / tango needs targets to share.
function SelectHeroToHeal()
    --print  '\n',('SelectHero function fired')
    local alliedHeroesNearby = GetBot():GetNearbyHeroes(1600, false)
    --print  '\n','There are',#alliedHeroesNearby,'nearby allied heroes'
    
    for _,hero in pairs(alliedHeroesNearby) do
        --print  '\n','hero',hero,'health is: ',hero:GetHealth()
        --print  '\n','hero',hero,'health ratio is: ',hero:GetHealth()/hero:GetMaxHealth()

        if hero:GetHealth()/hero:GetMaxHealth() <= 0.5 and GetBot():GetUnitName() ~= hero:GetUnitName() then
            targetAllyHero = hero
            --print  '\n','target hero is',targetAllyHero,'returning success'
            return SUCCESS
        end
    end

    --print  '\n',('select target hero failed.')
    return FAILURE 
end

function CastHealingAbility()
    --print  '\n',('CastHealingAbility function fired')
    local ability = GetBot():GetAbilityByName('witch_doctor_voodoo_restoration')
    GetBot():ActionPush_UseAbility(ability);
    return SUCCESS
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

-- use scroll to target location
function TpToLocation()
    local slot = GetBot():FindItemSlot( "item_tpscroll" )
    local scroll = GetBot():GetItemInSlot( slot )
    GetBot():Action_UseAbilityOnLocation( scroll , targetLoc )
    return SUCCESS
end

-- SENSES --

-- check if hero has health below 80%
function HasLowHealth()
    local currentHealth = GetBot():GetHealth()/GetBot():GetMaxHealth()
    --print  '\n','health is:',currentHealth

    return currentHealth < 0.8 and 1 or 0
end

-- check if any enemy hero is within 700 unit radius
function EnemyNearby()
    local nearbyEnemyHeroes = GetBot():GetNearbyHeroes(700, true, BOT_MODE_NONE)
    --print  '\n','EnemyNearby',tostring(#nearbyEnemyHeroes > 0)

    return #nearbyEnemyHeroes > 0 and 1 or 0
end

-- check if any ally hero is within 700 unit radius
function AllyNearby()
    local nearbyAllyHeroes = GetBot():GetNearbyHeroes(700, false, BOT_MODE_NONE)

    return #nearbyAllyHeroes > 1 and 1 or 0 -- true if > 1 hero; first hero in table is always this bot
end

-- TODO: check if observer ward available
function HasObserverWard()
    --print  '\n',('HasObserverWard sense fired')
    return 1
end

-- check team's desire to farm
function FarmLaneDesire()
    --print  '\n',('FarmLaneDesire sense fired')
    --print  '\n','GetFarmLaneDesire',GetFarmLaneDesire(GetBot():GetAssignedLane())

    return GetFarmLaneDesire(GetBot():GetAssignedLane()) > 0 and 1 or 0
end

-- TODO: currently checks distance from lane front but should check assigned lane instead
function IsCorrectLane()
    --print  '\n',('IsCorrectLane sense fired')
    --print  '\n','bots assigned lane is:',GetBot():GetAssignedLane()
    
    local dist = GetUnitToLocationDistance( GetBot(), GetLaneFrontLocation( GetBot():GetTeam() , GetBot():GetAssignedLane(), 0) )


    local botDistanceDownAssignedLane = GetAmountAlongLane(GetBot():GetAssignedLane(), GetBot():GetLocation()).distance 
    
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

    return GetBot():WasRecentlyDamagedByAnyHero( interval ) and 0 or 1 -- for now, it's safe to farm if no hero is attacking bot
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
    --print  '\n','unit name is',GetBot():GetUnitName()

    -- first, get all allied heroes nearby. 
    alliesNearby = GetBot():GetNearbyHeroes( 700, false, BOT_MODE_NONE) -- within 700 unit radius, BOT_MODE_NONE specifies all heroes
    
    -- remove this bot unit from allied heroes list
    table.remove(alliesNearby, 1) 
    --print  '\n','after table remove',alliesNearby,'has size',#alliesNearby 

    if #alliesNearby > 0 then
        for _,ally in pairs(alliesNearby) do
            --print  '\n','bot',GetBot():GetUnitName(),'position is',POSITIONS[GetBot():GetUnitName()]
            --print  '\n','ally',ally:GetUnitName(),'position is',POSITIONS[ally:GetUnitName()]
            return POSITIONS[GetBot():GetUnitName()] <= POSITIONS[ally:GetUnitName()] and 1 or 0
        end
    else
        --print  '\n','unit',GetBot():GetUnitName(),'has highest priority'
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
    --print  '\n','this bots attack range is ',GetBot():GetAttackRange()
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
    local enemiesNearby = GetBot():GetNearbyCreeps(700, true) -- returns a table of lane creeps, sorted closest-to-furthest. nRadius must be less than 1600.
    --print  '\n','There are',#enemiesNearby,'enemy creeps near'
    --print  '\n',(GetBot():GetUnitName())

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
    local ability = GetBot():GetAbilityByName('witch_doctor_voodoo_restoration')
    return ability:IsFullyCastable() and 1 or 0
end

function IsFarFromCarry()
    local targetAlly = nil
    if POSITIONS[GetBot():GetUnitName()] == 2 then
        targetAlly = GetTeamMember(1)
    end
    --print  '\n','farm from carry returns',GetUnitToUnitDistance(bot, targetAlly)
    return (GetUnitToUnitDistance(GetBot(), targetAlly) > 250) and 1 or 0
end

-- checks if any ability is levelled up and castable
function IsAbilityCastable()
    for i = 0, 23 do
        a = GetBot():GetAbilityInSlot( i )
        if a ~= nil and a:IsFullyCastable() and not a:IsPassive() then
            return 1 -- at least one ability can be cast
        end
    end
    return 0 -- parsed through all abilities and none are castable
end

-- checks if any projectiles incoming towards this unit
function IsUnderAttack()
    local iproj = GetBot():GetIncomingTrackingProjectiles()
    --print('iproj size is ', #iproj)
    return #iproj > 0 and 1 or 0
end


-- check if allied heroes around have health below 80%
function NearbyAllyHasLowHealth()
    -- print('in NearbyAllyHasLowHealth')

    local nearbyAllies = GetBot():GetNearbyHeroes( 1600 , false , BOT_MODE_NONE) -- get all allied heroes within 1600 radius
    if nearbyAllies ~= nil then
        for _,ally in pairs(nearbyAllies) do
            local health = ally:GetHealth()
            local maxHealth = ally:GetMaxHealth()
            if health/maxHealth < 0.8 then
                -- print('returning true')

                return 1
            end
        end
    end
    -- print('returning false')


    return 0 -- else no nearby ally is low health
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