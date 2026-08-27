local Background = {}
Background.__index = Background

function Background.new()
    local self = setmetatable({}, Background)

    self.sky = love.graphics.newImage("assets/background/sky.png")

    self.city = love.graphics.newImage("assets/background/city.png")

    self.sun = love.graphics.newImage("assets/background/sun.png")

    self.plane = love.graphics.newImage("assets/background/plane.png")

    self.planeScale = 0.35
    self.planeDelay = 10
    self.planeDuration = 12
    self.planeTimer = 0
    self.planeStarted = false
    self.planeFinished = false
    self.planeStartX = 0
    self.planeStartY = 0
    self.planeEndX = 0
    self.planeEndY = 0
    self.planeControlX = 0
    self.planeControlY = 0

    self.sunScale = 0.38
    self.sunX = 850
    self.sunStartY = 80
    self.sunY = self.sunStartY
    self.sunTargetY = 400
    self.sunsetDuration = 180 -- 3 minutes
    self.sunsetTimer = 0

    self.skyScale = 0.6 
    
    self.cityScale = 0.55

    self.speed = 12

    self.offset = 0
   
    return self
end

function Background:startPlane()

    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    local planeWidth = self.plane:getWidth() * self.planeScale

    local planeHeight = self.plane:getHeight() * self.planeScale

    -- Entre par la droite
    self.planeStartX = screenWidth + planeWidth

    self.planeStartY = screenHeight * 0.45

    -- Sort par le haut
    self.planeEndX = -planeWidth

    self.planeEndY = -planeHeight

    self.planeControlX = screenWidth * 0.55

    self.planeControlY = screenHeight * 0.20

    self.planeStarted = true

end

function Background:update(dt)
    self.offset = self.offset + self.speed * dt
    local width = self.city:getWidth() * self.cityScale

    if self.offset >= width then
        self.offset = self.offset - width
    end

    if self.sunsetTimer < self.sunsetDuration then

        self.sunsetTimer = self.sunsetTimer + dt

        local progress = self.sunsetTimer / self.sunsetDuration

        if progress > 1 then
            progress = 1
        end

        self.sunY = self.sunStartY + (self.sunTargetY - self.sunStartY) * progress
    end

    if not self.planeFinished then

        self.planeTimer = self.planeTimer + dt

        if not self.planeStarted and self.planeTimer >= self.planeDelay then

            self:startPlane()

            self.planeTimer = 0

        end

        -- Animation de l'avion
        if self.planeStarted then

            local progress = self.planeTimer / self.planeDuration

            if progress >= 1 then

                progress = 1
                self.planeFinished = true

            end

            -- Courbe douce
            local x = (1 - progress) * (1 - progress) * self.planeStartX + 2 * (1 - progress) * progress * self.planeControlX + progress * progress * self.planeEndX

            local y = (1 - progress) * (1 - progress) * self.planeStartY + 2 * (1 - progress) * progress * self.planeControlY + progress * progress * self.planeEndY

            self.planeX = x
            self.planeY = y

        end

    end

end

function Background:draw()
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    local skyWidth = self.sky:getWidth() * self.skyScale 
    local skyHeight = self.sky:getHeight() * self.skyScale

    love.graphics.draw(
        self.sky,
        0,
        0,
        0, 
        self.skyScale, 
        self.skyScale
    )

    love.graphics.draw(
        self.sun,
        self.sunX,
        self.sunY,
        0,
        self.sunScale,
        self.sunScale
    )

    if self.planeStarted and not self.planeFinished then

        love.graphics.draw(
            self.plane,
            self.planeX,
            self.planeY,
            0,
            self.planeScale,
            self.planeScale
        )

    end

    local cityWidth = self.city:getWidth() * self.cityScale

    local cityY = -100

    love.graphics.draw(
        self.city,
        -self.offset,
        cityY,
        0,
        self.cityScale,
        self.cityScale
    )

    love.graphics.draw(
        self.city,
        -self.offset + cityWidth,
        cityY, 0, self.cityScale,
        self.cityScale
    )

    if -self.offset + cityWidth < screenWidth then
        love.graphics.draw(
            self.city,
            -self.offset + cityWidth * 2,
            cityY,
            0,
            self.cityScale,
            self.cityScale
        )
    end
end

return Background