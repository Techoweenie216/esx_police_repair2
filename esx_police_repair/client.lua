ESX              = nil
local PlayerData = {}
local HasAlreadyGotMessage = false
local isInMarker = false


Locations = {
	vector3(473.36, -1023.25, 28.13),	 --MissionRow behind station
	vector3(1870.43, 3704.32, 33.22),	 --SandyShores Sheriff next to station under trees
	vector3(-454.91, 5984.63, 31.31),	 --Paleto Bay behind station in corner of the heli pad
	vector3(529.98, -28.98, 70.63),	 	 --VinewoodPD - in the left garage
	vector3(832.34, -1405.19, 26.16),	 --PD on Popular behind back building by red tank
	vector3(374.74, -1610.86, 29.29),	 --Davis Sheriff Station parking lot, no parking zone
	vector3(-1113.37, -833.89, 13.34),	 --Vespucci PD in the top level garage
	vector3(-1637.77, -1013.63, 12.73),	 --Del Perro PD under the del perro sign
	vector3(-1473.99, -1013.96, 6.32),	 --Life Guard Station by the sign
	vector3(-1330.7, -1519.96, 3.99),	 --Park Office on the Beach on the right side of the main window
	vector3(-1177.05, -1774.93, 3.85),	 --The Main Life Guard Station on the end of the beach
	vector3(364.32, 792.82, 187.49),	 --Ranger Station next to outhouse
}



Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer   
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)





Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local ped = GetPlayerPed(-1)
		local coords = GetEntityCoords(ped)

		for k,v in ipairs(Locations) do
			
			-- get player location
			local distance = #(coords.xy - v.xy)
			if distance < 8.0  then
				DrawMarker(36, v.x, v.y, v.z , 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 2.0, 2.0, 0, 255, 255, 50, false, false, 2, true, nil, nil, false)
				
				-- if you are closer than 2, you are considered in the marker	

				if distance < 2.0 then
					isInMarker = true
				elseif distance > 3.0 then
					HasAlreadyGotMessage = false
					isInMarker = false
				end
			end
			
				
			if isInMarker and not HasAlreadyGotMessage then
				yourJob = ESX.PlayerData.job.name
				
				-- check to see if your job is police, sheriff or highway patrol
				if yourJob == "police" or yourJob == "sheriff" or yourJob == "highway" then

					-- check to make sure player is in a vehicle
					if not IsPedInAnyVehicle(ped) then	
						TriggerEvent('chat:addMessage', 'You are not in a vehicle.')
						HasAlreadyGotMessage = true
						Citizen.Wait(5000)
					else
						local vehicle = GetVehiclePedIsIn(ped, false)
						-- Fix Engine Damage
						SetVehicleEngineHealth(vehicle, 1000.0) 
						TriggerEvent('chat:addMessage', 'We repaired the engine damage.')
						Citizen.Wait(500)			

						-- Repair vehicle body damage
						SetVehicleFixed(vehicle)
						SetVehicleDeformationFixed(vehicle)
						TriggerEvent('chat:addMessage', 'We fixed all the dents.')
						Citizen.Wait(500)

						-- Top off with a tank of gas
						SetVehicleFuelLevel(vehicle, 100.0)
						TriggerEvent('chat:addMessage', 'Your vehicle has been refueled.')
						Citizen.Wait(500)

						-- Make sure those tires are in tip-top shape
						SetVehicleWheelHealth(vehicle, 1.0, 100.00)
						SetVehicleWheelHealth(vehicle, 2.0, 100.00)
						SetVehicleWheelHealth(vehicle, 3.0, 100.00)
						SetVehicleWheelHealth(vehicle, 4.0, 100.00)
						TriggerEvent('chat:addMessage', 'Checking those tires, you are good to go.')
						Citizen.Wait(500)	
					
						-- Wash the vehicle
						SetVehicleDirtLevel(vehicle, 0.1)
						TriggerEvent('chat:addMessage', 'Your vehicle has been washed. Try to keep it clean.')
						HasAlreadyGotMessage = true
						Citizen.Wait(5000)
					end
				else
					TriggerEvent('chat:addMessage', 'You have no business here.')
					HasAlreadyGotMessage = true
					Citizen.Wait(500)
				end
			end
		end	
	end

end)
