--------------------------------------------------------------------------------------
-- constants live here  I THINK THIS SHOULD BE SOCIAL STRUCTURE IN OM               --
--------------------------------------------------------------------------------------

POSITIONS = { -- can this go in OperA role table?!
    ["npc_dota_hero_gyrocopter"] = 1,
	["npc_dota_hero_sniper"] = 1,
	["npc_dota_hero_drow_ranger"] = 1,

    ["npc_dota_hero_nevermore"] = 2,
    ["npc_dota_hero_viper"] = 2,

    ["npc_dota_hero_tidehunter"] = 3, 
	["npc_dota_hero_bristleback"] = 3,
    
    ["npc_dota_hero_crystal_maiden"] = 4,
    ["npc_dota_hero_shadow_shaman"] = 4,

    ["npc_dota_hero_ogre_magi"] = 5,
    ["npc_dota_hero_witch_doctor"] = 5
}

PLANS = { -- collections of team plans for OperA??!?
    [TEAM_RADIANT] = {
        [1] = nil,
        [2] = nil,
        [3] = nil,
        [4] = nil,
        [5] = nil, 
    },
    [TEAM_DIRE] = {
        [1] = nil,
        [2] = nil,
        [3] = nil,
        [4] = nil,
        [5] = nil, 
    }
}