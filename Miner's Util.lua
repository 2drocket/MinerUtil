-- Paths

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local char = player.Character -- must be lowercase
local bxs = Workspace.Boxes

-- Global Variables

getgenv().autoBuy = false;   
getgenv().autoCrate = false; 
getgenv().crateTpToggle = false;


-- Settings

settingsTable = {
    rebirthKeyBind = 'V',
    loadLay1KeyBind = 'B',
    loadLay2KeyBind = 'N',
    loadLay3KeyBind = 'M',
    withdrawKeyBind = 'K',
    pulseKeyBind = 'J',
    teleportKeyBind = 'G'

}

print("---DEFAULT SETTINGS---")
for i,v in pairs(settingsTable) do
    print(i,v)
end
print("-------")

function loadSettings()
    print("Loading settings")
    if(readfile and isfile and isfile(filename)) then
        settingsTable = HttpService:JSONEncode(readfile(filename));
        print("Settings loaded")
        print("New settings are")
        for i,v in pairs(settingsTable) do
            print(i,v)
        end
    end
end

function saveSettings()
    print("Saving current settings")
    local json;
    if (writefile) then
        json = HttpService:JSONEncode(settingsTable);
        writefile(filename, json);
    else
        print("Settings can not be saved due to your executor")
    end
end
  
-- Scripts

function purchaser()
    spawn(function()
        while autoBuy == true do
            local args = {
                [1] = "Basic Iron Mine",    
                [2] = 99
            }
            ReplicatedStorage.BuyItem:InvokeServer(unpack(args))
        end  
    end)
end

function teleportTo(placeCFrame) -- Teleports player to selected location
    local plyr = game.Players.LocalPlayer;
    if plyr.Character then
        plyr.Character.HumanoidRootPart.CFrame = placeCFrame;
    end
end

function teleportLocation(location) -- Finds selected location
    if game:GetService("Workspace").Tycoons:FindFirstChild(location) then
        teleportTo(game:GetService("Workspace").Tycoons[location].Base.CFrame)
    end
end

function opener()
    spawn(function()
        while autoCrate == true do
            local args = {
                [1] = "Inferno"
            }
            ReplicatedStorage.MysteryBox:InvokeServer(unpack(args))
        end
    end)
end

function crate()
    spawn(function()
        while crateTpToggle == true do
            for i, v in pairs(bxs:GetChildren()) do
                char.HumanoidRootPart.CFrame = v.CFrame+Vector3.new(math.random(0,0),0,math.random(0,0))
                wait(0.8)
                 if crateTpToggle == false then break end
            end
            wait()
        end
    end)
end

-- GUI

if _G.hereiambabyhehe ~= true then
    _G.hereiambabyhehe = true
elseif _G.hereiambabyhehe == true then
    local removethat = game.CoreGui:FindFirstChild("FluxLib") -- this bit of code is to use the fixed version of Flux Lib
    removethat:Destroy()
    removethat:Remove()
end

local Flux = loadstring(game:HttpGet"https://raw.githubusercontent.com/2drocket/MinerUtil/main/FluxLibTweaked.lua")()

local win = Flux:Window("Miner's Util", Color3.fromRGB(255, 110, 48), Enum.KeyCode.RightControl)
local tab1 = win:Tab("Farming", "http://www.roblox.com/asset/?id=6023426915")
local tab2 = win:Tab("Teleports", "http://www.roblox.com/asset/?id=6023426915")
local tab3 = win:Tab("Settings", "http://www.roblox.com/asset/?id=6023426915")

-- Tab 1

tab1:Toggle("Auto bazingium", "Automatically purchases 99x iron mines", false, function(bool)
    getgenv().autoBuy = bool
    print('Auto buy is: ', bool);
    if bool then
        purchaser();
    end
end)

tab1:Toggle("Auto Box Opener", "Automatically opens Inferno, Regular and Unreal boxes", false, function(bool)
    getgenv().autoCrate = bool
    print('Auto buy is: ', bool);
    if bool then
        opener();
    end
end)

tab1:Toggle("Crate TP", "Automatically teleport to boxes across the map", false, function(bool)
    getgenv().crateTpToggle = bool
    print('Crate TP is: ', bool);
    if bool then
        crate();
    end
end)

-- Tab 2

local selectedLocation;

tab2:Dropdown("Select a base via drop down menu",{"Factory1","Factory2","Factory3","Factory4","Factory5","Factory6"},function(value)
    selectedLocation = value;
    print(value)
end)

tab2:Button("Teleport", "Teleport to a selected location decided by the drop down menu above.",function()
    if selectedLocation then
        teleportLocation(selectedLocation)
    end
end)

-- Tab 3

tab3:Label("Keybinds")

tab3:Bind("Rebirth", Enum.KeyCode[settingsTable.rebirthKeyBind], function() 
    local args = {
        [1] = 26
    }
    ReplicatedStorage.Rebirth:InvokeServer(unpack(args))
    saveSettings()
 end)

 tab3:Bind("Load layout 1", Enum.KeyCode[settingsTable.loadLay1KeyBind], function() 
    local args = {
        [1] = "Load",
        [2] = "Layout1"
    }
    ReplicatedStorage.Layouts:InvokeServer(unpack(args))
    saveSettings()
 end)

 tab3:Bind("Load layout 2", Enum.KeyCode[settingsTable.loadLay2KeyBind], function() 
    local args = {
        [1] = "Load",
        [2] = "Layout2"
    }
    ReplicatedStorage.Layouts:InvokeServer(unpack(args))
    saveSettings()
 end)

tab3:Bind("Load layout 3", Enum.KeyCode[settingsTable.loadLay3KeyBind], function() 
    local args = {
        [1] = "Load",
        [2] = "Layout3"
    }
    ReplicatedStorage.Layouts:InvokeServer(unpack(args))
    saveSettings()
 end)

 tab3:Bind("Withdraw all", Enum.KeyCode[settingsTable.withdrawKeyBind], function() 
    ReplicatedStorage.DestroyAll:InvokeServer()
    saveSettings()
 end)

 tab3:Bind("Pulsar", Enum.KeyCode[settingsTable.pulseKeyBind], function() 
    ReplicatedStorage.Pulse:FireServer()
    saveSettings()
 end)

 tab3:Bind("Teleport to base 1", Enum.KeyCode[settingsTable.teleportKeyBind], function() 
    teleportLocation('Factory1')
    saveSettings()
 end)
    
