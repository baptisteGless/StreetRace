local QTE = {}

QTE.keys = { "up", "left", "down", "right" }
QTE.list = {}

QTE.current = 1
QTE.total = 7
QTE.images = {}

QTE.minTime = 0.7
QTE.maxTime = 1.2

QTE.minDelay = 1.0
QTE.maxDelay = 1.8

QTE.timer = 0
QTE.waiting = false
QTE.started = false

QTE.success = false
QTE.failed = false

function QTE.getNextDelay()

    return love.math.random()
        * (QTE.maxDelay - QTE.minDelay)
        + QTE.minDelay

end

function QTE.load() 
    QTE.images.up = love.graphics.newImage( "assets/background/fleche_up.png" ) 
    QTE.images.down = love.graphics.newImage( "assets/background/fleche_down.png" ) 
    QTE.images.left = love.graphics.newImage( "assets/background/fleche_left.png" ) 
    QTE.images.right = love.graphics.newImage( "assets/background/fleche_right.png" ) 
end

function QTE.start()

    QTE.list = {} 
    for i = 1, QTE.total do 
        local randomKey = QTE.keys[love.math.random(#QTE.keys)] 
        table.insert(QTE.list, randomKey) 
    end
    
    QTE.current = 1

    QTE.timer = 0
    QTE.waiting = false
    QTE.started = false

    QTE.success = false
    QTE.failed = false
end

function QTE.begin()

    if QTE.finished() then
        return
    end

    QTE.timer = love.math.random() * (QTE.maxTime - QTE.minTime) + QTE.minTime

    QTE.started = true
    QTE.waiting = false

    QTE.success = false
    QTE.failed = false

end

function QTE.update(dt)

    if QTE.finished() then
        return nil
    end

    if QTE.waiting then

        QTE.timer = QTE.timer - dt

        if QTE.timer <= 0 then

            QTE.waiting = false

            QTE.begin()

        end

        return nil
    end

    if not QTE.started then

        QTE.begin()

        return nil

    end

    QTE.timer = QTE.timer - dt

    if QTE.timer <= 0 then

        -- Le joueur n'a pas répondu à temps
        QTE.failed = true

        QTE.started = false

        -- Le jeu gagne ce QTE
        QTE.next()

        -- Petit délai avant le prochain
        QTE.waiting = true
        QTE.timer = QTE.getNextDelay()

        return "failed"

    end

    return nil

end

function QTE.currentKey()

    if QTE.finished() then
        return nil
    end

    return QTE.list[QTE.current]

end

function QTE.currentImage()

    if QTE.finished() then
        return nil
    end

    return QTE.images[QTE.currentKey()]

end

function QTE.next()

    QTE.current = QTE.current + 1

end

function QTE.finished()

    return QTE.current > #QTE.list

end

function QTE.draw()

    if QTE.finished() then
        return
    end

    if not QTE.started then
        return
    end

    if QTE.waiting then
        return
    end

    local image = QTE.currentImage()

    if not image then
        return
    end

    local scale = 0.5
    local width = image:getWidth() * scale
    local height = image:getHeight() * scale
    local screenWidth = love.graphics.getWidth()
    local x = (screenWidth - width) / 2
    local y = 80

    love.graphics.draw(
        image,
        x,
        y,
        0,
        scale,
        scale
    )

end

return QTE