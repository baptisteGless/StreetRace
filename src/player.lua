local Player = {}
Player.__index = Player

function Player.new(config, y)

    local self = setmetatable({}, Player)

    self.body = love.graphics.newImage(config.body)
    self.wheel = love.graphics.newImage(config.wheel)
    self.undercarriage = love.graphics.newImage(config.undercarriage)

    self.baseX = 150
    self.x = self.baseX
    self.displayX = self.baseX
    self.y = y
    self.engineTime = 0

    self.raceIsStarted = false

    self.distance = 0
    self.targetDistance = 0

    -- rotation roues
    self.rotation = 0
    self.rotationSpeed = 0
    self.targetRotationSpeed = 0

    -- boost temporaire QTE
    self.rotationBoost = 0
    self.speedBoost = 0

    self.scale = config.scale
    self.wheelScale = config.wheelScale

    self.frontWheelX = config.frontWheel[1]
    self.wheelY = config.frontWheel[2]

    self.rearWheelX = config.rearWheel[1]

    self.undercarriageScale = config.undercarriageScale
    self.undercarriageOffsetY = config.undercarriageOffsetY

    return self

end

function Player:startRace()

    self.rotationSpeed = 0
    self.targetRotationSpeed = 80

    self.engineTime = love.math.random() * math.pi * 2

    self.targetDistance = 100
    
end

function Player:update(dt)

    if self.rotationSpeed < self.targetRotationSpeed then

        self.rotationSpeed =
            math.min(
                self.targetRotationSpeed,
                self.rotationSpeed + 250 * dt
            )

    end

    if self.raceIsStarted == true then 
        self.engineTime = self.engineTime + dt * 14
    end

    -- Déplacement vers la distance cible
    if self.distance < self.targetDistance then

        local speed = 300

        local movement =
            math.min(
                self.targetDistance - self.distance,
                speed * dt
            )

        self.distance =
            self.distance + movement

    end

    -- rotation des roues
    self.rotation = self.rotation + ( self.rotationSpeed + self.rotationBoost ) * dt

    -- diminution du boost des roues
    if self.rotationBoost > 0 then

        self.rotationBoost = math.max( 0, self.rotationBoost - 120 * dt )

    end

end

function Player:accelerate()

    self.distance = self.distance + 200

    self.rotationBoost = 22

end

function Player:draw()

    local engineShake = math.sin(self.engineTime) * 2

    love.graphics.draw(
        self.undercarriage,
        self.displayX + engineShake,
        self.y + self.undercarriageOffsetY,
        0,
        self.undercarriageScale,
        self.undercarriageScale
    )

    love.graphics.draw(
        self.wheel,
        self.displayX + engineShake + self.frontWheelX * self.scale,
        self.y + self.wheelY * self.scale,
        self.rotation,
        self.wheelScale,
        self.wheelScale,
        self.wheel:getWidth()/2,
        self.wheel:getHeight()/2
    )

    love.graphics.draw(
        self.wheel,
        self.displayX + engineShake + self.rearWheelX * self.scale,
        self.y + self.wheelY * self.scale,
        self.rotation,
        self.wheelScale,
        self.wheelScale,
        self.wheel:getWidth()/2,
        self.wheel:getHeight()/2
    )

    love.graphics.draw(
        self.body,
        self.displayX + engineShake,
        self.y,
        0,
        self.scale,
        self.scale
    )

end

return Player