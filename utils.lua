local RF = select(2, ...)

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