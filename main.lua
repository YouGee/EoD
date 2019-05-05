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
	io.write("Dir save is: ",love.filesystem.getSaveDirectory(),"\n")

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

    -- Display our sexy icon
    local imageData = love.image.newImageData('EoD.png')
    success = love.window.setIcon(imageData)

    x, y, w, h = 20, 20, 60, 20

	-- And God creates the world
	world = {}

	-- Let's create things
	terraform()
end
 
-- Update (every frame)
function love.update(dt)
    w = w + 1
    h = h + 1
end
 
-- Draw (every frame)
function love.draw()
    love.graphics.setColor(0/255, 100/255, 100/255)
    love.graphics.rectangle("fill", x, y, w, h)
end

-- Keyboard
function love.keypressed(key)
  -- no far, nothing
end

-- Terraforming algorithm
function terraform()

	print('Now terraforming...')
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
    	listOfSummits[i] = sumXcoord..","..sumYcoord
    end
    
    print('Our summits are: ')
    for i=1,table.getn(listOfSummits) do
    	print(listOfSummits[i])
    end
    print("\n")

	displayWorld()
    
    -- Altitude semi-randomized propagation around the previous summits
	for i=1,table.getn(listOfSummits) do
		for sumXcoord,sumYcoord in string.gmatch(listOfSummits[i],"(%d+),(%d+)") do
			io.write("\nTerraforming around summit ",i," (",sumXcoord,",",sumYcoord,")\n")
			myNeighbors = neighborhood(sumXcoord,sumYcoord,world_dimension_width,world_dimension_height)
			nbOfNeighbors = table.getn(myNeighbors)
			print("\tMy ",nbOfNeighbors," neighbors are:")
			for n=1,nbOfNeighbors do
				neiXcoord = myNeighbors[n][1]
				neiYcoord = myNeighbors[n][2]
				io.write("\t\t",n,": ",neiXcoord,",",neiYcoord,"\n")
			end
		end
	end

	displayWorld()
    print('Terraforming done!')
end

function displayWorld()
	-- Display world
    print('\nOur world looks like this:\n')
    for j=1,world_dimension_height do
    	io.write("\t")
    	for i=1,world_dimension_width do
    		io.write(string.format("%03d",world[i][j]), " ")
    	end
    	io.write("\n")
    end
	io.write("\n")
end

function neighborhood(x,y,xmax,ymax)
	-- Returns the 2, 3 of 4 points around x,y on a (1,1)...(xmax,ymax) grid
	if ((x == 1) and (y == 1)) then
		return {{x+1,y},{x,y+1}}
	end
	if ((x == xmax) and (y == 1)) then
		return {{x-1,y},{x,y+1}}
	end
	if ((x == 1) and (y == ymax)) then
		return {{x-1,y},{x,y-1}}
	end
	return {{x-1,y},{x,y+1},{x,y-1},{x+1,y}}
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