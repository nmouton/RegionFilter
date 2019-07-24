local RF = select(2, ...)
local servers = RF.servers
local posts = RF.posts

function RF:setRegionRealmLabel(ownRealm)
	if (GetLocale() == "enUS") then
		--> Iterate over the different NA regions. If it hits any of them run the 'na_realms' function which will differntiate inside
		if isin(servers.na_nyc, ownRealm) then
			RF.realms = 'na_realms'
			RF.label = 'NA'
			RF.server_id = 'nyc'
			print(posts.na_post)
		end

		if isin(servers.na_chicago, ownRealm) then
			RF.realms = 'na_realms'
			RF.label = 'NA'
			RF.server_id = 'chicago'
			print(posts.na_post)
		end

		if isin(servers.na_la, ownRealm) then
			RF.realms = 'na_realms'
			RF.label = 'NA'
			RF.server_id = 'la'
			print(posts.na_post)
		end

		if isin(servers.na_phoenix, ownRealm) then
			RF.realms = 'na_realms'
			RF.label = 'NA'
			RF.server_id = 'phoenix'
			print(posts.na_post)
		end

		if isin(servers.br_realms, ownRealm) then
			RF.label = 'BR'
			print(posts.br_post)
		end

		if isin(servers.la_realms, ownRealm) then
			RF.label = 'LA'
			print(posts.la_post)
		end

		if isin(servers.oc_realms, ownRealm) then
			RF.label = 'OC'
			print(posts.oc_post)
		end

	else --> Do EU realms because the locale code was not enUS
		if isin(servers.eu_en_realms, ownRealm) then
			print(posts.en_post)
		end	

		if isin(servers.eu_de_realms, ownRealm) then
			print(posts.de_post)
		end	

		if isin(servers.eu_es_realms, ownRealm) then
			print(posts.es_post)
		end	

		if isin(servers.eu_it_realms, ownRealm) then
			print(posts.it_post)
		end	

		if isin(servers.eu_ru_realms, ownRealm) then
			print(posts.ru_post)
		end	

		if isin(servers.eu_fr_realms, ownRealm) then
			print(posts.fr_post)
		end	
	end
end