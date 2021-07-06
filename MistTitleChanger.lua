MistTitleChanger = {}
local self = MistTitleChanger
local selfs = "MistTitleChanger"

function self.Init()
  self.data_dir = GetLuaModsPath() .. "/" .. selfs .. "/data"
  self.ps1 = self.data_dir .. "/SetWindowTitle.ps1"
  self.worlds = persistence.load(self.data_dir .. "/worlds.lua")
  self.lastworld = 0
  self.throttle = 1000
  self.lastcheck = Now()
  d(selfs .. " loaded")
end

function self.GetWorldName(id)
  return self.worlds[id] or "Unknown"
end

function self.GetWorldText()
  local currentworld = self.GetWorldName(Player.currentworld)
  local homeworld = self.GetWorldName(Player.homeworld)
  if (currentworld ~= homeworld) then
    return currentworld .. " (" .. homeworld .. ")"
  else
    return homeworld
  end
end

function self.SetTitle(title)
  local pscmd = {
    'powershell -NoProfile -File ',
    self.ps1,
    ' -proc ',
    GetCurrentPID(),
    ' -title "',
    title,
    '"'
  }
  return io.popen(table.concat(pscmd)):close()
end

function self.Update(event, ticks)
  if (MGetGameState() == FFXIV.GAMESTATE.INGAME) then
    if (TimeSince(self.lastcheck) > self.throttle) then
      self.lastcheck = Now()
      if (self.lastworld ~= Player.currentworld) then
        self.lastworld = Player.currentworld
        self.SetTitle(Player.name .. " - " .. self.GetWorldText())
      end
    end
  end
end

RegisterEventHandler("Module.Initalize", self.Init, selfs .. ".Init")
RegisterEventHandler("Gameloop.Update", self.Update, selfs .. ".Update")
