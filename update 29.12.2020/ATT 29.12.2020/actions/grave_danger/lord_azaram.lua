local config = {
	verificarStorage = 0,
	centerRoom = Position(33424, 31473, 13),
	bossPosition = Position(33424, 31471, 13),
	newPosition = Position(33424, 31481, 13)
}

local function clearForgotten()
	local spectators = Game.getSpectators(config.centerRoom, false, false, 15, 15, 15, 15)
	for i = 1, #spectators do
		local spectator = spectators[i]
		if spectator:isPlayer() then
			spectator:teleportTo(Position(32192, 31819, 8))
			spectator:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			spectator:say('Time out! You were teleported out by strange forces.', TALKTYPE_MONSTER_SAY)
		elseif spectator:isMonster() then
			spectator:remove()
		end
	end
end

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 9825 then
		if player:getPosition() ~= Position(33422, 31493, 13) then
			return true
		end
	end
	if item.itemid == 9825 then
		local verificarStorage = 0
		if player:getStorageValue(Storage.GraveDanger.LordAzaram) > 0 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You recently challenged Lord Azaram. You can challenge him again in 6 hours.")
			return true
		end
		local specs, spec = Game.getSpectators(config.centerRoom, false, false, 15, 15, 15, 15)
		for i = 1, #specs do
			spec = specs[i]
			if spec:isPlayer() then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Someone is fighting against Lord Azaram.")
				return true
			end
		end
		for x = 33422, 33426 do
			local playerTile = Tile(Position(x, 31493, 13)):getTopCreature()
			if playerTile and playerTile:isPlayer() then
				if playerTile:getStorageValue(Storage.GraveDanger.LordAzaram) >= 1 then
					verificarStorage = config.verificarStorage + 1
				end
			end
		end
		
		for x = 33422, 33426 do
			local playerTile = Tile(Position(x, 31493, 13)):getTopCreature()
			if playerTile and playerTile:isPlayer() then
				if verificarStorage >= 1 then
					player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Someone didn't wait 6 hours")				
					return true
				end
			end
		end
		
		for x = 33422, 33426 do
			local playerTile = Tile(Position(x, 31493, 13)):getTopCreature()
			if playerTile and playerTile:isPlayer() then
				if verificarStorage < 1 then
					playerTile:getPosition():sendMagicEffect(CONST_ME_POFF)
					playerTile:teleportTo(config.newPosition)
					playerTile:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
					playerTile:setStorageValue(Storage.GraveDanger.LordAzaram, os.time() + 6 * 3600))
				end
				
			end
		end
		Game.createMonster("lord azaram", config.bossPosition, true, true)
		addEvent(clearForgotten, 20 * 60 * 1000, Position(33408, 31458, 13), Position(33439, 31488, 13), Position(32192, 31819, 8))
		item:transform(9826)	
	elseif item.itemid == 9826 then
		item:transform(9825)
	end
	return true
end