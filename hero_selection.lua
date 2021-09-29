
--------------------------------------------------------------------------------------
-- this script handles hero picking and lane assignment                             --
-- the following functions can be implemented here:                                 --
--  . Think() - Called every frame. Responsible for selecting heroes for bots.      --
--     . currently hero pool of 2+ for Pos1 .. Pos5 and randomising selection.      --
--  . UpdateLaneAssignments() - Called every frame prior to the game starting.      --
--    Returns ten PlayerID-Lane pairs.                                              --
--      . currently paring core players with support and one midlaner.              --
--  . GetBotNames() - Called once, returns a table of player names.                 --
--      . currently default                                                         --
--------------------------------------------------------------------------------------

-- hero pools for positions 1 through 5:

-- safelane core
local position_1 =
{
	"npc_dota_hero_gyrocopter",
	"npc_dota_hero_sniper",
	"npc_dota_hero_drow_ranger",
}

-- midlaner
local position_2 =
{
	"npc_dota_hero_nevermore", --shadow fiend
	"npc_dota_hero_viper", 

}

-- offlane core
local position_3 =
{
	"npc_dota_hero_tidehunter", 
	"npc_dota_hero_bristleback",
}

-- offlane support
local position_4 =
{
	"npc_dota_hero_crystal_maiden",
	"npc_dota_hero_shadow_shaman",
}

-- safelane support
local position_5 =
{
	"npc_dota_hero_ogre_magi",
	"npc_dota_hero_witch_doctor",
}

local positions =
{
	[1] = position_1, --safelane
	[2] = position_2, --mid 
	[3] = position_3, --offlane
	[4] = position_4, --offlane/roam 
	[5] = position_5, --safelane
}

-- randomly drafts hero from pool corresponding to position considering opponent in same position
-- args: position (int) and opponent hero name (str, nil if not yet selected)
-- returns: hero name (str)
function RandomHero(pos, opponent)
	
	--pick a random number from 1 to 5.
	local num = RandomInt(1, #positions[pos])
	local hero = positions[pos][num]
	
	-- if already picked, remove hero and try again.
	if hero == opponent 
	then
		table.remove(positions[pos], num)
		num = RandomInt(1, #positions[pos])
		hero = positions[pos][num]
	end
	
	print(#positions[pos])
	
	return hero
end

function Think()

	-- player id is offset depending on team.
	-- RADIANT player ids are 0 to 4, DIRE player ids are 5 to 9
	if ( GetTeam() == TEAM_RADIANT )
	then
		print( "selecting radiant" )
		offset = 0;
	elseif (GetTeam() == TEAM_DIRE )
	then
		print( "selecting dire" )
		offset = 5
	end

	-- keep track of opponent heroes to avoid duplicate selections
	local opponent_pick = {}
	for x, id in pairs(GetTeamPlayers(GetOpposingTeam())) do
		print(x)
		print(GetSelectedHeroName(id))
		table.insert(opponent_pick, GetSelectedHeroName(id))
	end

	-- select random hero from position pool
	for i=1, 5 do
		local opponent =  opponent_pick[i]
		SelectHero( offset + i - 1, RandomHero(i, opponent))
	end
end


-- lane assignments
function UpdateLaneAssignments()    
    if ( GetTeam() == TEAM_RADIANT )
    then
        return {
        -- [1] = LANE_BOT,
        [1] = LANE_BOT,
        [2] = LANE_MID,
        [3] = LANE_TOP,
        [4] = LANE_TOP,
        [5] = LANE_BOT,
        };
    elseif ( GetTeam() == TEAM_DIRE )
    then
        return {
        [1] = LANE_TOP,
        [2] = LANE_MID,
        [3] = LANE_BOT,
        [4] = LANE_BOT,
        [5] = LANE_TOP,
        };
    end
end

-----------------------------------------------------------------------
-- 	old default code											     -- 
-----------------------------------------------------------------------

-- function Think()


-- 	if ( GetTeam() == TEAM_RADIANT )
-- 	then
-- 		print( "selecting radiant" );
-- 		SelectHero( 0, "npc_dota_hero_doom_bringer" );
-- 		SelectHero( 1, "npc_dota_hero_nevermore" );
-- 		SelectHero( 2, "npc_dota_hero_lich" );
-- 		SelectHero( 3, "npc_dota_hero_rubick" );
-- 		SelectHero( 4, "npc_dota_hero_brewmaster" );
-- 	elseif ( GetTeam() == TEAM_DIRE )
-- 	then
-- 		print( "selecting dire" );
-- 		SelectHero( 5, "npc_dota_hero_dazzle" );
-- 		SelectHero( 6, "npc_dota_hero_slardar" );
-- 		SelectHero( 7, "npc_dota_hero_bane" );
-- 		SelectHero( 8, "npc_dota_hero_juggernaut" );
-- 		SelectHero( 9, "npc_dota_hero_alchemist" );
-- 	end

-- end