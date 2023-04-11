-- Variables

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

getgenv().autoBuy = false;   

-- Settings

rebirth = "t" -- has to be lowercase
lay1 = "y"
lay2 = "u"
withdraw = "k"
quasar = "j"

-- Keybinds

mouse.KeyDown:connect(function(key) 
    if key == rebirth then
        local args = {
            [1] = 26
        }
        ReplicatedStorage.Rebirth:InvokeServer(unpack(args))
    end
end)

mouse.KeyDown:connect(function(key2)
    if key2 == lay1 then
        local args = {
            [1] = "Load",
            [2] = "Layout1"
        }
        ReplicatedStorage.Layouts:InvokeServer(unpack(args))
    end
end)

mouse.KeyDown:connect(function(key3)
    if key3 == lay2 then
        local args = {
            [1] = "Load",
            [2] = "Layout2"
        }
        ReplicatedStorage.Layouts:InvokeServer(unpack(args))
    end
end)

mouse.KeyDown:connect(function(key4)
    if key4 == withdraw then
        ReplicatedStorage.DestroyAll:InvokeServer()
    end
end)


mouse.KeyDown:connect(function(key5)
    if key5 == quasar then
        ReplicatedStorage.Pulse:FireServer()
    end
end)

-- Scripts

function purchaser()
    spawn(function()
        while autoBuy == true do
            local args = {
                [1] = "Basic Iron Mine",    
                [2] = 99
            }
            remotePath.BuyItem:InvokeServer(unpack(args))
        end  
    end)
end

function teleportTo(placeCFrame)
    local plyr = game.Players.LocalPlayer;
    if plyr.Character then
        plyr.Character.HumanoidRootPart.CFrame = placeCFrame;
    end
end

function teleportLocation(location)
    if game:GetService("Workspace").Tycoons:FindFirstChild(location) then
        teleportTo(game:GetService("Workspace").Tycoons[location].Base.CFrame)
    end
end

-- GUI

local Flux = loadstring(game:HttpGet"https://raw.githubusercontent.com/dawid-scripts/UI-Libs/main/fluxlib.txt")()

local win = Flux:Window("Miner's Util", "By Astralzx", Color3.fromRGB(255, 110, 48), Enum.KeyCode.RightControl)
local tab1 = win:Tab("Farming", "http://www.roblox.com/asset/?id=6023426915")
local tab2 = win:Tab("Teleports", "http://www.roblox.com/asset/?id=6023426915")

-- Tab 1

tab1:Toggle("Auto bazingium", "Automatically purchases 99x iron mines", false, function(bool)
    getgenv().autoBuy = bool
    print('Auto buy is: ', bool);
    if bool then
        purchaser();
    end
end)

tab1:Toggle("Crate farm", "Automatically teleport to crates across the map")

-- Tab 2

local selectedLocation;

tab2:Dropdown("Factory",{"Factory1","Factory2","Factory3","Factory4","Factory5","Factory6"},function(value)
    selectedLocation = value;
    print(value)
end)

tab2:Button("Teleport", "Teleport to a selected location decided by the drop down menu above.",function()
    if selectedLocation then
        teleportLocation(selectedLocation)
    end
end)
