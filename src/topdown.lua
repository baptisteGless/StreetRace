local TopDown = {}

TopDown.phase = 0
TopDown.timer = 0

TopDown.images = {}

TopDown.distance = 0
TopDown.speed = 500

TopDown.screenWidth = 1280
TopDown.screenHeight = 720

TopDown.route2Height = 0
TopDown.transitionHeight = 0
TopDown.route4Height = 0

-- Position dans la séquence de la route
TopDown.transitionStart = 0
TopDown.transitionBaseY = 0

--------------------------------------------------
-- Voitures
--------------------------------------------------
TopDown.carTimer = 0

TopDown.carScale = 0.55

TopDown.carWidth = 174 * TopDown.carScale
TopDown.carHeight = 333 * TopDown.carScale

-- Position finale des voitures
TopDown.carCenterY = 350

-- Écart horizontal entre les deux voitures
TopDown.carSpacing = 100

-- Position de départ en bas de l'écran
TopDown.carStartY = TopDown.screenHeight + 50

-- Durée de l'arrivée des voitures
TopDown.carEntryTime = 1.2

-- Positions actuelles
TopDown.j1X = 0
TopDown.j1Y = TopDown.carStartY

TopDown.j2X = 0
TopDown.j2Y = TopDown.carStartY

-- Positions finales
TopDown.j1TargetX = 0
TopDown.j1TargetY = 0

TopDown.j2TargetX = 0
TopDown.j2TargetY = 0

function TopDown.load()

    TopDown.images.route2 = love.graphics.newImage(
        "assets/background/routes/2_routes.png"
    )

    TopDown.images.transition = love.graphics.newImage(
        "assets/background/routes/transition_route.png"
    )

    TopDown.images.route4 = love.graphics.newImage(
        "assets/background/routes/4_routes.png"
    )

    TopDown.images.j1 = love.graphics.newImage(
        "assets/background/cars/j1.png"
    )

    TopDown.images.j2 = love.graphics.newImage(
        "assets/background/cars/j2.png"
    )

    local width = TopDown.images.route2:getWidth()
    local height = TopDown.images.route2:getHeight()
    local scale = TopDown.screenWidth / width

    TopDown.route2Height = height * scale

    width = TopDown.images.transition:getWidth()

    height = TopDown.images.transition:getHeight()

    scale = TopDown.screenWidth / width

    TopDown.transitionHeight = height * scale

    width = TopDown.images.route4:getWidth()

    height = TopDown.images.route4:getHeight()

    scale = TopDown.screenWidth / width

    TopDown.route4Height = height * scale

    TopDown.transitionStart = 5 * TopDown.speed

end


function TopDown.start()

    TopDown.phase = 1
    TopDown.timer = 0
    TopDown.carTimer = 0
    TopDown.distance = 0
    TopDown.transitionBaseY = nil

    --------------------------------------------------
    -- POSITION HORIZONTALE
    --------------------------------------------------

    local centerX = TopDown.screenWidth / 2
    TopDown.j1TargetX = centerX - TopDown.carSpacing / 2 - TopDown.carWidth / 2
    TopDown.j2TargetX = centerX + TopDown.carSpacing / 2 - TopDown.carWidth / 2

    --------------------------------------------------
    -- COMPARAISON DES DISTANCES DE LA PHASE 1
    --------------------------------------------------

    local difference = p1.distance - p2.distance

    print("========== PHASE 2 ==========")
    print("Distance joueur :", p1.distance)
    print("Distance IA     :", p2.distance)
    print("Difference      :", difference)

    --------------------------------------------------
    -- EGALITE
    --------------------------------------------------

    if math.abs(difference) < 1 then

        print("Resultat : EGALITE")

        TopDown.j1TargetY = TopDown.carCenterY
        TopDown.j2TargetY = TopDown.carCenterY

    elseif difference > 0 then

        print("Resultat : JOUEUR DEVANT")

        -- Plus la différence est grande,
        -- plus le joueur est en avant.

        local lead = math.min(difference * 0.35, 120)

        TopDown.j1TargetY = TopDown.carCenterY - lead
        TopDown.j2TargetY = TopDown.carCenterY

    else

        print("Resultat : IA DEVANT")

        local lead = math.min(math.abs(difference) * 0.35, 120)

        TopDown.j1TargetY = TopDown.carCenterY
        TopDown.j2TargetY = TopDown.carCenterY - lead

    end

    TopDown.j1X = TopDown.j1TargetX
    TopDown.j2X = TopDown.j2TargetX
    TopDown.j1Y = TopDown.carStartY
    TopDown.j2Y = TopDown.carStartY

end

function TopDown.update(dt)

    if TopDown.phase == 0 then
        return
    end

    TopDown.timer = TopDown.timer + dt

    --------------------------------------------------
    -- ANIMATION D'ARRIVEE DES VOITURES
    --------------------------------------------------

    TopDown.carTimer = TopDown.carTimer + dt

    local progress = math.min( TopDown.carTimer / TopDown.carEntryTime, 1)

    -- Animation douce
    local smooth = progress * progress * (3 - 2 * progress)

    TopDown.j1Y = TopDown.carStartY + (TopDown.j1TargetY - TopDown.carStartY) * smooth
    TopDown.j2Y = TopDown.carStartY + (TopDown.j2TargetY - TopDown.carStartY) * smooth

    --------------------------------------------------
    -- DEFILEMENT DE LA ROUTE
    --------------------------------------------------

    TopDown.distance = TopDown.distance + TopDown.speed * dt

    if TopDown.distance < TopDown.transitionStart then

        TopDown.phase = 1

        return
    end

    if TopDown.transitionBaseY == nil then

        local h = TopDown.route2Height
        local offset = TopDown.distance % h
        local route2Top = -h + offset

        TopDown.transitionBaseY = route2Top - TopDown.transitionHeight

    end

    local transitionDistance = TopDown.distance - TopDown.transitionStart

    if transitionDistance >= TopDown.transitionHeight then

        TopDown.phase = 3

    else

        TopDown.phase = 2

    end


end


function TopDown.drawImage(image, y, height)

    local scaleX = TopDown.screenWidth / image:getWidth()

    local scaleY = height / image:getHeight()

    love.graphics.draw(
        image,
        0,
        y,
        0,
        scaleX,
        scaleY
    )

end

function TopDown.draw()

    love.graphics.clear(0, 0, 0)

    local distance = TopDown.distance
    local h = TopDown.route2Height
    local offset = distance % h
    local route2Y = -h + offset

    while route2Y < TopDown.screenHeight do

        TopDown.drawImage(
            TopDown.images.route2,
            route2Y,
            TopDown.route2Height
        )

        route2Y = route2Y + TopDown.route2Height

    end

    if TopDown.transitionBaseY ~= nil then

        local transitionDistance = distance - TopDown.transitionStart
        local transitionY = TopDown.transitionBaseY + transitionDistance

        TopDown.drawImage(
            TopDown.images.transition,
            transitionY,
            TopDown.transitionHeight
        )

        local route4Y = transitionY - TopDown.route4Height

        while route4Y + TopDown.route4Height > 0 do

            TopDown.drawImage(
                TopDown.images.route4,
                route4Y,
                TopDown.route4Height
            )

            route4Y = route4Y - TopDown.route4Height

        end

    end

    love.graphics.draw(
        TopDown.images.j1,
        TopDown.j1X,
        TopDown.j1Y,
        0,
        TopDown.carScale,
        TopDown.carScale
    )

    love.graphics.draw(
        TopDown.images.j2,
        TopDown.j2X,
        TopDown.j2Y,
        0,
        TopDown.carScale,
        TopDown.carScale
    )

end


return TopDown