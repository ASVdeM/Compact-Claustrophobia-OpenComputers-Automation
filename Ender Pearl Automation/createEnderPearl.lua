local robot = require ("robot")

function moveLeft ()
	robot.turnLeft ()
	robot.forward ()
	robot.turnRight ()
end

function moveRight ()
	robot.turnRight ()
	robot.forward ()
	robot.turnLeft ()
end


function findObsidianSlot ()
	local slot = 1
	while robot.count (slot) == 0 and slot <= 14 do
		slot = slot + 1
	end
	
	if slot > 14 then
		return 1
	end
	
	return slot
end


function placeObsidian ()
	while robot.count () == 0  and robot.select () <= 14 do
		local nextSlot = robot.select () + 1
		robot.select (nextSlot)
	end
	if robot.select () > 14 then
		robot.select (1)
		print ("YOU HAVE RUN OUT OF OBSIDIAN!!!!")
	end
	robot.place ()
end


function placeObsidianRow ()
	for x = 0, 1 do
		placeObsidian ()
		moveLeft ()
	end
	placeObsidian ()
	robot.back ()
end

function getIntoInitialPosition ()
	for x = 0, 2 do
		robot.forward ()
	end
	moveRight ()
end

function getIntoNextRowPosition ()
	robot.turnRight ()
	for x = 0, 1 do
		robot.forward ()
	end
	robot.turnLeft ()
end

function placeObsidianLayer ()	
	for x = 0, 2 do
		placeObsidianRow ()
		getIntoNextRowPosition ()
	end
end

function placeRedstoneRow ()
	
	placeObsidian ()
	moveLeft ()
	
	robot.select (15)
	robot.place ()
	robot.select (findObsidianSlot ())
	moveLeft ()
	
	placeObsidian ()
	robot.back ()	
end

function placeRedstoneLayer ()
	for x = 0, 2 do
		if x ~= 1 then
			placeObsidianRow ()
		else
			placeRedstoneRow ()
		end
		getIntoNextRowPosition ()
	end
end

function sleep (n)
	--copied from http://lua-users.org/wiki/SleepFunction
	local t0 = os.clock ()
	while os.clock () - t0 <= n do
	end
end



local amount = math.min (34, robot.count (15))

for x = 1, amount do
	for x = 0, 2 do
		getIntoInitialPosition ()
		if x ~= 1 then
			placeObsidianLayer ()
		else
			placeRedstoneLayer ()
		end
		moveLeft ()
		robot.up ()
	end


	robot.select (16)
	robot.drop (1)
	robot.select (findObsidianSlot ())

	for x = 0, 2 do
		robot.down ()
	end
	robot.back ()
	sleep (3)
end
