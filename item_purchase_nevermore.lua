-----------------------------------------------------------------------------------------------------------
-- this script handles control item purchasing by Shadow Fiend bot                                       --
--  . ItemPurchaseThink() - Called every frame. Responsible for purchasing items.                        --
--    . currently starts with 3x Iron Branch, Healing Salve, 2x Slippers of Agility                      --
-- NOTE Some items have strange names. This Reddit post helped immensely:                                --
--  . https://www.reddit.com/r/DotA2/comments/ply3xx/psa_some_items_and_heroes_have_strange_names_for/   --
-----------------------------------------------------------------------------------------------------------

local bot = GetBot();

-- local startingItems = {
-- 	[1] = "item_branches",
-- 	[2] = "item_slippers",
-- 	[3] = "item_flask"
-- }

-- starting items
local toBuy = {
	[1] = "item_branches", -- (50 gold, +1 str, +1 agi, +1 int)
	[2] = "item_circlet",
	[3] = "item_circlet",
	[4] = "item_faerie_fire", 
	[5] = "item_faerie_fire", 
	[6] = "item_faerie_fire",
	[7] = "item_slippers"
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
			print( 'remaining gold is ' , bot:GetGold() )
			table.remove(toBuy, idx)
		end
	end

	for i = 0, 23 do
		local ability = bot:GetAbilityInSlot(i)
		print('ability is', ability)
		if ability == nil and ability:IsTalent() then
			print('ability name is', ability:GetName())
		end
	end

end