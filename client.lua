local GettingTackled = false

local TACKLE_ANIM_DICT <const> = 'missmic2ig_11'

CreateThread(function()
	local Tackling = false

	while true do
		if IsControlPressed(1, 21) then -- SHIFT
			if IsControlPressed(1, 38) and not Tackling then -- E
				local closestTargetId, closestTargetPed, distance = lib.getClosestPlayer(GetEntityCoords(cache.ped), Config.MaximumDistance, false)
				if closestTargetId and not IsPedInAnyVehicle(closestTargetPed) then
					Tackling = true

					-- Only apply an animation if we can tackle (meaning they weren't able to resist)
					if lib.callback.await('player:tryTackling', Config.AfterTackledDelay, GetPlayerServerId(closestTargetId)) then
						lib.requestAnimDict(TACKLE_ANIM_DICT)
						TaskPlayAnim(cache.ped, TACKLE_ANIM_DICT, 'mic_2_ig_11_intro_goon', 8.0, -8.0, 3000, 0, 0, false, false, false)
						Wait(6000)
					end
				end

				Tackling = false
			end
		end
		Wait(250)
	end
end)

lib.callback.register('player:resistTackle', function(tacklerId)
	if not tacklerId then return false end

	if GettingTackled then return false end

	local canResist = lib.skillCheck({'easy', 'easy', {areaSize = 60, speedMultiplier = 2}, 'hard'}, Config.ResistKeys)

	if not canResist then
		CreateThread(function()
			GettingTackled = true

			lib.requestAnimDict(TACKLE_ANIM_DICT)

			AttachEntityToEntity(cache.ped, GetPlayerPed(GetPlayerFromServerId(tacklerId)), 11816, 0.25, 0.5, 0.0, 0.5, 0.5, 180.0, false, false, false, false, 2, false)
			TaskPlayAnim(cache.ped, TACKLE_ANIM_DICT, 'mic_2_ig_11_intro_p_one', 8.0, -8.0, 3000, 0, 0, false, false, false)

			Wait(3000)
			DetachEntity(cache.ped, true, false)

			SetPedToRagdoll(cache.ped, 1000, 1000, 0, false, false, false)
			Wait(4000)
			GettingTackled = false
		end)
	end

	return canResist
end)