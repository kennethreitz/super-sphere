local game = require('lib/game')

function love.load()
    -- Load the typeface.
    font = love.graphics.newFont("assets/Junction-bold.otf", 48)
end

function draw_buttons()
    local button_a = game.button_slots[1]
    love.graphics.setColor(255, 0, 0, 128)
    love.graphics.circle("fill", 0, 0, 180)

    love.graphics.setFont(font, 55)
    love.graphics.setColor(255, 255, 255)
    love.graphics.print(button_a.name)
end

function love.draw()
    -- love.graphics.print("Hello World!", 400, 300)
    draw_buttons()
end


countdownTime = 0.3 --five seconds

function timer(dt)
    countdownTime = countdownTime - dt
     if  countdownTime <= 0 then
          print(game:energy())
          -- game:upgrade_energy_collection(1)
          countdownTime = countdownTime + 0.3
     end
end

function love.update(dt)
    timer(dt)
    game:update(dt)
    -- print(game.energy_collected)
end