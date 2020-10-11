local RF = select(2, ...)

RF.consolePrefix = "|cff00ffff[Region Filter]:|r "

function RF:regionTag(playerRegion, listRegion, label, activity, playerDC, listDC)
	-- Creates and colours the REGION tag
	local colour = '|cFFA9A9A9['

	if playerDC ~= nil and listDC ~= nil then -- if we're talking murican
		if playerRegion == listRegion and playerDC == listDC then
			colour = '|cFFFF69B4['
		elseif playerRegion == listRegion and playerDC ~= listDC then
			colour = '|cFFFF0000['
		end	
	else
		if playerRegion == listRegion then 
			colour = '|cFFFF69B4['
		end
	end
	return colour..label..']|r '..activity
end

function RF:dungeonText(playerRegion, listRegion)
	-- Colours the activity name if its in an ideal region
	if playerRegion == listRegion then
		return 0, 1, 1
	else
		return 0.75, 0.75, 0.75
	end
end

function RF:sanitiseName(leaderName)
	-- returns name, realm when passed a name-realm full name
	if string.match(leaderName, "-") then
		local name, realm = strsplit("-", leaderName, 2)
		local realm = realm:gsub("'", "")
		return name, realm
	else
		
		local name = leaderName
		local realm = RF.myRealm
		return name, realm
	end
end

function RF:splitName(leaderName)
	-- returns name, realm when passed a name-realm full name
	local name, realm = strsplit("-", leaderName, 2)
	local realm = realm:gsub("'", "")
	return name, realm
end