RegionFilter = LibStub ("AceAddon-3.0"):NewAddon ("RegionFilter", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0")

local RegionFilter = RegionFilter

local f = CreateFrame ("frame", nil, UIParent)
f:RegisterEvent ("LFG_LIST_SEARCH_RESULTS_RECEIVED")

function RegionFilter:UpdateList()
	LFGListSearchPanel_UpdateResultList (LFGListFrame.SearchPanel)
	LFGListSearchPanel_UpdateResults (LFGListFrame.SearchPanel)
end

f:SetScript ("OnEvent", function (self, event, ...)
	RegionFilter:ScheduleTimer ("UpdateList", 1)
end)

-- all calls are local
local hooksecurefunc = hooksecurefunc

-- Some name strings to use in the functions.
home = 'HOME'
na_nyc_id = 'NA-NYC'
na_la_id = 'NA-LA'
na_phoenix_id = 'NA-PHX'
na_chicago_id = 'NA-CHI'
realm_unsubbed = GetRealmName()
realm = string.gsub(realm_unsubbed, "'", "")

local addonName, addonTable = ...
print(addonTable.servers.na_nyc)

-- NA posts
na_post = "|cff00ffff[Region Filter]:|r You are an on an |cffFF6EB4NA|r Server"
oc_post = "|cff00ffff[Region Filter]:|r You are an on an |cffFF6EB4OC|r Server"
br_post = "|cff00ffff[Region Filter]:|r You are an on an |cffFF6EB4BR|r Server"
la_post = "|cff00ffff[Region Filter]:|r You are an on an |cffFF6EB4LA|r Server"

-- EU posts
en_post = "|cff00ffff[Region Filter]:|r You are an on an |cffFF6EB4EN|r Server"
de_post = "|cff00ffff[Region Filter]:|r You are an on an |cffFF6EB4DE|r Server"
fr_post = "|cff00ffff[Region Filter]:|r You are an on an |cffFF6EB4FR|r Server"
it_post = "|cff00ffff[Region Filter]:|r You are an on an |cffFF6EB4IT|r Server"
ru_post = "|cff00ffff[Region Filter]:|r You are an on an |cffFF6EB4RU|r Server"
es_post = "|cff00ffff[Region Filter]:|r You are an on an |cffFF6EB4ES|r Server"



-- Check the region of each group and highlights if its in your region. This code runs on a region per region basis. See below.
function RegionFilter:InstallHookNA(realms, label)
	hooksecurefunc ("LFGListSearchEntry_Update", function (self) 
		local table = C_LFGList.GetSearchResultInfo(self.resultID)
		local activityID1 = table.activityID
		local LN1 = table.leaderName

		if LN1 ~= nil then -- Filter out nil entries from LFG Pane
			if string.match(LN1, "-") then -- If the string has a hyphen in it split it up
				local name, server = strsplit("-", LN1, 2) -- Split string with a maximum of two splits according to the "-"" delimiter
				server_subbed = string.gsub(server, "'", "" ) -- Remove the internal quotes from server names
				if realms == na_realms then
					
					for _, v in ipairs(servers.na_la) do		
						if v == server_subbed then
							local activityName = C_LFGList.GetActivityInfo(activityID1)
							if server_id == 'la' then
								self.ActivityName:SetText ("|cFF00CCFF["..na_la_id.."]|r " .. activityName)
							else
								self.ActivityName:SetText ("|cFFFFFF00["..na_la_id.."]|r " .. activityName)
							end
							self.ActivityName:SetTextColor (0, 1, 0)
						end
					end

					for _, v in ipairs(servers.na_nyc) do
						if v == server_subbed then
							local activityName = C_LFGList.GetActivityInfo(activityID1)
							if server_id == 'nyc' then
								self.ActivityName:SetText ("|cFF00CCFF["..na_nyc_id.."]|r " .. activityName)
							else
								self.ActivityName:SetText ("|cFFFFFF00["..na_nyc_id.."]|r " .. activityName)
							end
							self.ActivityName:SetTextColor (0, 1, 0)
						end
					end

					for _, v in ipairs(servers.na_chicago) do
						if v == server_subbed then
							local activityName = C_LFGList.GetActivityInfo (activityID1)
							if server_id == 'chicago' then
								self.ActivityName:SetText ("|cFF00CCFF["..na_chicago_id.."]|r " .. activityName)
							else
								self.ActivityName:SetText ("|cFFFFFF00["..na_chicago_id.."]|r " .. activityName)
							end
							self.ActivityName:SetTextColor (0, 1, 0)
						end
					end

					for _, v in ipairs(servers.na_phoenix) do
						if v == server_subbed then
							local activityName = C_LFGList.GetActivityInfo (activityID1)
							if server_id == 'phoenix' then
								self.ActivityName:SetText ("|cFF00CCFF["..na_phoenix_id.."]|r " .. activityName)
							else
								self.ActivityName:SetText ("|cFFFFFF00["..na_phoenix_id.."]|r " .. activityName)
							end
							self.ActivityName:SetTextColor (0, 1, 0)
						end
					end
				else if realms ~= na_realms then
					for _, v in ipairs(realms) do
						if v == server_subbed then
							local activityName = C_LFGList.GetActivityInfo (activityID1)
							self.ActivityName:SetText ("|cFFFFFF00["..label.."]|r " .. activityName)
							self.ActivityName:SetTextColor (0, 1, 0)
						end
					end
				end
			end
			else
				local activityName = C_LFGList.GetActivityInfo (activityID1)
				self.ActivityName:SetText ("|cFF00CCFF["..home.."]|r " .. activityName)
				self.ActivityName:SetTextColor (0, 1, 0)
			end
		end
	end)
end

function RegionFilter:InstallHookEU(realms, label)
	hooksecurefunc ("LFGListSearchEntry_Update", function (self) 
		local table = C_LFGList.GetSearchResultInfo(self.resultID)
		local activityID1 = table.activityID
		local LN1 = table.leaderName
		
		if LN1 ~= nil then --> Filter out nil entries from LFG Pane
			if string.match(LN1, "-") then --> If the string has a hyphen in it split it up (this separates home server from non home server)
				local name, server = strsplit("-", LN1, 2) --> Split string with a maximum of two splits according to the "-"" delimiter
				server_subbed = string.gsub(server, "'", "" ) --> Remove the internal quotes from server names

				for _, v in ipairs(realms) do
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
	-- Server requires
	print(debugstack())
	--> Print to the console some version stuff
	local z = CreateFrame("Frame")
	z:RegisterEvent("PLAYER_LOGIN")
	z:SetScript("OnEvent", function(f, event)
		if event == "PLAYER_LOGIN" then
			print("|cff00ffff[Region Filter]|r |cffffcc00Version 1.3|r. If there any bugs please report them via https://wow.curseforge.com/projects/regionfilter or https://github.com/jamesb93/RegionFilter")
		end
	end)
	my_locale = GetLocale()

	if (GetLocale() == "enUS") then
		--> Iterate over the different NA regions. If it hits any of them run the na_realms function which will differntiate inside
		for _, v in ipairs(na_nyc) do
			if realm == v then
				RegionFilter:ScheduleTimer ("InstallHookNA", time, na_realms, 'NA')
				print(na_post)
				server_id = 'nyc'
			end
		end

		for _, v in ipairs(na_chicago) do
			if realm == v then
				RegionFilter:ScheduleTimer ("InstallHookNA", time, na_realms, 'NA')
				print(na_post)
				server_id = 'chicago'
			end
		end

		for _, v in ipairs(na_la) do
			if realm == v then
				RegionFilter:ScheduleTimer ("InstallHookNA", time, na_realms, 'NA')
				print(na_post)
				server_id = 'la'
			end
		end

		for _, v in ipairs(na_phoenix) do
			if realm == v then
				RegionFilter:ScheduleTimer ("InstallHookNA", time, na_realms, 'NA')
				print(na_post)
				server_id = 'phoenix'
			end
		end

		for _, v in ipairs(br_realms) do
			if realm == v then
				RegionFilter:ScheduleTimer ("InstallHookNA", time, br_realms, 'BR')
				print(br_post)
			end
		end

		for _, v in ipairs(la_realms) do
			if realm == v then
				RegionFilter:ScheduleTimer ("InstallHookNA", time, la_realms, 'LA')
				print(la_post)
			end
		end

		for _, v in ipairs(oc_realms) do
			if realm == v then
				RegionFilter:ScheduleTimer ("InstallHookNA", time, oc_realms, 'OC')
				print(oc_post)
			end
		end

	else --> Do EU realms because the locale code was not enUS
		for _, v in ipairs(eu_en_realms) do
			if realm == v then 
				RegionFilter:ScheduleTimer ("InstallHookEU", time, eu_en_realms, 'EN')
				print(en_post)
			end
		end	

		for _, v in ipairs(eu_de_realms) do
			if realm == v then 
				RegionFilter:ScheduleTimer ("InstallHookEU", time, eu_fr_realms, 'FR')
				print(de_post)
			end
		end	

		for _, v in ipairs(eu_es_realms) do
			if realm == v then 
				RegionFilter:ScheduleTimer ("InstallHookEU", time, eu_es_realms, 'ES')
				print(es_post)
			end
		end	

		for _, v in ipairs(eu_it_realms) do
			if realm == v then 
				RegionFilter:ScheduleTimer ("InstallHookEU", time, eu_it_realms, 'IT')
				print(it_post)
			end
		end	

		for _, v in ipairs(eu_ru_realms) do
			if realm == v then 
				RegionFilter:ScheduleTimer ("InstallHookEU", time, eu_ru_realms, 'RU')
				print(ru_post)
			end
		end	

		for _, v in ipairs(eu_fr_realms) do
			if realm == v then 
				RegionFilter:ScheduleTimer ("InstallHookEU", time, eu_fr_realms, 'RU')
				print(fr_post)
			end
		end	
	end 
end

