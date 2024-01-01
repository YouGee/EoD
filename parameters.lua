
version = 'Alpha 0.0.'

-- Game global static parameters
	-- Colors
ColorLightGreenR = 153
ColorLightGreenG = 255
ColorLightGreenB = 153
ColorDarkGreenR = 0
ColorDarkGreenG = 0
ColorDarkGreenB = 0

	-- Configuration
		-- mountains
world_config_mountains_exist = true
world_config_mountains_dimension_min = 10	-- x 100m
world_config_mountains_dimension_max = 100	-- x 100m
world_config_mountains_minimum_number = 20	-- No less than that
world_config_mountains_maximum_number = 40	-- No less than that
world_config_mountains_maxpercent_adj_point = 90	-- max % of altitude decrease for adjacent points
world_config_mountains_minpercent_adj_point = 60	-- min % of altitude decrease for adjacent points
world_config_mountains_maxpercent_diag_point = 80	-- max % of altitude decrease for diagonal points
world_config_mountains_minpercent_diag_point = 50	-- min % of altitude decrease for diagonal points

		-- rivers
world_config_rivers_exist = false
		-- seas
world_config_seas_exist = false

	-- World size
		-- Horizontal dimensions
world_dimension_width = 70		-- world horizontal dimension in 10 meters
world_dimension_height = 50		-- world vertical dimension in 10 meters

	-- Display parameters
		-- Tile size in pixel
Display_tile_size = 4

		-- Display zoom factor
Display_zoom_factor = 2