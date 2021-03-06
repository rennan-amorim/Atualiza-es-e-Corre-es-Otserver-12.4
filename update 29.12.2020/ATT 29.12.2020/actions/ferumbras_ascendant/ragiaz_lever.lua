local config = {
	verificarStorage = 0,
	centerRoom = Position(33481, 32334, 13),
	BossPosition = Position(33481, 32334, 13),
	newPosition = Position(33482, 32339, 13),
	deathDragons = {
		Position(33476, 32331, 13),
		Position(33476, 32340, 13),
		Position(33487, 32340, 13),
		Position(33488, 32331, 13)
	}
}

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 9825 then
		local verificarStorage = 0
		if player:getPosition() ~= Position(33456, 32356, 13) then
			item:transform(9826)
			return true
		end
	end
	if item.itemid == 9825 then
		local specs, spec = Game.getSpectators(config.centerRoom, false, false, 15, 15, 15, 15)
		for i = 1, #specs do
			spec = specs[i]
			if spec:isPlayer() then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Someone is fighting with Ragiaz.")
				return true
			end
		end
		for x = 33456, 33460 do
			local playerTile = Tile(Position(x, 32356, 13)):getTopCreature()
			if playerTile and playerTile:isPlayer() then
				if playerTile:getStorageValue(Storage.FerumbrasAscension.RagiazTimer) >= 1 then
					verificarStorage = config.verificarStorage + 1
				end
			end
		end
		
		for x = 33456, 33460 do
			local playerTile = Tile(Position(x, 32356, 13)):getTopCreature()
			if playerTile and playerTile:isPlayer() then
				if verificarStorage >= 1 then
					player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Someone didn't wait 6 hours")				
					return true
				end
			end
		end
		
		for x = 33456, 33460 do
			local playerTile = Tile(Position(x, 32356, 13)):getTopCreature()
			if playerTile and playerTile:isPlayer() then
				if verificarStorage < 1 then
					playerTile:getPosition():sendMagicEffect(CONST_ME_POFF)
					playerTile:teleportTo(config.newPosition)
					playerTile:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
					playerTile:setStorageValue(Storage.FerumbrasAscension.RagiazTimer, os.time() + 6 * 3600))
				end
				
			end
		end
		Game.createMonster("Ragiaz", config.BossPosition, true, true)
		for d = 1, #config.deathDragons do
			Game.createMonster('Death Dragon', config.deathDragons[d], true, true)
		end
		addEvent(clearForgotten, 30 * 60 * 1000, Position(33472, 32323, 13), Position(33493, 32347, 13), Position(33319, 32318, 13))
		item:transform(9826)
	elseif item.itemid == 9826 then
		item:transform(9825)
	end
	return true
end
