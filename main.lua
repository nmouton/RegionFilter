local RF = select(2, ...)
local servers = RF.servers
local posts = RF.posts
local cat = RF.cat

-- TODO make the removeEntries subcomponents functions for simpler code
-- TODO GUI
-- By default filter outside data centers to yes --
RF.togRemove = true

local realm_unsubbed = GetRealmName()
local spaced_realm = string.gsub(realm_unsubbed, "%s+", "")
RF.myRealm = string.gsub(spaced_realm, "'", "")
---- Set variables for realm/data-centre info ----

RF:setRegionRealmLabel(RF.myRealm)

---- Removing Enrties when togRemove is enabled
function RF.removeEntries(results)
	if RF.togRemove then
		for idx=1, #results  do
			local resultID = results[idx]
			local searchResults = C_LFGList.GetSearchResultInfo(resultID)
			local activitiyID1 = searchResults.activityID
			local leaderName = searchResults.leaderName

			if leaderName ~= nil then -- Filter out nil entries from LFG Pane
				local name, realm = RF:sanitiseName(leaderName)
				local info = servers[realm]
				if info ~= nil then
					local region = info[1]
					if RF.region ~= region then
						table.remove(results, idx)
					end
				end
			end
			table.sort(results)
		end
	end
end

---- Updating the text of entries
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
							results.ActivityName:SetText("|cFF00CCFF["..cat.na_nyc_id.."]|r " .. activityName)
						else
							results.ActivityName:SetText("|cFFFFFF00["..cat.na_nyc_id.."]|r " .. activityName)
						end
						results.ActivityName:SetTextColor(0, 1, 0)
					end

					if dataCentre == 'PHX' then
						if RF.dataCentre == dataCentre then
							results.ActivityName:SetText("|cFF00CCFF["..cat.na_phx_id.."]|r " .. activityName)
						else
							results.ActivityName:SetText("|cFFFFFF00["..cat.na_phx_id.."]|r " .. activityName)
						end
						results.ActivityName:SetTextColor(0, 1, 0)
					end

					if dataCentre == 'LA' then
						if RF.dataCentre == dataCentre then
							results.ActivityName:SetText ("|cFF00CCFF["..cat.na_la_id.."]|r " .. activityName)
						else
							results.ActivityName:SetText ("|cFFFFFF00["..cat.na_la_id.."]|r " .. activityName)
						end
						results.ActivityName:SetTextColor(0, 1, 0)
					end

					if dataCentre == 'CHI' then
						if RF.dataCentre == dataCentre then
							results.ActivityName:SetText("|cFF00CCFF["..cat.na_chi_id.."]|r " .. activityName)
						else
							results.ActivityName:SetText("|cFFFFFF00["..cat.na_chi_id.."]|r " .. activityName)
						end
						results.ActivityName:SetTextColor(0, 1, 0)
					end
				end
			end

			-- non-NA realms
			if RF.region == 'BR' and region == 'BR' then
				results.ActivityName:SetText("|cFFFFFF00["..cat.br.."]|r " .. activityName)
				results.ActivityName:SetTextColor(0, 1, 0)
			end

			if RF.region == 'LA' and region == 'LA' then
				results.ActivityName:SetText("|cFFFFFF00["..cat.la.."]|r " .. activityName)
				results.ActivityName:SetTextColor(0, 1, 0)	
			end
			
			if RF.region == 'OC' and region == 'OC' then
				results.ActivityName:SetText("|cFFFFFF00["..cat.oc.."]|r " .. activityName)
				results.ActivityName:SetTextColor(0, 1, 0)	
			end
		end
	end
end


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
		print("|cff00ffff[Region Filter]|r |cffffcc00Version 1.3.7|r. If there any bugs please report them at https://github.com/jamesb93/RegionFilter")
		print("If possible, stop using CurseForge (soon/now to be Overwolf) and try CurseBreaker https://www.github.com/AcidWeb/CurseBreaker.")
		print(RF.postType)
	end
end)

hooksecurefunc("LFGListUtil_SortSearchResults", RF.removeEntries)
hooksecurefunc("LFGListSearchEntry_Update", 	RF.updateEntries)