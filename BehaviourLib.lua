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
-- local bot = GetBot() -- gets bot this script is currently running on

-- MEMORY -- 
local targetLoc = nil
local evadeLoc = nil
local targetAllyHero = nil
local interval = 10

-- default selected ability is first ability but this might be passive ... 
local selectedAbility = GetBot():GetAbilityInSlot( 0 )

-- ACTIONS --

-- move to assigned ally unit
function GoToPartner()

    local partnerPos = PARTNERS[ GetBot():GetUnitName() ]
    local partnerHandle = GetTeamMember( POSITIONS[ partnerPos ] )

    if partnerHandle ~= nil then
        GetBot():Action_MoveToUnit( partnerHandle ) -- Command a bot to move to the specified unit, this will continue to follow the unit
        return SUCCESS
    else
        return FAILURE
    end
end

-- select and set targetLoc as location along lane
function SelectLaneLocation()
    targetLoc = GetLocationAlongLane( GetBot():GetAssignedLane() , 0.5 )
    return SUCCESS
end

-- moves to targetLoc location
function GoToLocation()
    local epsilon = 10

    GetBot():Action_MoveToLocation( targetLoc )
    if GetUnitToLocationDistance(GetBot(), targetLoc) < epsilon then
        return SUCCESS
    else
        return RUNNING
    end
    -- TODO: add condition if times up, return failure
end

-- gets lane front and moves to location
function GoToCreepWave()
    -- GetBot():Action_ClearActions( false )
    local laneLocation = GetLaneFrontLocation(GetBot():GetTeam(), GetBot():GetAssignedLane(), -200)
    GetBot():Action_MoveToLocation(laneLocation) 

    return RUNNING
    -- TODO: add condition if times up, return failure
end

-- selects base as safe location
function SelectSafeLocation()
    -- print('SelectSafeLocation')
    -- { hUnit, ... } GetNearbyTowers( nRadius, bEnemies ) --Returns a table of towers, sorted closest-to-furthest. nRadius must be less than 1600.
    -- nearbyAlliedTowers = GetBot():GetNearbyTowers(700, false) --for now, return nearby allied towers

    local base = GetAncient(GetTeam())
    local baseLoc = base:GetLocation()

    targetLoc = baseLoc or RandomVector( 700 ) -- and run towards first one otherwise run in random direciton lol.
    
    -- TODO: ASSERT TYPE
    return SUCCESS
end

-- sets creepTarget as creep with lowest health around
function SelectTarget()

    local enemyCreepsNearby = GetBot():GetNearbyCreeps(700, true)
    local thresholdTarget = 2*GetBot():GetAttackDamage()
 
    for _,creep in pairs(enemyCreepsNearby) do
        -- Gets an estimate of the amount of damage that this unit can do to the specified unit. If bCurrentlyAvailable is true, it takes into account mana and cooldown status.
        if creep:GetHealth() <= thresholdTarget then            
            -- Target setting and getting is available in the API omg 🙄
            GetBot():SetTarget( creep )

            return SUCCESS
        end
    end

    ---- MORE API FUNCTIONS TO CONSIDER HERE ----
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

    return FAILURE
end

-- dodge attack
function EvadeAttack()
    local iproj = GetBot():GetIncomingTrackingProjectiles()
    -- print("iproj nil?", #iproj)
    if #iproj > 0 then 
        --print('incoming attack at location and is dodgeable?', iproj[1].location, iproj[1].is_dodgeable)
        if iproj[1].is_dodgeable then
            local loc = GetBot():GetLocation()
            -- GetBot():Action_MoveDirectly( Vector(loc.x - 100, loc.y, loc.z) )
            -- GetBot():ActionQueue_MoveDirectly( Vector(loc.x - 100, loc.y, loc.z) )
            evadeLoc = Vector(loc.x - 100, loc.y, loc.z)
            GetBot():Action_MoveToLocation( evadeLoc )
            print("evaded to", evadeLoc )
        end
    end
    return SUCCESS
end

-- select enemy hero target
function SelectHeroTarget()
    -- first check if any enemy heroes nearby
    local enemyHeroesNearby = GetBot():GetNearbyHeroes(700, true, BOT_MODE_NONE)

    -- TODO: check each hero's target, if they are farming / harassing high priority ally, then select that hero.
    if #enemyHeroesNearby > 0 then

        for _,hero in pairs(enemyHeroesNearby) do
            
            -- if this hero has a target, then attack
            if hero:GetAttackTarget() ~= nil then
                -- location, caster, player, ability, is_dodgeable, is_attack
                target = hero
                GetBot():SetTarget( hero )
                return SUCCESS
            end

        end

        -- otherwise just target the closest enemy 
        target = enemyHeroesNearby[1]
        GetBot():SetTarget( target )
        return SUCCESS

    end
    
    -- else
    return FAILURE
end

-- right click attacks target once
function RightClickAttack()
    GetBot():Action_AttackUnit(GetBot():GetTarget(), true)
    return SUCCESS
end

-- select ability to case
function SelectAbility()
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

    GetBot():Action_UseAbilityOnEntity( selectedAbility , GetBot():GetTarget() )
    return SUCCESS
end

-- selects allied hero to heal TODO: Check the need for this. Voodoo Restoration takes NO TARGET. but perhaps healing salve / tango needs targets to share.
function SelectHeroToHeal()
    local alliedHeroesNearby = GetBot():GetNearbyHeroes(1600, false)
    
    for _,hero in pairs(alliedHeroesNearby) do
        if hero:GetHealth()/hero:GetMaxHealth() <= 0.5 and GetBot():GetUnitName() ~= hero:GetUnitName() then
            targetAllyHero = hero
            return SUCCESS
        end
    end

    return FAILURE 
end

-- witch doctor casts healing ability
function CastHealingAbility()
    local ability = GetBot():GetAbilityByName('witch_doctor_voodoo_restoration') -- TODO: Check if this returns nil when not witch doctor
    if ability ~= nil then
        GetBot():ActionPush_UseAbility(ability);
        return SUCCESS
    end
    return FAILURE
end

-- returns table of unit handles in order of position (role)
function GetUnits()
    local units = { }

    for i=1,5 do
        local member = GetTeamMember( i )
        if member ~= nil then
            local membername = member:GetUnitName()
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

-- does nothing
function Idle()
    return SUCCESS
end

-- SENSES --

-- check if hero has health below 80%
function HasLowHealth()
    local currentHealth = GetBot():GetHealth()/GetBot():GetMaxHealth()
    return currentHealth < 0.8 and 1 or 0
end

-- check if any enemy hero is within 700 unit radius
function EnemyNearby()
    local nearbyEnemyHeroes = GetBot():GetNearbyHeroes(700, true, BOT_MODE_NONE)
    return #nearbyEnemyHeroes > 0 and 1 or 0
end

-- check if any ally hero is within 700 unit radius
function AllyNearby()
    local nearbyAllyHeroes = GetBot():GetNearbyHeroes(700, false, BOT_MODE_NONE)

    return #nearbyAllyHeroes > 1 and 1 or 0 -- true if > 1 hero; first hero in table is always this bot
end

-- check team's desire to farm
-- TODO: this should probably be adjustable in the OperA module too. Desire is a top level, team strategy function
function FarmLaneDesire()
    return GetFarmLaneDesire(GetBot():GetAssignedLane()) > 0 and 1 or 0
end

-- checks if in correct lane and position
function IsCorrectLane()
    local dist = GetUnitToLocationDistance( GetBot(), GetLaneFrontLocation( GetBot():GetTeam() , GetBot():GetAssignedLane(), 0) )
    
    if dist < 500 then --500 might not be the right number
        return 1
    else -- either > 500 or something went wrong :) 
        return 0
    end
end

-- check if it is farming time
function IsFarmingTime()   
    local time = DotaTime()
    return time < 10 * 60 and 1 or 0 -- for now, farming time is first 10 mins (laning phase)
end

-- check if it is safe to farm
function IsSafeToFarm()
    return GetBot():WasRecentlyDamagedByAnyHero( interval ) and 0 or 1 -- for now, it's safe to farm if no hero is attacking bot
end

-- check if teleportation scroll is available
function IsScrollAvailable()
    return GetItemStockCount( "item_tpscroll" ) > 0 and 1 or 0
end

-- check if target is dead
function IsLastHit()
    return target:IsAlive() and 1 or 0
end

-- check if this hero has highest position around
function HasHighestPriorityAround()
    -- first, get all allied heroes nearby. 
    alliesNearby = GetBot():GetNearbyHeroes( 700, false, BOT_MODE_NONE) -- within 700 unit radius, BOT_MODE_NONE specifies all heroes
    
    table.remove(alliesNearby, 1) -- remove this bot unit from allied heroes list
    if #alliesNearby > 0 then
        for _,ally in pairs(alliesNearby) do
            return POSITIONS[GetBot():GetUnitName()] <= POSITIONS[ally:GetUnitName()] and 1 or 0
        end
    else
        return 1 -- no allies around, return true
    end
--     { hUnit, ... } GetNearbyHeroes( nRadius, bEnemies, nMode)
-- Returns a table of heroes, sorted closest-to-furthest, that are in the specified mode. If nMode is BOT_MODE_NONE, searches for all heroes. If bEnemies is true, nMode must be BOT_MODE_NONE. nRadius must be less than 1600.
end

-- checks if there are any enemy creeps within 700 unit radius
function EnemyCreepNearby()
    local enemiesNearby = GetBot():GetNearbyCreeps(700, true) -- returns a table of lane creeps, sorted closest-to-furthest. nRadius must be less than 1600.
    return #enemiesNearby > 0 and 1 or 0
end

-- checks if healing ability is available
function IsHealingAbilityAvailable()
    local ability = GetBot():GetAbilityByName('witch_doctor_voodoo_restoration')
    return ability:IsFullyCastable() and 1 or 0
end


function IsFarFromPartner()

    local partnerPos = PARTNERS[ GetBot():GetUnitName() ]
    local partnerHandle = GetTeamMember( POSITIONS[ partnerPos ] )

    return (GetUnitToUnitDistance(GetBot(), partnerHandle) > 250) and 1 or 0
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
                return 1
            end
        end
    end

    return 0 -- else no nearby ally is low health
end

---------------- INCOMPLETE IMPLEMENTATIONS ----------------

-- TODO: check if distance to target location is walkable 
function IsWalkableDistance()
    return 1
end

-- TODO: check if creeps within right click range
function CreepWithinRightClickRange()    
    -- int GetAttackRange()
    -- Returns the range at which the unit can attack another unit.
    return 1
end

-- TODO: check if creeps can be last hit
function CreepCanBeLastHit()
    return 1
end