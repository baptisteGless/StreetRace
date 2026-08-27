local Player=require("src.player")
local Countdown=require("src.countdown")
local QTE=require("src.qte")
local CarConfig = require("src.car_config")
local Road = require("src.road")
local Decoration = require("src.decoration")
local Background = require("src.background")
local Dust = require("src.dust")
local Sound = require("src.sound")
local TopDown = require("src.topdown")

local Game={}

function Game.load()

    raceStarted = false
    startingRace = false
    fightTime = 0
    fightTimer = 0
    fightOffset = 0

    raceFinished = false
    finishTimer = 0
    finishStarted = false
    finishSpeed = 0

    p1 = Player.new(
        CarConfig.blue,
        575
    )

    p2 = Player.new(
        CarConfig.green,
        620
    )

    background = Background.new()

    road = Road.new()
    decoration = Decoration.new()

    Dust.load()
    QTE.load()
    QTE.start()
    Countdown.load()
    Countdown.start()
    TopDown.load()

end

function Game:updatePositions(dt)

    if raceFinished then
        return
    end

    local target1 = p1.baseX
    local target2 = p2.baseX

    target1 = p1.baseX + p1.distance * 0.35
    target2 = p2.baseX + p2.distance * 0.35

    if raceStarted then
        local fight = math.sin(fightTime * 6) * 12
        target1 = target1 + fight
        target2 = target2 - fight 
    end

    p1.displayX = p1.displayX + (target1 - p1.displayX) * 8 * dt 
    p2.displayX = p2.displayX + (target2 - p2.displayX) * 8 * dt

end

function Game.update(dt)

    if TopDown.phase > 0 then
        TopDown.update(dt)
        return
    end

    Countdown.update(dt)
    Sound.update()
    if raceStarted then
        fightTime = fightTime + dt
    end

    if Countdown.finished and not raceStarted and not startingRace then

        startingRace = true

        p1:startRace()
        p2:startRace()
        road:start()
        decoration:start()

    end

    -- Mise à jour de la route
    if startingRace or raceStarted then
        background:update(dt)
        road:update(dt)
        decoration:update(dt, road.speed, road:getY())
    end

    Dust.update(dt, road.speed)

    if startingRace then

        local speedReached = p1.rotationSpeed >= 80 and p2.rotationSpeed >= 80

        local distanceReached = p1.distance >= p1.targetDistance and p2.distance >= p2.targetDistance

        if speedReached and distanceReached then

            startingRace = false
            raceStarted = true

            p1.raceIsStarted = true
            p2.raceIsStarted = true

            Dust.start(p1, p2)
            Sound.startRace()

        end

    end

    p1:update(dt)
    p2:update(dt)

    if raceStarted then

        local result = QTE.update(dt)

        if result == "failed" then

            p2:accelerate()

        end

    end

    if raceStarted and QTE.finished() and not raceFinished then
        raceFinished = true
        finishTimer = 0
        finishStarted = false
        -- Sound.stop()
    end
    
    if raceFinished then
        finishTimer = finishTimer + dt

        if not finishStarted and finishTimer >= 2 then
            finishStarted = true
            finishSpeed = 0
        end

        if finishStarted then
            -- Accélération progressive 
            finishSpeed = finishSpeed + 2500 * dt
            -- Limite de vitesse
            if finishSpeed > 1800 then
                finishSpeed = 1800
            end
            
            p1.displayX = p1.displayX + finishSpeed * dt
            p2.displayX = p2.displayX + finishSpeed * dt
        end
        -- Après 3 secondes :
        -- passage à la vue de dessus
        if finishTimer >= 3 then

            TopDown.start()

            return

        end
    end

    Game:updatePositions(dt)
end

function Game.draw()

    if TopDown.phase > 0 then
        TopDown.draw()
        return
    end
    
    love.graphics.clear(.4,.7,1)

    background:draw()
    Countdown.draw()
    road:draw()
    decoration:drawBehind()
    
    p1:draw()
    p2:draw()
    Dust.draw()
    decoration:drawInFront()

    if raceStarted  then

        if not QTE.finished() then

            if not qteWaiting then
                QTE.draw()
            end

        else


        end

    end

end

function Game.keypressed(key)

    print("Touche :", key)

    if not raceStarted then
        return
    end

    if raceFinished then
        return
    end

    if QTE.finished() then
        return
    end

    if not QTE.started then
        return
    end

    if QTE.waiting then
        return
    end

    if key==QTE.currentKey() then

        p1:accelerate()

        Sound.nextGear()

        QTE.next()

        -- Petit délai avant le prochain
        QTE.waiting = true
        QTE.timer = QTE.getNextDelay()

        QTE.started = false

    end

end

return Game