
local composer = require( "composer" )

local scene = composer.newScene()

local physics = require( "physics" )
physics.start()


-----------------------------------------------------------------------------------------------------
------------------------------------------ monster sprite creation-----------------------------------
-----------------------------------------------------------------------------------------------------

local sheetOptionsMonster =
{
    width = 100,
    height = 100,
    numFrames = 7
}

local sequences_runningMonster = {
    -- first sequence 
	{
        name = "normalRun",
        start = 1,
        count = 7,
        time = 800,
        loopCount = 0
    },
    -- next sequence 
    {
        name = "fastRun",
        frames = { 1,5,7 },
        time = 400,
        loopCount = 0
    },
	--next sequence 
	{
        name = "jump",
        frames = { 7 },
        time = 400,
        loopCount = 0
    },

}

local sheet_runningMonster = graphics.newImageSheet( "monsterSprite.png", sheetOptionsMonster )

----------------------------------------------------------------------------------------------------
------------------------------------------ laser sprite creation------------------------------------
----------------------------------------------------------------------------------------------------

local sheetOptionsLaser =
{
    frames =
    {
        {   -- laser
            x = 98,
            y = 265,
            width = 7,
            height = 20
        },
    },
}

local sheet_laser = graphics.newImageSheet( "laser.png", sheetOptionsLaser )

----------------------------------------------------------------------------------------------------
------------------------------------------ enemy creation ------------------------------------------
----------------------------------------------------------------------------------------------------

local sheetOptionsEnemy =
{
    width = 587,
    height = 707,
    numFrames = 10,

	--sheetContentWidth = 2618,  -- width of original 1x size of entire sheet
    --sheetContentHeight = 1157  -- height of original 1x size of entire sheet
}

local sequences_Enemy = {
    -- first sequence 
        name = "normalRun",
		frames = { 5,4,3,1,7,8,10,9 },
        time = 1000,
        loopCount = 0,
		loopDirection = "forward"
}



local sheet_enemy = graphics.newImageSheet( "knight_sheet.png", sheetOptionsEnemy )

-----------------------------------------------------------------------------------------------------
------------------------------------------ variables ------------------------------------------------
-----------------------------------------------------------------------------------------------------


local lives = 1
local newScore = 0
local died = false
 
coinsTable = {}
enemyTable = {}
obstacleTable = {}


local enemyLoopTimer 
local runningMonster
local gameLoopTimer


local backGroup
local groundGroup
local mainGroup
local uiGroup

-----------------------------------------------------------------------------------------------------
-------------------------------------------- music & text  ------------------------------------------
-----------------------------------------------------------------------------------------------------


--game music
local backgroundMusic = audio.loadStream( "game.audio.wav")
 


--score text

local paint = {
    type = "gradient",
    color1 = { 0, 1, 0 },
    color2 = { 0, 1, 0.5, 0.2 },
    direction = "down"
}

local scoreText = display.newText(  "0000", display.contentCenterX-10, 15, "font.otf", 35 )
scoreText.fill = paint
 
local function lerp( v0, v1, t )
    return v0 + t * (v1 - v0)
end
 
local function incrementScore( target, amount, duration, startValue )
 
    newScore = startValue or 0
    local passes = (duration/1000) * display.fps
    local increment = lerp( 0, amount, 1/passes )
 
    local count = 0

    local function updateText(  )
        if ( lives >0  ) then
            newScore = newScore + increment
            target.text = string.format( "%04d", newScore )
            count = count + 1
        else
            Runtime:removeEventListener( "enterFrame", updateText )
			display.remove(scoreText)
        end
    end

	Runtime:addEventListener( "enterFrame", updateText )
 
end

function scoringUpdate()
	incrementScore( scoreText, 20000, 1800000 )
end


-----------------------------------------------------------------------------------------------------
-------------------------------------------- background ---------------------------------------------
-----------------------------------------------------------------------------------------------------

function update( event )
	updateBackgrounds()
	speed = speed + .05


end


function updateBackgrounds()
   
	--clouds background movement

   backgroundN1.x = backgroundN1.x - (speed/55)
   if(backgroundN1.x < -200) then
	  backgroundN1.x = 700
   end
   backgroundN2.x = backgroundN2.x - (speed/55)
   if(backgroundN2.x < -200) then
	   backgroundN2.x = 700
   end
   backgroundN3.x = backgroundN3.x - (speed/55)
   if(backgroundN3.x < -200) then
	   backgroundN3.x = 700
   end

	
   --Trees background movement
   backgroundA1.x = backgroundA1.x - (speed/20)
   if(backgroundA1.x < -200) then
      backgroundA1.x = 700
   end
	
   backgroundA2.x = backgroundA2.x - (speed/20)
   if(backgroundA2.x < -200) then
      backgroundA2.x = 700
   end

   backgroundA3.x = backgroundA3.x - (speed/20)
   if(backgroundA3.x < -200) then
      backgroundA3.x = 700
   end

end

-----------------------------------------------------------------------------------------------------
------------------------------------------ coin creation --------------------------------------------
-----------------------------------------------------------------------------------------------------


function createCoins()
	newCoin = display.newImageRect(mainGroup , "bitcoin.png" , 30 ,30)
	table.insert( coinsTable, newCoin )
	physics.addBody( newCoin, "dynamic", { radius=20 , bounce=0} )
	newCoin.myName = "coin"
	newCoin.objType = "coin"
	newCoin.gravityScale = 0


	local whereFrom = math.random(2,3)

    if(whereFrom == 3 ) then 
	    newCoin.x = display.contentWidth/2 +300
		newCoin.y = 30
	end

	if(whereFrom == 2 ) then 
	    newCoin.x = display.contentWidth/2 +300
		newCoin.y = 90
	end

	if(whereFrom == 1 ) then 
		newCoin.x = display.contentWidth/2 + 300
		newCoin.y = 290
	end
	
end
 

local function gameLoop() 
	createCoins()

	for i = #coinsTable, 1, -1 do
		local thisCoins =  coinsTable[i]

		transition.to(thisCoins , { time = 1500 - speed ,  x = display.contentWidth - display.contentWidth -150 } )

		if (thisCoins.x < -120  or thisCoins.y < -100 or thisCoins.y > display.contentHeight + 100) then
			display.remove(thisCoins)
			table.remove( coinsTable , i )
		end
	end
end

-----------------------------------------------------------------------------------------------------
------------------------------------------ enemy creation  ------------------------------------------
-----------------------------------------------------------------------------------------------------

function createEnemy()
	newEnemy = display.newSprite( mainGroup ,sheet_enemy  ,  sequences_Enemy)
	local enemyShape = { -20,-34 , 20,-34 , 22,40 , -22,40 }
	
	newEnemy:scale(0.125 , 0.125)
	table.insert( enemyTable, newEnemy )
	physics.addBody( newEnemy, "static", { shape = enemyShape ,  bounce=0.8 } )
	newEnemy.objType = "enemy"


	newEnemy.myName = "enemy"
	newEnemy.gravity =  0

	newEnemy.x = display.contentWidth/2 + 300
	newEnemy.y = 280	
end
 

local function enemyLoop() 
	createEnemy()

	newEnemy:setSequence("normalRun")
	newEnemy:play()

	for i = #enemyTable, 1, -1 do
		local thisEnemy =  enemyTable[i]

		transition.to(thisEnemy , { time = 2000 - speed ,  x = display.contentWidth - display.contentWidth -150 } )

		if (thisEnemy.x < -120  or thisEnemy.y < -100 or thisEnemy.y > display.contentHeight + 100) then
			display.remove(thisEnemy)
			table.remove( enemyTable , i )
		end
	end
end

--------------------------------------------------------------------------------------------------------
------------------------------------------ obstacle creation  ------------------------------------------
--------------------------------------------------------------------------------------------------------

function createObstacle()
	obstacle = display.newImage(mainGroup , "grassPlatform.png" , 50 ,15)
	obstacle2 = display.newImage(mainGroup , "grassPlatform.png" , 2,5 ,0,75)

	-- jumping sensor 
	local rectShape = {-52.5,-17.5, 52.5,-17.5,  -52.5,2.5 , 52.5,2.5}
	physics.addBody( obstacle, "static",
    { shape = rectShape, density=1.0, friction=0.3, bounce=0.2  } -- Main body element
	)

	-- collision sensor  
	local rectShape = {-55,-10.5, 48.5,-10.5,  -55.5,2.5 , 48.5,2.5}
	physics.addBody( obstacle2, "static",
    { shape = rectShape, density=1.0, friction=0.3, bounce=0.2  } -- Main body element
	)

	obstacle:scale( 0.5, 0.5 )
    table.insert( obstacleTable, obstacle )
	obstacle.objType = "obstacle"


    obstacle2:scale( 0.5, 0.5 )
    table.insert( obstacleTable, obstacle2 )
	obstacle2.objType = "leftVertex_obstacle"

	obstacle2.myName = "leftVertex_obstacle"
	obstacle2.gravity =  0

	obstacle.myName = "obstacle"
	obstacle.gravity =  0

	local whereFrom = math.random(2,3)

	if(whereFrom == 1 ) then 
		obstacle2.x = display.contentWidth/2 + 300
		obstacle2.y = 290
	end

	if(whereFrom == 2 ) then 
		obstacle.x = display.contentWidth/2 + 300
		obstacle.y = 230
		obstacle2.x = display.contentWidth/2 + 300
		obstacle2.y = 230
	end	

	if(whereFrom ==3 ) then 
		obstacle.x = display.contentWidth/2 + 300
		obstacle.y = 190
		obstacle2.x = display.contentWidth/2 + 300
		obstacle2.y = 190
	end	


end
 

local function obstacleLoop() 
	createObstacle()

	for i = #obstacleTable, 1, -1 do
		local thisObstacle =  obstacleTable[i]

		transition.to(thisObstacle , { time = 2000 - speed ,  x = display.contentWidth - display.contentWidth -150 } )

		if (thisObstacle.x < -120  or thisObstacle.y < -100 or thisObstacle.y > display.contentHeight + 100) then
			display.remove(thisObstacle)
			table.remove( obstacleTable , i )
		end
	end
end




-----------------------------------------------------------------------------------------------------
------------------------------------------ jump -----------------------------------------------------
-----------------------------------------------------------------------------------------------------

function jump(event)
	if ( event.phase == "began" and runningMonster.sensorOverlaps > 0 ) then
        if(event.x < 300  ) then
			local vx, vy = runningMonster:getLinearVelocity()
			runningMonster:setLinearVelocity( vx, 0 )
			runningMonster:applyLinearImpulse( 0, -55, runningMonster.x, runningMonster.y )
		end
	end
end


function sensorCollide( self, event )
 
    -- Confirm that the colliding elements are the foot sensor and a ground object
    if (  event.selfElement == 2 and ((event.other.objType == "ground") or (event.other.objType == "obstacle")) ) then
 
        -- Foot sensor has entered (overlapped) a ground object
        if ( event.phase == "began" ) then
            self.sensorOverlaps = self.sensorOverlaps + 1
        -- Foot sensor has exited a ground object
        elseif ( event.phase == "ended" ) then
            self.sensorOverlaps = self.sensorOverlaps - 1
        end
    end
end


 


-----------------------------------------------------------------------------------------------------
------------------------------------------ fire -----------------------------------------------------
-----------------------------------------------------------------------------------------------------


function fireLaser(event)
	if( lives == 1 ) then
		if(event.phase == "began") then 
			if(event.x > 301) then 
				
				local newLaser = display.newImageRect( mainGroup, sheet_laser , 1 , 7 , 14 )
				physics.addBody( newLaser, "dynamic", { isSensor=true } )
				newLaser.isBullet = true
				newLaser.myName = "laser"
	 
		
				newLaser.x = runningMonster.x
				newLaser.y = runningMonster.y
				
	
				transition.to( newLaser, { y=display.contentHeight - 30, time=500,
					onComplete = function() display.remove( newLaser ) end
				} )
	
			end
		end
	end
end



-----------------------------------------------------------------------------------------------------
------------------------------------------ collision ------------------------------------------------
-----------------------------------------------------------------------------------------------------


local function onGlobalCollision( event )
 
    if ( event.phase == "began" ) then
        print( "began: " .. event.object1.myName .. " and " .. event.object2.myName )
		if( (event.object1.myName == "monster") and ((event.object1.myName == "enemy") or (event.object1.myName== "obstacle")))then
			
		end
 
    elseif ( event.phase == "ended" ) then
        print( "ended: " .. event.object1.myName .. " and " .. event.object2.myName )
    end
end



function collision( event )

	if ( event.phase == "began" ) then

		local obj1 = event.object1
		local obj2 = event.object2

		if ( ( obj1.myName == "laser" and obj2.myName == "enemy" ) or
			 ( obj1.myName == "enemy" and obj2.myName == "laser" ) )
		then
			-- Remove both the laser and asteroid
			display.remove( obj1 )
			display.remove( obj2 )

			for i = #enemyTable, 1, -1 do
				if ( enemyTable[i] == obj1 or enemyTable[i] == obj2 ) then
					table.remove( enemyTable, i )
					break
				end
			end

			-- Increase score
			newScore = newScore + 1000
			scoreText.text = "Score: " .. newScore

		elseif ( ( obj1.myName == "monster" and obj2.myName == "enemy" ) or
				 ( obj1.myName == "enemy" and obj2.myName == "monster" ) )
		then
				if ( died == false ) then
					died = true
				
					-- Update lives
					lives = lives - 1
				
					if ( lives == 0 ) then
						display.remove( runningMonster )
						timer.performWithDelay(2000 , endGame(), 1)
					end
				end
		elseif ( ( obj1.myName == "monster" and obj2.myName == "leftVertex_obstacle" ) or
			     ( obj1.myName == "leftVertex_obstacle" and obj2.myName == "monster" ) )
        then
		        if ( died == false ) then
					died = true
					 -- Update lives
					 lives = lives - 1
					 
					 if ( lives == 0 ) then
						display.remove( runningMonster )
						timer.performWithDelay(2000 , endGame(), 1)
					end
				end
		
		elseif ( ( obj1.myName == "monster" and obj2.myName == "coin" ) or
				 ( obj1.myName == "coin" and obj2.myName == "monster" ) )
		then

			if(obj1.myName == "coin") then
				display.remove( obj1 )
			else
				display.remove( obj2)
			end

			for i = #coinsTable, 1, -1 do
				if ( coinsTable[i] == obj1 or coinsTable[i] == obj2 ) then
					table.remove( coinsTable, i )
					break
				end
			end

			-- Increase score
			newScore = newScore + 1000
			scoreText.text = "Score: " .. newScore
		end
	end
end


-----------------------------------------------------------------------------------------------------
------------------------------------------ end game  ------------------------------------------------
-----------------------------------------------------------------------------------------------------


function endGame()
	composer.setVariable( "finalScore", newScore )
    composer.gotoScene( "highscores_local", { time=800, effect="crossFade" } )
end


------------------------------------------ restart ------------------------------------------


local function restartGame()
end



-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	physics.pause()
	physics.setGravity( 0, 0)
	speed = 5


 
	-- group creations 
	backGroup = display.newGroup()  -- Display group for the background image
	sceneGroup:insert( backGroup ) 
	
	groundGroup = display.newGroup()  -- Display group for the ground image
	sceneGroup:insert( groundGroup ) 

	mainGroup = display.newGroup()  -- Display group for the monster,coins
	sceneGroup:insert( mainGroup ) 

	uiGroup = display.newGroup()    -- Display group for UI objects like the score
	sceneGroup:insert( uiGroup )   


	-- create the background
	local background = display.newImageRect( backGroup,"background.png",1500,1200 )

	ground = display.newImageRect( mainGroup, "upperGrass.jpg" , 1500 , 50)
	ground.x = contentCenterX
	ground.y = 340
	physics.addBody( ground, "static" , { friction = 0.3, bounce = 0.0 })
	ground.myName = "grass"
	ground.objType = "ground"

    backgroundN1 = display.newImageRect( backGroup,"nuvole.png" ,150,100)
    backgroundN1.x = 300
    backgroundN1.y = 80

    backgroundN2 = display.newImageRect( backGroup,"nuvole.png" ,150,100)
    backgroundN2.x = 80
    backgroundN2.y = 50

    backgroundN3 = display.newImageRect( backGroup,"nuvole.png" ,150,100)
    backgroundN3.x = 520
    backgroundN3.y = 50

    backgroundA1 = display.newImageRect( backGroup,"albero.png" ,120,175)
    backgroundA1.x = 100
    backgroundA1.y = 240

    backgroundA2 = display.newImageRect( backGroup,"albero.png" ,120,175)
    backgroundA2.x = 300
    backgroundA2.y = 240

	backgroundA3 = display.newImageRect( backGroup,"albero.png" ,120,175)
    backgroundA3.x = 500
    backgroundA3.y = 240


	--create the monster
    runningMonster = display.newSprite( mainGroup ,sheet_runningMonster  ,  sequences_runningMonster)
    runningMonster.x = 80
    runningMonster.y = ground.y - ground.height -40
	local monsterShape = {-28,-25 , 28,-25 , 28,50  , -28,50}
	physics.addBody( runningMonster, "dynamic",
    { shape = monsterShape, density=1.0, bounce=0.0 },  -- Main body element
    { box={ halfWidth=runningMonster.width/4, halfHeight=runningMonster.height/8, x=0, y=44 }, isSensor=true } -- Foot sensor element
)
	runningMonster.myName = "monster"
	runningMonster.isFixedRotation = true 
	runningMonster.sensorOverlaps = 0


	runningMonster:setSequence("normalRun")
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		
		
	elseif ( phase == "did" ) then
		--audio
		audio.play( backgroundMusic , { channel = 1 , loops = -1 })
		--physics
		physics.start()
		--physics.setDrawMode( "hybrid" )
		physics.setGravity(0,14)

		--background
		backMovement = timer.performWithDelay(1, update, -1)

		--scoringTimer =timer.performWithDelay(1,incrementScore( scoreText, 10000, 1800000 ))
		scoringTimer = timer.performWithDelay(1,scoringUpdate,1)

		--hero movement
		
		runningMonster.collision = sensorCollide
		runningMonster:addEventListener("collision")
		
		runningMonster:play()
		--hero function :jump / fire / double jump 
		Runtime:addEventListener("touch" , jump)
		Runtime:addEventListener( "touch", fireLaser )

		--collision
		collisionListener  = Runtime:addEventListener( "collision", collision )
		Runtime:addEventListener( "collision", onGlobalCollision )

		--coin/enemy creation/movement movement
		gameLoopTimer = timer.performWithDelay( 2800, gameLoop, -1 )
		enemyLoopTimer = timer.performWithDelay( 3300, enemyLoop, -1 )
		obstacleLoopTimer = timer.performWithDelay( 2500, obstacleLoop, -1 )

	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
		timer.cancel( gameLoopTimer )
		timer.cancel( obstacleLoopTimer )
		timer.cancel( enemyLoopTimer )
		timer.cancel( backMovement )
		audio.stop( 1 )

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
		Runtime:removeEventListener( "collision", onGlobalCollision )
		Runtime:removeEventListener( "collision", collision )
		Runtime:removeEventListener("touch" , jump)
		Runtime:removeEventListener( "touch", fireLaser )
		physics.pause()
		composer.removeScene( "game" )
		transition.pause()
	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	audio.dispose( backgroundMusic )
end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene

