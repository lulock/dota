-----------------------------------------------------------------------------------------------------------
-- this script handles control item purchasing by Viper bot                                              --
--  . ItemPurchaseThink() - Called every frame. Responsible for purchasing items.                        --
--    . currently starts with 3x Iron Branch, Healing Salve, 2x Slippers of Agility                      --
-- NOTE Some items have strange names. This Reddit post helped immensely:                                --
--  . https://www.reddit.com/r/DotA2/comments/ply3xx/psa_some_items_and_heroes_have_strange_names_for/   --
-----------------------------------------------------------------------------------------------------------

local bot = GetBot()
local nextUpdate = 0

local abilities = { 
	[0] = 0, 
	[1] = 1,
	[2] = 2, 
	[3] = 3
}

-- starting items
local toBuy = {
	[1] = "item_branches", -- (50 gold, +1 str, +1 agi, +1 int)
	[2] = "item_circlet",
	[3] = "item_circlet",
	[4] = "item_faerie_fire", 
	[5] = "item_slippers" 
}

function ItemPurchaseThink()

	-- if GetGameState() == GAME_STATE_PRE_GAME then
	-- 	for i=1,#startingItems do
	-- 		toBuy[#toBuy+1] = startingItems[i]
	-- 	end
	-- end

	if #toBuy > 0 then
		for idx,item in pairs(toBuy) do
			bot:ActionImmediate_PurchaseItem( item )
			table.remove(toBuy, idx)
		end
	end
	
	-- return if no ability points available to upgrade
	if bot:GetAbilityPoints() <= 0 then
		return
	end
	
	-- otherwise, update next ability
	local ability = nil
	local botLevel = bot:GetLevel()
	-- if level 6, then upgrade ult
	if botLevel == 6 or botLevel == 11 or botLevel == 13 then
		ability = bot:GetAbilityInSlot( abilities[#abilities] )
	else
		ability = bot:GetAbilityInSlot( abilities[nextUpdate] )
	end
	
	
	if ability ~= nil then
		bot:ActionImmediate_LevelAbility (ability:GetName())
		print('ability leveled up is', ability:GetName())
		nextUpdate = (nextUpdate + 1) % 3
		print('nextUpdate is', nextUpdate)
	end

end