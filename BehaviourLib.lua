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

-- MEMORY -- each agent instantiates their own copy of this class.

-- local targetLoc = nil
local targetAllyHero = nil

local tbot = GetBot( ):GetUnitName( )
--print("in behaviourlib and bot is ", tbot)

-- CONSTANTS --

local interval = 10
local maxActions = 4
local lowHealth = 0.8

local targetLoc = 
{
    [1] = nil,
    [2] = nil,
    [3] = nil,
    [4] = nil,
    [5] = nil

}
local LocTest = 
{
    [1] = nil,
    [2] = nil,
    [3] = nil,
    [4] = nil,
    [5] = nil

}

BOUNTY = 
{
    [1] = 0,
    [2] = 0,
    [3] = 0,
    [4] = 0,
    [5] = 0
}

-- default selected ability is first ability but this might be passive ... 
local selectedAbility = GetBot():GetAbilityInSlot( 0 )
print('Unit Name, Role, Dota Time, Drive, Hero Level, Hero Gold, Hero Kills, Hero Deaths, Hero Assists')


-- HELPER FUNCTIONS --

function clearActions()
    GetBot():Action_ClearActions( false )
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

-- ACTIONS --

-- select and set targetLoc as location along lane
function SelectLaneLocation( status )
    if status == IDLE then
        targetLoc[ POSITIONS[ GetBot():GetUnitName() ] ] = GetLocationAlongLane( GetBot( ):GetAssignedLane( ) , 0.5)
        return SUCCESS
    end
    return status
end

-- moves to targetLoc location
function GoToLocation( status )
    if status == IDLE then
        -- print("GO2LOC", targetLoc, " - queuing action - RUNNING", GetBot():GetUnitName() )
        -- print("GO2LOC", targetLoc, " - dist", GetUnitToLocationDistance( GetBot(), targetLoc) )
        GetBot():Action_MoveToLocation( targetLoc[ POSITIONS[ GetBot():GetUnitName() ] ] )
        -- print("QueueLength", GetBot():NumQueuedActions() )
        return RUNNING
    elseif status == RUNNING then 
        -- print("GO2LOC - RUNNING, curr action is", GetBot():GetCurrentActionType (  ) )
        -- print("QueueLength", GetBot():NumQueuedActions() )
        if GetBot():GetCurrentActionType (  ) ~=  BOT_ACTION_TYPE_MOVE_TO and GetBot():NumQueuedActions() == 0 then
            --print("GO2LOC - reached DEST")
            return SUCCESS
        else
            return RUNNING
        end
    end
    return status
end

-- gets lane front and moves to location
function GoToCreepWave( status )

    
    -- Return the lane front amount (0.0 - 1.0) of the specified teams creeps along the specified lane. Optionally can ignore towers.
    -- vector GetLaneFrontLocation( nTeam, nLane, fDeltaFromFront )
    -- Returns the location of the lane front for the specified team and lane. Always ignores towers. Has a third parameter for a distance delta from the front.
    -- Returns the location the specified amount (0.0 - 1.0) along the specified lane.

    if status == IDLE then
        local laneLocation = GetLaneFrontLocation(GetBot():GetTeam(), GetBot():GetAssignedLane(), -200) - RandomVector( 20 )

        local tower = GetBot():GetNearbyTowers( 1600, true )
        if #tower > 0 then 
            local tower1 = tower[1] 
        
            local towerLoc = tower1:GetLocation()
            if tower1:CanBeSeen() then
                --print('can see enemy tower', GetBot():GetUnitName())
                local radius = tower1:GetAttackRange()
                local withinX = laneLocation.x >= towerLoc.x - radius and laneLocation.x <= towerLoc.x + radius
                local withinY = laneLocation.y >= towerLoc.y - radius and laneLocation.y <= towerLoc.y + radius
                -- Draws a line from vStar to vEnd in the specified color for one frame.
                -- DebugDrawCircle( towerLoc, radius, 255, 0, 0 )
    
                if withinX and withinY then 
                    laneLocation =  laneLocation - RandomVector( 1*radius )
                end
            end

        end

        LocTest[ POSITIONS[ GetBot():GetUnitName() ] ] = laneLocation
        GetBot():Action_MoveToLocation( laneLocation )
        --print("GO2CREEP - queuing action - RUNNING - laneLoc passable?", IsLocationPassable(laneLocation), GetBot():GetUnitName() )
        return RUNNING
    elseif status == RUNNING then 
        -- print ("GO2CREEP - reached DEST?", GetUnitToLocationDistance( GetBot(), LocTest[ POSITIONS[ GetBot():GetUnitName() ] ]), GetBot():GetUnitName() )
        -- print ("GO2CREEP - TIME", DotaTime() )
        while not IsLocationPassable( LocTest[ POSITIONS[ GetBot():GetUnitName() ] ] ) do 
            LocTest[ POSITIONS[ GetBot():GetUnitName() ] ] = LocTest[ POSITIONS[ GetBot():GetUnitName() ] ] - RandomVector( 20 )
            -- print("recalc loc", GetBot():GetUnitName())
        end 

        if (GetBot():GetCurrentActionType(  ) ~=  BOT_ACTION_TYPE_MOVE_TO and GetBot():NumQueuedActions() == 0) or (GetUnitToLocationDistance( GetBot(), LocTest[ POSITIONS[ GetBot():GetUnitName() ] ]) <= 60) then
            return SUCCESS
        else
            return RUNNING
        end
    end
    return status
end

-- selects base as safe location
function SelectSafeLocation( status )
    -- print( "select safe location", status )
    -- { hUnit, ... } GetNearbyTowers( nRadius, bEnemies ) --Returns a table of towers, sorted closest-to-furthest. nRadius must be less than 1600.
    if status == IDLE then
        -- local closeTowers = GetBot( ):GetNearbyTowers( 1600, false )
        local baseLoc = GetAncient( GetTeam( ) ):GetLocation( )
        targetLoc[ POSITIONS[ GetBot():GetUnitName() ] ] = baseLoc 
        return SUCCESS
    end
    
    return status
end

-- helper function, health extrapolation
function PredictHealth( unit )
    -- local currHealth = unit:GetHealth( )
    local iProj = unit:GetIncomingTrackingProjectiles( )

    local currHealth = unit:GetHealth( )
    -- print("currHealth", currHealth)
    for i, p in pairs(iProj) do
        -- print("info about proj #", i, 
        -- "loc:", p.location, 
        -- "caster:", p.caster, 
        -- "player:", p.player, 
        -- "ability:", p.ability, 
        -- "dodge:", p.is_dodgeable, 
        -- "attack:", p.is_attack,
        -- "is caster hero?:", p.caster:IsHero())

        -- local actualDamage = unit:GetActualIncomingDamage(p.caster:GetAttackDamage(), DAMAGE_TYPE_ALL)
        -- print("caster attack damage", p.caster:GetAttackDamage())
        -- print("caster estimated damage to target", p.caster:GetEstimatedDamageToTarget(false, unit, GetBot():GetSecondsPerAttack() , DAMAGE_TYPE_ALL))
        -- print("caster attack projectile speed", p.caster:GetAttackProjectileSpeed())
        -- print("caster attack projectile seconds per attack", p.caster:GetSecondsPerAttack())
        -- print("actualDamage from caster is", actualDamage)

        currHealth = currHealth - p.caster:GetEstimatedDamageToTarget(false, unit, GetBot():GetSecondsPerAttack() , DAMAGE_TYPE_ALL)
        -- print("discounted unit health is", i, currHealth)
    end
    return currHealth
    -- { { location, caster, player, ability, is_dodgeable, is_attack }, ... } GetIncomingTrackingProjectiles()

    -- Returns information about all projectiles incoming towards this unit.

end

-- sets creepTarget as creep with lowest health around
function SelectTarget( status )

    if status == IDLE then
        local secondsPerAttack = GetBot():GetSecondsPerAttack()
        local enemyCreepsNearby = GetBot( ):GetNearbyCreeps( GetBot():GetAttackRange( ), true )
        for i,creep in pairs( enemyCreepsNearby ) do
        local secondsPerAttack = GetBot():GetSecondsPerAttack()
            local thresholdTarget = secondsPerAttack*creep:GetActualIncomingDamage(GetBot():GetAttackDamage(), DAMAGE_TYPE_PHYSICAL)
            -- local thresholdTarget = GetUnitToUnitDistance(creep, GetBot() )*0.01*creep:GetBot():GetAttackDamage()
            if creep:CanBeSeen( ) and (creep:GetHealth() <= thresholdTarget ) then
                -- GetBot():Action_AttackUnit( creep, true )
                -- print("creep health", creep:GetHealth() )
                GetBot( ):SetTarget( creep )
                return SUCCESS
            end
        end
        return FAILURE
    end
    return status
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
end

-- dodge attack
function EvadeAttack( status )
    -- bool IsLocationPassable( vLocation )
    -- Returns whether the specified location is passable.
    
    if status == IDLE then
        -- get all incoming projectiles
        local iproj = GetBot():GetIncomingTrackingProjectiles()
        
        -- if yes ... 
        if #iproj > 0 then

            -- first consider only first projectile
            local attack = iproj[1]

            -- is it dogeable?
            if attack.is_dodgeable then
                local loc = GetBot():GetLocation()
                local dist = GetUnitToLocationDistance(GetBot(), attack.location)
                local evadeLoc = (attack.location - loc) / dist
                
                -- GetBot():ActionPush_MoveToLocation( loc + ( 10 * Vector( evadeLoc.y, -evadeLoc.x, 0 )) )
                GetBot():Action_MoveToLocation( loc + ( 50 * Vector( evadeLoc.y, -evadeLoc.x, 0 )) )
                -- --print( "evaded to", evadeLoc )
                -- GetBot():ActionPush_MoveDirectly( loc + ( 200 * Vector( evadeLoc.y, -evadeLoc.x, 0 )) )
                
            end
        end
        GetBot():Action_AttackUnit( GetBot():GetTarget(), true )
        --print("EVADE - queuing action - RUNNING", GetBot():GetUnitName() )

        -- print("current action type is ", GetBot():GetCurrentActionType())
        -- print("action queue length is ", GetBot():NumQueuedActions())
        -- print( "EVADEATTACK - RUNNING")
        return RUNNING
    elseif status == RUNNING then
        -- if GetBot():GetCurrentActionType() ~= BOT_ACTION_TYPE_MOVE_TO then -- if not already moving, then move
        if GetBot():NumQueuedActions() == 0 then 
            -- print( "EVADEATTACK - SUCCESS")
            return SUCCESS
        else
            return RUNNING
        end
    end

    return status
end

-- select enemy hero target
function SelectHeroTarget( status )

    if status == IDLE then
        -- first check if any enemy heroes nearby
        local enemyHeroesNearby = GetBot( ):GetNearbyHeroes( 700, true, BOT_MODE_NONE )
        local thresholdTarget = 2*GetBot( ):GetAttackDamage( )

        -- TODO: check each hero's target, if they are farming / harassing high priority ally, then select that hero.
        if #enemyHeroesNearby > 0 then

            for _,hero in pairs( enemyHeroesNearby ) do
                
                -- if this hero has a target, then attack
                if hero:CanBeSeen() then
                    if hero:GetAttackTarget( ) ~= nil then
                        -- location, caster, player, ability, is_dodgeable, is_attack
                        target = hero
                        GetBot( ):SetTarget( hero )
                    end
                end
            end

            -- otherwise just target the closest enemy 
            target = enemyHeroesNearby[1]
            GetBot( ):SetTarget( target )
            return SUCCESS

        end
        -- else
        return FAILURE
    end
    return status

end

-- right click attacks target once
function RightClickAttack( status )

    if status == IDLE then        
        GetBot( ):Action_AttackUnit( GetBot( ):GetTarget( ), true )
        -- print("RCA - action - RUNNING", GetBot():GetUnitName() )
        -- print("TARGET HEALTH", GetBot( ):GetTarget( ):GetHealth( ) )
        -- print("TARGET DAMAGE", GetBot( ):GetTarget( ):GetActualIncomingDamage( GetBot( ):GetAttackDamage( ), DAMAGE_TYPE_PHYSICAL ) )
        return SUCCESS
    -- elseif status == RUNNING then 
    --     if GetBot( ):GetCurrentActionType ( ) ~=  BOT_ACTION_TYPE_ATTACK and GetBot():NumQueuedActions() == 0 then
    --         --print ( "RCA - SUCCESS", GetBot():GetUnitName() )
    --         return SUCCESS
    --     else
    --         return RUNNING
    --     end
    end
    return status
    -- GetBot():Action_MoveDirectly(GetBot():GetLocation() - RandomVector(100))
    -- GetBot():ActionImmediate_Chat( "attack", true ) 
    -- print("in RCA, # of queued actions ", GetBot():NumQueuedActions())
end

-- select ability to case
-- BUGFIX: Select Ability based on type and based on behaviour. If harassing, then select ability with target hero. If farming, then select ability with target creep.
function SelectAbility( status )

    if status == IDLE then
        -- first check if ultimate is available
        local ult = GetBot():GetAbilityInSlot( ULTIMATE[ GetBot():GetUnitName() ] )
        if ult:IsFullyCastable() then
            selectedAbility = ult
            --print('selected ability is ', ult:GetName())
            return SUCCESS
        else
            for i = 0, 23 do
                a = GetBot():GetAbilityInSlot( i )
                -- only select ability that is active, can be seen, fully castable, applies damage, and targets all units or no target. 
                if a ~= nil and not a:IsPassive() and not a:IsHidden() and a:IsFullyCastable() and a:GetAbilityDamage() > 0 and (a:GetTargetType() == ABILITY_TARGET_TYPE_ALL or a:GetTargetType() == ABILITY_TARGET_TYPE_NONE) then
                    selectedAbility = a 
                    print('selected ability is ', a:GetName())
                    --print('selected ability damage is ', a:GetAbilityDamage())
                    return SUCCESS
                end
            end
        end
        -- print('could not select ability, return failure')
        return FAILURE
    end
    return status
end

-- cast ability on target once
function CastAbility( status )
    --print("CASTABILITY - target type", selectedAbility:GetTargetType(), GetBot():GetUnitName())
    if status == IDLE then
        print("target type ", selectedAbility:GetTargetType(), GetBot():GetUnitName() )
        if selectedAbility:GetTargetType() == ABILITY_TARGET_TYPE_NONE then
            GetBot():Action_UseAbility( selectedAbility )
            --print("CASTABILITY1 - queuing action - RUNNING", GetBot():GetUnitName() )
        else
            GetBot():Action_UseAbilityOnEntity( selectedAbility , GetBot():GetTarget() )
            --print("CASTABILITY2 - queuing action - RUNNING", GetBot():GetUnitName() )
        end
        return RUNNING
    elseif status == RUNNING then 
        if GetBot( ):GetCurrentActionType ( ) ~=  BOT_ACTION_TYPE_USE_ABILITY and GetBot():NumQueuedActions() == 0 then
            -- print ( "Cast Ability - SUCCESS" )
            --print ( "CASTABILITY - SUCCESS", GetBot():GetUnitName() )
            return SUCCESS
        else
            return RUNNING
        end
    end
    return status

end

-- selects allied hero to heal TODO: Check the need for this. Voodoo Restoration takes NO TARGET. but perhaps healing salve / tango needs targets to share.
function SelectHeroToHeal( status )
    
    if status == IDLE then
        local alliedHeroesNearby = GetBot():GetNearbyHeroes( 700, false )
        for _,hero in pairs( alliedHeroesNearby ) do
            if hero:GetHealth()/hero:GetMaxHealth( ) <= 0.5 and GetBot( ):GetUnitName( ) ~= hero:GetUnitName( ) then
                targetAllyHero = hero -- TODO: use API target setter here instead
                return SUCCESS
            end
        end

        return FAILURE -- no allied hero low health, return failure
    end

    return status

end

-- witch doctor casts healing ability
function HealAbility( status )

    if status == IDLE then
        GetBot():Action_UseAbility( GetBot():GetAbilityByName( 'witch_doctor_voodoo_restoration' ) )
        return RUNNING
    elseif status == RUNNING then
        if GetBot( ):GetCurrentActionType ( ) ~=  BOT_ACTION_TYPE_USE_ABILITY and GetBot():NumQueuedActions() == 0 then
            -- print ( "Cast Ability - SUCCESS" )
            --print ( "HEALABILITY - SUCCESS", GetBot():GetUnitName() )
            return SUCCESS
        else
            return RUNNING
        end
    end

    return status 
    
end

-- witch doctor casts healing ability
function HealItem( status )
    if status == IDLE then

        local itemSlot = GetBot():FindItemSlot('item_flask')
        local itemHandle = GetBot():GetItemInSlot( itemSlot )
        GetBot():Action_UseAbilityOnEntity( itemHandle, GetBot() )
        -- print("stock count", GetItemStockCount('item_flask'))
        -- print("slot type", GetBot():GetItemSlotType(itemSlot))
        -- print("slot main?", GetBot():GetItemSlotType(itemSlot) == ITEM_SLOT_TYPE_MAIN)

        return RUNNING
    elseif status == RUNNING then
        if GetBot( ):GetCurrentActionType ( ) ~=  BOT_ACTION_TYPE_USE_ABILITY and GetBot():NumQueuedActions() == 0 then
            -- print ( "Cast Ability - SUCCESS" )
            --print ( "HEALITEM - SUCCESS", GetBot():GetUnitName() )
            return SUCCESS
        else
            return RUNNING
        end
    end

    return status 
    
end

-- TODO
function CourierStashedItems (status)

    if status == IDLE then
        -- print("IsCourierAvailable?", IsCourierAvailable())    
        -- if IsCourierAvailable() then
        GetBot():ActionImmediate_Courier(GetCourier( POSITIONS[GetBot():GetUnitName()] -1), COURIER_ACTION_TAKE_STASH_ITEMS)
        -- GetBot():ActionImmediate_Courier(GetCourier( POSITIONS[GetBot():GetUnitName()] ), COURIER_ACTION_TAKE_AND_TRANSFER_ITEMS)
        return SUCCESS

    -- elseif status == RUNNING then
    end

    return status

    -- ActionImmediate_Courier(, COURIER_ACTION_TAKE_STASH_ITEMS) 
    -- bool IsCourierAvailable()

    -- Returns if the courier is available to use.

    -- Returns the number of team couriers
    -- hCourier GetCourier( nCourier )

    -- Returns a handle to the specified courier (zero based index)
    -- int GetCourierState( hCourier )

    -- Returns the current state of the specified courier.

end

-- witch doctor casts healing ability
function BuyHealItem( status )

-- Item Purchase Results
-- PURCHASE_ITEM_SUCCESS
-- PURCHASE_ITEM_OUT_OF_STOCK
-- PURCHASE_ITEM_DISALLOWED_ITEM
-- PURCHASE_ITEM_INSUFFICIENT_GOLD
-- PURCHASE_ITEM_NOT_AT_HOME_SHOP
-- PURCHASE_ITEM_NOT_AT_SIDE_SHOP
-- PURCHASE_ITEM_NOT_AT_SECRET_SHOP
-- PURCHASE_ITEM_INVALID_ITEM_NAME

    if status == IDLE then
        -- buy here 
        local result = GetBot():ActionImmediate_PurchaseItem ( 'item_flask' )
        if result == PURCHASE_ITEM_SUCCESS then
            --print ( "BUYITEM - SUCCESS", GetBot():GetUnitName() )
            --print ( "BUYITEM - currAction", GetBot():GetCurrentActionType() )
            
            return SUCCESS
        else
            return FAILURE
        end
    end

    return status 
    
end

-- witch doctor casts healing ability
function CastHealingAbility()
    -- local ability = GetBot():GetAbilityByName('witch_doctor_voodoo_restoration') -- TODO: Check if this returns nil when not witch doctor
    if ability ~= nil then
        GetBot():ActionPush_UseAbility(ability);
        return SUCCESS
    end
    return FAILURE
end

-- move to assigned ally unit TODO: refactor
function GoToPartner( status )

    if status == IDLE then
        local partnerPos = PARTNERS[ GetBot( ):GetUnitName( ) ]
        local partnerHandle = GetTeamMember( POSITIONS[ partnerPos ] )

        if partnerHandle ~= nil then
            GetBot():ActionQueue_MoveToUnit( partnerHandle ) -- Command a bot to move to the specified unit, this will continue to follow the unit
            --print("GTP - queuing action - RUNNING")
            return RUNNING
        else
            return FAILURE
        end

    elseif status == RUNNING then
        if GetBot():GetCurrentActionType() ~= BOT_ACTION_TYPE_MOVE_TO and GetBot():NumQueuedActions() == 0 then
            -- print ( "GO2PARTNER - SUCCESS" )
            return SUCCESS
        else 
            return RUNNING
        end
    end
    return status
end

-- use scroll to target location
function TpToLocation( status )
    -- print( "TpToLocation" )
    local slot = GetBot( ):FindItemSlot( "item_tpscroll" )
    local scroll = GetBot( ):GetItemInSlot( slot )
    GetBot( ):Action_UseAbilityOnLocation( scroll , targetLoc[ POSITIONS[ GetBot():GetUnitName() ] ] )
    return SUCCESS
end

-- does nothing
function Idle( status )
    GetBot():Action_MoveDirectly( GetBot():GetLocation() + RandomVector( 10 ) )
    return SUCCESS
end

-- SENSES --

-- -- check if hero has health below 80%
-- function HasLowHealth( )
--     local currentHealth = GetBot( ):GetHealth( )/GetBot( ):GetMaxHealth( )
--     return currentHealth < lowHealth and 1 or 0
-- end
-- check if hero has health below 80%
function HasExtremelyLowHealth( )
    local currentHealth = GetBot( ):GetHealth( )/GetBot( ):GetMaxHealth( )
    return currentHealth < 0.3 and 1 or 0
end

-- check if any enemy hero is within 700 unit radius
function EnemyNearby( )
    local nearbyEnemyHeroes = GetBot( ):GetNearbyHeroes( 700, true, BOT_MODE_NONE )
    return #nearbyEnemyHeroes > 0 and 1 or 0
end

-- check if any ally hero is within 700 unit radius
function AllyNearby( )
    local nearbyAllyHeroes = GetBot( ):GetNearbyHeroes( 700, false, BOT_MODE_NONE )

    return #nearbyAllyHeroes > 1 and 1 or 0 -- true if > 1 hero; first hero in table is always this bot
end

-- check team's desire to farm
-- TODO: this should probably be adjustable in the OperA module too. Desire is a top level, team strategy function
function FarmLaneDesire( )
    return GetFarmLaneDesire(GetBot():GetAssignedLane()) > 0 and 1 or 0
end

-- checks if in correct lane and position
function IsCorrectLane( )
    local dist = GetUnitToLocationDistance( GetBot( ), GetLaneFrontLocation( GetBot( ):GetTeam( ), GetBot( ):GetAssignedLane( ), 0) )
    
    if dist < 500 then --500 might not be the right number
        return 1
    else -- either > 500 or something went wrong :) 
        return 0
    end
end

-- check if it is farming time
function IsFarmingTime( )   
    local time = DotaTime( )
    return time < 10 * 60 and 1 or 0 -- for now, farming time is first 10 mins (laning phase)
end

-- check if it is safe to farm
function IsSafeToFarm( )
    -- print("not safetofarm", GetBot( ):WasRecentlyDamagedByAnyHero( interval ) or GetBot( ):GetHealth( )/GetBot():GetMaxHealth( ) < 0.8)
    -- GetBot( ):WasRecentlyDamagedByAnyHero( interval )
    return (Health( ) > 0.8) and 1 or 0 -- for now, it's safe to farm if health > 80%
end

-- check if target is dead
function IsLastHit( )
    return target:IsAlive( ) and 1 or 0
end

-- check if this hero has highest position around
function HasHighestPriorityAround( )
    -- first, get all allied heroes nearby. 
    alliesNearby = GetBot():GetNearbyHeroes( 700, false, BOT_MODE_NONE ) -- within 700 unit radius, BOT_MODE_NONE specifies all heroes
    
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

-- -- checks if any projectiles incoming towards this unit
function IsUnderAttack()
    -- local iproj = GetBot():GetIncomingTrackingProjectiles()
    
    -- if #iproj > 0 then

    --     -- first consider only first projectile
    --     local attack = iproj[1]

    --     -- is it dogeable?
    --     return attack.is_dodgeable
    -- end

    return (GetBot():WasRecentlyDamagedByAnyHero(3) or GetBot():WasRecentlyDamagedByCreep(3) or GetBot():WasRecentlyDamagedByTower(3)) and 1 or 0
end

-- checks if recently damaged by hero, creep, or tower within speicified time
function RecentlyUnderAttack( time )
    local nTime = tonumber( time )
    -- local nTime = tonumber( time ) or 10 -- or default 10
    return (GetBot():WasRecentlyDamagedByAnyHero(nTime) or GetBot():WasRecentlyDamagedByCreep(nTime) or GetBot():WasRecentlyDamagedByTower(nTime)) and 1 or 0
end

-- returns this bot's health percentage value within range [0.0, 1.0]
function Health( )
    return GetBot():GetHealth() / GetBot():GetMaxHealth()
end

-- checks if item argument is available
function IsItemAvailable( item )
    local itemSlot = GetBot():FindItemSlot( item )
    
    return GetBot():GetItemSlotType(itemSlot) == ITEM_SLOT_TYPE_MAIN and 1 or 0
end

-- checks if ability argument is available
function IsAbilityAvailable( ability )
    local abilityHandle = GetBot():GetAbilityByName( ability )
    if abilityHandle ~= nil and abilityHandle:IsFullyCastable() then
        return 1
    else 
        return 0
    end
    -- return abilityHandle:IsFullyCastable() > 0 and 1 or 0
end

-- checks if enough gold for item argument
function EnoughGoldForItem( item )
    local itemCost = GetItemCost( item )
    local botGold = GetBot():GetGold( )

    -- print("Enough Gold?", botGold >= itemCost )
    -- print("Bot Gold", GetBot():GetGold() )
    -- print("itemCost", item, 'is', GetItemCost( item ) )
    -- print("a diff itemCost item_arcane_boots is", GetItemCost( 'item_arcane_boots' ) )
    -- print("Stash Val", GetBot():GetStashValue() )
    -- local alreadyStashed = GetBot():GetStashValue() >= GetItemCost( item ) 
    return (botGold >= itemCost) and 1 or 0
end

-- checks if item argument is available
function IsItemStashed( item )
    local itemSlot = GetBot():FindItemSlot( item )
    
    return GetBot():GetItemSlotType(itemSlot) == ITEM_SLOT_TYPE_STASH and 1 or 0
end

-- checks if courier available
function CourierAvailable(  )
    local courier = GetCourier( POSITIONS[GetBot():GetUnitName()] - 1 )
    local cState = GetCourierState( courier )
    
    return (cState == COURIER_STATE_IDLE or cState == COURIER_STATE_AT_BASE) and 1 or 0
end

-- check if allied heroes around have health below 80%
function NearbyAllyHasLowHealth( )
    -- print('in NearbyAllyHasLowHealth')

    local nearbyAllies = GetBot( ):GetNearbyHeroes( 1600 , false , BOT_MODE_NONE) -- get all allied heroes within 1600 radius
    if nearbyAllies ~= nil then
        for _,ally in pairs( nearbyAllies ) do
            local health = ally:GetHealth( )
            local maxHealth = ally:GetMaxHealth( )
            if health/maxHealth < lowHealth then
                return 1
            end
        end
    end

    return 0 -- else no nearby ally is low health
end

---------------- INCOMPLETE IMPLEMENTATIONS ----------------

-- TODO: check if distance to target location is walkable 
function IsWalkableDistance( )
    return 1
end

-- TODO: check if creeps within right click range
function CreepWithinRightClickRange( )    
    -- int GetAttackRange()
    -- Returns the range at which the unit can attack another unit.
    return 1
end

-- TODO: check if creeps can be last hit
function CreepCanBeLastHit( )
    return 1
end