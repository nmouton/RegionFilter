RegionFilter = LibStub ("AceAddon-3.0"):NewAddon ("RegionFilter", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0")

local RegionFilter = RegionFilter

---- Crucical code to detect when the LFG pane is opened ----
local LFGOpened = CreateFrame ("frame", nil, UIParent)
LFGOpened:RegisterEvent ("LFG_LIST_SEARCH_RESULTS_RECEIVED")

function RegionFilter:UpdateList()
	LFGListSearchPanel_UpdateResultList (LFGListFrame.SearchPanel)
	LFGListSearchPanel_UpdateResults (LFGListFrame.SearchPanel)
end

LFGOpened:SetScript ("OnEvent", function (self, event, ...)
	-- When the LFG panel is opened called the above function --
	RegionFilter:ScheduleTimer ("UpdateList", 1)
	print('opened LFG')
end)

RF = select(2, ...)
servers = RF.servers
posts = RF.posts
cat = RF.cat

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
end

local realm_unsubbed = GetRealmName()
RF.myRealm = string.gsub(realm_unsubbed, "'", "")

---- Useful functions ----
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

-- function colourActivity(self, server_id, activityName, activityID)
-- 	local activityName = C_LFGList.GetActivityInfo(activityID)
-- 	if server_id == 'la' then
-- 		self.ActivityName:SetText ("|cFF00CCFF["..na_la_id.."]|r " .. activityName)
-- 	else
-- 		self.ActivityName:SetText ("|cFFFFFF00["..na_la_id.."]|r " .. activityName)
-- 	end
-- 	self.ActivityName:SetTextColor (0, 1, 0)
-- end
function removeEntriesNA(results)
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

function updateEntriesNA(results)
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


-- Check the region of each group and highlights if its in your region. This code runs on a region per region basis. See below.
function RegionFilter:FilterNA()
	hooksecurefunc ("LFGListUtil_SortSearchResults", removeEntriesNA)
	hooksecurefunc ("LFGListSearchEntry_Update", updateEntriesNA)
end


function RegionFilter:FilterEU(realms, label)
	hooksecurefunc ("LFGListSearchEntry_Update", function (self) 
		local table = C_LFGList.GetSearchResultInfo(self.resultID)
		local activityID1 = table.activityID
		local leaderName = table.leaderName
		
		if leaderName ~= nil then --> Filter out nil entries from LFG Pane
			if string.match(leaderName, "-") then --> If the string has a hyphen in it split it up (this separates home server from non home server)
				local name, server = strsplit("-", leaderName, 2) --> Split string with a maximum of two splits according to the "-"" delimiter
				server_subbed = string.gsub(server, "'", "" ) --> Remove the internal quotes from server names

				for _, v in pairs(realms) do
					if v == server_subbed then
						local activityName = C_LFGList.GetActivityInfo (activityID1)
						self.ActivityName:SetText ("|cFFFFFF00["..label.."]|r " .. activityName)
						self.ActivityName:SetTextColor (0, 1, 0)
					end
				end
			end

		else
			local activityName = C_LFGList.GetActivityInfo (activityID1)
			self.ActivityName:SetText ("|cFF00CCFF["..home.."]|r " .. activityName)
			self.ActivityName:SetTextColor (0, 1, 0)
		end
	end)
end

--> At loadtime
function RegionFilter:OnInitialize()
	local time = 10
	--> Print to the console some version stuff
	local z = CreateFrame("Frame")
	z:RegisterEvent("PLAYER_LOGIN")
	z:SetScript("OnEvent", function(f, event)
		if event == "PLAYER_LOGIN" then
			print("|cff00ffff[Region Filter]|r |cffffcc00Version 1.3|r. If there any bugs please report them via https://wow.curseforge.com/projects/regionfilter or https://github.com/jamesb93/RegionFilter")
		end
	end)

	if (GetLocale() == "enUS") then
		--> Iterate over the different NA regions. If it hits any of them run the 'na_realms' function which will differntiate inside
		if isin(servers.na_nyc, RF.myRealm) then
			RF.realms = 'na_realms'
			RF.label = 'NA'
			RF.server_id = 'nyc'
			RegionFilter:ScheduleTimer ("FilterNA", time)
			print(posts.na_post)
		end

		if isin(servers.na_chicago, RF.myRealm) then
			RF.realms = 'na_realms'
			RF.label = 'NA'
			RF.server_id = 'chicago'
			RegionFilter:ScheduleTimer ("FilterNA", time)
			print(posts.na_post)
		end

		if isin(servers.na_la, RF.myRealm) then
			RF.realms = 'na_realms'
			RF.label = 'NA'
			RF.server_id = 'la'
			RegionFilter:ScheduleTimer ("FilterNA", time)
			print(posts.na_post)
		end

		if isin(servers.na_phoenix, RF.myRealm) then
			RF.realms = 'na_realms'
			RF.label = 'NA'
			RF.server_id = 'phoenix'
			RegionFilter:ScheduleTimer ("FilterNA", time)
			print(posts.na_post)
		end

		if isin(servers.br_realms, RF.myRealm) then
			RF.label = 'BR'
			RegionFilter:ScheduleTimer ("FilterNA", time, 'br_realms', 'BR')
			print(posts.br_post)
		end

		if isin(servers.la_realms, RF.myRealm) then
			RF.label = 'LA'
			RegionFilter:ScheduleTimer ("FilterNA", time, 'la_realms', 'LA')
			print(posts.la_post)
		end

		if isin(servers.oc_realms, RF.myRealm) then
			RF.label = 'OC'
			RegionFilter:ScheduleTimer ("FilterNA", time, 'oc_realms', 'OC')
			print(posts.oc_post)
		end

	else --> Do EU realms because the locale code was not enUS
		if isin(servers.eu_en_realms, RF.myRealm) then
			RegionFilter:ScheduleTimer ("FilterEU", time, 'eu_en_realms', 'EN')
			print(posts.en_post)
		end	

		if isin(servers.eu_de_realms, RF.myRealm) then
			RegionFilter:ScheduleTimer ("FilterEU", time, 'eu_fr_realms', 'FR')
			print(posts.de_post)
		end	

		if isin(servers.eu_es_realms, RF.myRealm) then
			RegionFilter:ScheduleTimer ("FilterEU", time, 'eu_es_realms', 'ES')
			print(posts.es_post)
		end	

		if isin(servers.eu_it_realms, RF.myRealm) then
			RegionFilter:ScheduleTimer ("FilterEU", time, 'eu_it_realms', 'IT')
			print(posts.it_post)
		end	

		if isin(servers.eu_ru_realms, RF.myRealm) then
			RegionFilter:ScheduleTimer ("FilterEU", time, 'eu_ru_realms', 'RU')
			print(posts.ru_post)
		end	

		if isin(servers.eu_fr_realms, RF.myRealm) then
			RegionFilter:ScheduleTimer ("FilterEU", time, 'eu_fr_realms', 'RU')
			print(posts.fr_post)
		end	
	end 
end