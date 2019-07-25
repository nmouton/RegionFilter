local RF = select(2, ...)

---- Utility Functions ----
function RF:isin(input_table, val)
	for index, value in pairs(input_table) do
		if value == val then
			return true
		end
	end
	return false
end

function RF:sanitiseName(leaderName)
	-- returns name, realm when passed a name-realm full name
	if string.match(leaderName, "-") then
		local t_name, t_realm = strsplit("-", leaderName, 2)
		local t_realm = string.gsub(t_realm, "'", "")
		return t_name, t_realm
	else
		
		local t_name = leaderName
		local t_realm = RF.myRealm
		return t_name, t_realm
	end
end

function RF:splitName(leaderName)
	-- returns name, realm when passed a name-realm full name
	local t_name, t_realm = strsplit("-", leaderName, 2)
	local t_realm = string.gsub(t_realm, "'", "")
	return t_name, t_realm
end

function RF:colourNotNA(id, activityName)
	results.ActivityName:SetText ("|cFFFFFF00["..id.."]|r " .. activityName)
	results.ActivityName:SetTextColor (0, 1, 0)
end