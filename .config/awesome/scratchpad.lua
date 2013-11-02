-- Scratchpad code, influenced by:
--   <http://git.sysphere.org/awesome-configs/tree/scratch/drop.lua> and
--   <http://awesome.naquadah.org/wiki/Drop-down_terminal>

-- Use:

-- local scratchpad = require("scratch")
-- local scratch_console = {}
-- for s = 1, screen.count() do
--    scratch_console[s] = scratchpad({ command = "urxvt -name scratchpad",
--                                      name    = "scratchpad",
-- 			                                height  = 0.3,
--                                      screen  = s })
-- end

-- config.keys.global = awful.util.table.join(
--    config.keys.global,
--    awful.key({ modkey }, "`",
-- 	     function () scratch_console[mouse.screen]:toggle() end)

-- If you have a rule like "awful.client.setslave" for your terminals, ensure
-- you use an exception for the scratchpad name. Otherwise, you may run into
-- problems with focus.

local setmetatable = setmetatable
local string = string
local awful = require("awful")
local capi = { mouse = mouse,
               screen = screen,
               client = client,
               timer = timer }

local scratchpad = {}

local Scratchpad = {}

-- Display
function Scratchpad:display()
  -- first, we locate the scratchpad app
  local client = nil
  local i = 0
  for c in awful.client.iterate(function (c)
                                  -- c.name may be changed!
                                  return c.instance == self.name
                                end,
                                nil, self.screen) do
    i = i + 1
    if i == 1 then
      client = c
    else
      -- For additional matching clients, let's remove the sticky bit which may
      -- persist between awesome restarts. We don't close them as they may be
      -- valuable. They will just turn into normal windows.
      c.sticky = false
      c.ontop  = false
      c.above  = false
    end
  end

  if not client and not self.visible then
    -- The scratchpad is not here yet but we don't want it yet. Just do nothing.
    return
  end

  if not client then
    -- The client does not exist, so we spawn it.
    awful.util.spawn(self.command, false, self.screen)
    return
  end

  -- compute size
  local geom = capi.screen[self.screen].workarea
  local width, height = self.width, self.height
  if width  <= 1 then width = geom.width * width end
  if height <= 1 then height = geom.height * height end
  local x, y
  if     self.horiz == "left"  then x = geom.x
  elseif self.horiz == "right" then x = geom.width + geom.x - width
  else   x = geom.x + (geom.width - width)/2 end
  if     self.vert == "top"    then y = geom.y
  elseif self.vert == "bottom" then y = geom.height + geom.y - height
  else   y = geom.y + (geom.height - height)/2 end

  -- resize scratchpad
  awful.client.floating.set(client, true)
  -- client.size_hints_honor = false
  client:geometry({ x = x, y = y, width = width, height = height })

  -- sticky and on top
  client.ontop = true
  client.above = true
  client.skip_taskbar = true
  client.sticky = true
  
  -- This is not a normal window, don't apply any specific keyboard stuff
  -- client:buttons({})
  -- client:keys({})

  -- Toggle display
  if self.visible then
    client.hidden = false
    client:raise()
    capi.client.focus = client
  else
    client.hidden = true
  end
end

-- Create a scratchpad
function Scratchpad:new(config)
  -- The "scratchpad" object is just its configuration.

  -- The application to be invoked is:
  config.command  = config.command  or "urxvtc -name scratchpad" -- application to spawn
  config.name     = config.name     or "scratchpad" -- name used to identify it

  -- If width or height <= 1 this is a proportion of the workspace
  config.height   = config.height   or 0.25	     -- height
  config.width    = config.width    or 1	       -- width
  config.vert     = config.vert     or "center"	 -- top, bottom or center
  config.horiz    = config.horiz    or "center"  -- left, right or center

  config.screen   = config.screen  or capi.mouse.screen
  config.visible  = config.visible or false      -- initially, not visible

  local scratchpad = setmetatable(config, { __index = Scratchpad })
  capi.client.connect_signal("manage",
                         function(c)
                           if c.instance == scratchpad.name and c.screen == scratchpad.screen then
                             scratchpad:display()
                           end
  end)
  capi.client.connect_signal("unmanage",
                         function(c)
                           if c.instance == scratchpad.name and c.screen == scratchpad.screen then
                             scratchpad.visible = false
                           end
  end)

  -- "Reattach" currently running Scratchpad. This is in case awesome is restarted.
  local reattach = capi.timer { timeout = 0 }
  reattach:connect_signal("timeout",
                      function()
                        reattach:stop()
                        scratchpad:display()
  end)
  reattach:start()
  return scratchpad
end

-- toggle the scratchpad
function Scratchpad:toggle()
  self.visible = not self.visible
  self:display()
end

return setmetatable(scratchpad, { __call = function(_, ...) return Scratchpad:new(...) end })
