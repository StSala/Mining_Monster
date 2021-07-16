



local sheetOptions =
{
    width = 100,
    height = 100,
    numFrames = 7
}

local sheet_runningMonster = graphics.newImageSheet( "monsterSprite.png", sheetOptions )

local sequences_runningMonster = {
    -- first sequence (consecutive frames)
    {
        name = "normalRun",
        start = 1,
        count = 7,
        time = 800,
        loopCount = 0
    },
    -- next sequence (non-consecutive frames)
    {
        name = "fastRun",
        frames = { 1,2,7 },
        time = 400,
        loopCount = 0
    },
}

runningMonster = display.newSprite(sheet_runningMonster  ,  sequences_runningMonster)
runningMonster.x = 100
runningMonster.y = 200


--rectangle used for our collision detection
--it will always be in front of the monster sprite
--that way we know if the monster hit into anything
local collisionRect = display.newRect(runningMonster.x + 45, runningMonster.y, 1, 70)
collisionRect.strokeWidth = 1
collisionRect:setFillColor(140, 0, 0)
collisionRect:setStrokeColor(180, 180, 180)
collisionRect.alpha = 100



-- sprite listener function
local function spriteListener( event )
 
    local thisSprite = event.target  -- "event.target" references the sprite
 
    if ( event.phase == "began" ) then 
        thisSprite:setSequence( "fastRun" )  -- switch to "fastRun" sequence
        thisSprite:play()  -- play the new sequence
    end
end
 
-- add the event listener to the sprite
runningMonster:addEventListener( "sprite", spriteListener )



local function update( event )
    runningMonster.play()

end