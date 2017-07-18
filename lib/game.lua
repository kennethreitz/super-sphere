local class = require('lib/vendor/middleclass')
local inspect = require('lib/vendor/inspect')

Game = class('Game')
function Game:initialize()
  self.distance = 0
  self.distance_rate = 80
  self.goal_distance = 1000
  self.stretch_goal_distance = 3000
  self.starting_position = (-1 * self.goal_distance)
  self.track = 1

  self.progress = 0
  self.stretch_progress = 0

  self.ball_wobble = 0
  self.ball_max_wobble = 8
  self.track_wobble = 0
  self.track_max_wobble = 25

  self.jump_duration = 0.05
  self.current_jump = 0

  self.background_color = self:random_color()
  self.background_slowest = 1.4
  self.background_interval = self.background_slowest
  self.background_countdown = self.background_interval

end
function Game:update(dt)
  self.progress = (self.distance / self.goal_distance)
  self.stretch_progress = (self.distance / self.stretch_goal_distance)

  self:update_distance(dt)
  self:update_background(dt)
  self:update_background_speed()
  self:update_jump(dt)
  self:update_wobbles(dt)
end
function Game:score()
  return self.starting_position + self.distance
end

function Game:update_wobbles(dt)
  if self.progress > 1 then
    self.track_wobble = self.progress * self.track_max_wobble
    self.ball_wobble = self.progress * self.ball_max_wobble
  end
end

function Game:update_jump(dt)
    if self.current_jump > 0 then
        self.current_jump = self.current_jump - (dt / self.jump_duration)
    end
    if self.current_jump < 0 then
      self.current_jump = 0
    end
end
function Game:jump_available()
    return false
end
function Game:jump(dt)
    self:toggle_tracks()
    self.current_jump = 1

end

-- Countdown timer for background switch.
function Game:update_background(dt)
    self.background_countdown = self.background_countdown - dt
     if self.background_countdown <= 0 then
          self.background_color = self:random_color()
          self.background_countdown = self.background_countdown + self.background_interval
     end
end
function Game:random_color()
    return {math.random(1, 255), math.random(1, 255), math.random(1, 255)}
end
function Game:toggle_tracks()
    if self.track == 1 then
        self.track = 2
    elseif self.track == 2 then
        self.track = 1
    end

    return true
end
function Game:update_distance(dt)
  local d = (dt * self.distance_rate)
  self.distance = self.distance + d
end
function Game:update_background_speed(dt)
    --
    delta = self.progress * self.background_slowest

    self.background_interval = self.background_slowest - delta

    -- self.background_interval =

end

local game = Game:new()
return game