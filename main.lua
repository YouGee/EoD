-- EoD Alpha 0.0.1
-- (c)UG 2018

suit = require 'suit'
require('parameters')


-- Init
function love.load()

    -- temporary stuff :)
	local major, minor, revision, codename = love.getVersion()
    local str = string.format("Version %d.%d.%d", major, minor, revision)
    io.write("We are running ",_VERSION," and LOVE ",str,"\n")

	--create/open database
	require('sqlite3')
	local hDB = sqlite3.open("EoD.db")
	if hDB then
		mystamp = os.date("Last launch was %c")
		print(mystamp)
		local sQuery = "UPDATE witness SET launchtime = '"..mystamp.."';"
		hDB:execute(sQuery)
		hDB:close()
	end

    -- Log file creation
    file = io.open("EoD_log.txt", "w")
    io.output(file)

	-- And God creates the world
	world = {}

	-- Let's create things
	terraform()

    -- Render terrain into a canvas, point per point
    canvas = love.graphics.newCanvas(800, 600)
    love.graphics.setCanvas(canvas)
    love.graphics.clear()
    love.graphics.setBlendMode("alpha")
    love.graphics.scale(2,2)
    for j=1,world_dimension_height do
        for i=1,world_dimension_width do
            io.write("Drawing point (",i*5,",",j*5,"), altitude ",world[i][j]," with color ")
            myColor = altitudeToColor(world[i][j])
            love.graphics.rectangle("fill",i*5,j*5,4,4)
        end
        io.write("\n")
    end
    love.graphics.setCanvas()

    io.close(file)
    print("Load is done")
end
 
-- Update (every frame)
function love.update(dt)

end
 
-- Draw (every frame)
function love.draw()
--[[    love.graphics.setColor(0/255, 100/255, 100/255)
    love.graphics.rectangle("fill", x, y, w, h)--]]

    -- World graphical display
    love.graphics.draw(canvas)
end

-- Keyboard
function love.keypressed(key)
  -- no far, nothing
end

-- Terraforming algorithm
function terraform()

	io.write('Now terraforming...')
	-- at the beginning, everything was flat
	local i,j
	for i=1,world_dimension_width do
     	world[i] = {}     -- create a new line
     	for j=1,world_dimension_height do
    		world[i][j] = 0 -- and a new column with a flat point
    	end
    end


    -- and light green
    love.graphics.setColor(ColorLightGreenR/255, ColorLightGreenG/255, ColorLightGreenB/255)

    -- Create the summits
    math.randomseed(os.time())
    NumberOfSummits = math.random(world_config_mountains_minimum_number,world_config_mountains_maximum_number)
    io.write("\tSo there'll be ",NumberOfSummits," summits\n")
    listOfSummits = {}
    for i=1,NumberOfSummits do
    	sumXcoord = math.random(1,world_dimension_width)	-- X summit coord is ramdomly chosen on the map
    	sumYcoord = math.random(1,world_dimension_height)	-- Y summit coord is ramdomly chosen on the map
    	sumAltitude = math.random(world_config_mountains_dimension_min,world_config_mountains_dimension_max) -- so is its altitude
    	world[sumXcoord][sumYcoord] = sumAltitude
    	io.write("\tSummit ",i," is located ",sumXcoord,":",sumYcoord," and is ",sumAltitude," high.\n")
        listOfSummits[i] = {}
    	listOfSummits[i][1] = sumXcoord
        listOfSummits[i][2] = sumYcoord
    end
    
    io.write('Our summits are: ')
    for i=1,table.getn(listOfSummits) do
    	io.write(i,": ",listOfSummits[i][1],",",listOfSummits[i][2],"\n")
    end
    io.write("\n")

	displayWorld()
    
    -- Altitude semi-randomized propagation around the previous summits
	for i=1,table.getn(listOfSummits) do

        sumXcoord = listOfSummits[i][1]
        sumYcoord = listOfSummits[i][2]
        myAltitude = world[sumXcoord][sumYcoord]
        io.write("\nTerraforming around summit ",i," (",sumXcoord,",",sumYcoord,") altitude ",myAltitude,"\n")

        -- adjacents points: N, E, S and W
		myAdjNeighbors = adjneighborhood(sumXcoord,sumYcoord,world_dimension_width,world_dimension_height)
		nbOfNeighbors = table.getn(myAdjNeighbors)
		io.write("\tMy ",nbOfNeighbors," adjacent neighbors are:\n")
		for n=1,nbOfNeighbors do
			neiXcoord = myAdjNeighbors[n][1]
			neiYcoord = myAdjNeighbors[n][2]
            io.write("\t\t",n,": ",neiXcoord,",",neiYcoord," new altitude: ")
            newAltitude = math.floor(math.random(world_config_mountains_minpercent_adj_point*myAltitude/100,world_config_mountains_maxpercent_adj_point*myAltitude/100)) -- new random lower altitude
            if (world[neiXcoord][neiYcoord] == 0) then
                world[neiXcoord][neiYcoord] = newAltitude
                io.write(world[neiXcoord][neiYcoord]," previous was 0\n")
            else
                world[neiXcoord][neiYcoord] = math.floor((world[neiXcoord][neiYcoord]+newAltitude)/2)
                io.write(world[neiXcoord][neiYcoord]," as an average with previous altitude\n")
            end
		end

        -- diagonal points: NE, SE, SW and NW
		myDiagNeighbors = diagneighborhood(sumXcoord,sumYcoord,world_dimension_width,world_dimension_height)
		nbOfNeighbors = table.getn(myDiagNeighbors)
		io.write("\tMy ",nbOfNeighbors," diagonal neighbors are:\n")
		for n=1,nbOfNeighbors do
			neiXcoord = myDiagNeighbors[n][1]
			neiYcoord = myDiagNeighbors[n][2]
            io.write("\t\t",n,": ",neiXcoord,",",neiYcoord," new altitude: ")
            newAltitude = math.floor(math.random(world_config_mountains_minpercent_diag_point*myAltitude/100,world_config_mountains_maxpercent_diag_point*myAltitude/100)) -- new random lower altitude
            if (world[neiXcoord][neiYcoord] == 0) then
                world[neiXcoord][neiYcoord] = newAltitude
                io.write(world[neiXcoord][neiYcoord]," previous was 0\n")
            else
                world[neiXcoord][neiYcoord] = math.floor((world[neiXcoord][neiYcoord]+newAltitude)/2)
                io.write(world[neiXcoord][neiYcoord]," as an average with previous altitude\n")
            end
		end
	end

	displayWorld()
    io.write('Terraforming done!')
end

function displayWorld()
	-- Display world
    io.write('\nOur world looks like this:\n')
    for j=1,world_dimension_height do
    	io.write("\t")
    	for i=1,world_dimension_width do
    		io.write(string.format("%03d",world[i][j]), " ")
    	end
    	io.write("\n")
    end
	io.write("\n")
end

function altitudeToColor (altitude)
    --- Gets the correct color for a given altitude
    if (altitude >= 0) then
        -- we"re above sea level here
        heightPercentage = altitude/world_config_mountains_dimension_max
        color={}
        color.R = round((ColorLightGreenR+((ColorDarkGreenR-ColorLightGreenR)*heightPercentage)) /255,3)
        color.G = round((ColorLightGreenG+((ColorDarkGreenG-ColorLightGreenG)*heightPercentage)) /255,3)
        color.B = round((ColorLightGreenB+((ColorDarkGreenB-ColorLightGreenB)*heightPercentage)) /255,3)
        io.write(color.R,",",color.G,",",color.B,"\n")
        return {color.R,color.G,color.B}
    else
        -- wet feet!
        return{128/255,159/255,255/255} -- lets be statically blue for now
    end
end


function adjneighborhood(x,y,xmax,ymax)
	-- Returns the 2, 3 of 4 points sticking x,y on a (1,1)...(xmax,ymax) grid
    
    -- point is one corner?
    if ((x==1) and (y==1)) then
        return {{1,2},{2,1}}
    end
    if ((x==1) and (y==ymax)) then
        return {{1,ymax-1},{2,ymax}}
    end
    if ((x==xmax) and (y==1)) then
        return {{xmax-1,1},{xmax,2}}
    end
    if ((x==xmax) and (y==ymax)) then
        return {{xmax,ymax-1},{xmax-1,ymax}}
    end

    -- point is far W
    if (x==1) then
        return {{1,y-1},{1,y+1},{2,y}}
    end
    -- point is far E
    if (x==xmax) then
        return {{xmax,y-1},{xmax,y+1},{xmax-1,y}}
    end
    -- point is far N
    if (y==1) then
        return {{x-1,1},{x+1,1},{x,2}}
    end
    -- point is far S
    if (y==ymax) then
        return {{x-1,ymax},{x+1,ymax},{x,ymax-1}}
    end
    
    -- point is not borderline
    return {{x-1,y},{x,y+1},{x,y-1},{x+1,y}}
end

function diagneighborhood(x,y,xmax,ymax)
	-- Returns the 2, 3 of 4 points in the corners of x,y on a (1,1)...(xmax,ymax) grid
    
    -- point is one corner?
    if ((x ==1) and (y==1)) then
        return {{2,2}}
    end
    if ((x ==1) and (y==ymax)) then
        return {{2,ymax-1}}
    end
    if ((x ==xmax) and (y==1)) then
        return {{xmax-1,2}}
    end
    if ((x ==xmax) and (y==ymax)) then
        return {{xmax-1,ymax-1}}
    end

    -- point is far W
    if (x == 1) then
        return {{2,y-1},{2,y+1}}
    end
    -- point is far E
    if (x == xmax) then
        return {{xmax-1,y-1},{xmax-1,y+1}}
    end
    -- point is far N
    if (y == 1) then
        return {{x-1,2},{x+1,2}}
    end
    -- point is far S
    if (y == ymax) then
        return {{x-1,ymax-1},{x+1,ymax-1}}
    end
    
    -- point is not borderline
    return {{x-1,y-1},{x-1,y+1},{x+1,y-1},{x+1,y+1}}
end

function print_table(node)
    -- to make output beautiful
    local function tab(amt)
        local str = ""
        for i=1,amt do
            str = str .. "\t"
        end
        return str
    end

    local cache, stack, output = {},{},{}
    local depth = 1
    local output_str = "{\n"

    while true do
        local size = 0
        for k,v in pairs(node) do
            size = size + 1
        end

        local cur_index = 1
        for k,v in pairs(node) do
            if (cache[node] == nil) or (cur_index >= cache[node]) then

                if (string.find(output_str,"}",output_str:len())) then
                    output_str = output_str .. ",\n"
                elseif not (string.find(output_str,"\n",output_str:len())) then
                    output_str = output_str .. "\n"
                end

                -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
                table.insert(output,output_str)
                output_str = ""

                local key
                if (type(k) == "number" or type(k) == "boolean") then
                    key = "["..tostring(k).."]"
                else
                    key = "['"..tostring(k).."']"
                end

                if (type(v) == "number" or type(v) == "boolean") then
                    output_str = output_str .. tab(depth) .. key .. " = "..tostring(v)
                elseif (type(v) == "table") then
                    output_str = output_str .. tab(depth) .. key .. " = {\n"
                    table.insert(stack,node)
                    table.insert(stack,v)
                    cache[node] = cur_index+1
                    break
                else
                    output_str = output_str .. tab(depth) .. key .. " = '"..tostring(v).."'"
                end

                if (cur_index == size) then
                    output_str = output_str .. "\n" .. tab(depth-1) .. "}"
                else
                    output_str = output_str .. ","
                end
            else
                -- close the table
                if (cur_index == size) then
                    output_str = output_str .. "\n" .. tab(depth-1) .. "}"
                end
            end

            cur_index = cur_index + 1
        end

        if (size == 0) then
            output_str = output_str .. "\n" .. tab(depth-1) .. "}"
        end

        if (#stack > 0) then
            node = stack[#stack]
            stack[#stack] = nil
            depth = cache[node] == nil and depth + 1 or depth - 1
        else
            break
        end
    end

    -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
    table.insert(output,output_str)
    output_str = table.concat(output)

    print(output_str)
end

function round(num, numDecimalPlaces)
  return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end