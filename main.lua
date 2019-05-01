-- EoD Alpha 1.0.0
-- (c)UG 2018

version = 'Alpha 1.0.0'
suit = require 'suit'
require('parameters')


-- Init
function love.load()
    x, y, w, h = 20, 20, 60, 20
    local imageData = love.image.newImageData('EoD.png')
    success = love.window.setIcon(imageData)
    print(success)
end
 
-- Update (every frame)
function love.update(dt)
    w = w + 1
    h = h + 1
end
 
-- Draw (every frame)
function love.draw()
    love.graphics.setColor(0, 100, 100)
    love.graphics.rectangle("fill", x, y, w, h)
end

-- Keyboard
function love.keypressed(key)
  
end

-- Terraforming algorithm
function terraform()
	-- and God creates the world
	world = {}

	-- at the beginning, everything was flat
	local i,j
	for i=1,world_imension_width do
     	world[i] = {}     -- create a new row
     	for j=1,world_dimension_height do
    		world[i][j] = 0
    	end
    end
	
	--[[ montagnes
	1 trouver le nombre et l'emplacement des sommets
	2 tracer un nombre de lignes "crest" de longueurs aléatoires issues du sommet
	3 tracer un nombre égal de lignes "talweg" intercalées de longueurs aléatoires issues du sommet
	4 les angles entre 2 crests sont aléatoires
	5 les angles entre une talweg et deux crests sont aléatoires
	6 sur chaque ligne on détermine les points des courbes de niveaux
	7 on trace les courbes de niveaux passant par tous les points de même altitude
	--]]
end