local game = require('lib/game')

TLbind, control = love.filesystem.load('lib/vendor/TLbind.lua')()
TLbind.joyBtns = { {"jump", "jump", "jump", "jump"} }
TLbind.keys = {space="jump", e="jump", escape="quit", q="quit"}
-- TLbind.mouseBtns = { l="jump" }


function comma_value(amount)
  local formatted = amount
  while true do
    formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
    if (k==0) then
      break
    end
  end
  return formatted
end



function love.load()
    -- Load the typeface.
    font = love.graphics.newFont("assets/Junction-bold.otf", 50)
    love.graphics.setFont(font, 55)

    -- The operating system.
    mobile = (love.system.getOS() == 'iOS') or (love.system.getOS() == 'Android')

    -- Dimensions.
    width, height = love.graphics.getDimensions()
    print('Running in '..width..'x'..height..' mode.')

    jump_sound = love.audio.newSource("assets/jump.wav", "static")
    over_sound = love.audio.newSource("assets/game-over.wav", "static")

    music = love.audio.newSource("assets/loop.wav")
    music:setLooping(true)

    music2 = love.audio.newSource("assets/loop2.wav")
    music2:setLooping(true)

    music3 = love.audio.newSource("assets/loop3.wav")
    music3:setLooping(true)

    -- Initialize the pseudo random number generator
    math.randomseed(os.time())
    math.random(); math.random(); math.random()

end


function draw_attractor()
  local random_max = width / 2
  local offset_x = width / 2
  local offset_y = height / 2

  love.graphics.setColor(game.background_color)
  love.graphics.polygon("fill",
    0, 0,
    0, height,
    width, height,
    width, 0)

  if (game.stretch_progress > 0.8) then

    -- Only grow so large (iOS limitations).
    if game.stretch_progress < 2 then
        random_max = game.stretch_progress * random_max
    end

    love.graphics.setColor(math.random(1, 255), math.random(1, 255), math.random(1, 255))
    love.graphics.polygon("fill",
      math.random(-1 * random_max, random_max) + offset_x,
      math.random(-1 * random_max, random_max) + offset_y,

      math.random(-1 * random_max, random_max) + offset_x,
      math.random(-1 * random_max, random_max) + offset_y,

      math.random(-1 * random_max, random_max) + offset_x,
      math.random(-1 * random_max, random_max) + offset_y,

      math.random(-1 * random_max, random_max) + offset_x,
      math.random(-1 * random_max, random_max) + offset_y,

      math.random(-1 * random_max, random_max) + offset_x,
      math.random(-1 * random_max, random_max) + offset_y)
  end

  -- if not game:energy_is_negative() then
    -- love.graphics.setColor(255, 255, 255)
  -- else
  love.graphics.setColor(0, 0, 0)
  -- love.graphics.circle("fill", 400, 300, random_max - 15)
end

function draw_field()
  for i=1,1000 do
      love.graphics.setColor(math.random(1, 255), math.random(1, 255), math.random(1, 255))
      love.graphics.points(math.random(1, 800), math.random(1, 600))
      -- stars_printed = 1
  end
end

function draw_distance()
  love.graphics.setColor(255, 255, 255)
  love.graphics.printf(comma_value(math.floor(game:score())), 30, 30, 400, 'left')
end



function draw_ball()
  x_locations = {(width/5)*2, (width/5)*3}
  track_distance = x_locations[2] - x_locations[1]

  woggle1 = math.random(-1 * game.ball_wobble, game.ball_wobble)
  woggle2 = math.random(-1 * game.ball_wobble, game.ball_wobble)

  if game.track == 1 then
    direction = 1
  else
    direction = -1
  end

  jump_offset = direction * (game.current_jump * track_distance)

  x = (x_locations[game.track] + jump_offset) + woggle2
  y = (height / 2) + woggle1

  love.graphics.setColor(255, 255, 255)
  love.graphics.circle("fill", x, y, width/20 + (width/40)*game.current_jump)
end


function draw_track1()
  local track_width = (width/8)

  woggle = math.random(-1 * game.track_wobble, game.track_wobble)

  local x_offset = (width / 5)*2
  love.graphics.setColor(0, 0, 0)
  love.graphics.polygon("fill",
    x_offset, 0,
    x_offset + track_width, 0,
    x_offset + track_width + woggle, height,
    x_offset + woggle, height)


end

function draw_track2()
  local track_width = (width/8)

  woggle = math.random(-1 * game.track_wobble, game.track_wobble)

  local x_offset = (width / 5)*3
  love.graphics.setColor(0, 0, 0)
  love.graphics.polygon("fill",
    x_offset + woggle, 0,
    x_offset + track_width + woggle, 0,
    x_offset + track_width, height,
    x_offset, height)
end

function draw_obstacles()
  x_locations = {(width/5)*2, (width/5)*3}
  love.graphics.setColor(255, 255, 255, 225)

  h = (width/20)

  for i,v in ipairs(game.obstacles_1) do

    love.graphics.polygon('fill',
      h, (height-h) - (height*v),
      h, height - (height*v),
      width/2, height - (height*v),
      width/2, (height-h) - (height*v))
  end

  for i,v in ipairs(game.obstacles_2) do

    love.graphics.polygon('fill',
      (width/10)*9, (height-(height/10)) - (height*v),
      (width/10)*9, height - (height*v),
      width/2, height - (height*v),
      width/2, (height-(height/10)) - (height*v))
  end


end


function draw_demands()
  if not game.started then
    love.graphics.setColor(0, 0, 0)
    love.graphics.polygon("fill",
      0, 0,
      0, height,
      width, height,
      width, 0)

    love.graphics.setColor(255, 0, 0)
    love.graphics.printf('Warning: Could potentially cause seizures!', 0, height/2, width, 'center')

    love.graphics.setColor(255, 255, 255)
    love.graphics.printf('Jump, if you dare!', 0, (height/8)*5, width, 'center')

  end
end

function draw_death()
  if game.dead then
    love.graphics.setColor(0, 0, 0)
    love.graphics.polygon("fill",
      0, 0,
      0, height,
      width, height,
      width, 0)

    love.graphics.setColor(255, 0, 0)
    love.graphics.printf('GAME OVER', 0, height/2, width, 'center')

    love.graphics.setColor(255, 255, 255)
    love.graphics.printf('Score: '..math.floor(game:score()), 0, (height/3)*2, width, 'center')

    over_sound:play()
  end
end

function love.draw()
    draw_attractor()

    draw_track1()
    draw_track2()
    draw_obstacles()

    draw_ball()

    draw_distance()
    draw_demands()
    draw_death()

end


-- Jump!
function jump(dt)
  if not game.dead then
    game:jump(dt)
    jump_sound:play()
  else
    if game.dead_elapsed > game.dead_timeout then
      over_sound:stop()
      game:initialize()
      game.started = true
    end
  end
end

-- iOS touchscreen support.
function love.touchpressed(id, x, y, dx, dy, pressure)
  jump()
end

function love.update(dt)
  if game.progress < 1 then
    music:play()
  elseif game.stretch_progress > 1 then
    music2:stop()
    music3:play()
  else
    music:stop()
    music2:play()
  end

  if game.dead then
    music:stop()
    music2:stop()
    music3:stop()
  end

  -- Update the controller.
  TLbind:update()

  -- Update the game engine.
  game:update(dt)

  if control.tap['jump'] then
    jump(dt)
  end

  if control.tap["quit"] then
    love.event.quit()
  end

end