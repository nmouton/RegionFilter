local RF = select(2, ...)
local servers = RF.servers
local posts = RF.posts

function RF:setRegionRealmLabel(ownRealm)
	RF.info = servers[ownRealm] 
	RF.region, RF.dataCentre = RF.info[1], RF.info[2]

	if RF.region == 'NA' then
		if RF.dataCentre == 'NYC' then
			RF.postType = posts.na_nyc_post
		end

		if RF.dataCentre == 'PHX' then
			RF.postType = posts.na_phx_post
		end

		if RF.dataCentre == 'LA' then
			RF.postType = posts.na_la_post
		end

		if RF.dataCentre == 'CHI' then
			RF.postType = posts.na_chi_post
		end
	end

	if RF.region == 'OC' then
		RF.postType = posts.oc_post
	end

	if RF.region == 'LA' then
		RF.postType = posts.la_post
	end

	if RF.region == 'BR' then
		RF.postType = posts.br_post
	end

end