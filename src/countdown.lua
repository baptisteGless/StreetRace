local Countdown = {}

Countdown.redImage = nil
Countdown.orangeImage = nil
Countdown.greenImage = nil

Countdown.current = 0
Countdown.timer = 0
Countdown.finished = false

function Countdown.load()

    Countdown.redImage = love.graphics.newImage(
        "assets/background/red_light.png"
    )

    Countdown.orangeImage = love.graphics.newImage(
        "assets/background/orange_light.png"
    )

    Countdown.greenImage = love.graphics.newImage(
        "assets/background/green_light.png"
    )

end

function Countdown.start()

    Countdown.current = 3
    Countdown.timer = 1
    Countdown.finished = false

end

function Countdown.update(dt)

    if Countdown.finished then
        return
    end

    Countdown.timer = Countdown.timer - dt

    if Countdown.timer <= 0 then

        Countdown.current = Countdown.current - 1

        if Countdown.current <= 0 then

            Countdown.finished = true

        else

            Countdown.timer = 1

        end

    end

end

function Countdown.draw()

    if Countdown.finished then
        return
    end

    local image

    if Countdown.current == 3 then

        image = Countdown.redImage

    elseif Countdown.current == 2 then

        image = Countdown.orangeImage

    elseif Countdown.current == 1 then

        image = Countdown.greenImage

    end

    if image then

        local scale = 0.3
        local width = image:getWidth() * scale
        local height = image:getHeight() * scale
        local screenWidth = love.graphics.getWidth()
        local screenHeight = love.graphics.getHeight()

        local x = (screenWidth - width) / 2

        local y = ((screenHeight - height) / 2) - 200

        love.graphics.draw( image, x, y, 0, scale, scale)

    end

end

return Countdown