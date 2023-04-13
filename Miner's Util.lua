-- Variables

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local Player = game:GetService("Players").LocalPlayer
local Boxes = game:GetService("Workspace").Boxes
local Character = Player.Character

getgenv().autoBuy = false;   
getgenv().autoCrate = false; 
getgenv().crateTpToggle = false;

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
            ReplicatedStorage.BuyItem:InvokeServer(unpack(args))
        end  
    )
end

function teleportTo(placeCFrame)
    if Character then
        Character.HumanoidRootPart.CFrame = placeCFrame;
    end
end

function teleportLocation(location)
    if game:GetService("Workspace").Tycoons:FindFirstChild(location) then
        teleportTo(game:GetService("Workspace").Tycoons[location].Base.CFrame)
    end
end

function opener()
    spawn(function()
        while autoCrate == true do
            local args = {
                [1] = "Inferno",
                --[2] = 
            }
            ReplicatedStorage.MysteryBox:InvokeServer(unpack(args))
        end
    )
end

function crate()
    spawn(function()
        while crateTpToggle == true do
            for i, v in pairs(bxs:GetChildren()) do
                char:MoveTo(v.Position)
                wait(1.5)
            end
        end
    )
end
-- GUI

local Flux = loadstring(game:HttpGet"https://raw.githubusercontent.com/dawid-scripts/UI-Libs/main/fluxlib.txt")()

local win = Flux:Window("Miner's Util", Color3.fromRGB(255, 110, 48), Enum.KeyCode.RightControl)
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

tab1:Toggle("Auto crate", "Automatically opens crates", false, function(bool)
    getgenv().autoCrate = bool
    print('Auto buy is: ', bool);
    if bool then
        opener();
    end
end)

tab1:Toggle("Crate farm", "Automatically teleport to crates across the map", false, function(bool)
    gengenv().crateTpToggle = bool
    print('CrateTP is: ', bool);
    if bool then
        crate();
    end
end)

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
