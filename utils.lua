local RF = select(2, ...)

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

function RF:sanitiseRealm(inputString)
	-- remove spaces and quotations from names of servers
	local t_string = string.gsub(inputString, "%s+", "")
	local t_string = string.gsub(t_string, "'", "")
	return t_string

function RF:splitName(leaderName)
	-- returns name, realm when passed a name-realm full name
	local t_name, t_realm = strsplit("-", leaderName, 2)
	local t_realm = string.gsub(t_realm, "'", "")
	return t_name, t_realm
end