-----------------------------------------------------------------------------------------------------------
-- this script handles control of ability and item usage for all bots                                    --
--  . ItemUsageThink() - Called every frame. Responsible for issuing item usage actions.                 --
--  . AbilityUsageThink() - Called every frame. Responsible for issuing ability usage actions.           -- 
--  . CourierUsageThink() - Called every frame. Responsible for issuing commands to the courier.         --
--  . BuybackUsageThink() - Called every frame. Responsible for issuing a command to buyback.            --
--  . AbilityLevelUpThink() - Called every frame. Responsible for managing ability leveling.             --
--                                                                                                       --
-- NOTE Built-in ability names can be found here:                                                        --
--  . https://developer.valvesoftware.com/wiki/Dota_2_Workshop_Tools/Scripting/Built-In_Ability_Names    --
-----------------------------------------------------------------------------------------------------------

-- local bot = GetBot()
-- -- Called every frame. Responsible for managing ability leveling.
-- function AbilityLevelUpThink() 
-- 	--print('in ability think level up', bot:GetUnitName())
-- 	if bot:GetUnitName() == 'npc_dota_hero_nevermore' then
-- 		for i = 0, 23 do
-- 			local ability = bot:GetAbilityInSlot(i)
-- 			--print('ability is', ability)
-- 			if ability == nil and ability:IsTalent() then
-- 				--print('ability name is', ability:GetName())
-- 			end
-- 		end
-- 	end
-- end