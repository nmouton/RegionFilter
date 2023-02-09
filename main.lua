local RF = select(2, ...)
local servers = RF.servers
local posts = RF.posts
RF.version = "1.5.0"
RF.togRemove = false

local spaced_realm = string.gsub(GetRealmName(), "%s+", "")
RF.myRealm = string.gsub(spaced_realm, "'", "")
---- Set variables for realm/data-centre info ----
RF.info = servers[RF.myRealm] 
RF.region, RF.dataCentre = RF.info[1], RF.info[2]

if RF.region == 'NA' then
	if RF.dataCentre == 'EAST' then
		RF.postType = posts.na_east_post
	end

	if RF.dataCentre == 'WEST' then
		RF.postType = posts.na_west_post
	end
end

if RF.region == 'OC' then RF.postType = posts.oc_post end
if RF.region == 'LA' then RF.postType = posts.la_post end
if RF.region == 'BR' then RF.postType = posts.br_post end

---- Updating the text of entries
function RF.updateEntries(results)
	local searchResults = C_LFGList.GetSearchResultInfo(results.resultID)
	local activityID = searchResults.activityID
	local leaderName = searchResults.leaderName
	local activityName = C_LFGList.GetActivityInfoTable(activityID)

	if leaderName ~= nil then -- Filter out nil entries from LFG Pane
		local name, realm = RF:sanitiseName(leaderName)
		local info = servers[realm]
		if info then
			local region, dataCentre, regionColour = info[1], info[2], info[3]
			if region == "NA" then
				regionLabel = region..'-'..dataCentre;
			else
				regionLabel = region
			end
				results.ActivityName:SetText(
					RF:regionTag(
						regionLabel, 
						activityName,
						regionColour
					)
				)
				results.ActivityName:SetTextColor(
					RF:dungeonText(RF.region, region)
				)
		end
	end
end

---- Print When Loaded ----
local welcomePrompt = CreateFrame("Frame")
welcomePrompt:RegisterEvent("PLAYER_LOGIN")
welcomePrompt:SetScript("OnEvent", function(_, event)
	if event == "PLAYER_LOGIN" then
		print("|cff00ffff[Region Filter]|r |cffffcc00Version "..RF.version.."|r. If there any bugs please report them at https://github.com/jamesb93/RegionFilter")
		print(RF.postType)
	end
end)

-- hooksecurefunc("LFGListUtil_SortSearchResults", RF.sortEntries)
hooksecurefunc("LFGListSearchEntry_Update", RF.updateEntries)
