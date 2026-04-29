local appwatcher = hs.application.watcher

local function sh(cmd)
  hs.execute(cmd, true)
end

local function jump(appName)
  local ignore = {
    ["Hammerspoon"] = true,
    ["Raycast"] = true,
    ["System Settings"] = true,
    ["System Preferences"] = true,
  }

  if ignore[appName] then return end

  local app = hs.application.find(appName)
  if not app then return end

  local win = app:mainWindow()
  if not win then return end

  local id = win:id()
  if not id then return end

  local out = hs.execute(
    "yabai -m query --windows --window " .. id .. " | jq -r ''.space''",
    true
  )

  local space = tonumber((out or ""):match("%d+"))
  if not space then return end

  sh("yabai -m space --focus " .. space)
  hs.timer.usleep(120000)
  sh("yabai -m window --focus " .. id)
end

appwatcher.new(function(name, event)
  if event == appwatcher.activated then
    hs.timer.doAfter(0.03, function()
      pcall(jump, name)
    end)
  end
end):start()

hs.alert.show("Hammerspoon loaded")
