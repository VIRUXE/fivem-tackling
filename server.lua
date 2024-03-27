lib.callback.register('player:tryTackling', function(source, targetPlayerId)
	-- Check if they can resist first
	if not lib.callback.await('player:resistTackle', targetPlayerId, source) then -- They weren't able to resist
		-- Only allow tackling if still close
		if (#GetEntityCoords(GetPlayerPed(source)) - #GetEntityCoords(GetPlayerPed(targetPlayerId))) <= Config.MaximumDistance then return true end
	end
	
	return false
end)