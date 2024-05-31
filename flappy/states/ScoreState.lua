--[[
    ScoreState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    A simple state used to display the player's score before they
    transition back into the play state. Transitioned to from the
    PlayState when they collide with a Pipe.
]]

local bronzeMedal = love.graphics.newImage('medal-ribbon-bronze.png')
local silverMedal = love.graphics.newImage('medal-ribbon-silver.png')
local goldMedal = love.graphics.newImage('medal-ribbon-gold.png')

ScoreState = Class{__includes = BaseState}

--[[
    When we enter the score state, we expect to receive the score
    from the play state so we know what to render to the State.
]]
function ScoreState:enter(params)
    self.score = params.score
end

function ScoreState:update(dt)
    -- go back to play if enter is pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end

function ScoreState:render()
    -- simply render the score to the middle of the screen
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Oof! You lost!', 0, 32, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 68, VIRTUAL_WIDTH, 'center')

    if self.score > 20 then
        love.graphics.printf('Rank: GOLD', 0, 90, VIRTUAL_WIDTH, 'center')
        love.graphics.draw(goldMedal, (VIRTUAL_WIDTH - goldMedal:getWidth()) / 2, 104)
    elseif self.score > 10 then
        love.graphics.printf('Rank: SILVER', 0, 90, VIRTUAL_WIDTH, 'center')
        love.graphics.draw(silverMedal, (VIRTUAL_WIDTH - silverMedal:getWidth()) / 2, 104)
    else
        love.graphics.printf('Rank: BRONZE', 0, 90, VIRTUAL_WIDTH, 'center')
        love.graphics.draw(bronzeMedal, (VIRTUAL_WIDTH - bronzeMedal:getWidth()) / 2, 104)
    end

    love.graphics.printf('Press Enter to Play Again!', 0, 180, VIRTUAL_WIDTH, 'center')
end