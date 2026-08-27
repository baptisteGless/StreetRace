local Road = {}
Road.__index = Road

function Road.new()

    local self = setmetatable({}, Road)

    self.image = love.graphics.newImage(
        "assets/background/route.png"
    )

    self.offset = 0
    
    -- Vitesse actuelle de défilement
    self.speed = 0

    -- Vitesse maximale de croisière
    self.targetSpeed = 800

    -- Accélération très rapide au départ
    self.acceleration = 2500

    return self
end

function Road:start()

    self.speed = 0
end

function Road:update(dt)

    -- Accélération vers la vitesse de croisière
    if self.speed < self.targetSpeed then

        self.speed = math.min(
            self.targetSpeed,
            self.speed + self.acceleration * dt
        )

    end

    -- Déplacement de la route
    self.offset = self.offset + self.speed * dt

end

function Road:getY()

    local screenHeight = love.graphics.getHeight()

    return screenHeight - self.image:getHeight()

end

function Road:draw()

    local width = self.image:getWidth()
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    local y = self:getY()

    local x = -(self.offset % width)

    while x < screenWidth do

        love.graphics.draw(
            self.image,
            x,
            y
        )

        x = x + width

    end

end

return Road