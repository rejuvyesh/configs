--[[

     Awesome WM configuration template
     github.com/lcpz

--]]

-- {{{ Required libraries
local awesome, client, mouse, screen, tag = awesome, client, mouse, screen, tag
local ipairs, string, os, table, tostring, tonumber, type = ipairs, string, os, table, tostring, tonumber, type

local gears         = require("gears")
local awful         = require("awful")
                      require("awful.autofocus")
local wibox         = require("wibox")
local beautiful     = require("beautiful")
local naughty       = require("naughty")
local lain          = require("lain")
--local menubar       = require("menubar")
local scratchpad = require("scratchpad")
local redshift   = require("redshift")
local freedesktop   = require("freedesktop")
local hotkeys_popup = require("awful.hotkeys_popup").widget
                      require("awful.hotkeys_popup.keys")
local my_table      = awful.util.table or gears.table -- 4.{0,1} compatibility
-- }}}

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

function chomp_read(command)
  return awful.util.pread(command):gsub("\n$", "")
end

local fume = chomp_read("ti now")
-- localization
os.setlocale(os.getenv("LANG"))

-- for host-specific settings
local hostname = chomp_read("hostname")

-- {{{ Autostart windowless processes

-- This function will run once every time Awesome is started
local function run_once(cmd_arr)
    for _, cmd in ipairs(cmd_arr) do
        awful.spawn.with_shell(string.format("pgrep -u $USER -fx '%s' > /dev/null || (%s)", cmd, cmd))
    end
end

-- disable mouse
function mouse_toggle()
  awful.util.spawn("toggle_mouse.rb")
  -- move cursor in lower left corner and don't trigger any events
  mouse.coords({x=0, y=screen[1][1]}, true)
end

-- run the command if it not exists, otherwise raise/kill it (and rely on tool itself to tray)
function run_or_raise(command, rule, active_hide)
  active_hide = active_hide or false

  local matcher = function (c)
    return awful.rules.match(c, rule)
  end

  local kill_or_hide = function (c)
    if active_hide then
      -- FIXME implement
    else
      c:kill()
    end
  end

  local find_client = function ()
    for c in awful.client.iterate(function (cc)
        return matcher(cc)
                                  end, nil, nil) do
      return c
    end

    return nil
  end


  if client.focus and matcher(client.focus) then
    kill_or_hide(client.focus)
  else
    c = find_client()

    if c then
      if c:tags()[mouse.screen] == awful.tag.selected(mouse.screen) then
        client.focus = c
        c:raise()
      else
        awful.client.jumpto(c)
      end
    else
      awful.util.spawn(command)
    end
  end
end

redshift.redshift = "/usr/bin/redshift"
redshift.options = "-l 37.421:-122.158 -t 6500:4000"
redshift.init(1)


-- run_once({ "alacritty", "unclutter -root" }) -- entries must be separated by commas

-- This function implements the XDG autostart specification
--[[
awful.spawn.with_shell(
    'if (xrdb -query | grep --quiet "^awesome\\.started:\\s*true$"); then; exit; fi;' ..
    'xrdb -merge <<< "awesome.started:true";' ..
    -- list each of your autostart commands, followed by ; inside single quotes, followed by ..
    'dex --environment Awesome --autostart --search-paths "$XDG_CONFIG_DIRS/autostart:$XDG_CONFIG_HOME/autostart"' -- https://github.com/jceb/dex
)
--]]

-- }}}

-- {{{ Variable definitions


local theme = "multicolor"
local modkey       = "Mod4"
local altkey       = "Mod1"
local terminal     = "alacritty"
local editor       = "emacs-gui"
local browser      = "firefox"
local scrlocker    = "slock"

-- scratchpads
local scratchpad_term = scratchpad({ command = terminal.." --title scratchpad -e zsh -i -c 'scratchpad'",
                                     name    = "scratchpad",
                                     height  = 0.7,
                                     width   = 0.5})
local scratchpad_slack = scratchpad({ command = "slack", 
                                      name    = "slack",
                                      height  = 0.7, width = 0.5})

-- dmenu_font  = "-xos4-terminus-medium-*-*-*-12-*-*-*-*-*-*-*"
-- dmenu_opts  = "-b -i -fn '"..dmenu_font.."' -nb '#000000' -nf '#FFFFFF' -sb '"..beautiful.bg_focus.."'"
-- dmenu       = "dmenu "..dmenu_opts
-- dmenu_all   = "dmenu_run "..dmenu_opts
-- dmenu_quick = "eval \"exec `cat $HOME/.programs | "..dmenu.."`\""


awful.util.terminal = terminal
awful.util.tagnames = {
  "1",
  "📚",
  "code",
  "4",
  "5",
  "6",
  "📺",
  "♬",
  "study",
  "web",
}
awful.layout.layouts = {
  awful.layout.suit.tile,
  awful.layout.suit.tile.left,
  awful.layout.suit.tile.top,
  awful.layout.suit.tile.bottom,
  awful.layout.suit.fair,
  awful.layout.suit.fair.horizontal,
  awful.layout.suit.max.fullscreen,
  awful.layout.suit.magnifier,
  lain.layout.termfair,
  lain.layout.centerwork,
    --awful.layout.suit.fair,
    --awful.layout.suit.fair.horizontal,
    --awful.layout.suit.spiral,
    --awful.layout.suit.spiral.dwindle,
    --awful.layout.suit.max,
    --awful.layout.suit.max.fullscreen,
    --awful.layout.suit.magnifier,
    --awful.layout.suit.corner.nw,
    --awful.layout.suit.corner.ne,
    --awful.layout.suit.corner.sw,
    --awful.layout.suit.corner.se,
    --lain.layout.cascade,
    --lain.layout.cascade.tile,
    --lain.layout.centerwork,
    --lain.layout.centerwork.horizontal,
    --lain.layout.termfair,
    --lain.layout.termfair.center,
}

function toggleLayouts(a, b) -- a is preferred default
  if awful.layout.get(mouse.screen) == a then
    awful.layout.set(b)
  else
    awful.layout.set(a)
  end
end

function toggleHorizontalTiling()
  toggleLayouts(awful.layout.suit.tile.bottom, awful.layout.suit.tile.top)
end

function toggleVerticalTiling()
  toggleLayouts(awful.layout.suit.tile, awful.layout.suit.tile.left)
end

function toggleGridTiling()
  toggleLayouts(awful.layout.suit.fair, awful.layout.suit.fair.horizontal)
end

function toggleCenterFair()
  toggleLayouts(awful.layout.suit.fair, lain.layout.centerwork)
end

function toggleFullScreenTiling()
  toggleLayouts(awful.layout.suit.max.fullscreen, awful.layout.suit.magnifier)
end


awful.util.taglist_buttons = my_table.join(
    awful.button({ }, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),
    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

awful.util.tasklist_buttons = my_table.join(
    awful.button({ }, 1, function (c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal("request::activate", "tasklist", {raise = true})
        end
    end),
    awful.button({ }, 3, function ()
        local instance = nil

        return function ()
            if instance and instance.wibox.visible then
                instance:hide()
                instance = nil
            else
                instance = awful.menu.clients({theme = {width = 250}})
            end
        end
    end),
    awful.button({ }, 4, function () awful.client.focus.byidx(1) end),
    awful.button({ }, 5, function () awful.client.focus.byidx(-1) end)
)

lain.layout.termfair.nmaster           = 3
lain.layout.termfair.ncol              = 1
lain.layout.termfair.center.nmaster    = 3
lain.layout.termfair.center.ncol       = 1
lain.layout.cascade.tile.offset_x      = 2
lain.layout.cascade.tile.offset_y      = 32
lain.layout.cascade.tile.extra_padding = 5
lain.layout.cascade.tile.nmaster       = 5
lain.layout.cascade.tile.ncol          = 2

beautiful.init(string.format(gears.filesystem.get_configuration_dir() .. "/themes/%s/theme.lua", theme))
-- }}}

-- {{{ Menu
local myawesomemenu = {
    { "hotkeys", function() return false, hotkeys_popup.show_help end },
    { "manual", terminal .. " -e man awesome" },
    { "edit config", string.format("%s -e %s %s", terminal, editor, awesome.conffile) },
    { "restart", awesome.restart },
    { "quit", function() awesome.quit() end }
}
awful.util.mymainmenu = freedesktop.menu.build({
    icon_size = beautiful.menu_height or 16,
    before = {
        { "Awesome", myawesomemenu, beautiful.awesome_icon },
        -- other triads can be put here
    },
    after = {
        { "Open terminal", terminal },
        -- other triads can be put here
    }
})
--menubar.utils.terminal = terminal -- Set the Menubar terminal for applications that require it
-- }}}

-- {{{ Screen
-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", function(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end)
-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(function(s) 
    beautiful.get().at_screen_connect(s) end
)
-- }}}

-- {{{ Mouse bindings
root.buttons(my_table.join(
    awful.button({ }, 3, function () awful.util.mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = my_table.join(
    -- -- Take a screenshot
    -- -- https://github.com/lcpz/dots/blob/master/bin/screenshot
    -- awful.key({ altkey }, "p", function() os.execute("screenshot") end,
    --           {description = "take a screenshot", group = "hotkeys"}),

    -- -- X screen locker
    -- awful.key({ altkey, "Control" }, "l", function () os.execute(scrlocker) end,
    --           {description = "lock screen", group = "hotkeys"}),

    -- -- Hotkeys
    -- awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
    --           {description = "show help", group="awesome"}),
    -- -- Tag browsing
    -- awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
    --           {description = "view previous", group = "tag"}),
    -- awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
    --           {description = "view next", group = "tag"}),
    -- awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
    --           {description = "go back", group = "tag"}),

    -- -- Non-empty tag browsing
    -- awful.key({ altkey }, "Left", function () lain.util.tag_view_nonempty(-1) end,
    --           {description = "view  previous nonempty", group = "tag"}),
    -- awful.key({ altkey }, "Right", function () lain.util.tag_view_nonempty(1) end,
    --           {description = "view  previous nonempty", group = "tag"}),

    -- -- Default client focus
    -- awful.key({ altkey,           }, "j",
    --     function ()
    --         awful.client.focus.byidx( 1)
    --     end,
    --     {description = "focus next by index", group = "client"}
    -- ),
    -- awful.key({ altkey,           }, "k",
    --     function ()
    --         awful.client.focus.byidx(-1)
    --     end,
    --     {description = "focus previous by index", group = "client"}
    -- ),

    -- -- By direction client focus
    -- awful.key({ modkey }, "j",
    --     function()
    --         awful.client.focus.global_bydirection("down")
    --         if client.focus then client.focus:raise() end
    --     end,
    --     {description = "focus down", group = "client"}),
    -- awful.key({ modkey }, "k",
    --     function()
    --         awful.client.focus.global_bydirection("up")
    --         if client.focus then client.focus:raise() end
    --     end,
    --     {description = "focus up", group = "client"}),
    -- awful.key({ modkey }, "h",
    --     function()
    --         awful.client.focus.global_bydirection("left")
    --         if client.focus then client.focus:raise() end
    --     end,
    --     {description = "focus left", group = "client"}),
    -- awful.key({ modkey }, "l",
    --     function()
    --         awful.client.focus.global_bydirection("right")
    --         if client.focus then client.focus:raise() end
    --     end,
    --     {description = "focus right", group = "client"}),
    -- awful.key({ modkey,           }, "w", function () awful.util.mymainmenu:show() end,
    --           {description = "show main menu", group = "awesome"}),

    -- -- Layout manipulation
    -- awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
    --           {description = "swap with next client by index", group = "client"}),
    -- awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
    --           {description = "swap with previous client by index", group = "client"}),
    -- awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
    --           {description = "focus the next screen", group = "screen"}),
    -- awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
    --           {description = "focus the previous screen", group = "screen"}),
    -- awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
    --           {description = "jump to urgent client", group = "client"}),
    -- awful.key({ modkey,           }, "Tab",
    --     function ()
    --         awful.client.focus.history.previous()
    --         if client.focus then
    --             client.focus:raise()
    --         end
    --     end,
    --     {description = "go back", group = "client"}),

    -- -- Show/Hide Wibox
    -- awful.key({ modkey }, "b", function ()
    --         for s in screen do
    --             s.mywibox.visible = not s.mywibox.visible
    --             if s.mybottomwibox then
    --                 s.mybottomwibox.visible = not s.mybottomwibox.visible
    --             end
    --         end
    --     end,
    --     {description = "toggle wibox", group = "awesome"}),

    -- -- On the fly useless gaps change
    -- awful.key({ altkey, "Control" }, "+", function () lain.util.useless_gaps_resize(1) end,
    --           {description = "increment useless gaps", group = "tag"}),
    -- awful.key({ altkey, "Control" }, "-", function () lain.util.useless_gaps_resize(-1) end,
    --           {description = "decrement useless gaps", group = "tag"}),

    -- -- Dynamic tagging
    -- awful.key({ modkey, "Shift" }, "n", function () lain.util.add_tag() end,
    --           {description = "add new tag", group = "tag"}),
    -- awful.key({ modkey, "Shift" }, "r", function () lain.util.rename_tag() end,
    --           {description = "rename tag", group = "tag"}),
    -- awful.key({ modkey, "Shift" }, "Left", function () lain.util.move_tag(-1) end,
    --           {description = "move tag to the left", group = "tag"}),
    -- awful.key({ modkey, "Shift" }, "Right", function () lain.util.move_tag(1) end,
    --           {description = "move tag to the right", group = "tag"}),
    -- awful.key({ modkey, "Shift" }, "d", function () lain.util.delete_tag() end,
    --           {description = "delete tag", group = "tag"}),

    -- -- Standard program
    -- awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
    --           {description = "open a terminal", group = "launcher"}),
    -- awful.key({ modkey, "Control" }, "r", awesome.restart,
    --           {description = "reload awesome", group = "awesome"}),
    -- awful.key({ modkey, "Shift"   }, "q", awesome.quit,
    --           {description = "quit awesome", group = "awesome"}),

    -- awful.key({ altkey, "Shift"   }, "l",     function () awful.tag.incmwfact( 0.05)          end,
    --           {description = "increase master width factor", group = "layout"}),
    -- awful.key({ altkey, "Shift"   }, "h",     function () awful.tag.incmwfact(-0.05)          end,
    --           {description = "decrease master width factor", group = "layout"}),
    -- awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
    --           {description = "increase the number of master clients", group = "layout"}),
    -- awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
    --           {description = "decrease the number of master clients", group = "layout"}),
    -- awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
    --           {description = "increase the number of columns", group = "layout"}),
    -- awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
    --           {description = "decrease the number of columns", group = "layout"}),
    -- awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
    --           {description = "select next", group = "layout"}),
    -- awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
    --           {description = "select previous", group = "layout"}),

    -- awful.key({ modkey, "Control" }, "n",
    --           function ()
    --               local c = awful.client.restore()
    --               -- Focus restored client
    --               if c then
    --                   client.focus = c
    --                   c:raise()
    --               end
    --           end,
  --           {description = "restore minimized", group = "client"}),
  
    -- launch scratchpad
    awful.key({ modkey,           }, "i", function () scratchpad_term:toggle() end),
    
    awful.key({ modkey,           }, "s", function () scratchpad_slack:toggle() end),
    
    -- -- Widgets popups
    -- awful.key({ altkey, }, "c", function () lain.widget.calendar.show(7) end,
    --           {description = "show calendar", group = "widgets"}),
    -- awful.key({ altkey, }, "h", function () if beautiful.fs then beautiful.fs.show(7) end end,
    --           {description = "show filesystem", group = "widgets"}),
    -- awful.key({ altkey, }, "w", function () if beautiful.weather then beautiful.weather.show(7) end end,
    --           {description = "show weather", group = "widgets"}),

    -- -- Brightness
    -- awful.key({ }, "XF86MonBrightnessUp", function () os.execute("xbacklight -inc 10") end,
    --           {description = "+10%", group = "hotkeys"}),
    -- awful.key({ }, "XF86MonBrightnessDown", function () os.execute("xbacklight -dec 10") end,
    --           {description = "-10%", group = "hotkeys"}),

    -- -- ALSA volume control
    -- awful.key({ altkey }, "Up",
    --     function ()
    --         os.execute(string.format("amixer -q set %s 1%%+", beautiful.volume.channel))
    --         beautiful.volume.update()
    --     end,
    --     {description = "volume up", group = "hotkeys"}),
    -- awful.key({ altkey }, "Down",
    --     function ()
    --         os.execute(string.format("amixer -q set %s 1%%-", beautiful.volume.channel))
    --         beautiful.volume.update()
    --     end,
    --     {description = "volume down", group = "hotkeys"}),
    -- awful.key({ altkey }, "m",
    --     function ()
    --         os.execute(string.format("amixer -q set %s toggle", beautiful.volume.togglechannel or beautiful.volume.channel))
    --         beautiful.volume.update()
    --     end,
    --     {description = "toggle mute", group = "hotkeys"}),
    -- awful.key({ altkey, "Control" }, "m",
    --     function ()
    --         os.execute(string.format("amixer -q set %s 100%%", beautiful.volume.channel))
    --         beautiful.volume.update()
    --     end,
    --     {description = "volume 100%", group = "hotkeys"}),
    -- awful.key({ altkey, "Control" }, "0",
    --     function ()
    --         os.execute(string.format("amixer -q set %s 0%%", beautiful.volume.channel))
    --         beautiful.volume.update()
    --     end,
    --     {description = "volume 0%", group = "hotkeys"}),

    -- -- MPD control
    -- awful.key({ altkey, "Control" }, "Up",
    --     function ()
    --         os.execute("mpc toggle")
    --         beautiful.mpd.update()
    --     end,
    --     {description = "mpc toggle", group = "widgets"}),
    -- awful.key({ altkey, "Control" }, "Down",
    --     function ()
    --         os.execute("mpc stop")
    --         beautiful.mpd.update()
    --     end,
    --     {description = "mpc stop", group = "widgets"}),
    -- awful.key({ altkey, "Control" }, "Left",
    --     function ()
    --         os.execute("mpc prev")
    --         beautiful.mpd.update()
    --     end,
    --     {description = "mpc prev", group = "widgets"}),
    -- awful.key({ altkey, "Control" }, "Right",
    --     function ()
    --         os.execute("mpc next")
    --         beautiful.mpd.update()
    --     end,
    --     {description = "mpc next", group = "widgets"}),
    -- awful.key({ altkey }, "0",
    --     function ()
    --         local common = { text = "MPD widget ", position = "top_middle", timeout = 2 }
    --         if beautiful.mpd.timer.started then
    --             beautiful.mpd.timer:stop()
    --             common.text = common.text .. lain.util.markup.bold("OFF")
    --         else
    --             beautiful.mpd.timer:start()
    --             common.text = common.text .. lain.util.markup.bold("ON")
    --         end
    --         naughty.notify(common)
    --     end,
    --     {description = "mpc on/off", group = "widgets"}),

    -- -- Copy primary to clipboard (terminals to gtk)
    -- awful.key({ modkey }, "c", function () awful.spawn.with_shell("xsel | xsel -i -b") end,
    --           {description = "copy terminal to gtk", group = "hotkeys"}),
    -- -- Copy clipboard to primary (gtk to terminals)
    -- awful.key({ modkey }, "v", function () awful.spawn.with_shell("xsel -b | xsel") end,
    --           {description = "copy gtk to terminal", group = "hotkeys"}),

    -- -- User programs
    -- awful.key({ modkey }, "q", function () awful.spawn(browser) end,
    --           {description = "run browser", group = "launcher"}),
    -- awful.key({ modkey }, "a", function () awful.spawn(guieditor) end,
    --           {description = "run gui editor", group = "launcher"}),

    -- Default
    --[[ Menubar
    awful.key({ modkey }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"})
    --]]
    --[[ dmenu
    awful.key({ modkey }, "x", function ()
            os.execute(string.format("dmenu_run -i -fn 'Monospace' -nb '%s' -nf '%s' -sb '%s' -sf '%s'",
            beautiful.bg_normal, beautiful.fg_normal, beautiful.bg_focus, beautiful.fg_focus))
        end,
        {description = "show dmenu", group = "launcher"})
    --]]
    -- -- Prompt
    -- awful.key({ modkey }, "r", function () awful.screen.focused().mypromptbox:run() end,
    --           {description = "run prompt", group = "launcher"}),

    -- awful.key({ modkey }, "x",
    --           function ()
    --               awful.prompt.run {
    --                 prompt       = "Run Lua code: ",
    --                 textbox      = awful.screen.focused().mypromptbox.widget,
    --                 exe_callback = awful.util.eval,
    --                 history_path = awful.util.get_cache_dir() .. "/history_eval"
    --               }
    --           end,
    --           {description = "lua execute prompt", group = "awesome"})
  --]]
  -- launch dmenu
  awful.key({ modkey , "Shift" }, "e", function ()
      os.execute(string.format("dmenu_run -i -fn 'Monospace' -nb '%s' -nf '%s' -sb '%s' -sf '%s'",
                               beautiful.bg_normal, beautiful.fg_normal, beautiful.bg_focus, beautiful.fg_focus))
                             end,
    {description = "show dmenu", group = "launcher"}),
  
  awful.key({ modkey }, "e", function()
      awful.util.spawn_with_shell("eval \"exec `cat $HOME/.programs | " .. string.format("dmenu -i -fn 'Monospace' -nb '%s' -nf '%s' -sb '%s' -sf '%s'",
                                                                                         beautiful.bg_normal, beautiful.fg_normal, beautiful.bg_focus, beautiful.fg_focus) .. "`\"")
                             end,
    {description = "frequent programs", group="launcher"}),
  
  -- move through tags
  awful.key({ modkey,           }, "h",   awful.tag.viewnext),
  awful.key({ modkey, "Shift"   }, "h",   awful.tag.viewprev),
  
  -- move through screens
  awful.key({ modkey,               }, "o", function () awful.screen.focus_relative(1) end),
  awful.key({ modkey, "Shift"       }, "o", function () awful.screen.focus_relative(-1) end),
  awful.key({ modkey, "Control"     }, "o", function () awful.client.movetoscreen() end),
  
  -- focus history
  awful.key({ modkey,           }, "Tab", awful.tag.history.restore),
  awful.key({ modkey, "Shift"   }, "Tab", function ()
      awful.client.focus.history.previous()
      if client.focus then
        client.focus:raise()
  end end),
  
  -- move client focus up/down
  awful.key({ modkey,           }, "n", function ()
      awful.client.focus.byidx(-1)
      if client.focus then client.focus:raise() end end),
  awful.key({ modkey,           }, "r", function ()
      awful.client.focus.byidx(1)
      if client.focus then client.focus:raise() end end),
  
  -- jump to urgent client
  awful.key({ modkey,           }, "x", awful.client.urgent.jumpto),
  
  -- restore first minimized window
  awful.key({ modkey, "Shift"   }, "v", function ()
      for _, c in ipairs(client.get(mouse.screen)) do
        if (c.minimized
            and c:tags()[mouse.screen] == awful.tag.selected(mouse.screen)) then
          c.minimized = false
          client.focus = c
          c:raise()
          return
        end
      end
  end ),
  
  -- restore all minimized windows
  awful.key({ modkey, "Control" }, "v", function ()
      local gave_focus = false -- give focus to first in list
      for _, c in ipairs(client.get(mouse.screen)) do
        if (c.minimized
            and c:tags()[mouse.screen] == awful.tag.selected(mouse.screen)) then
          c.minimized = false
          c:raise()
          if not gave_focus then
            client.focus = c
            gave_focus = true
          end
        end
      end
  end ),
  
  -- move clients around
  awful.key({ modkey, "Shift"   }, "n", function () awful.client.swap.byidx(-1) end),
  awful.key({ modkey, "Shift"   }, "r", function () awful.client.swap.byidx(1) end),
  
  -- layouts
  awful.key({ modkey,           }, "space", function () awful.layout.inc(1) end),
  awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1) end),
  
  -- fast toggling of layouts
  awful.key({ modkey,           }, "m", toggleVerticalTiling),
  awful.key({ modkey, "Shift"   }, "m", toggleHorizontalTiling),
  awful.key({ modkey, "Control" }, "m", toggleGridTiling),
  awful.key({ modkey,           }, "f", toggleFullScreenTiling),
  awful.key({ modkey, "Shift"   }, "f", toggleCenterFair),
  
  -- resize winodws
  awful.key({ modkey,           }, "d", function () awful.tag.incnmaster( 1, nil, true) end),
  awful.key({ modkey, "Shift"   }, "d", function () awful.tag.incnmaster(-1, nil, true) end),
  awful.key({ modkey, "Control" }, "r", function () awful.tag.incmwfact( 0.05) end),
  awful.key({ modkey, "Control" }, "n", function () awful.tag.incmwfact(-0.05) end),
  
  -- passmenu
  awful.key({ modkey,           }, "p", function () awful.util.spawn("passmenu") end),
  
  -- launch terminal
  awful.key({ modkey,           }, "u", function () awful.util.spawn(terminal) end),
  
  -- rotate screen
  awful.key({ modkey,           }, "j", function () awful.util.spawn("rotate_screen normal") end),
  awful.key({ modkey, "Shift"   }, "j", function () awful.util.spawn("rotate_screen left") end),
  awful.key({ modkey, "Control" }, "j", function () awful.util.spawn("rotate_screen right") end),
  
  -- X screen locker
  awful.key({ modkey }, "Escape", function () os.execute(scrlocker) end,
    {description = "lock screen", group = "hotkeys"}),
  
  -- toggle trackpad
  awful.key({ modkey            }, "y", mouse_toggle),
  
  -- ALSA volume control
  awful.key({ modkey }, "Up",
      function ()
          os.execute(string.format("amixer -q set %s 1%%+", beautiful.volume.channel))
          beautiful.volume.update()
      end,
      {description = "volume up", group = "hotkeys"}),
  
  awful.key({ }, "XF86AudioRaiseVolume",
    function ()
      os.execute(string.format("amixer -q set %s 1%%+", beautiful.volume.channel))
      beautiful.volume.update()
    end,
    {description = "volume up", group = "hotkeys"}),
  
  awful.key({ modkey }, "Down",
      function ()
          os.execute(string.format("amixer -q set %s 1%%-", beautiful.volume.channel))
          beautiful.volume.update()
      end,
      {description = "volume down", group = "hotkeys"}),
  awful.key({  }, "XF86AudioLowerVolume",
    function ()
      os.execute(string.format("amixer -q set %s 1%%-", beautiful.volume.channel))
      beautiful.volume.update()
    end,
    {description = "volume down", group = "hotkeys"}),
  
  awful.key({ altkey }, "m",
      function ()
          os.execute(string.format("amixer -q set %s toggle", beautiful.volume.togglechannel or beautiful.volume.channel))
          beautiful.volume.update()
      end,
      {description = "toggle mute", group = "hotkeys"}),
  
  awful.key({                   }, "XF86AudioMute", function ()
      awful.util.spawn_with_shell("pactl set-sink-mute 0 toggle") end),
  
  awful.key({ modkey }, ".", function()
      awful.util.spawn_with_shell("sp play") end),
  
  -- Copy to clipboard
  awful.key({ modkey }, "c", function () os.execute("xclip -selection primary -o | xclip -selection clipboard -i") end),
  
  -- screenshots
  awful.key({                   }, "Print", function ()
      awful.util.spawn("screenshot.sh scr") end),
  awful.key({ modkey,           }, "Print", function ()
      awful.util.spawn("screenshot.sh win") end),
  
  -- backlights
  awful.key({                   }, "XF86MonBrightnessDown", function ()
      awful.util.spawn_with_shell("light -U 10") end),
  awful.key({                   }, "XF86MonBrightnessUp", function ()
      awful.util.spawn_with_shell("light -A 10") end),
  
  awful.key({ modkey, "Control" }, "r", awesome.restart,
    {description = "reload awesome", group = "awesome"}),
  awful.key({ modkey, "Shift"   }, "q", awesome.quit,
    {description = "quit awesome", group = "awesome"})
)
  
clientkeys = my_table.join(
  -- client movement
  awful.key({ modkey,           }, "Return", function (c) c:swap(awful.client.getmaster()) end),
  awful.key({ modkey, "Shift"   }, "Return", function (c) c.ontop = not c.ontop end),
  awful.key({ modkey, "Control" }, "Return", function (c) c.fullscreen = not c.fullscreen  end),
    
  awful.key({ altkey, "Shift"   }, "m",      lain.util.magnify_client,
    {description = "magnify client", group = "client"}),
  
  -- close it  
  awful.key({ modkey, "Shift"   }, "w",      function (c) c:kill()                         end,
    {description = "close", group = "client"}),
  
  -- close it
  awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
  awful.key({ modkey,           }, "v",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
  
  -- mark client
  awful.key({ modkey,           }, "l", function (c) awful.client.togglemarked(c) end)  
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 10 do
    -- Hack to only show tags 1 and 9 in the shortcut window (mod+s)
    local descr_view, descr_toggle, descr_move, descr_toggle_focus
    if i == 1 or i == 9 then
        descr_view = {description = "view tag #", group = "tag"}
        descr_toggle = {description = "toggle tag #", group = "tag"}
        descr_move = {description = "move focused client to tag #", group = "tag"}
        descr_toggle_focus = {description = "toggle focused client on tag #", group = "tag"}
    end
    globalkeys = my_table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  descr_view),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  descr_toggle),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  descr_move),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  descr_toggle_focus)
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey, "Shift" }, 1,
      function()
        local c = awful.mouse.client_under_pointer()
        if c then
          awful.client.floating.toggle(c)
        end
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
-- rules for automatic focus switching
function full_focus_filter(client)
  local default_focus = true  -- whether to give a client focus by default
  local stupid_client = false -- is the client stupid?

  -- pidgin is annoying, so prevent its conversations from stealing focus
  if client.class == "Pidgin" and client.role == "conversation" then
    stupid_client = true
  end

  return (default_focus and not stupid_client and awful.client.focus.filter)
end

awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = full_focus_filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen,
                     size_hints_honor = false
     }
    },
    
    -- ignore that stupid urxvt gap
    { rule_any = { class = { "URxvt", "Emacs" } },
      properties = { size_hints_honor = false }},
    
    -- float these by default
    { rule_any = { class = {
                     "mpv",
                     "pinentry",
                     "Wine",
                     "Gxmessage",
                     "anking",
                     "Plugin-container"
                 }},
      properties = { floating = true }},
    
    -- keep them on top
    { rule_any = { class = { "mpv", "CMST" }},
      properties = { ontop  = true,
                     sticky = true,
    }},
    
    -- Set Firefox to always map on the first tag on screen 1.
    -- default tags
    { rule_any = { class = { "Pidgin",
                             "Firefox",
                             "Chromium-browser"
                 }},
      properties = { tag = awful.util.tagnames[10] }},
    
    { rule_any = { name  = {"Figure [0-9].*"}}, properties = {floating = true }},
    
    { rule_any = { class = {"Spotify"}},
      properties = { tag = awful.util.tagnames[8] }},

    { rule = { class = "Gimp", role = "gimp-image-window" },
          properties = { maximized = true } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_overlap(c)
        awful.placement.no_offscreen(c)
    end
end)

client.connect_signal("focus",   function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = true})
end)

-- No border for maximized clients
function border_adjust(c)
    if c.maximized then -- no borders if only 1 client visible
        c.border_width = 0
    elseif #awful.screen.focused().clients > 1 then
        c.border_width = beautiful.border_width
        c.border_color = beautiful.border_focus
    end
end

client.connect_signal("property::maximized", border_adjust)

-- client.connect_signal("focus", border_adjust)
-- client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
