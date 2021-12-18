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

PARTNERS = { -- can this go in OperA role table?!
    ["npc_dota_hero_gyrocopter"] = 5,
	["npc_dota_hero_sniper"] = 5,
	["npc_dota_hero_drow_ranger"] = 5,

    ["npc_dota_hero_nevermore"] = 4,
    ["npc_dota_hero_viper"] = 4,

    ["npc_dota_hero_tidehunter"] = 3, 
	["npc_dota_hero_bristleback"] = 3,
    
    ["npc_dota_hero_crystal_maiden"] = 2,
    ["npc_dota_hero_shadow_shaman"] = 2,

    ["npc_dota_hero_ogre_magi"] = 1,
    ["npc_dota_hero_witch_doctor"] = 1
}


ULTIMATE = { -- each hero has different slots for their ultimate abilities
    ["npc_dota_hero_gyrocopter"] = 3,
	["npc_dota_hero_sniper"] = 3,
	["npc_dota_hero_drow_ranger"] = 3,

    ["npc_dota_hero_nevermore"] = 5,
    ["npc_dota_hero_viper"] = 3,

    ["npc_dota_hero_tidehunter"] = 3, 
	["npc_dota_hero_bristleback"] = 3,
    
    ["npc_dota_hero_crystal_maiden"] = 3,
    ["npc_dota_hero_shadow_shaman"] = 3,

    ["npc_dota_hero_ogre_magi"] = 3,
    ["npc_dota_hero_witch_doctor"] = 3
}

-- STATUS
IDLE = 0
RUNNING = 1
SUCCESS = 2
FAILURE = 3

-- OPERATORS
OBLIGED = 0
PERMITTED = 1
NOTPERMITTED = 2