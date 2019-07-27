local RF = select(2, ...)
local servers = RF.servers
local posts = RF.posts
local cat = RF.cat

-- TODO make the removeEntries subcomponents functions for simpler code
-- TODO GUI
-- By default filter outside data centers to yes --
RF.togRemove = true

local realm_unsubbed = GetRealmName()
RF.myRealm = string.gsub(realm_unsubbed, "'", "")
---- Set variables for realm/data-centre info ----

RF:setRegionRealmLabel(RF.myRealm)

---- Labelling and Removing Functions
function RF.removeEntries(results)
	if RF.togRemove == true then
		for idx = #results, 1, -1 do
			local resultID = results[idx]
			local searchResults = C_LFGList.GetSearchResultInfo(resultID)
			local activitiyID1 = searchResults.activityID
			local leaderName = searchResults.leaderName

			if leaderName ~= nil then -- Filter out nil entries from LFG Pane
				local name, realm = RF:sanitiseName(leaderName)
				local info = servers[realm]
				if info ~= nil then
					local region = info[1]
		
					if RF.region == 'NA' then -- if your own region is NA colour code NA servers appropriately
						if region == 'NA' then
							-- Do nothing because its in your region
						else
							table.remove(results, idx)
						end
					end

					if RF.region == 'BR' then -- if your own region is NA colour code BR servers appropriately
						if region == 'BR' then
						else
							table.remove(results, idx)
						end
					end

					if RF.region == 'LA' then -- if your own region is NA colour code LA servers appropriately
						if region == 'LA' then
						else
							table.remove(results, idx)
						end
					end

					if RF.region == 'OC' then -- if your own region is NA colour code OC servers appropriately
						if region == 'OC' then
						else
							table.remove(results, idx)
						end
					end
				end
			end
		end
	-- If the flag is switched off
	elseif RF.togRemove == false then
		-- do nothing!
	end
end

function RF.updateEntries(results)
	local searchResults = C_LFGList.GetSearchResultInfo(results.resultID)
	local activityID = searchResults.activityID
	local leaderName = searchResults.leaderName
	local activityName = C_LFGList.GetActivityInfo(activityID)

	if leaderName ~= nil then -- Filter out nil entries from LFG Pane
		local name, realm = RF:sanitiseName(leaderName)
		local info = servers[realm]
		if info ~= nil then
			local region, dataCentre = info[1], info[2]

			if RF.region == 'NA' then -- if your own region is NA colour code NA servers appropriately
				if region == 'NA' then
					if dataCentre == 'NYC' then
						if RF.dataCentre == dataCentre then -- if your personal data centre matches the queried leader/realm name (colour coding for home data centres)
							results.ActivityName:SetText ("|cFF00CCFF["..cat.na_nyc_id.."]|r " .. activityName)
						else
							results.ActivityName:SetText ("|cFFFFFF00["..cat.na_nyc_id.."]|r " .. activityName)
						end
						results.ActivityName:SetTextColor (0, 1, 0)
					end

					if dataCentre == 'PHX' then
						if RF.dataCentre == dataCentre then
							results.ActivityName:SetText ("|cFF00CCFF["..cat.na_phx_id.."]|r " .. activityName)
						else
							results.ActivityName:SetText ("|cFFFFFF00["..cat.na_phx_id.."]|r " .. activityName)
						end
						results.ActivityName:SetTextColor (0, 1, 0)
					end

					if dataCentre == 'LA' then
						if RF.dataCentre == dataCentre then
							results.ActivityName:SetText ("|cFF00CCFF["..cat.na_la_id.."]|r " .. activityName)
						else
							results.ActivityName:SetText ("|cFFFFFF00["..cat.na_la_id.."]|r " .. activityName)
						end
						results.ActivityName:SetTextColor (0, 1, 0)
					end

					if dataCentre == 'CHI' then
						if RF.dataCentre == dataCentre then
							results.ActivityName:SetText ("|cFF00CCFF["..cat.na_chi_id.."]|r " .. activityName)
						else
							results.ActivityName:SetText ("|cFFFFFF00["..cat.na_chi_id.."]|r " .. activityName)
						end
						results.ActivityName:SetTextColor (0, 1, 0)
					end
				end
			end

			-- non-NA realms
			if RF.region == 'BR' then
				if region == 'BR' then
					results.ActivityName:SetText ("|cFFFFFF00["..cat.br.."]|r " .. activityName)
					results.ActivityName:SetTextColor (0, 1, 0)
				end
			end

			if RF.region == 'LA' then
				if region == 'LA' then		
					results.ActivityName:SetText ("|cFFFFFF00["..cat.la.."]|r " .. activityName)
					results.ActivityName:SetTextColor (0, 1, 0)	
				end
			end
			
			if RF.region == 'OC' then
				if region == 'OC' then
					results.ActivityName:SetText ("|cFFFFFF00["..cat.oc.."]|r " .. activityName)
					results.ActivityName:SetTextColor (0, 1, 0)	
				end
			end
		end
	end
end

hooksecurefunc ("LFGListUtil_SortSearchResults", RF.removeEntries)
hooksecurefunc ("LFGListSearchEntry_Update", 	 RF.updateEntries)

SLASH_RFILTER1 = "/rfilter"
SlashCmdList["RFILTER"] = function(msg)
	if RF.togRemove == true then
		RF.togRemove = false
		print('|cff00ffff[Region Filter]: |cffFF6EB4 Not filtering outside regions')
	else
		RF.togRemove = true
		print('|cff00ffff[Region Filter]: |cffFF6EB4 Filtering outside regions')
	end
	LFGListSearchPanel_UpdateResultList (LFGListFrame.SearchPanel)
	LFGListSearchPanel_UpdateResults 	(LFGListFrame.SearchPanel)
end

---- Print When Loaded ----
local welcomePrompt = CreateFrame("Frame")
welcomePrompt:RegisterEvent("PLAYER_LOGIN")
welcomePrompt:SetScript("OnEvent", function(_, event)
	if event == "PLAYER_LOGIN" then
		print("|cff00ffff[Region Filter]|r |cffffcc00Version 1.3.3|r. If there any bugs please report them via https://wow.curseforge.com/projects/regionfilter or https://github.com/jamesb93/RegionFilter")
		print(RF.postType)
	end
end)

-------- OLD CODE --------
---- Crucical code to detect when the LFG pane is opened ----
-- local LFGOpened = CreateFrame ("frame", nil, UIParent)
-- LFGOpened:RegisterEvent ("LFG_LIST_SEARCH_RESULTS_RECEIVED")

-- function RF.UpdateList()
-- 	-- Call the two functions which filter and label LFG entries --
-- 	hooksecurefunc ("LFGListSearchEntry_Update", RF.updateEntriesNA)
-- 	hooksecurefunc ("LFGListUtil_SortSearchResults", RF.removeEntriesNA)
-- end

-- LFGOpened:SetScript ("OnEvent", function (self, event, ...)
-- 	-- When the LFG panel is opened called the above function --
-- 	RF.UpdateList()
-- end)