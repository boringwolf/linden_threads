local Disable = {}
Citizen.CreateThread(function()
	while true do
		if next(Disable) then
			for k,v in pairs(Disable) do
				DisableControlAction(0, v, true)
			end
		else Citizen.Wait(95) end
		Citizen.Wait(5)
	end
end)

-- Setup different sets of keys to disable depending on active variables
-- Either trigger ESX.SetPlayerData('key', state) or add an event to set keys to disable like below
local Keys = {
	handsup = {23, 24, 25, 37, 45, 166, 167, 168, 170, 257, 263, 288, 289},
}

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


local Threads = {}

-- Create a thread that triggers an event when state changes to true/fale
local BoolThread = function(name, interval, action, args)
	local state, current = false
	local args = table.unpack(args)
	Citizen.CreateThread(function()
		while ESX.PlayerLoaded and Threads[name] do
			Citizen.Wait(interval)
			if args == 'playerped' then args = ESX.PlayerData.ped end
			local result = action(args)
			if state and (not result or result == 0) then
				state = false
				TriggerEvent(name..'Thread', state)
			elseif not state and result > 0 then
				state, current = true, result
				TriggerEvent(name..'Thread', state, result)
			end
		end
		TriggerEvent(name..'Thread', false)
	end)
end

-- Create a thread that triggers an event when the result changes
local UpdateThread = function(name, interval, action, args)
	local current
	local args = table.unpack(args)
	Citizen.CreateThread(function()
		while ESX.PlayerLoaded and Threads[name] do
			Citizen.Wait(interval)
			if args == 'playerped' then args = ESX.PlayerData.ped end
			local result = action(args)
			if result ~= current then
				current = result
				TriggerEvent(name..'Thread', result)
			end
		end
		TriggerEvent(name..'Thread', false)
	end)
end

-- Create a thread that triggers an event at a set interval
local Thread = function(name, interval, action, args)
	local args = table.unpack(args)
	Citizen.CreateThread(function()
		while ESX.PlayerLoaded and Threads[name] do
			Citizen.Wait(interval)
			if args == 'playerped' then args = ESX.PlayerData.ped end
			local result = action(args)
			TriggerEvent(name..'Thread', result)
		end
		TriggerEvent(name..'Thread', false)
	end)
end


local ToggleThread = function(name, type, interval, action, args)
	if Threads[name] then Threads[name] = nil
	elseif interval then Threads[name] = true
		if type == 'bool' then
			BoolThread(name, interval, action, args)
		elseif type == 'update' then
			UpdateThread(name, interval, action, args)
		else
			Thread(name, interval, action, args)
		end
	end
end

ToggleThread('Vehicle', 'bool', 500, GetVehiclePedIsUsing, {'playerped'})
ToggleThread('Armour', 'update', 1000, GetPedArmour, {'playerped'})
ToggleThread('Coords', '', 100, GetEntityCoords, {'playerped'})





-- Example usage for toggling a thread
local on = true
RegisterCommand('printcoords', function()
	if on then
		ToggleThread('Coords')
	else
		ToggleThread('Coords', '', 100, GetEntityCoords, {'playerped'})
	end
	on = not on
end)


-- Example events

-- Bool
AddEventHandler('VehicleThread', function(state, result)
	inVehicle = state
	if not inVehicle then
		print('Not driving a vehicle')
	else
		while inVehicle do
			local speed = math.floor(GetEntitySpeed(result) * 3.6)
			print('Driving '..speed..' km/h')
			Citizen.Wait(100)
		end
	end
end)

-- Update
AddEventHandler('ArmourThread', function(result)
	if result then
		print('Armour is currently '..result)
	end
end)

-- Default
AddEventHandler('CoordsThread', function(result)
	print(result)
end)