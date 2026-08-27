local Dust = {}

Dust.frames = {}
Dust.active = false
Dust.frame = 1
Dust.timer = 0
Dust.frameDuration = 0.04

Dust.x1 = 0
Dust.y1 = 0

Dust.x2 = 0
Dust.y2 = 0

Dust.scale = 0.35

function Dust.load()

    Dust.frames = {}

    for i = 1, 9 do

        Dust.frames[i] = love.graphics.newImage(
            "assets/background/dust/" .. i .. ".png"
        )

    end

end

function Dust.start(player1, player2)

    -- Ne jamais rejouer l'animation
    if Dust.active then
        return
    end

    Dust.active = true
    Dust.frame = 1
    Dust.timer = 0

    -- Position initiale des fumées
    Dust.x1 = player1.displayX + player1.rearWheelX * player1.scale
    Dust.y1 = player1.y + player1.wheelY * player1.scale

    Dust.x2 = player2.displayX + player2.rearWheelX * player2.scale
    Dust.y2 = player2.y + player2.wheelY * player2.scale

end


function Dust.update(dt, roadSpeed)

    if not Dust.active then
        return
    end

    Dust.timer = Dust.timer + dt

    -- Traveling de la route
    -- La fumée est entraînée vers la gauche
    Dust.x1 = Dust.x1 - roadSpeed * dt
    Dust.x2 = Dust.x2 - roadSpeed * dt

    -- Animation des frames
    if Dust.timer >= Dust.frameDuration then

        Dust.timer = Dust.timer - Dust.frameDuration
        Dust.frame = Dust.frame + 1

        -- Animation terminée
        if Dust.frame > #Dust.frames then
            Dust.active = false
            return
        end

    end

end


function Dust.draw()

    if not Dust.active then
        return
    end

    local image = Dust.frames[Dust.frame]

    if not image then
        return
    end

    local width = image:getWidth()
    local height = image:getHeight()

    -- Fumée voiture 1
    love.graphics.draw(
        image,
        Dust.x1,
        Dust.y1,
        0,
        Dust.scale,
        Dust.scale,
        width / 2,
        height / 2
    )

    -- Fumée voiture 2
    love.graphics.draw(
        image,
        Dust.x2,
        Dust.y2,
        0,
        Dust.scale,
        Dust.scale,
        width / 2,
        height / 2
    )

end


return Dust