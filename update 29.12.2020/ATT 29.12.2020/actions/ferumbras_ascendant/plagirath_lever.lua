local config = {
	verificarStorage = 0,
	centerRoom = Position(33172, 31501, 13),
	BossPosition = Position(33172, 31501, 13),
	playerPositions = {
		Position(33229, 31500, 13),
		Position(33229, 31501, 13),
		Position(33229, 31502, 13),
		Position(33229, 31503, 13),
		Position(33229, 31504, 13)
	},
	newPosition = Position(33173, 31504, 13)
}

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 9825 then
		local verificarStorage = 0
		if player:getPosition() ~= Position(33229, 31500, 13) then
			item:transform(9826)
			return true
		end
	end
	if item.itemid == 9825 then
		local specs, spec = Game.getSpectators(config.centerRoom, false, false, 15, 15, 15, 15)
		for i = 1, #specs do
			spec = specs[i]
			if spec:isPlayer() then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Someone is fighting with Plagirath.")
				return true
			end
		end
		for y = 31500, 31504 do
			local playerTile = Tile(Position(x, y, 13)):getTopCreature()
			if playerTile and playerTile:isPlayer() then
				if playerTile:getStorageValue(Storage.FerumbrasAscension.PlagirathTimer) >= 1 then
					verificarStorage = config.verificarStorage + 1
				end
			end
		end
		
		for y = 31500, 31504 do
			local playerTile = Tile(Position(x, y, 13)):getTopCreature()
			if playerTile and playerTile:isPlayer() then
				if verificarStorage >= 1 then
					player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Someone didn't wait 6 hours")				
					return true
				end
			end
		end
		
		for y = 31500, 31504 do
			local playerTile = Tile(Position(x, y, 13)):getTopCreature()
			if playerTile and playerTile:isPlayer() then
				if verificarStorage < 1 then
					playerTile:getPosition():sendMagicEffect(CONST_ME_POFF)
					playerTile:teleportTo(config.newPosition)
					playerTile:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
					playerTile:setStorageValue(Storage.FerumbrasAscension.PlagirathTimer, os.time() + 6 * 3600))
				end
				
			end
		end
		Game.createMonster("Plagirath", config.BossPosition, true, true)
		addEvent(clearForgotten, 30 * 60 * 1000, Position(33159, 31491, 13), Position(33185, 31513, 13), Position(33319, 32318, 13))
		item:transform(9826)
	elseif item.itemid == 9826 then
		item:transform(9825)
	end
	return true
end
