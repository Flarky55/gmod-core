if SERVER then return end

local sam = sam
local SUI = sam.SUI
local GetColor = SUI.GetColor
local Line = sui.TDLib.LibClasses.Line


local FONT_TAG = SUI.CreateFont("Maps.Tag", "Roboto Bold", 12)


local categroies = {
	["gm"] = "Sandbox",
	["rp"] = "Role Play"
}

local TAG_DEFAULT 	= {Title = "Стандартная", 	Color = Color(46, 204, 113)}
local TAG_SMALL		= {Title = "Маленькая", 	Color = Color(46, 204, 113)}
local TAG_VERYSMALL	= {Title = "Очень маленькая", Color = Color(46, 204, 113)}
local TAG_NONSTANDARD = {Title = "Нестандартная", Color = Color(155, 89, 182)}
local TAG_CLOSED = {Title = "Закрытая", Color = Color(46, 204, 133)}

local TAG_APOCALYPSE 	= {Title = "Апокалипсис", 	Color = Color(230, 126, 34)}
local TAG_CITY 			= {Title = "Город", 		Color = Color(52, 73, 94)}
local TAG_DAY 			= {Title = "День", 			Color = Color(241, 196, 15)}
local TAG_NIGHT 		= {Title = "Ночь", 			Color = Color(44, 62, 80)}
local TAG_SNOW 			= {Title = "Снег", 			Color = color_white}
local TAG_WATER			= {Title = "Вода",			Color = Color(72, 126, 176)}
local TAG_HALFLIFE 		= {Title = "Half-Life", 	Color = Color(230, 126, 34)}
local TAG_STALKER		= {Title = "S.T.A.L.K.E.R", Color = Color(87, 75, 144)}
local TAG_SCP			= {Title = "SCP", 			Color = color_white}
local TAG_METRO			= {Title = "Metro", 		Color = color_white}
local TAG_SAND 			= {Title = "Песок", 		Color = Color(194, 178, 128)}
local TAG_WESTERN 		= {Title = "Дикий Запад", 	Color = Color(230, 126, 34)}
local TAG_MEDIEVAL		= {Title = "Средневековье", Color = Color(128, 128, 128)}

local tags = {
	--[[
		Sandbox
	]]
	-- Default
	["gm_construct"] = {TAG_DEFAULT},
	["gm_flatgrass"] = {TAG_DEFAULT},

	-- Snow
	["gm_balkans_snow"]					= {TAG_SNOW},
	["gm_vyten"] 						= {TAG_SNOW},
	["gm_boreas"] 						= {TAG_SNOW},
	["gm_christruct"] 					= {TAG_SNOW},
	["gm_christruct_noice"] 			= {TAG_SNOW},
	["gm_coast_nlo_prewar_snownight"] 	= {TAG_SNOW, TAG_NIGHT},
	["gm_frozen_lake"]					= {TAG_SNOW, TAG_DAY},
	["gm_frozen_lake_night"]			= {TAG_SNOW, TAG_NIGHT},

	-- Sand
	["gm_buttes2"] 			= {TAG_SAND, TAG_DAY},
	["gm_buttes2_night"] 	= {TAG_SAND, TAG_NIGHT},
	["gm_highway14800"]		= {TAG_SAND},
	["gm_disten"]			= {TAG_SAND, TAG_DAY},
	["gm_disten_night"]		= {TAG_SAND, TAG_NIGHT},
	["gm_redrock"]			= {TAG_SAND},

	-- City
	["gm_bigcity_improved"]		= {TAG_CITY, TAG_DAY},
	["gm_bigcity_winter_day"] 	= {TAG_CITY, TAG_SNOW, TAG_DAY},
	["gm_bigcity_winter"]		= {TAG_CITY, TAG_SNOW, TAG_NIGHT},
	["gm_goldencity_v2_day"]	= {TAG_CITY, TAG_DAY},
	["gm_goldencity_v2"]		= {TAG_CITY, TAG_NIGHT},
	["gm_york_remaster"] 		= {TAG_CITY, TAG_DAY},
	["gm_york_remaster_night"] 	= {TAG_CITY, TAG_NIGHT},
	["gm_blesmont"] 			= {TAG_CITY},

	-- Day/Night
	["gm_shambles_day"]				= {TAG_DAY},
	["gm_shambles"]					= {TAG_NIGHT},
	["gm_renostruct_v2"]			= {TAG_DAY},
	["gm_renostruct_v2_night"]		= {TAG_NIGHT},
	["gm_citylimits_day_v1"]		= {TAG_DAY},
	["gm_citylimits_v2"]			= {TAG_NIGHT},
	["gm_northbury_day"]			= {TAG_DAY},
	["gm_northbury"]				= {TAG_NIGHT},
	["gm_cabin_in_the_woods_day"]	= {TAG_DAY},
	["gm_cabin_in_the_woods"]		= {TAG_NIGHT},

	-- Apocalypse
	["gm_aftermath_thelast"] = {TAG_APOCALYPSE},

	-- Small
	["gm_coast_prewar_snownight"] 		= {TAG_SMALL, TAG_SNOW, TAG_NIGHT},
	["gm_mdach"]						= {TAG_SMALL},
	["gm_pineforest2"]					= {TAG_SMALL},
	["gm_mountainresort"]				= {TAG_SMALL, TAG_DAY},
	["gm_mountainresort_night"]			= {TAG_SMALL, TAG_NIGHT},
	["gm_mountainresort_snow"]			= {TAG_SMALL, TAG_SNOW, TAG_DAY},
	["gm_mountainresort_snow_night"]	= {TAG_SMALL, TAG_SNOW, TAG_NIGHT},
	["gm_mountainresort_storm"]			= {TAG_SMALL},
	["gm_abandoned_factory"]			= {TAG_VERYSMALL},
	["gm_building"]						= {TAG_VERYSMALL},
	["gm_sosnovka"]						= {TAG_VERYSMALL},
	["gm_sosnovka2"]					= {TAG_VERYSMALL, TAG_SNOW, TAG_DAY},
	["gm_sosnovka2_night"]				= {TAG_VERYSMALL, TAG_SNOW, TAG_NIGHT},

	-- Water
	["gm_mother_base"] 	= {TAG_WATER},
	["gm_sevenseas"]	= {TAG_WATER},
	["gm_facade"]		= {TAG_WATER},

	-- Non-standard
	["gm_abyssalplain"] 			= {TAG_NONSTANDARD, {Title = "Заполнена водой", Color = Color(72, 126, 176)}},
	["gm_site19"] 					= {TAG_NONSTANDARD, TAG_SCP},
	["gm_conflux"] 					= {TAG_NONSTANDARD},
	["gm_grandfathergalley"] 		= {TAG_NONSTANDARD},
	["gm_towncomplete"] 			= {TAG_NONSTANDARD, TAG_HALFLIFE},
	["gm_descent"]					= {TAG_NONSTANDARD},
	["gm_fever_dream_2"]			= {TAG_NONSTANDARD},
	["gm_kylig"]					= {TAG_NONSTANDARD, TAG_VERYSMALL},
	["gm_vacant_industry"]			= {TAG_NONSTANDARD},
	["gm_viscera_sandbox"]			= {TAG_NONSTANDARD},
	["gm_voidplaces"]				= {TAG_NONSTANDARD, TAG_CLOSED},

	
	--[[
		Role Play
	]]
	-- Apocalypse 
	["rp_asheville"] 			= {TAG_APOCALYPSE},
	["rp_apocalypse_remaster"] 	= {TAG_APOCALYPSE},

	-- Half-Life
	["rp_industrial17_v1"] 				= {TAG_HALFLIFE},
	["rp_city8_edit_v3b"] 				= {TAG_HALFLIFE},
	["rp_city17_district47"]			= {TAG_HALFLIFE},
	["rp_city17_district47_sv_v2"]		= {TAG_HALFLIFE, TAG_SNOW},
	["rp_city8_district9"] 				= {TAG_HALFLIFE},
	["rp_city3"]						= {TAG_HALFLIFE},
	["rp_c24_v1"]						= {TAG_HALFLIFE},
	["rp_ineu_valley2_v1a"]				= {TAG_HALFLIFE},
	["rp_ineu_valley2_winter"] 			= {TAG_HALFLIFE, TAG_SNOW},
	["rp_nova"]							= {TAG_HALFLIFE},
	["rp_nova_prewar"]					= {TAG_HALFLIFE},
	["rp_white_forest_svcom"]			= {TAG_HALFLIFE},
	["rp_city11_night_v1b"]				= {TAG_HALFLIFE},
	["rp_city34_v1a"]					= {TAG_HALFLIFE},
	["rp_c17trainstationdistrict_v2"]	= {TAG_HALFLIFE},
	["rp_city17transitblock_prewar_v3"]	= {TAG_HALFLIFE},
	["rp_city24_v3"]					= {TAG_HALFLIFE},
	["rp_city27_v1c"]					= {TAG_HALFLIFE},
	["rp_bmsectorc_v2"]					= {TAG_CLOSED, TAG_HALFLIFE},

	-- City
	["rp_southside_day"] 			= {TAG_CITY, TAG_DAY},
	["rp_southside"] 				= {TAG_CITY, TAG_NIGHT},
	["rp_unioncity_day"] 			= {TAG_CITY, TAG_DAY},
	["rp_unioncity"] 				= {TAG_CITY, TAG_NIGHT},
	["rp_nycity_day"]				= {TAG_CITY, TAG_DAY},
	["rp_nycity"]					= {TAG_CITY, TAG_NIGHT},
	["rp_pure_lake"] 				= {TAG_CITY},
	["rp_downpour_clear"]			= {TAG_CITY, TAG_DAY},
	["rp_downpour"]					= {TAG_CITY, TAG_NIGHT},
	["rp_dobrograd"]				= {TAG_CITY},
	["rp_evocity_dbg"]				= {TAG_CITY},
	["rp_florida_v2"]				= {TAG_CITY},
	["rp_nexusgrad_v1_winter"] 		= {TAG_CITY, TAG_SNOW},
	["rp_tricity"]					= {TAG_CITY},
	["rp_lofagorsk_v1a"]			= {TAG_CITY},
	["rp_newexton2_v4h"]			= {TAG_CITY},
	["rp_rashkinsk_v5"]				= {TAG_CITY},

	-- Day/Night
	["rp_rudmerge_day"]	= {TAG_DAY},
	["rp_rudmerge"]		= {TAG_NIGHT},

	-- S.T.A.L.K.E.R
	["rp_marsh_cs"] 		= {TAG_STALKER},
	["rp_stalker_mixed"] 	= {TAG_STALKER},
	["rp_zaton_remaster"]	= {TAG_STALKER},

	-- Western
	["rp_jaggedspringsv3"] 	= {TAG_WESTERN},

	-- Sand
	["rp_desert_conflict"] 	= {TAG_SAND},
	["rp_foreign_desert"]	= {TAG_SAND},

	-- Medieval
	["rp_skyrim"] 		= {TAG_MEDIEVAL},
	["rp_medieval_v2"]	= {TAG_MEDIEVAL},

	-- Metro
	["rp_metro_refuge"] 	= {TAG_METRO},

	["rp_lowerland"] = {TAG_CLOSED}, 
	["rp_site65"] = {TAG_SCP},

	--[[
		Other
	]]
	["copper_forest"] 			= {TAG_NONSTANDARD},
	["cerberon_a_recreation"] 	= {TAG_NONSTANDARD},
	["vp_pinkplace_v2"] 		= {TAG_NONSTANDARD, TAG_CLOSED},
	["vp_voidmall"] 			= {TAG_NONSTANDARD, TAG_CLOSED},
	["vp_whitecomplex"] 		= {TAG_NONSTANDARD, TAG_CLOSED},

	["de_gossamer"] = {TAG_CLOSED},
	["sb_omen_v2"] = {{Title = "Космос", Color = Color(44, 62, 80)}},
	["zs_duskwood_v1"] = {TAG_VERYSMALL},
}


sam.menu.add_tab("https://raw.githubusercontent.com/conred-gmod/.github/main/images/map.png", function(column_sheet)
    local tab_body = column_sheet:Add("Panel")
    tab_body:Dock(FILL)
    tab_body:DockMargin(0, 1, 0, 0)

    do
        local label = tab_body:Add("SAM.Label")
		label:Dock(TOP)
		label:DockMargin(10, 10, 0, 0)
		label:SetFont(SAM_TAB_TITLE_FONT)
		label:SetText("Карты")
		label:SetTextColor(GetColor("menu_tabs_Title"))
		label:SizeToContents()
    end

    local body = tab_body:Add("Panel")
	body:Dock(FILL)
	body:DockMargin(10, 5, 10, 10)

    Line(body, nil, 0, 0, 0, 10)

    local search_entry = body:Add("SAM.TextEntry")
	search_entry:Dock(TOP)
	search_entry:SetNoBar(true)
	search_entry:SetPlaceholder("Поиск...")
	search_entry:SetRadius(4)
	search_entry:SetTall(27)

    local category_list = body:Add("SAM.CollapseCategory")
	category_list:Dock(FILL)
	category_list:DockMargin(0, SUI.Scale(10), 0, 0)

	for _, map in ipairs(sam.get_global("Maps")) do
		local item = category_list:add_item(map, categroies[map:sub(1, 2)] or "Прочее")
		item:DockPadding(5, 5, 0, 5)
		item:InvalidateParent(true)
		item:SetTall(32)
		item.DoClick = function(s)
			RunConsoleCommand("sam", "votemap", map)
		end
		item.DoRightClick = function(s)
			SetClipboardText(map)
		end

		local names = {map}

		local tags = tags[map]
		if tags then
			for i, tag in ipairs(tags) do
				local tag_pnl = item:Add("SAM.Label")
				tag_pnl:Dock(LEFT)
				tag_pnl:DockMargin(0, 0, 5, 0)
				tag_pnl:SetMouseInputEnabled(false)
				-- tag_pnl:SetBackgroundColor(tag.Color)
				tag_pnl:SetFont(FONT_TAG)
				tag_pnl:SetText(tag.Title)
				tag_pnl:SizeToContentsX(16)

				names[1 + i] = utf8.lower(tag.Title)
			end
		end

		item.names = names
	end

	search_entry.OnValueChange = function(s, text)
		category_list:Search(utf8.lower(text), true)
	end

    return tab_body
end, nil, 6)