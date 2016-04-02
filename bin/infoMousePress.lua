function infoMousePressed(x, y, button)

    if button == "l" then

        if optionMouseOver(x,y,500,500+212,480,480+89) then
            gamestate.switch(menu)
        end
    end
end