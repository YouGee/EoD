# Temperatures
## ground temperature = f(season,altitude)
* 1 degree/100m
* min = -50°
* max = +50°

## water temperature = f(month,depth)
* T° = Surface T° / ((.00018 * depth in m * Surface T°) +1) (thx to [this formula](http://residualanalysis.blogspot.fr/2010/02/temperature-of-ocean-water-at-given.html))
* min @sea level = -5°
* max @sea level = +36
* still fresh water freezing point = 0°
* runnig fresh water freezing point = -10°
* salt water freezing point = -2°

# Altitude and depth
max altitude = 8000m
max depth    = 8000m
256 steps (1 step = 31m)

# Color gradients (RGB, using [this page](http://www.perbang.dk/rgbgradient/))
* ground, green to brown
**    0m =  0,229,61
** 8000m = 68, 33,19
* water, light blue to dark blue
**    0m = 82,255,245
** 8000m = 14,  0,56

# Seasons
* Spring
** light = 60%
** temperature @sea level = +15°, variation = +/- 5°
* Summer
** light = 70%
** temperature @sea level = +25°, variation = +/- 10°
* Autumn
** light = 40%
** temperature @sea level = +15°, variation = +/- 5°
* Winter
** light = 30%
** temperature @sea level = 5°, variation = +/- 10°