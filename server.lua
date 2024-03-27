lib.callback.register('player:tryTackling', function(source, targetPlayerId)
	local ableToTackle    = lib.callback.await('player:resistTackle', targetPlayerId, source)
	local arePlayersClose = (#GetEntityCoords(GetPlayerPed(source)) - #GetEntityCoords(GetPlayerPed(targetPlayerId))) <= Config.MaximumDistance

	-- Only allow to tackle if actually able to tackle and distance is still within spec
	if ableToTackle and arePlayersClose then return true end
	
	return false
end)