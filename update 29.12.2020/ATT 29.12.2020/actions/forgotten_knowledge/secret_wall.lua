function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.actionid == 24877 then
		player:teleportTo(Position(32891, 31620, 10))
		return true
	end
--	if not player:getItemById(26406, true) then
--		return false
--	end
	if player:getStorageValue(Storage.ForgottenKnowledge.Lanterna) > 0 then
	player:teleportTo(Position(32924, 31637, 14))
	return true
end
