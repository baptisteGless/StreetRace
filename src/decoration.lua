local Decoration = {}
Decoration.__index = Decoration

function Decoration.new()

    local self = setmetatable({}, Decoration)

    self.images = {
        love.graphics.newImage("assets/background/palmier1.png"),
        love.graphics.newImage("assets/background/palmier2.png"),
        love.graphics.newImage("assets/background/palmier3.png")
    }

    self.palms = {}

    -- Temps avant le prochain palmier
    self.spawnTimer = 0

    return self
end

function Decoration:start()

    self.palms = {}
    self.spawnTimer = 1
end

function Decoration:update(dt, speed, groundY)

    -- Déplacement des palmiers
    for i = #self.palms, 1, -1 do

        local palm = self.palms[i]

        palm.x = palm.x - speed * dt

        -- Supprime le palmier lorsqu'il sort de l'écran
        if palm.x + palm.width < 0 then
            table.remove(self.palms, i)
        end

    end

    -- Gestion de l'apparition des palmiers
    self.spawnTimer = self.spawnTimer - dt

    if self.spawnTimer <= 0 then

        self:spawn(groundY + 58)

        -- Entre 1 et 3 secondes avant le prochain
        self.spawnTimer = love.math.random(10, 30) / 10

    end

end

function Decoration:spawn(groundY)

    local topIndex = love.math.random(#self.images)

    local bottomIndex = love.math.random(#self.images)

    -- Empêche d'avoir deux fois le même palmier
    while bottomIndex == topIndex do
        bottomIndex = love.math.random(#self.images)
    end

    local scale = 0.6

    -- Palmier du haut
    local topImage = self.images[topIndex]

    local topWidth = topImage:getWidth() * scale
    local topHeight = topImage:getHeight() * scale

    local topPalm = {
        image = topImage,

        x = love.graphics.getWidth(),

        -- Le bas du palmier touche le haut de la route
        y = groundY - topHeight,

        scale = scale,

        width = topWidth,
        height = topHeight,
        side = "top"
    }

    -- Palmier du bas
    local bottomImage = self.images[bottomIndex]

    local bottomWidth = bottomImage:getWidth() * scale
    local bottomHeight = bottomImage:getHeight() * scale

    local screenHeight = love.graphics.getHeight()

    local bottomPalm = {
        image = bottomImage,

        x = love.graphics.getWidth(),

        -- Le haut du palmier touche le bas de la route
        y = screenHeight - bottomHeight - 10,

        scale = scale,

        width = bottomWidth,
        height = bottomHeight,
        side = "bottom"
    }

    table.insert(self.palms, topPalm)
    table.insert(self.palms, bottomPalm)

end

function Decoration:drawBehind()

    for _, palm in ipairs(self.palms) do

        if palm.side == "top" then

            love.graphics.draw(
                palm.image,
                palm.x,
                palm.y,
                0,
                palm.scale,
                palm.scale
            )

        end

    end

end

function Decoration:drawInFront()

    for _, palm in ipairs(self.palms) do

        if palm.side == "bottom" then

            love.graphics.draw(
                palm.image,
                palm.x,
                palm.y,
                0,
                palm.scale,
                palm.scale
            )

        end

    end

end

return Decoration