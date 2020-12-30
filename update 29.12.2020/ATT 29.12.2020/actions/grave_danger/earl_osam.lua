local config = {
	verificarStorage = 0,
	centerRoom = Position(33488, 31438, 13),
	bossPosition = Position(33488, 31437, 13),
	newPosition = Position(33488, 31446, 13)
}

local function clearForgotten()
	local spectators = Game.getSpectators(config.centerRoom, false, false, 15, 15, 15, 15)
	for i = 1, #spectators do
		local spectator = spectators[i]
		if spectator:isPlayer() then
			spectator:teleportTo(Position(33261, 31986, 8))
			spectator:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			spectator:say('Time out! You were teleported out by strange forces.', TALKTYPE_MONSTER_SAY)
		elseif spectator:isMonster() then
			spectator:remove()
		end
	end
end

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 9825 then
		if player:getPosition() ~= Position(33516, 31444, 13) then
			return true
		end
	end
	if item.itemid == 9825 then
		local verificarStorage = 0
		if player:getStorageValue(Storage.GraveDanger.EarlOsam) > 0 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You recently challenged Earl Osam. You can challenge him again in 6 hours.")
			return true
		end
		local specs, spec = Game.getSpectators(config.centerRoom, false, false, 15, 15, 15, 15)
		for i = 1, #specs do
			spec = specs[i]
			if spec:isPlayer() then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Someone is fighting against Earl Osam.")
				return true
			end
		end
		for x = 33516, 33520 do
			local playerTile = Tile(Position(x, 31444, 13)):getTopCreature()
			if playerTile and playerTile:isPlayer() then
				if playerTile:getStorageValue(Storage.GraveDanger.EarlOsam) >= 1 then
					verificarStorage = config.verificarStorage + 1
				end
			end
		end
		
		for x = 33516, 33520 do
			local playerTile = Tile(Position(x, 31444, 13)):getTopCreature()
			if playerTile and playerTile:isPlayer() then
				if verificarStorage >= 1 then
					player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Someone didn't wait 6 hours")				
					return true
				end
			end
		end
		
		for x = 33516, 33520 do
			local playerTile = Tile(Position(x, 31444, 13)):getTopCreature()
			if playerTile and playerTile:isPlayer() then
				if verificarStorage < 1 then
					playerTile:getPosition():sendMagicEffect(CONST_ME_POFF)
					playerTile:teleportTo(config.newPosition)
					playerTile:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
					playerTile:setExhaustion(Storage.GraveDanger.EarlOsam, os.time() + 6 * 3600))
				end
				
			end
		end
		Game.createMonster("earl osam", config.bossPosition, true, true)
		addEvent(clearForgotten, 20 * 60 * 1000, Position(33476, 31425, 13), Position(33503, 31450, 13), Position(33261, 31986, 8))
		item:transform(9826)
	elseif item.itemid == 9826 then
		item:transform(9825)
	end
	return true
end