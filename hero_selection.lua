-----------------------------------------------------------------------
-- 	old default code											     -- 
-----------------------------------------------------------------------

function Think()


	if ( GetTeam() == TEAM_RADIANT )
	then
		--print( "selecting radiant" );
		SelectHero( 0, "npc_dota_hero_sniper" );
		SelectHero( 1, "npc_dota_hero_nevermore" );
		SelectHero( 2, "npc_dota_hero_tidehunter" );
		SelectHero( 3, "npc_dota_hero_crystal_maiden" );
		SelectHero( 4, "npc_dota_hero_witch_doctor" );
	elseif ( GetTeam() == TEAM_DIRE )
	then
		--print( "selecting dire" );
		SelectHero( 5, "npc_dota_hero_gyrocopter" );
		SelectHero( 6, "npc_dota_hero_viper" );
		SelectHero( 7, "npc_dota_hero_bristleback" );
		SelectHero( 8, "npc_dota_hero_shadow_shaman" );
		SelectHero( 9, "npc_dota_hero_ogre_magi" );
	end

end

-- lane assignments
function UpdateLaneAssignments()    
    if ( GetTeam() == TEAM_RADIANT )
    then
        return {
        [1] = LANE_BOT,
        -- [1] = LANE_MID,
        [2] = LANE_BOT,
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