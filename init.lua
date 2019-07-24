local RF = select(2, ...)
local servers = RF.servers
local posts = RF.posts

function RF:setRegionRealmLabel(ownRealm)
	if (GetLocale() == "enUS") then
		if RF:isin(servers.na_nyc, ownRealm) then
			RF.realms = 'na_realms'
			RF.label = 'NA'
			RF.server_id = 'nyc'
			RF.postType = posts.na_nyc_post
		end

		if RF:isin(servers.na_chicago, ownRealm) then
			RF.realms = 'na_realms'
			RF.label = 'NA'
			RF.server_id = 'chicago'
			RF.postType = posts.na_chicago_post
		end

		if RF:isin(servers.na_la, ownRealm) then
			RF.realms = 'na_realms'
			RF.label = 'NA'
			RF.server_id = 'la'
			RF.postType = posts.na_la_posts
		end

		if RF:isin(servers.na_phoenix, ownRealm) then
			RF.realms = 'na_realms'
			RF.label = 'NA'
			RF.server_id = 'phoenix'
			RF.postType = posts.na_phoenix_post
		end

        if RF:isin(servers.br_realms, ownRealm) then
            RF.realms = servers.br_realms
			RF.label = 'BR'
			RF.postType = posts.br_post
		end

        if RF:isin(servers.la_realms, ownRealm) then
            RF.realms = servers.la_realms
			RF.label = 'LA'
			RF.postType = posts.la_post
		end

        if RF:isin(servers.oc_realms, ownRealm) then
            RF.realms = servers.oc_realms
			RF.label = 'OC'
			RF.postType = posts.oc_post
		end

	else --> Do EU realms because the locale code was not enUS
		if RF:isin(servers.eu_en_realms, ownRealm) then
			print(posts.en_post)
		end	

		if RF:isin(servers.eu_de_realms, ownRealm) then
			print(posts.de_post)
		end	

		if RF:isin(servers.eu_es_realms, ownRealm) then
			print(posts.es_post)
		end	

		if RF:isin(servers.eu_it_realms, ownRealm) then
			print(posts.it_post)
		end	

		if RF:isin(servers.eu_ru_realms, ownRealm) then
			print(posts.ru_post)
		end	

		if RF:isin(servers.eu_fr_realms, ownRealm) then
			print(posts.fr_post)
		end	
	end
end