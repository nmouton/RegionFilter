local RF = select(2, ...)
local servers = RF.servers
local posts = RF.posts
local cat = RF.cat

-- By default filter outside data centers to yes --
RF.togRemove = 1

SLASH_RFILTER1 = "/rfilter"
SlashCmdList["RFILTER"] = function(msg)
	if RF.togRemove == 1 then
		RF.togRemove = 0
		print('|cff00ffff[Region Filter]|: Not filtering outside regions')
	elseif RF.togRemove == 0 then
		RF.togRemove = 1
		print('|cff00ffff[Region Filter]|: Filtering outside regions')
	end
	RF.UpdateList()
end

local realm_unsubbed = GetRealmName()
RF.myRealm = string.gsub(realm_unsubbed, "'", "")

---- Set variables for realm/data-centre info ----
RF:setRegionRealmLabel(RF.myRealm)

---- Utility Functions ----
function isin(input_table, val)
	for index, value in pairs(input_table) do
		if value == val then
			return true
		end
	end
	return false
end

function sanitiseName(leaderName)
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

function splitName(leaderName)
	-- returns name, realm when passed a name-realm full name
	local t_name, t_realm = strsplit("-", leaderName, 2)
	local t_realm = string.gsub(t_realm, "'", "")
	return t_name, t_realm
end

---- Labelling and Removing Functions
function RF.removeEntriesNA(results)
	if RF.togRemove == 1 then
		for idx = #results, 1, -1 do
			local resultID = results[idx]
			local searchResults = C_LFGList.GetSearchResultInfo(resultID)
			local activitiyID1 = searchResults.activityID
			local leaderName = searchResults.leaderName
			if leaderName ~= nil then
				local name, realm = sanitiseName(leaderName)
				if isin(servers.na_nyc, realm)
				or isin(servers.na_la, realm)
				or isin(servers.na_chicago, realm)
				or isin(servers.na_phoenix, realm) then
					-- do nothing
				else
					table.remove(results, idx)
				-- TODO account for entries where there is no realm (home server)
				end	
			end
		end
	elseif RF.togRemove == 0 then
	end

end

function RF.updateEntriesNA(results)
	local searchResults = C_LFGList.GetSearchResultInfo(results.resultID)
	local activityID = searchResults.activityID
	local leaderName = searchResults.leaderName

	if leaderName ~= nil then -- Filter out nil entries from LFG Pane
		if string.match(leaderName, "-") then -- If the string has a hyphen in it split it up
			local name, realm = splitName(leaderName)

			if RF.realms == 'na_realms' then
				-- Looping through the server lists to determine the naming
				if isin(servers.na_la, realm) then
					local activityName = C_LFGList.GetActivityInfo(activityID)
					if RF.server_id == 'la' then
						results.ActivityName:SetText ("|cFF00CCFF["..cat.na_la_id.."]|r " .. activityName)
					else
						results.ActivityName:SetText ("|cFFFFFF00["..cat.na_la_id.."]|r " .. activityName)
					end
					results.ActivityName:SetTextColor (0, 1, 0)
				end

				if isin(servers.na_nyc, realm) then
					local activityName = C_LFGList.GetActivityInfo(activityID)
					if RF.server_id == 'nyc' then
						results.ActivityName:SetText ("|cFF00CCFF["..cat.na_nyc_id.."]|r " .. activityName)
					else
						results.ActivityName:SetText ("|cFFFFFF00["..cat.na_nyc_id.."]|r " .. activityName)
					end
					results.ActivityName:SetTextColor (0, 1, 0)
				end

				if isin(servers.na_chicago, realm) then
					local activityName = C_LFGList.GetActivityInfo (activityID)
					if RF.server_id == 'chicago' then
						results.ActivityName:SetText ("|cFF00CCFF["..cat.na_chicago_id.."]|r " .. activityName)
					else
						results.ActivityName:SetText ("|cFFFFFF00["..cat.na_chicago_id.."]|r " .. activityName)
					end
					results.ActivityName:SetTextColor (0, 1, 0)
				end

				if isin(servers.na_phoenix, realm) then
					local activityName = C_LFGList.GetActivityInfo (activityID)
					if RF.server_id == 'phoenix' then
						results.ActivityName:SetText ("|cFF00CCFF["..cat.na_phoenix_id.."]|r " .. activityName)
					else
						results.ActivityName:SetText ("|cFFFFFF00["..cat.na_phoenix_id.."]|r " .. activityName)
					end
					results.ActivityName:SetTextColor (0, 1, 0)
				end

			elseif RF.realms ~= 'na_realms' then
				for _, v in pairs(realms) do
					if v == server_subbed then
						local activityName = C_LFGList.GetActivityInfo (activityID)
						results.ActivityName:SetText ("|cFFFFFF00["..RF.label.."]|r " .. activityName)
						results.ActivityName:SetTextColor (0, 1, 0)
					end
				end
			end
		else -- home server
			local activityName = C_LFGList.GetActivityInfo (activityID)
			results.ActivityName:SetText ("|cFF00CCFF["..cat.home.."]|r " .. activityName)
			results.ActivityName:SetTextColor (0, 1, 0)
		end
	end
end

---- Print When Loaded ----
local welcomePrompt = CreateFrame("Frame")
welcomePrompt:RegisterEvent("PLAYER_LOGIN")
welcomePrompt:SetScript("OnEvent", function(f, event)
	if event == "PLAYER_LOGIN" then
		print("|cff00ffff[Region Filter]|r |cffffcc00Version 1.3|r. If there any bugs please report them via https://wow.curseforge.com/projects/regionfilter or https://github.com/jamesb93/RegionFilter")
	end
end)

---- Crucical code to detect when the LFG pane is opened ----
local LFGOpened = CreateFrame ("frame", nil, UIParent)
LFGOpened:RegisterEvent ("LFG_LIST_SEARCH_RESULTS_RECEIVED")

function RF.UpdateList()
	LFGListSearchPanel_UpdateResultList (LFGListFrame.SearchPanel)
	LFGListSearchPanel_UpdateResults (LFGListFrame.SearchPanel)
	-- Call the two functions which filter and label LFG entries --
	hooksecurefunc ("LFGListUtil_SortSearchResults", RF.removeEntriesNA)
	hooksecurefunc ("LFGListSearchEntry_Update", RF.updateEntriesNA)
end

LFGOpened:SetScript ("OnEvent", function (self, event, ...)
	-- When the LFG panel is opened called the above function --
	RF.UpdateList()
end)
-------- Legacy Code --------

-- function RegionFilter:FilterEU(realms, label)
-- 	hooksecurefunc ("LFGListSearchEntry_Update", function (self) 
-- 		local table = C_LFGList.GetSearchResultInfo(self.resultID)
-- 		local activityID1 = table.activityID
-- 		local leaderName = table.leaderName
		
-- 		if leaderName ~= nil then --> Filter out nil entries from LFG Pane
-- 			if string.match(leaderName, "-") then --> If the string has a hyphen in it split it up (this separates home server from non home server)
-- 				local name, server = strsplit("-", leaderName, 2) --> Split string with a maximum of two splits according to the "-"" delimiter
-- 				server_subbed = string.gsub(server, "'", "" ) --> Remove the internal quotes from server names

-- 				for _, v in pairs(realms) do
-- 					if v == server_subbed then
-- 						local activityName = C_LFGList.GetActivityInfo (activityID1)
-- 						self.ActivityName:SetText ("|cFFFFFF00["..label.."]|r " .. activityName)
-- 						self.ActivityName:SetTextColor (0, 1, 0)
-- 					end
-- 				end
-- 			end

-- 		else
-- 			local activityName = C_LFGList.GetActivityInfo (activityID1)
-- 			self.ActivityName:SetText ("|cFF00CCFF["..home.."]|r " .. activityName)
-- 			self.ActivityName:SetTextColor (0, 1, 0)
-- 		end
-- 	end)
-- end