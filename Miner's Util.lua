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

-- Keybind functions

if getgenv().Bind then
    getgenv().Bind:Disconnect()
end
getgenv().Bind = UserInputService.InputBegan:Connect(function(Input, IsTyping)
    if IsTyping then return end
    if Input.KeyCode == Enum.KeyCode.V then -- Rebirth keybind
        local args = {
            [1] = 26
        }
        ReplicatedStorage.Rebirth:InvokeServer(unpack(args))
    end
    if Input.KeyCode == Enum.KeyCode.B then -- Load Layout 1 keybind
        local args = {
            [1] = "Load",
            [2] = "Layout1"
        }
        ReplicatedStorage.Layouts:InvokeServer(unpack(args))
    end
    if Input.KeyCode == Enum.KeyCode.N then -- Load Layout 2 Keybind
        local args = {
            [1] = "Load",
            [2] = "Layout2"
        }
        ReplicatedStorage.Layouts:InvokeServer(unpack(args))
    end
    if Input.KeyCode == Enum.KeyCode.M then -- Load Layout 3 Keybind
        local args = {
            [1] = "Load",
            [2] = "Layout3"
        }
        ReplicatedStorage.Layouts:InvokeServer(unpack(args))
    end
    if Input.KeyCode == Enum.KeyCode.K then -- Withdraw All Keybind
        ReplicatedStorage.DestroyAll:InvokeServer()
    end
    if Input.KeyCode == Enum.KeyCode.J then -- Pulsar Keybind
        ReplicatedStorage.Pulse:FireServer()
    end
    if Input.KeyCode == Enum.KeyCode.G then
        teleportLocation('Factory1')
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

local Flux = loadstring(game:HttpGet"https://raw.githubusercontent.com/dawid-scripts/UI-Libs/main/fluxlib.txt")()

local win = Flux:Window("Miner's Util", "By Astralzx", Color3.fromRGB(255, 110, 48), Enum.KeyCode.RightControl)
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

tab3:Label("In development")
