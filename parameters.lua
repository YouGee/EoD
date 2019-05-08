
version = 'Alpha 0.0.1'

-- Game global static parameters
	-- Colors
ColorLightGreenR = 153
ColorLightGreenG = 255
ColorLightGreenB = 153
ColorDarkGreenR = 0
ColorDarkGreenG = 128
ColorDarkGreenB = 0

	-- configuration
		-- mountains
world_config_mountains_exist = true
world_config_mountains_dimension_min = 10
world_config_mountains_dimension_max = 100
world_config_mountains_minimum_number = 2	-- No less than that
world_config_mountains_maximum_number = 10	-- No less than that
world_config_mountains_maxpercent_adj_point = 90	-- max % of altitude decrease for adjacent points
world_config_mountains_minpercent_adj_point = 60	-- min % of altitude decrease for adjacent points
world_config_mountains_maxpercent_diag_point = 80	-- max % of altitude decrease for diagonal points
world_config_mountains_minpercent_diag_point = 50	-- min % of altitude decrease for diagonal points

		-- rivers
world_config_rivers_exist = false
		-- seas
world_config_seas_exist = false

	-- world surface size
	-- here 80 x 60 km
world_dimension_width = 8		-- world horizontal dimension in 10 meters
world_dimension_height = 8		-- world vertical dimension in 10 meters

	-- vertical dimensions
world_dimension_max_altitude = 800	-- 10 meters, 8km max
world_dimension_max_depth = 800		-- 10 meters, 8km max