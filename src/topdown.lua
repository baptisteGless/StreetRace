local TopDown = {}

TopDown.phase = 0
TopDown.timer = 0

TopDown.images = {}

TopDown.distance = 0
TopDown.speed = 800

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

--------------------------------------------------
-- VOIES
--------------------------------------------------

TopDown.laneCount = 4

-- Positions X des 4 voies de la route du joueur
TopDown.playerLanes = {
    170,
    290,
    410,
    520
}

-- Positions X des 4 voies de la route de l'IA
TopDown.aiLanes = {
    660,
    780,
    900,
    1030
}

-- Voie actuelle
TopDown.j1Lane = 4
TopDown.j2Lane = 1

--------------------------------------------------
-- OBSTACLES
--------------------------------------------------

TopDown.obstacles = {}

TopDown.obstacleTimer = 0

-- Temps minimum entre deux générations
TopDown.obstacleMinDelay = 0.8
TopDown.obstacleMaxDelay = 1.4

-- Position d'apparition
TopDown.obstacleSpawnY = -600

-- Vitesse des obstacles
TopDown.obstacleSpeed = 500

-- Distance minimale entre deux obstacles
TopDown.obstacleMinDistance = 350

TopDown.obstacleImages = {}

TopDown.obstacleScale = 0.55

-- Autorisation de changer de voie
TopDown.canChangeLane = false

-- Vitesse de déplacement entre deux voies
TopDown.laneMoveSpeed = 1000

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

    --------------------------------------------------
    -- OBSTACLES
    --------------------------------------------------

    TopDown.obstacleImages = {

        {
            name = "cat-m",
            image = love.graphics.newImage(
                "assets/background/cars/cat-m.png"
            ),
            width = 150 * TopDown.obstacleScale,
            height = 302 * TopDown.obstacleScale
        },

        {
            name = "cat-r",
            image = love.graphics.newImage(
                "assets/background/cars/cat-r.png"
            ),
            width = 150 * TopDown.obstacleScale,
            height = 302 * TopDown.obstacleScale
        },

        {
            name = "cat-v",
            image = love.graphics.newImage(
                "assets/background/cars/cat-v.png"
            ),
            width = 150 * TopDown.obstacleScale,
            height = 302 * TopDown.obstacleScale
        },


        {
            name = "jeep-b",
            image = love.graphics.newImage(
                "assets/background/cars/jeep-b.png"
            ),
            width = 154 * TopDown.obstacleScale,
            height = 320 * TopDown.obstacleScale
        },

        {
            name = "jeep-r",
            image = love.graphics.newImage(
                "assets/background/cars/jeep-r.png"
            ),
            width = 154 * TopDown.obstacleScale,
            height = 320 * TopDown.obstacleScale
        },

        {
            name = "jeep-v",
            image = love.graphics.newImage(
                "assets/background/cars/jeep-v.png"
            ),
            width = 154 * TopDown.obstacleScale,
            height = 320 * TopDown.obstacleScale
        },


        {
            name = "min-b",
            image = love.graphics.newImage(
                "assets/background/cars/min-b.png"
            ),
            width = 129 * TopDown.obstacleScale,
            height = 196 * TopDown.obstacleScale
        },

        {
            name = "min-m",
            image = love.graphics.newImage(
                "assets/background/cars/min-m.png"
            ),
            width = 129 * TopDown.obstacleScale,
            height = 196 * TopDown.obstacleScale
        },

        {
            name = "min-r",
            image = love.graphics.newImage(
                "assets/background/cars/min-r.png"
            ),
            width = 129 * TopDown.obstacleScale,
            height = 196 * TopDown.obstacleScale
        },


        {
            name = "r1-n",
            image = love.graphics.newImage(
                "assets/background/cars/r1-n.png"
            ),
            width = 152 * TopDown.obstacleScale,
            height = 305 * TopDown.obstacleScale
        },

        {
            name = "r1-r",
            image = love.graphics.newImage(
                "assets/background/cars/r1-r.png"
            ),
            width = 152 * TopDown.obstacleScale,
            height = 305 * TopDown.obstacleScale
        },

        {
            name = "r1-v",
            image = love.graphics.newImage(
                "assets/background/cars/r1-v.png"
            ),
            width = 152 * TopDown.obstacleScale,
            height = 305 * TopDown.obstacleScale
        },


        {
            name = "bus",
            image = love.graphics.newImage(
                "assets/background/cars/bus.png"
            ),
            width = 213 * TopDown.obstacleScale,
            height = 490 * TopDown.obstacleScale
        }

    }

end


function TopDown.start()

    TopDown.phase = 1
    TopDown.timer = 0
    TopDown.carTimer = 0
    TopDown.distance = 0
    TopDown.transitionBaseY = nil

    TopDown.j1Lane = 4
    TopDown.j2Lane = 1
    TopDown.canChangeLane = false

    TopDown.obstacles = {}
    TopDown.obstacleTimer = 0

    TopDown.nextObstacleDelay = math.random( TopDown.obstacleMinDelay * 100, TopDown.obstacleMaxDelay * 100 ) / 100

    --------------------------------------------------
    -- POSITION HORIZONTALE
    --------------------------------------------------

    TopDown.j1TargetX = TopDown.playerLanes[TopDown.j1Lane]
    TopDown.j2TargetX = TopDown.aiLanes[TopDown.j2Lane]

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

    TopDown.j1Lane = 4
    TopDown.j2Lane = 1
    TopDown.canChangeLane = false

end

function TopDown.canUseLane(side, lane)

    for _, obstacle in ipairs(TopDown.obstacles) do

        if obstacle.side == side
        and obstacle.lane == lane then

            local distance =
                math.abs(
                    obstacle.y -
                    TopDown.obstacleSpawnY
                )

            if distance < TopDown.obstacleMinDistance then
                return false
            end

        end

    end

    return true

end

function TopDown.spawnObstacle(side)

    --------------------------------------------------
    -- RECHERCHE DES VOIES DISPONIBLES
    --------------------------------------------------

    local availableLanes = {}

    for lane = 1, 4 do

        if TopDown.canUseLane(side, lane) then
            table.insert(
                availableLanes,
                lane
            )
        end

    end

    --------------------------------------------------
    -- AUCUNE VOIE DISPONIBLE
    --------------------------------------------------

    if #availableLanes == 0 then
        return false
    end

    --------------------------------------------------
    -- EVITER DE REMPLIR LES 4 VOIES
    --------------------------------------------------

    local occupiedLanes = 0

    for _, obstacle in ipairs(TopDown.obstacles) do

        if obstacle.side == side then

            local distance =
                math.abs(
                    obstacle.y -
                    TopDown.obstacleSpawnY
                )

            if distance < TopDown.obstacleMinDistance then
                occupiedLanes = occupiedLanes + 1
            end

        end

    end

    -- Toujours laisser au moins une voie libre
    if occupiedLanes >= 3 then
        return false
    end

    --------------------------------------------------
    -- CHOIX D'UNE VOIE
    --------------------------------------------------

    local lane = availableLanes[math.random(1, #availableLanes)]

    --------------------------------------------------
    -- POSITION X
    --------------------------------------------------

    local x

    if side == 1 then
        x = TopDown.playerLanes[lane]
    else
        x = TopDown.aiLanes[lane]
    end

    --------------------------------------------------
    -- VEHICULE
    --------------------------------------------------

    local data = TopDown.obstacleImages[math.random( 1, #TopDown.obstacleImages)]

    --------------------------------------------------
    -- CREATION
    --------------------------------------------------

    local obstacle = {

        image = data.image,

        width = data.width,
        height = data.height,

        side = side,
        lane = lane,

        x = x,
        y = TopDown.obstacleSpawnY

    }

    --------------------------------------------------
    -- AJOUT
    --------------------------------------------------

    table.insert(
        TopDown.obstacles,
        obstacle
    )

    return true

end

function TopDown.changeLane(player, direction)

    if not TopDown.canChangeLane then
        return
    end

    --------------------------------------------------
    -- JOUEUR
    --------------------------------------------------

    if player == 1 then

        local newLane = TopDown.j1Lane + direction

        if newLane >= 1 and newLane <= 4 then

            TopDown.j1Lane = newLane

        end

    --------------------------------------------------
    -- IA
    --------------------------------------------------

    elseif player == 2 then

        local newLane =
            TopDown.j2Lane + direction

        if newLane >= 1 and newLane <= 4 then

            TopDown.j2Lane = newLane

        end

    end

end

--------------------------------------------------
-- DEPLACEMENT HORIZONTAL
--------------------------------------------------

function moveTowards(current, target, speed, dt)

    if current < target then

        current =
            math.min(
                current + speed * dt,
                target
            )

    elseif current > target then

        current =
            math.max(
                current - speed * dt,
                target
            )

    end

    return current

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
        TopDown.canChangeLane = true

    else

        TopDown.phase = 2
        TopDown.canChangeLane = false

    end

    --------------------------------------------------
    -- POSITION CIBLE DES VOITURES
    --------------------------------------------------

    if TopDown.canChangeLane then

        TopDown.j1TargetX = TopDown.playerLanes[TopDown.j1Lane]
        TopDown.j2TargetX = TopDown.aiLanes[TopDown.j2Lane]
        TopDown.j1X = moveTowards( TopDown.j1X, TopDown.j1TargetX, TopDown.laneMoveSpeed, dt)
        TopDown.j2X = moveTowards( TopDown.j2X, TopDown.j2TargetX, TopDown.laneMoveSpeed, dt)

    end

    --------------------------------------------------
    -- OBSTACLES
    --------------------------------------------------

    if TopDown.canChangeLane then

        TopDown.obstacleTimer = TopDown.obstacleTimer + dt

        --------------------------------------------------
        -- GENERATION
        --------------------------------------------------

        if TopDown.obstacleTimer >= TopDown.nextObstacleDelay then

            -- Route joueur
            TopDown.spawnObstacle(1)

            -- Route IA
            TopDown.spawnObstacle(2)

            TopDown.obstacleTimer = 0
            TopDown.nextObstacleDelay = math.random(TopDown.obstacleMinDelay * 100, TopDown.obstacleMaxDelay * 100) / 100

        end

        --------------------------------------------------
        -- DEPLACEMENT
        --------------------------------------------------

        for i = #TopDown.obstacles, 1, -1 do

            local obstacle =
                TopDown.obstacles[i]

            obstacle.y =
                obstacle.y +
                TopDown.obstacleSpeed * dt


            --------------------------------------------------
            -- SUPPRESSION
            --------------------------------------------------

            if obstacle.y >
            TopDown.screenHeight + 600 then

                table.remove(
                    TopDown.obstacles,
                    i
                )

            end

        end

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

    for _, obstacle in ipairs(TopDown.obstacles) do

        love.graphics.draw(
            obstacle.image,
            obstacle.x,
            obstacle.y,
            0,
            TopDown.obstacleScale,
            TopDown.obstacleScale
        )

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