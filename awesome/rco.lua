-- Standard awesome library
--require("awful")
--require("awful.autofocus")
--require("awful.rules")
-- Theme handling library
--require("beautiful")
-- Notification library
--require("naughty")
--require("vicious")
--require("revelation")

local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")


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
    awesome.add_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
--beautiful.init("/usr/share/awesome/themes/default/theme.lua")
beautiful.init("/home/dude/.config/awesome/themes/default/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "urxvt"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    --awful.layout.suit.spiral,
    --awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    --awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier
}
-- }}}

-- {{{ Tags
 -- Define a tag table which will hold all screen tags.
 tags = {
   names  = { "! Main", 		"@ WWW",		"# Gaming",
			  "$ Coding",		"% Office",	"^ im", "& Video"},
   layout = { layouts[3],	layouts[8], layouts[2],
			  layouts[2],	layouts[2],	layouts[1], layouts[1]}
 }
 for s = 1, screen.count() do
     -- Each screen has its own tag table.
     tags[s] = awful.tag(tags.names, s, tags.layout)
 end
 -- }}}



-- Enable mocp
function moc_control (action)
    local moc_info,moc_state

    if action == "next" then
        io.popen("mocp --next")
    elseif action == "previous" then
        io.popen("mocp --previous")
    elseif action == "stop" then
        io.popen("mocp --stop")
    elseif action == "play_pause" then
        moc_info = io.popen("mocp -i"):read("*all")
            moc_state = string.gsub(string.match(moc_info, "State: %a*"),"State: ","")

        if moc_state == "PLAY" then
            io.popen("mocp --pause")
        elseif moc_state == "PAUSE" then
            io.popen("mocp --unpause")
        elseif moc_state == "STOP" then
            io.popen("mocp --play")
        end
    end
end

 

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "reload", awesome.restart },
   { "quit", awesome.quit },
   { "reboot", "reboot" },
   { "shutdown", "shutdown" }
}

appsmenu = {
   { "urxvt", "urxvt" },
   { "sakura", "sakura" },
   { "ncmpcpp", terminal .. " -e ncmpcpp" },
   { "luakit", "luakit" },
   { "uzbl", "uzbl-browser" },
   { "firefox", "firefox" },
   { "chromium", "chromium" },
   { "thunar", "thunar" },
   { "ranger", terminal .. " -e ranger" },
   { "gvim", "gvim" },
   { "leafpad", "leafpad" },
   { "htop", terminal .. " -e htop" },
   { "sysmonitor", "gnome-system-monitor" }
}

gamesmenu = {
   { "warsow", "warsow" },
   { "nexuiz", "nexuiz" },
   { "xonotic", "xonotic" },
   { "openarena", "openarena" },
   { "alienarena", "alienarena" },
   { "teeworlds", "teeworlds" },
   { "frozen-bubble", "frozen-bubble" },
   { "warzone2100", "warzone2100" },
   { "wesnoth", "wesnoth" },
   { "supertuxkart", "supertuxkart" },
   { "xmoto" , "xmoto" },
   { "flightgear", "flightgear" },
   { "snes9x" , "snes9x" },

}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu },
                                    { "apps", appsmenu },
				    { "games", gamesmenu },
                                    { "terminal", terminal },
				    { "web browser", browser },
				    { "text editor", geditor }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })
-- }}}

-- {{{ Wibox

-- Initialize widget
memwidgettext = widget({ type = "textbox" })

-- Create a textclock widget
mytextclock = awful.widget.textclock({ align = "right" })

-- calendar widget

function displayMonth(month,year,weekStart)
	local t,wkSt=os.time{year=year, month=month+1, day=0},weekStart or 1
	local d=os.date("*t",t)
	local mthDays,stDay=d.day,(d.wday-d.day-wkSt+1)%7

	print(mthDays .."\n" .. stDay)
	local lines = "    "

	for x=0,6 do
		lines = lines .. os.date("%a ",os.time{year=2006,month=1,day=x+wkSt})
	end

	lines = lines .. "\n" .. os.date(" %V",os.time{year=year,month=month,day=1})

	local writeLine = 1
	while writeLine < (stDay + 1) do
		lines = lines .. "    "
		writeLine = writeLine + 1
	end

	for d=1,mthDays do
		local x = d
		local t = os.time{year=year,month=month,day=d}
		if writeLine == 8 then
			writeLine = 1
			lines = lines .. "\n" .. os.date(" %V",t)
		end
		if os.date("%Y-%m-%d") == os.date("%Y-%m-%d", t) then
			x = "<u>" .. d .. "</u>"
		end
		if (#(tostring(d)) == 1) then
			x = " " .. x
		end
		lines = lines .. "  " .. x
		writeLine = writeLine + 1
	end
	local header = os.date("%B %Y\n",os.time{year=year,month=month,day=1})

	return header .. "\n" .. lines
end

local calendar = {}
function switchNaughtyMonth(switchMonths)
	if (#calendar < 3) then return end
	local swMonths = switchMonths or 1
	calendar[1] = calendar[1] + swMonths
	calendar[3].box.widgets[2].text = string.format('<span font_desc="%s">%s</span>', "monospace", displayMonth(calendar[1], calendar[2], 2))
end

function switchNaughtyGoToToday()
        if (#calendar < 3) then return end
        local swMonths = switchMonths or 1
        calendar[1] = os.date("*t").month
        calendar[2] = os.date("*t").year
       switchNaughtyMonth(0)
end

mytextclock:add_signal('mouse::enter', function ()
	local month, year = os.date('%m'), os.date('%Y')
	calendar = { month, year, 
	naughty.notify({
		text = string.format('<span font_desc="%s">%s</span>', "monospace", displayMonth(month, year, 2)),
		timeout = 0,
		hover_timeout = 0.5,
		screen = mouse.screen
	})
}
end)
mytextclock:add_signal('mouse::leave', function () naughty.destroy(calendar[3]) end)

mytextclock:buttons(awful.util.table.join(
awful.button({ }, 1, function()
	switchNaughtyMonth(-1)
end),
awful.button({ }, 2, switchNaughtyGoToToday),
awful.button({ }, 3, function()
	switchNaughtyMonth(1)
end),
awful.button({ }, 4, function()
	switchNaughtyMonth(-1)
end),
awful.button({ }, 5, function()
	switchNaughtyMonth(1)
end),
awful.button({ 'Shift' }, 1, function()
	switchNaughtyMonth(-12)
end),
awful.button({ 'Shift' }, 3, function()
	switchNaughtyMonth(12)
end),
awful.button({ 'Shift' }, 4, function()
	switchNaughtyMonth(-12)
end),
awful.button({ 'Shift' }, 5, function()
	switchNaughtyMonth(12)
end)
))

-- Register widget
vicious.register(memwidgettext, vicious.widgets.mem, "$1% ($2MB/$3MB)", 13)

-- Moc Widget
tb_moc = widget({ type = "textbox", align = "right" })


function hook_moc()
       moc_info = io.popen("mocp -i"):read("*all")
       if moc_info == ""
       then
		return "No MOCP"
       end
       
       moc_state = string.gsub(string.match(moc_info, "State: %a*"),"State: ","")
       if moc_state == "PLAY" or moc_state == "PAUSE" then
           moc_artist = string.gsub(string.match(moc_info, "Artist: %C*"), "Artist: ","")
           moc_title = string.gsub(string.match(moc_info, "SongTitle: %C*"), "SongTitle: ","")
           moc_curtime = string.gsub(string.match(moc_info, "CurrentTime: %d*:%d*"), "CurrentTime: ","")
           moc_totaltime = string.gsub(string.match(moc_info, "TotalTime: %d*:%d*"), "TotalTime: ","")
           if moc_artist == "" then
               moc_artist = "unknown artist"
           end
           if moc_title == "" then
               moc_title = "unknown title"
           end
       -- moc_title = string.format("%.5c", moc_title)
           moc_string = moc_artist .. " - " .. moc_title .. "(" .. moc_curtime .. "/" .. moc_totaltime .. ")"
           if moc_state == "PAUSE" then
               moc_string = "PAUSE - " .. moc_string .. ""
           end
       else
           moc_string = "-- not playing --"
       end
       return moc_string
end

-- refresh Moc widget
--awful.hooks.timer.register(1, function() tb_moc.text = '| ' .. hook_moc() .. ' ' end)
moc_timer = timer({timeout = 1})
moc_timer:add_signal("timeout", function() tb_moc.text = '| ' .. hook_moc() .. ' ' end)
moc_timer:start()


-- Server Widget
server_status = widget({ type = "textbox", align = "right" })
server_status_t = awful.tooltip({ objects = { server_status},})


function hook_server()
	   serverstring = ""
       ports = io.popen("netstat -an | grep LISTEN | awk '{print $4}' | awk -F: '{print $2}' | grep '.*.'"):read("*all")
        --ports = io.popen("nmap -sT  localhost"):read("*all") -- cheaper 
       --ftp_state = string.match(ports, "21")
       --http_state = string.match(ports, "80")
       --ssh_state = string.match(ports, "22")
       ftp_state = "Down"
       http_state = "Down"
       ssh_state = "Down"
       
		for port in string.gmatch(ports, "%d+") do
			if port == "21"
			then
				ftp_state = "Up"
			elseif port == "22"
			then
				ssh_state = "Up"
			elseif port == "80"
			then
				http_state = "Up"
			end
		end

		serverstring = "FTP: " .. ftp_state .. " HTTP: " .. http_state .. " SSH: " .. ssh_state

       
       return serverstring
end



server_timer = timer({timeout = 1})
server_timer:add_signal("timeout", function() server_status.text = '| ' .. hook_server() .. ' ' end)
server_timer:start()


 channel = "jack.jack1c.pcm1"
 function volume (mode, widget)
	if mode == "update" then
             local fd = io.popen("ossmix " .. channel)
             local volume = fd:read("*all"):match("(%d+)")
             fd:close()
               
               volume = tonumber(volume)
               
		if volume == 0 then
			volume = 'VOL: MUTE'
		else
			volume = 'VOL: ' .. volume .. '%'
		end
		widget.text = volume
	elseif mode == "up" then
		awful.util.spawn("ossmix " .. channel .. " +5")
		--If you are using my ossvol script replace the previous line with the following one
		--awful.util.spawn("ossvol -i 5")
		volume("update", widget)
	elseif mode == "down" then
		awful.util.spawn("ossmix " .. channel .. " -- -5")
		--If you are using my ossvol script replace the previous line with the following one
		--awful.util.spawn("ossvol -d 5")
		volume("update", widget)
	else
		--The mute option is useless without ossvol, ossmix does not navitely support muting
		awful.util.spawn("ossvol -t")
		volume("update", widget)
	end
 end

 volwidget = widget({ type = 'textbox', name = 'volwidget' })
 volwidget:buttons({
       button({ }, 4, function () volume("up", volwidget) end),
       button({ }, 5, function () volume("down", volwidget) end),
       button({ }, 1, function () volume("mute", volwidget) end)
 })
 --volume("update", volwidget)
 awful.hooks.timer.register(1, function () volume("update", volwidget) end)


separator = widget({ type = "textbox" })
separator.text  = " | "  
 
 -- Initialize widget
memwidget = awful.widget.progressbar()
-- Progressbar properties
memwidget:set_width(8)
memwidget:set_height(10)
memwidget:set_vertical(true)
memwidget:set_background_color("#494B4F")
memwidget:set_border_color(nil)
memwidget:set_color("#AECF96")
memwidget:set_gradient_colors({ "#AECF96", "#88A175", "#FF5656" })
-- Register widget
vicious.register(memwidget, vicious.widgets.mem, "$1", 13)

 

cputext = widget({ type = "textbox" })
cputext.text  = "معالج "

cpu1text = widget({ type = "textbox" })
cpu1text.text  = "2:"

cpu2text = widget({ type = "textbox" })
cpu2text.text  = "1:"


-- Initialize widget
cpu1widget = awful.widget.graph()
-- Graph properties
cpu1widget:set_width(50)
cpu1widget:set_background_color("black")
cpu1widget:set_color("#FF5656")
cpu1widget:set_gradient_colors({ "#FF5656", "#88A175", "#AECF96" })
-- Register widget
vicious.register(cpu1widget, vicious.widgets.cpu, "$1")

-- Initialize widget
cpu2widget = awful.widget.graph()
-- Graph properties
cpu2widget:set_width(50)
cpu2widget:set_background_color("black")
cpu2widget:set_color("#FF5656")
cpu2widget:set_gradient_colors({ "#FF5656", "#88A175", "#AECF96" })
-- Register widget
vicious.register(cpu2widget, vicious.widgets.cpu, "$2")


-- Weather widget
weatherwidget = widget({ type = "textbox" })
weather_t = awful.tooltip({ objects = { weatherwidget },})

vicious.register(weatherwidget, vicious.widgets.weather,
                function (widget, args)
                    weather_t:set_text("City: " .. args["{city}"] .."\nWind: " .. args["{windkmh}"] .. "km/h " .. args["{wind}"] .. "\nSky: " .. args["{sky}"] .. "\nHumidity: " .. args["{humid}"] .. "%")
                    return args["{tempc}"] .. "C"
                end, 1800, "HECA")
                --'1800': check every 30 minutes.
                --'CYUL': the Montreal ICAO code.
-- Pacman Widget
pacwidget = widget({type = "textbox"})

pacwidget_t = awful.tooltip({ objects = { pacwidget},})

vicious.register(pacwidget, vicious.widgets.pkg,
                function(widget,args)
                    local io = { popen = io.popen }
                    local s = io.popen("pacman -Qu")
                    local str = ''

                    for line in s:lines() do
                        str = str .. line .. "\n"
                    end
                    pacwidget_t:set_text(str)
                    s:close()
                    return "UPDATES: " .. args[1]
                end, 36000, "Arch")

                --'1800' means check every 30 minutes

 --  Network usage widget
 -- Initialize widget
 netwidget = widget({ type = "textbox" })
 -- Register widget
 vicious.register(netwidget, vicious.widgets.net, '<span color="#CC9393">${eth0 down_kb}</span> <span color="#7F9F7F">${eth0 up_kb}</span>', 3)



-- Create a systray
mysystray = widget({ type = "systray" })

-- Create a wibox for each screen and add it
mywibox = {}
mywibox2 = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(function(c)
                                              return awful.widget.tasklist.label.currenttags(c, s)
                                          end, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })
    mywibox2[s] = awful.wibox({ position = "bottom", screen = s })
    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = {
        {
            mylauncher,
            mytaglist[s],
            mypromptbox[s],
            layout = awful.widget.layout.horizontal.leftright
        },
        mylayoutbox[s],
        mytextclock,
        tb_moc,
        memwidget.widget,
        memwidgettext,
        cputext,
        cpu1text,
        cpu1widget.widget,
        cpu2text,
        cpu2widget.widget,
        separator,
        netwidget,
        separator,
        server_status,
        separator,
        volwidget,
        --weatherwidget,
        separator,
        pacwidget,
        separator,
        layout = awful.widget.layout.horizontal.rightleft
    }
    
        mywibox2[s].widgets = {
        s == 1 and mysystray or nil,
        mytasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
    }
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
-- revelation expose
awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
awful.key({ modkey,           }, "Escape", awful.tag.history.restore),
awful.key({modkey}, "e", revelation),

-- Application switcher

	awful.key({ "Mod1" }, "Tab", function ()
     -- If you want to always position the menu on the same place set coordinates
     awful.menu.menu_keys.down = { "Down", "Alt_L" }
     local cmenu = awful.menu.clients({width=245}, { keygrabber=true, coords={x=525, y=330} }) end),
     
     -- alt + tab
    awful.key({ "Mod1", }, "Shift_L",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
		end),
		
	awful.key({ modkey }, "0", function (c)
    awful.util.spawn("transset-df --actual --inc 0.1")
    end),
    awful.key({ modkey }, "9", function (c)
        awful.util.spawn("transset-df --actual --dec 0.1")
    end),
    
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "m", function () mymainmenu:show({keygrabber=true}) end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "l", function () awful.util.spawn("xlock") end),
    awful.key({ modkey,           }, "/", function () awful.util.spawn("xrandr --output CRT1 --mode 1440x900") end),
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    --awful.key({ modkey }, "x",
    --          function ()
    --              awful.prompt.run({ prompt = "Run Lua code: " },
    --              mypromptbox[mouse.screen].widget,
    --              awful.util.eval, nil,
    --              awful.util.getdir("cache") .. "/history_eval")
    --          end),
    
    
    
    --awful.key({ }, "XF86AudioRaiseVolume", function () volume("up", tb_volume) end),
    --awful.key({ }, "XF86AudioLowerVolume", function () volume("down", tb_volume) end),
    --awful.key({ }, "XF86AudioMute", function () volume("mute", tb_volume) end),
    awful.key({}, "XF86AudioNext", function () moc_control("next") end),
    awful.key({}, "XF86AudioPrev" , function () moc_control("previous") end),
    awful.key({}, "XF86AudioStop" , function () moc_control("stop") end),
    awful.key({}, "XF86AudioPlay" , function () moc_control("play_pause") end),
    awful.key({}, "XF86AudioRaiseVolume" , function () volume("up", volwidget) end),
    awful.key({}, "XF86AudioLowerVolume" , function () volume("down", volwidget) end),
    awful.key({}, "XF86AudioMute" , function () volume("mute", volwidget) end)


)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey 			  }, "w",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
        


)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end)),
                  
-- Move Window to Workspace Left/Right
awful.key({ modkey, "Shift"   }, ",",
    function (c)
        local curidx = awful.tag.getidx(c:tags()[1])
        if curidx == 1 then
            c:tags({screen[mouse.screen]:tags()[9]})
        else
            c:tags({screen[mouse.screen]:tags()[curidx - 1]})
        end
    end),
awful.key({ modkey, "Shift"   }, ".",
  function (c)
        local curidx = awful.tag.getidx(c:tags()[1])
        if curidx == 9 then
            c:tags({screen[mouse.screen]:tags()[1]})
        else
            c:tags({screen[mouse.screen]:tags()[curidx + 1]})
        end
        --screen[mouse.screen]:tags()[].focus()
        c:tags()[1].focus()
    end)

end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     size_hints_honor = true } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } ,
      properties = { tag = tags[1][7] } },
          { rule = { class = "smplayer" },
      properties = { floating = true } ,
      properties = { tag = tags[1][7] } },
    { rule = { class = "Remote_akkumatik.py" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    { rule = { class = "Cinelerra" },
      properties = { floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    { rule = { class = "Firefox" },
      properties = { tag = tags[1][2] } },
    { rule = { class = "Pidgin" },
      properties = { tag = tags[1][6] } },
      
    { rule = { class = "xterm" },
      properties = { tag = tags[1][6] }, callback = function(c) c:geometry({x=0, y=0}) end, opacity = 0.6 },
      
      
      
},
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
client.add_signal("focus", function(c)
                              c.border_color = beautiful.border_focus
                              c.opacity = 1
                           end)
client.add_signal("unfocus", function(c)
                                c.border_color = beautiful.border_normal
                                c.opacity = 0.8
                             end)
                             
                             
function ror(c)

   --local clients = client.get()

   --for  cc in clients
   --do
		--if cc.class == c.class
		--then
			--if current tag != c.tag
			--then
				--focus on the c.tag
			--end
		--end
   --end
            
	c:tags()[1].focus()
      
end

--client.add_signal("manage", function (c) if c  then  end end )
client.add_signal("manage",
    function(c)
    --c:tags()[1].focus()
    --awful.tag.viewonly(c:tags()[1])
    --viewidx(awful.tag.getidx(c:tags()[1]), 0)
    if c ~= nil
    then
    print(c.name)
    end
	end)
-- }}}



function run_once(cmd, screen)
  findme = cmd
  firstspace = cmd:find(" ")
  if firstspace then
    findme = cmd:sub(0, firstspace-1)
  end
  awful.util.spawn_with_shell("pgrep -u $USER -x " .. findme .. " > /dev/null || (" .. cmd .. ")", screen)
end

run_once("qxkb &")
run_once("pidgin &")
run_once("liferea &")
run_once("gringotts &")
--run_once("xcompmgr -CF &")
 
 
 
 
 
 
 
 
 
 --Keeping multitags persistent
 
-- Bind all key numbers to F keys.
-- Keep a (semi-)persistant mapping of active multitags
-- This should map on the top row of your keyboard, usually F1 to F9.
extra_tags = {}
for i = 1, keynumber do
    extra_tags[i] = {}
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ }, "F" .. i,
                  function ()
		     local screen = mouse.screen
		     local curtag = tags[screen][i]
		     if curtag then
			awful.tag.viewonly(curtag)
		     end
		     for tag,v in pairs(extra_tags[i]) do 
			if v then
			   awful.tag.viewtoggle(tags[screen][tag])
			end
		     end
                  end),
        awful.key({ "Control" }, "F" .. i,
                  function ()
		     local screen = mouse.screen
		     local curtag = awful.tag.getidx(awful.tag.selected(screen))
		     local selected = awful.tag.selectedlist(screen)
		     local found = false
		     for i_,v in ipairs(selected) do 
			v = awful.tag.getidx(v)
			if v == i then
			   found = true
			   break
			end
		     end
		     if found then
			extra_tags[curtag][i] = false
		     else
			extra_tags[curtag][i] = true
		     end
		     if tags[screen][i] then
			awful.tag.viewtoggle(tags[screen][i])
		     end
                  end),
        awful.key({ "Shift" }, "F" .. i,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ "Control", "Shift" }, "F" .. i,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end





-- After this you can use blinking(any_textbox_widget,blinking_interval_in_seconds). The call of blinking function toggles the blinking of text. 
blinkers = {}
function blinking(tb,iv)
    if (tb==nil) then 
        return
    end
    local fiv = iv or 1
    if blinkers[tb] then
        if blinkers[tb].timer.started then
            blinkers[tb].timer:stop()
        else
            blinkers[tb].timer:start()
        end
    else
        if (tb.text == nil) then
            return
        end
        blinkers[tb]= {}
        blinkers[tb].timer = timer({timeout=fiv})
        blinkers[tb].text = tb.text
        blinkers[tb].empty = 0

        blinkers[tb].timer:add_signal("timeout", function ()
            if (blinkers[tb].empty==1) then
                tb.text = blinkers[tb].text
                blinkers[tb].empty=0
            else
                blinkers[tb].empty=1
                tb.text = ""
            end
        end)

        blinkers[tb].timer:start()

    end
end




      

awful.util.spawn_with_shell("xcompmgr -CF &")
--awful.util.spawn_with_shell("unagi &")
--awful.util.spawn_with_shell("compton -C -F -G -m .8")
--ips_t = awful.tooltip({ objects = { ipsimg},})
--ips_t:set_text(get_ips())







