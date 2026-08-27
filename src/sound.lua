local Sound = {}

Sound.sounds = {}

Sound.files = {
    depart = "assets/sound_effect/depart.ogg",
    depart_rupteur = "assets/sound_effect/depart_rupteur.ogg",

    passage1 = "assets/sound_effect/passage1.ogg",
    passage1_rupteur = "assets/sound_effect/passage1_rupteur.ogg",

    passage2 = "assets/sound_effect/passage2.ogg",
    passage2_rupteur = "assets/sound_effect/passage2_rupteur.ogg",

    passage3 = "assets/sound_effect/passage3.ogg",
    passage3_rupteur = "assets/sound_effect/passage3_rupteur.ogg"
}

Sound.player = {
    current = nil,
    currentName = nil,
    volume = 1.0
}

Sound.ai = {
    current = nil,
    currentName = nil,
    volume = 0.55
}

Sound.gear = 0

function Sound.createSource(name)

    local path = Sound.files[name]

    if not path then
        print("ERREUR : son introuvable :", name)
        return nil
    end

    print("Chargement du son :", path)

    return love.audio.newSource(
        path,
        "stream"
    )

end

function Sound.play(car, name, loop)

    local data = Sound[car]

    if not data then
        print("Voiture inconnue :", car)
        return
    end

    local source = Sound.createSource(name)

    if not source then
        return
    end

    -- Arrêter l'ancien son
    if data.current then
        data.current:stop()
    end

    source:setVolume(data.volume)
    source:setLooping(loop or false)
    source:play()

    data.current = source
    data.currentName = name

end


function Sound.startRace()

    Sound.gear = 0

    -- Joueur
    Sound.play(
        "player",
        "depart",
        false
    )

    -- IA
    Sound.play(
        "ai",
        "depart",
        false
    )

end


function Sound.updateCar(car)

    local data = Sound[car]

    if not data then
        return
    end

    if not data.current then
        return
    end

    if not data.current:isPlaying() then

        if data.currentName == "depart" then

            Sound.play(
                car,
                "depart_rupteur",
                true
            )

        elseif data.currentName == "passage1" then

            Sound.play(
                car,
                "passage1_rupteur",
                true
            )

        elseif data.currentName == "passage2" then

            Sound.play(
                car,
                "passage2_rupteur",
                true
            )

        elseif data.currentName == "passage3" then

            Sound.play(
                car,
                "passage3_rupteur",
                true
            )

        end

    end

end


function Sound.update()

    Sound.updateCar("player")
    Sound.updateCar("ai")

end


function Sound.nextGear()

    Sound.gear = Sound.gear + 1

    if Sound.gear == 1 then

        Sound.play(
            "player",
            "passage1",
            false
        )

        Sound.play(
            "ai",
            "passage1",
            false
        )

    elseif Sound.gear == 2 then

        Sound.play(
            "player",
            "passage2",
            false
        )

        Sound.play(
            "ai",
            "passage2",
            false
        )

    else

        Sound.gear = 3

        Sound.play(
            "player",
            "passage3",
            false
        )

        Sound.play(
            "ai",
            "passage3",
            false
        )

    end

end


function Sound.stopCar(car)

    local data = Sound[car]

    if not data then
        return
    end

    if data.current then
        data.current:stop()
        data.current = nil
        data.currentName = nil
    end

end


function Sound.stop()

    Sound.stopCar("player")
    Sound.stopCar("ai")

end


return Sound