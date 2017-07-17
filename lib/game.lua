local class = require('lib/vendor/middleclass')
local inspect = require('lib/vendor/inspect')

Game = class('Game')
function Game:initialize()
  self.energy_collected = 0  -- the amont of energy collected, thus far.
  self.energy_rate = 1  -- the rate of energy absorbtion per second.
  self.button_slots = {}
  self.upgrade_slots = {}
end
function Game:update(dt)
  self:update_energy(dt)
end
function Game:energy()
  return math.floor(self.energy_collected)
end
function Game:add_energy(e)
  self.energy_collected = self.energy_collected + e
  return self.energy_collected
end
function Game:update_energy(dt)
  local e = (dt * self.energy_rate)
  return self:add_energy(e)
end
function Game:upgrade_energy_collection(n)

  -- If no rate was given, double it.
  if not n then
    n = self.energy_rate
  end

  -- Add the new energy rate.
  self.energy_rate = self.energy_rate + n
end


ButtonBox = class('ButtonBox')
function ButtonBox:initialize(name)
  self.name = name
  self.is_ready = false
end
function ButtonBox:toggle_ready()
  self.is_ready = not self.is_ready
end

local game = Game:new()

local a_box = ButtonBox:new('Generator')
-- a_box.is_ready = true
a_box:toggle_ready()

local b_box = ButtonBox:new('B')
local x_box = ButtonBox:new('X')
local y_box = ButtonBox:new('Y')

table.insert(game.button_slots, a_box)
table.insert(game.button_slots, b_box)
table.insert(game.button_slots, x_box)
table.insert(game.button_slots, y_box)

-- print(game.energy_rate)
-- game:upgrade_energy_collection(nil)
-- print(game.energy_rate)
-- print(inspect(game.button_slots))
-- print(a_box.is_ready)
-- print(b_box.is_ready)

return game