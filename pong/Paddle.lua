--[[
    GD50 2018
    Pong Remake

    -- Paddle Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents a paddle that can move up and down. Used in the main
    program to deflect the ball back toward the opponent.
]]

PADDING = 10

Paddle = Class{}

--[[
    The `init` function on our class is called just once, when the object
    is first created. Used to set up all variables in the class and get it
    ready for use.

    Our Paddle should take an X and a Y, for positioning, as well as a width
    and height for its dimensions.

    Note that `self` is a reference to *this* object, whichever object is
    instantiated at the time this function is called. Different objects can
    have their own x, y, width, and height values, thus serving as containers
    for data. In this sense, they're very similar to structs in C.
]]
function Paddle:init(x, y, width, height, upButtons, downButtons, isPlayable)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.dy = 0
    self.upButtons = upButtons
    self.downButtons = downButtons
    self.isPlayable = isPlayable
end

function Paddle:update(dt)
    -- math.max here ensures that we're the greater of 0 or the player's
    -- current calculated Y position when pressing up so that we don't
    -- go into the negatives; the movement calculation is simply our
    -- previously-defined paddle speed scaled by dt
    if self.dy < 0 then
        self.y = math.max(0, self.y + self.dy * dt)
    -- similar to before, this time we use math.min to ensure we don't
    -- go any farther than the bottom of the screen minus the paddle's
    -- height (or else it will go partially below, since position is
    -- based on its top left corner)
    else
        self.y = math.min(VIRTUAL_HEIGHT - self.height, self.y + self.dy * dt)
    end
end

--[[
    To be called by our main function in `love.draw`, ideally. Uses
    LÖVE2D's `rectangle` function, which takes in a draw mode as the first
    argument as well as the position and dimensions for the rectangle. To
    change the color, one must call `love.graphics.setColor`. As of the
    newest version of LÖVE2D, you can even draw rounded rectangles!
]]
function Paddle:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end


--[[
    Function to handle movement depending on whether the Paddle is controlled
    by the player or automated.
]]
function Paddle:handleMovement(gameState, ball, difficulty)
    if self.isPlayable then
        self:handlePlayerMovement()
    else
        self:handleNPCMovement(gameState, ball, difficulty)
    end
end


--[[
    Check if any of the up/down buttons for this paddle has been triggered
    and move the paddle upwards or downwards accordingly.
]]
function Paddle:handlePlayerMovement()
    isMovingUp = false
    for i, upButton in pairs(self.upButtons) do
        if love.keyboard.isDown(upButton) then
            isMovingUp = true
            break
        end
    end

    isMovingDown = false
    for i, downButton in pairs(self.downButtons) do
        if love.keyboard.isDown(downButton) then
            isMovingDown = true
            break
        end
    end

    if isMovingUp then
        self.dy = -PADDLE_SPEED
    elseif isMovingDown then
        self.dy = PADDLE_SPEED
    else
        self.dy = 0
    end

end


--[[
    Calculate whether the paddle should move up or down depending on its
    position relative to the ball.
]]
function Paddle:handleNPCMovement(gameState, ball, difficulty)
    if gameState == "play" then
        errorChance = math.random(1000)
        doNothingChance = math.random(1000)

        if ball.y + ball.height > self.y + self.height then
            correctVelocity = PADDLE_SPEED
        elseif ball.y + ball.height < self.y then
            correctVelocity = -PADDLE_SPEED
        else
            correctVelocity = 0
        end

        isBallTowardsSelf = (ball.dx < 0 and self.x == 0 + PADDING) or (ball.dx > 0 and self.x == VIRTUAL_WIDTH - PADDING)
        if difficulty == DIFFICULTIES.EASY then
            shouldMove = doNothingChance < 700 and isBallTowardsSelf
            shouldError = errorChance < 200
        elseif difficulty == DIFFICULTIES.NORMAL then
            shouldMove = doNothingChance < 800 and isBallTowardsSelf
            shouldError = errorChance < 100
        elseif difficulty == DIFFICULTIES.HARD then
            shouldMove = doNothingChance < 800
            shouldError = errorChance < 100
        elseif difficulty == DIFFICULTIES.IMPOSSIBLE then
            shouldMove = true
            shouldError = false
        end

        if not shouldMove then
            self.dy = 0
        elseif shouldError then
            self.dy = -correctVelocity
        else
            self.dy = correctVelocity
        end
    else
        self.dy = 0
    end
end
