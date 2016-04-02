gamestate = require("gamestate")

local menu = {}
local game = {}
local pause = {}

function menu:enter()

end

function menu:draw()

end

function menu:leave()

end

function game:enter()

end

function game:update()

end

function game:draw()

end

function game:leave()

end

function love.load()
    math.randomseed(os.clock())
    gamestate.registerEvents()
    gamestate.switch(menu)
end
