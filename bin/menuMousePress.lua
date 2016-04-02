function menuMousePressed(x, y, button)

    if button == "l" then

           -- Start
        if optionMouseOver(x,y,294,294+212,190,190+89) then
            love.mousepressed = function () end
            gamestate.switch(game)

            -- Info
        elseif optionMouseOver(x,y,294,294+212,279,279+89) then
            gamestate.switch(info)

            -- Quit
        elseif optionMouseOver(x,y,294,294+212,368,368+89) then
            love.event.quit()

            -- Sound
        elseif optionMouseOver(x,y,668,668+52,528,528+62) then
            if menu_sound then
                menu_sound = false
            else
                menu_sound = true
            end

            -- Music
        elseif optionMouseOver(x,y,730,730+52,528,528+62) then
            if menu_music then
                menu_music = false
            else
                menu_music = true
            end

            -- EasterEgg
        elseif optionMouseOver(x,y,0,50,0,50) then
            if menu_sound then
                love.audio.play(menu_easterEggSound)
            end
        end
    end
end

return love.mousepressed
