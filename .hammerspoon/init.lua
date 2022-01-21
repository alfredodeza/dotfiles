hs.window.animationDuration = 0.1
units = {
  right30       = { x = 0.70, y = 0.00, w = 0.30, h = 1.00 },
  right70       = { x = 0.30, y = 0.00, w = 0.70, h = 1.00 },
  left70        = { x = 0.00, y = 0.00, w = 0.70, h = 1.00 },
  right50       = { x = 0.50, y = 0.00, w = 0.50, h = 1.00 },
  left50        = { x = 0.00, y = 0.00, w = 0.50, h = 1.00 },
  left30        = { x = 0.00, y = 0.00, w = 0.30, h = 1.00 },
  top50         = { x = 0.00, y = 0.00, w = 1.00, h = 0.50 },
  bot50         = { x = 0.00, y = 0.50, w = 1.00, h = 0.50 },
  upright30     = { x = 0.70, y = 0.50, w = 0.30, h = 0.50 },
  botright30    = { x = 0.70, y = 0.00, w = 0.30, h = 0.50 },
  upleft30      = { x = 0.00, y = 0.00, w = 0.30, h = 0.50 },
  botleft30     = { x = 0.00, y = 0.50, w = 0.30, h = 0.50 },
  maximum       = { x = 0.00, y = 0.00, w = 1.00, h = 1.00 },
  center       =  { x = 0.30, y = 0.30, w = 0.40, h = 1.00 },
}

mash = { 'ctrl', 'alt', 'cmd' }
hs.hotkey.bind(mash, 'l', function() hs.window.focusedWindow():move(units.right30,    nil, true) end)
hs.hotkey.bind(mash, 'h', function() hs.window.focusedWindow():move(units.left30,     nil, true) end)
hs.hotkey.bind(mash, 'k', function() hs.window.focusedWindow():move(units.top50,      nil, true) end)
hs.hotkey.bind(mash, 'j', function() hs.window.focusedWindow():move(units.bot50,      nil, true) end)
hs.hotkey.bind(mash, 'y', function() hs.window.focusedWindow():move(units.upleft30,   nil, true) end)
hs.hotkey.bind(mash, 'u', function() hs.window.focusedWindow():move(units.botleft30,  nil, true) end)
hs.hotkey.bind(mash, 'o', function() hs.window.focusedWindow():move(units.botright30, nil, true) end)
hs.hotkey.bind(mash, "i", function() hs.window.focusedWindow():move(units.upright30,  nil, true) end)
hs.hotkey.bind(mash, 'm', function() hs.window.focusedWindow():move(units.maximum,    nil, true) end)
hs.hotkey.bind(mash, ']', function() hs.window.focusedWindow():move(units.center,     nil, true) end)
hs.hotkey.bind(mash, 'f', function() hs.window.focusedWindow():move(units.maximum,    nil, true) end)
hs.hotkey.bind(mash, 'n', function() hs.window.focusedWindow():move(units.left50,    nil, true) end)
hs.hotkey.bind(mash, '.', function() hs.window.focusedWindow():move(units.right50,    nil, true) end)


hs.loadSpoon("SpoonInstall")
Install=spoon.SpoonInstall

Install:andUse("KSheet",
               {
                 hotkeys = {
                   toggle = { mash, "/" }
}})


Install:andUse("Seal",
               {
                 hotkeys = { show = { mash, "space" } },
                 fn = function(s)
                   s:loadPlugins({"apps", "useractions"})
                   s.plugins.useractions.actions =
                     {
			    ["Red Hat Bugzilla"] = { url = "https://bugzilla.redhat.com/show_bug.cgi?id=${query}", icon="favicon", keyword="bz" },
			    ["Red Hat Support"] = { url = "https://access.redhat.com/support/cases/#/case/${query}", icon="favicon", keyword="sup" },
			    ["Red Hat Support Exception"] = { url = "https://tools.apps.cee.redhat.com/support-exceptions/id/${query}", icon="favicon", keyword="se" },
			    ["Launchpad Bugs"] = { url = "https://launchpad.net/bugs/${query}", icon="favicon", keyword="lp" },
                     }
                   s:refreshAllCommands()
                 end,
                 start = true,
               }
)
