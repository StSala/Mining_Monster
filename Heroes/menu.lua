

local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local function gotoGame()
	composer.gotoScene( "game", { time=500, effect="crossFade" } )
end

local function gotoHighScores()
	composer.gotoScene( "highscores_local", { time=500, effect="crossFade" } )
end


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen

	local background = display.newImageRect(sceneGroup, "background.png", 700 ,1000 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY

    local backgroundM = display.newImageRect(sceneGroup, "monsterBack.png", 100 , 100 )
	backgroundM.x = display.contentCenterX -180
	backgroundM.y = display.contentCenterY -70

	local backgroundCoin = display.newImageRect(sceneGroup , "bitcoin.png" , 50 , 50 )
	backgroundCoin.x = display.contentCenterX + 170
	backgroundCoin.y = display.contentCenterY - 60

	local title = display.newImageRect( sceneGroup, "title.png", 500, 150 )
	title.x = display.contentCenterX
	title.y = display.contentCenterY

	local playButton = display.newImageRect(sceneGroup, "playButton.png", 150, 100 )
	playButton.x = display.contentCenterX -100
	playButton.y = display.contentCenterY +100

	local scoreButton = display.newImageRect(sceneGroup, "scoreButton.png", 150 ,100 )
	scoreButton.x = display.contentCenterX +100
	scoreButton.y = display.contentCenterY +100

	playButton:addEventListener( "tap", gotoGame )
	scoreButton:addEventListener( "tap", gotoHighScores )
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen

	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen

	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

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
