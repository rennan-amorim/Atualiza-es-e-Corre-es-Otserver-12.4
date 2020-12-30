local config = {
	verificarStorage = 0,
	centerRoom = Position(33919, 31645, 8),
	bossPosition = Position(33919, 31648, 8),
	newPosition = Position(33919, 31657, 8)
}

local function clearTenebris()
	local spectators = Game.getSpectators(config.centerRoom, false, false, 15, 15, 15, 15)
	for i = 1, #spectators do
		local spectator = spectators[i]
		if spectator:isPlayer() then
			spectator:teleportTo(Position(33920, 31629, 8))
			spectator:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			spectator:say('Time out! You were teleported out by strange forces.', TALKTYPE_MONSTER_SAY)
		elseif spectator:isMonster() then
			spectator:remove()
		end
	end
end

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 9825 then
		if player:getPosition() ~= Position(33918, 31626, 8) then
			return true
		end
	end
	if item.itemid == 9825 then
		local verificarStorage = 0
		if player:getStorageValue(Storage.Kilmaresh.Lululever) > 0 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You recently challenged Urmahlullu the Weakened. You can challenge him again in 6 hours.")
			return true
		end
		local specs, spec = Game.getSpectators(config.centerRoom, false, false, 15, 15, 15, 15)
		for i = 1, #specs do
			spec = specs[i]
			if spec:isPlayer() then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Someone is fighting with Urmahlullu the Weakened.")
				return true
			end
		end
		for x = 33918, 33922 do
			local playerTile = Tile(Position(x, 31626, 8)):getTopCreature()
			if playerTile and playerTile:isPlayer() then
				if playerTile:getStorageValue(Storage.Kilmaresh.Lululever) >= 1 then
					verificarStorage = config.verificarStorage + 1
				end
			end
		end
		
		for x = 33918, 33922 do
			local playerTile = Tile(Position(x, 31626, 8)):getTopCreature()
			if playerTile and playerTile:isPlayer() then
				if verificarStorage >= 1 then
					player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Someone didn't wait 6 hours")				
					return true
				end
			end
		end
		
		for x = 33918, 33922 do
			local playerTile = Tile(Position(x, 31626, 8)):getTopCreature()
			if playerTile and playerTile:isPlayer() then
				if verificarStorage < 1 then
					playerTile:getPosition():sendMagicEffect(CONST_ME_POFF)
					playerTile:teleportTo(config.newPosition)
					playerTile:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
					playerTile:setStorageValue(Storage.Kilmaresh.Lululever, os.time() + 6 * 3600))
				end
				
			end
		end
		Game.createMonster("urmahlullu the weakened", config.bossPosition, true, true)
		addEvent(clearTenebris, 20 * 60 * 1000, Position(33894, 31635, 8), Position(33939, 31649, 8), Position(33920, 31629, 8))
		item:transform(9826)
	elseif item.itemid == 9826 then
		item:transform(9825)
	end
	return true
end