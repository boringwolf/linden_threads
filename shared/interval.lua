-----------------------------------------------------------------------------------------------
-- Similar to the threads but slimmed down; to be used as an import rather than running locally
-----------------------------------------------------------------------------------------------
local Intervals = {}
local CreateInterval = function(name, interval, action)
	local self = {}
	self.name = name	self.interval = interval	self.action = action
	Citizen.CreateThread(function()
		while self.name do
			self.action()
			Citizen.Wait(self.interval)
		end
	end)
	return self
end

SetInterval = function(name, interval, action)
	if Intervals[name] and interval then Intervals[name].interval = interval
	else Intervals[name] = CreateInterval(name, interval, action) end
end

ClearInterval = function(name)
	Intervals[name].name = nil
end

--[[ Example usage and what this replaces (using a snippet from esx_joblisting)
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if IsControlJustReleased(0, 38) and isInMarker and not menuIsShowed then
			ESX.UI.Menu.CloseAll()
			ShowJobListingMenu()
		end
	end
end)


SetInterval('menu', 10, function()
  if not menuIsShowed and isInMarker and IsControlJustReleased(0, 38) then
		ESX.UI.Menu.CloseAll()
		ShowJobListingMenu()
		menuIsShowed = true
	elseif menuIsShowed then ClearInterval('menu') end
end)
-- Now we just need to trigger the function from elsewhere; once the menu is opened the function will end ]]
