
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
world_config_mountains_density_low = 30		-- out of 100
world_config_mountains_density_mid = 40		-- out of 100
world_config_mountains_density_high = 30	-- out of 100
world_config_mountains_minimum_number = 2	-- No less than that
world_config_mountains_maximum_number = 10	-- No less than that
		-- rivers
world_config_rivers_exist = false
		-- seas
world_config_seas_exist = false

	-- world surface size
	-- here 80 x 60 km
world_dimension_width = 16		-- world horizontal dimension in 10 meters
world_dimension_height = 16		-- world vertical dimension in 10 meters

	-- vertical dimensions
world_dimension_max_altitude = 800	-- 10 meters, 8km max
world_dimension_max_depth = 800		-- 10 meters, 8km max