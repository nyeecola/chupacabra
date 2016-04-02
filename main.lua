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

function love.load()
    local font = love.graphics.newFont("assets/font.ttf", 40)
    love.graphics.setFont(font)
    math.randomseed(os.clock())
    gamestate.registerEvents()
    gamestate.switch(menu)
end
