-------------------------------------------------------------------------------------------------------
-- Handle all DisableControlActions here; setup different triggers to add or remove keys from the table
-------------------------------------------------------------------------------------------------------
local Disable = {}
Citizen.CreateThread(function()
	while true do
		HideHudComponentThisFrame(14)
		HideHudComponentThisFrame(19)
		HideHudComponentThisFrame(20)
		if next(Disable) then
			for k,v in pairs(Disable) do
				DisableControlAction(0, v, true)
			end
		else Citizen.Wait(95) end
		Citizen.Wait(5)
	end
end)

-- Either trigger ESX.SetPlayerData('key', state) or add an event to set keys to disable like below
local Keys = {
	always = {199}
	handsup = {23, 24, 25, 45, 166, 167, 168, 170, 257, 263, 288},
}
for k,v in pairs(Keys['always']) do
	Disable[k] = v
end

OnPlayerData = function(key, val)
	if key == 'handsup' then
		if val then
			for k,v in pairs(Keys[key]) do
				Disable[key..k] = v
			end
		else
			for k,v in pairs(Keys[key]) do
				Disable[key..k] = nil
			end
		end
	end
end

--------------------------------------------------------------------------------------------------
-- Create threads to handle tasks and when the result changes trigger an event for other resources
--------------------------------------------------------------------------------------------------
local Threads = {}

-- When the thread result changes, call this function to gather more information before sending the TriggerEvent
local ThreadEvent = function(name, result)
	Citizen.CreateThread(function()
		local data = {}
		if name == 'vehicle' then
			data.vehicle = result
			data.class = GetVehicleClass(result)
			local seat = GetPedInVehicleSeat(result, -1)
			if seat == ESX.PlayerData.ped then data.driver = true else data.driver = false end
		end
		TriggerEvent('thread:'..name, data)
	end)
end

-- Define a thread class, allowing for the creation of multiple objects using the same structure
local CreateThread = function(name, interval, action)
	local self = {}
	self.name = name	self.interval = interval	self.action = action	self.current = false
	Citizen.CreateThread(function()
		while self.name do
			local result = self.action()
			if result == 0 or nil then result = false end
			if result ~= self.current then
				self.current = result
				if not result then
					TriggerEvent('thread:'..self.name, false)
					self.interval = self.interval
				else
					ThreadEvent(self.name, result)
					self.interval = self.interval
				end
			end
			Citizen.Wait(self.interval)
		end
		TriggerEvent('thread:'..self.name, false)
		Threads[name] = nil
	end)
	return self
end

-- Allow for creation and deletion of a thread object
local ToggleThread = function(name, interval, action)
	if Threads[name] then
		if interval then Threads[name].interval = interval else Threads[name].name = nil end
	else
		Threads[name] = CreateThread(name, interval, action)
	end
end

-- Create a thread to check if the player is inside a vehicle
ToggleThread('vehicle', 600, function()
	return GetVehiclePedIsIn(ESX.PlayerData.ped, false)
end)

-- Put this in any resource
AddEventHandler('thread:vehicle', function(data)
	if data and vehicle ~= data.vehicle then
		vehicle = data.vehicle
		vehicleClass = data.class
		if vehicleClass ~= 21 and vehicleClass ~= 13 then
			if data.driver and vehicleClass ~= 15 and vehicleClass ~= 16 then
				driving = true
			end
		end
	else
		vehicle, vehicleClass = nil, nil
	end
end)
