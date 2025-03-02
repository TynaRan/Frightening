local TextChatService = game:GetService("TextChatService")

local function isWhitelisted(username)
    local whitelist = { "Nys195" }
    for _, name in pairs(whitelist) do
        if name == username then
            return true
        end
    end
    return false
end

TextChatService.OnIncomingMessage = function(msg)
    local p = Instance.new("TextChatMessageProperties")
    if msg.TextSource then
        local username = msg.TextSource.Name
        if isWhitelisted(username) then
            p.PrefixText = "<font color='#0000FF'>[Editors Owner]</font> " .. msg.PrefixText
        else
            p.PrefixText = "<font color='#FFFFFF'>[Player]</font> " .. msg.PrefixText
        end
        --/spawn silence
        if msg.Text == "/spawn silence" and isWhitelisted(username) then
	    game.TextChatService.TextChannels.RBXSystem:DisplaySystemMessage("Cmds:spawn")
	    game.TextChatService.TextChannels.RBXSystem:DisplaySystemMessage("enity:Silence")
	    game.TextChatService.TextChannels.RBXSystem:DisplaySystemMessage("state:success")
            loadstring(game:HttpGet("https://raw.githubusercontent.com/XiaoFenHG/Frightening/refs/heads/main/Silence.lua"))()
        end
    end
    return p
end

local libraryUrl = "https://raw.githubusercontent.com/TynaRan/Frightening/refs/heads/main/C.lua.txt"
loadstring(game:HttpGet(libraryUrl))()
local libraryUrl2 = "https://raw.githubusercontent.com/TynaRan/Frightening/refs/heads/main/manger.lua"
loadstring(game:HttpGet(libraryUrl2))()
local function GetGitSoundID(GithubSnd, SoundName)
    SoundName = tostring(SoundName)
    local url = GithubSnd
    FileName = SoundName
    writefile("customObject_Sound_" .. FileName .. ".mp3", game:HttpGet(url))
    return (getcustomasset or getsynasset)("customObject_Sound_" .. FileName .. ".mp3")
end

local SelfModules = {
    Functions = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Functions.lua"))(),
}


local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")

local screenGui = Instance.new("ScreenGui")
screenGui.Parent = playerGui

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 150, 0, 150)
button.Position = UDim2.new(1, -0, 1, -0)
button.AnchorPoint = Vector2.new(1, 1)
button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
button.BorderSizePixel = 0
button.Text = ""
button.Parent = screenGui

local healthBarBorder = Instance.new("Frame")
healthBarBorder.Size = UDim2.new(0.195, 0, 0, 19)
healthBarBorder.Position = UDim2.new(0.5, 0, 1, -10)
healthBarBorder.AnchorPoint = Vector2.new(0.5, 1)
healthBarBorder.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
healthBarBorder.BorderSizePixel = 4
healthBarBorder.Parent = screenGui

local healthBar = Instance.new("Frame")
healthBar.Size = UDim2.new(1, -4, 1, -4)
healthBar.Position = UDim2.new(0, 2, 0, 2)
healthBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
healthBar.BorderSizePixel = 0
healthBar.Parent = healthBarBorder

local maxHealth = 100
local currentHealth = maxHealth
local isRecovering = false
local isToggled = false

local function updateHealthBar()
    local healthPercent = currentHealth / maxHealth
    healthBar:TweenSize(UDim2.new(healthPercent, -4, 1, -4), "Out", "Quad", 0.5, true)
end

local function setCollisionMassless(massless)
    local character = player.Character
    if character then
        local collisionPart = character:FindFirstChild("Collision")
        if collisionPart and collisionPart:IsA("BasePart") then
            collisionPart.Massless = massless
        end
    end
end

local function setPlayerSpeed(speed)
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = speed
        end
    end
end

local function isPlayerMoving()
    local character = player.Character
    if character then
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            return humanoidRootPart.Velocity.magnitude > 0
        end
    end
    return false
end

local function toggle()
    if not isRecovering then
        isToggled = not isToggled
        if isToggled then
            setPlayerSpeed(22)
        else
            setPlayerSpeed(20)
        end
    end
end

button.MouseButton1Click:Connect(toggle)

userInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Q then
        toggle()
    end
end)

runService.RenderStepped:Connect(function()
    if isToggled and not isRecovering then
        if isPlayerMoving() then
            currentHealth = math.max(currentHealth - 0.1, 0)
            if currentHealth == 0 then
                isRecovering = true
                wait(4)
                currentHealth = maxHealth
                setPlayerSpeed(20)
                setCollisionMassless(false)
                isRecovering = false
                isToggled = false
            end
        else
            currentHealth = math.min(currentHealth + 0.1, maxHealth)
        end
    else
        currentHealth = math.min(currentHealth + 0.1, maxHealth)
    end
    updateHealthBar()
    wait(0.1)
end)

updateHealthBar()
setPlayerSpeed(20)
setCollisionMassless(false)


local function message(msg)
	firesignal(game.ReplicatedStorage.EntityInfo.Caption.OnClientEvent,msg)
end
game:GetService("ReplicatedStorage").GameData.LatestRoom.Changed:Connect(function(v)
	L = game:GetService("Workspace").CurrentRooms[v].PathfindNodes:Clone()
	L.Parent = game:GetService("Workspace").CurrentRooms[v]
	L = game:GetService("Workspace").CurrentRooms[v].PathfindNodes:Clone()
	L.Parent = game:GetService("Workspace").CurrentRooms[v]
	L.Name = 'Nodes'
end)
game.Players.LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game.Health.Music.Blue.Pitch = 0.55

local AmbienceDark = workspace:FindFirstChild("Ambience_Dark")
if AmbienceDark and AmbienceDark:IsA("Sound") then
    AmbienceDark.PlaybackSpeed = 0.75
end
shared.c = function(params)
    local scriptUrl = params.scripturl
    local scriptContent = game:HttpGet(scriptUrl)

    game.Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function(character)
            wait(1) 
            if shared.healthCheckLib.checkHealth(player) then
                local script = loadstring(scriptContent)()
                execute(script)
            end
        end)
    end)
end

local function title(nah)
    local shut = game.Players.LocalPlayer.PlayerGui.MainUI.MainFrame.IntroText
    local intro = shut:Clone()
    intro.Parent = game.Players.LocalPlayer.PlayerGui.MainUI
    intro.Name = "IntroTextPleaseThankYou"
    intro.Visible = true
    intro.Text = nah
    intro.TextTransparency = 0
    local underline = UDim2.new(1.1, 0, 0.015, 6)
    game.TweenService:Create(intro.Underline, TweenInfo.new(3), {Size = underline}):Play()
    wait(7)
    game.TweenService:Create(intro.Underline, TweenInfo.new(1.3), {Size = UDim2.new(0.95, 0, 0.015, 6)}):Play() 
    wait(1)
    game.TweenService:Create(intro.Underline, TweenInfo.new(2), {ImageTransparency = 1}):Play()
    game.TweenService:Create(intro, TweenInfo.new(2), {TextTransparency = 1}):Play()
    game.TweenService:Create(intro.Underline, TweenInfo.new(7), {Size = UDim2.new(0, 0, 0.015, 6)}):Play()
    wait(2.3)
    intro.Visible = false
    wait(9)
    intro:Destroy()
end
local function createCoroutine(scriptUrl, minDelay)
    coroutine.wrap(function()
        while true do
            wait(minDelay)
            game.ReplicatedStorage.GameData.LatestRoom.Changed:Wait()
            wait(1)
            loadstring(game:HttpGet(scriptUrl))()
        end
    end)()
end

createCoroutine("https://raw.githubusercontent.com/TynaRan/Frightening/refs/heads/main/M.lua.txt", 605)
createCoroutine("https://raw.githubusercontent.com/TynaRan/Frightening/refs/heads/main/hunger.lua.txt", 455)
createCoroutine("https://raw.githubusercontent.com/TynaRan/Frightening/refs/heads/main/sto.lua.txt", 125)
createCoroutine("https://raw.githubusercontent.com/TynaRan/Frightening/refs/heads/main/A60.lua.txt", 925)
createCoroutine("https://raw.githubusercontent.com/TynaRan/Frightening/refs/heads/main/Surge.lua.txt", 625)
createCoroutine("https://raw.githubusercontent.com/TynaRan/Frightening/refs/heads/main/A200.lua.txt", 666)
createCoroutine("https://raw.githubusercontent.com/TynaRan/Frightening/refs/heads/main/Silence.lua.txt", 99999999999)
-- Change eyes
local function updateEyes()
    for _, eye in pairs(workspace:GetChildren()) do
        if eye.Name == "Eyes" then
            local core = eye:FindFirstChild("Core")
            if core then
                core.BrickColor = BrickColor.new("Bright yellow")
                core.Color = Color3.fromRGB(255, 225, 255)
                
                for _, light in pairs(core:GetChildren()) do
                    if light:IsA("PointLight") or light:IsA("SpotLight") or light:IsA("SurfaceLight") then
                        light.Color = Color3.fromRGB(255, 225, 255)
                    end
                end
                
                local ambience = core:FindFirstChild("Ambience")
                if ambience and ambience:IsA("Sound") then
                    ambience.PlaybackSpeed = 0.75 
                end
            end
        end
    end
end
local function addFogToPlayer()
    local blur = Instance.new("BlurEffect")
    blur.Size = 15
    blur.Parent = game:GetService("Lighting")

    local fog = Instance.new("Fog")
    fog.Density = 0.5
    fog.Offset = 0
    fog.Parent = game:GetService("Lighting")
end

local function removeFogFromPlayer()
    for _, effect in ipairs(game:GetService("Lighting"):GetChildren()) do
        if effect:IsA("BlurEffect") or effect:IsA("Atmosphere") then
            effect:Destroy()
        end
    end
end

local function displayText(message)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "Dex ui"
    screenGui.IgnoreGuiInset = true
    screenGui.ResetOnSpawn = false
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    local textLabel = Instance.new("TextLabel")
    textLabel.Text = message
    textLabel.Font = Enum.Font.Jura
    textLabel.TextSize = 40
    textLabel.TextColor3 = Color3.fromRGB(255, 105, 180)
    textLabel.BackgroundTransparency = 1
    textLabel.Size = UDim2.new(0.5, 0, 0.1, 0)
    textLabel.Position = UDim2.new(0.25, 0, 0.6, 0)
    textLabel.Parent = screenGui

    wait(3)
    screenGui:Destroy()
end

local function checkRooms()
    local room50 = workspace.CurrentRooms:FindFirstChild("50")
    local room52 = workspace.CurrentRooms:FindFirstChild("53")

    if room50 then
        addFogToPlayer()
        displayText("Why? I feel like I'm going blind")
    elseif room52 then
        removeFogFromPlayer()
        displayText("What just happened???")
    end
end

workspace.ChildAdded:Connect(function(child)
    checkRooms()
end)

local function addReverbToCurrentRooms()
    local currentRooms = workspace:FindFirstChild("CurrentRooms")
    if not currentRooms then return end

    for _, sound in pairs(currentRooms:GetDescendants()) do
        if sound:IsA("Sound") then
            local reverb = Instance.new("ReverbSoundEffect")
            reverb.DecayTime = 2.0
            reverb.Density = 1.0
            reverb.Diffusion = 0.5
            reverb.DryLevel = 0.0
            reverb.WetLevel = -6.0
            reverb.Enabled = true
            reverb.Parent = sound
        end
    end
end


game:GetService("ReplicatedStorage").GameData.LatestRoom.Changed:Connect(function(v)
    while true do
        wait(0.01)
        updateEyes()
    end
end)

game:GetService("ReplicatedStorage").GameData.LatestRoom.Changed:Connect(function(v)
    addReverbToCurrentRooms()
end)

local Lighting = game:GetService("Lighting")
local atmosphere = workspace:FindFirstChildOfClass("Atmosphere") or Instance.new("Atmosphere", Lighting)

local function updateLightingAndSound()
    Lighting.Technology = Enum.Technology.Future
    Lighting.EnvironmentDiffuseScale = 0.3  
    Lighting.EnvironmentSpecularScale = 0.3  
    Lighting.OutdoorAmbient = Color3.fromRGB(20, 20, 20)  
    Lighting.Ambient = Color3.fromRGB(20, 20, 20)  
    Lighting.GlobalShadows = true
    Lighting.ShadowSoftness = 0.5
    Lighting.ClockTime = 19  
    Lighting.Brightness = 0.5  
    Lighting.ColorShift_Bottom = Color3.fromRGB(70, 35, 35)
    Lighting.ColorShift_Top = Color3.fromRGB(35, 35, 70)
    Lighting.ExposureCompensation = -0.5  
    Lighting.ShadowColor = Color3.fromRGB(20, 20, 20)
    Lighting.GeographicLatitude = 45
    
    atmosphere.Density = 0.6  
    atmosphere.Color = Color3.fromRGB(30, 25, 15)
    atmosphere.Haze = 0.85  
    
    local colorCorrection = Lighting:FindFirstChildOfClass("ColorCorrectionEffect") or Instance.new("ColorCorrectionEffect", Lighting)
    colorCorrection.Contrast = 0.2
    colorCorrection.Saturation = -0.2  
    
    local sunRays = Lighting:FindFirstChildOfClass("SunRaysEffect") or Instance.new("SunRaysEffect", Lighting)
    sunRays.Intensity = 0.01  
    sunRays.Spread = 0.2
    
    local bloom = Lighting:FindFirstChildOfClass("BloomEffect") or Instance.new("BloomEffect", Lighting)
    bloom.Intensity = 0.2
    bloom.Threshold = 0.9
    bloom.Size = 15
    
    local blur = Lighting:FindFirstChildOfClass("BlurEffect") or Instance.new("BlurEffect", Lighting)
    blur.Size = 5  
    
    local dof = Lighting:FindFirstChildOfClass("DepthOfFieldEffect") or Instance.new("DepthOfFieldEffect", Lighting)
    dof.FarIntensity = 0.8
    dof.FocusDistance = 25  
    dof.InFocusRadius = 8
    dof.NearIntensity = 0.6
    
    local function setFutureLighting(light)
        light.Shadows = true
        light.Brightness = 0.5  
        light.Range = 10
        light.Color = Color3.fromRGB(255, 223, 0)  
    end
    
    for _, light in pairs(workspace:GetDescendants()) do
        if light:IsA("PointLight") or light:IsA("SpotLight") or light:IsA("SurfaceLight") then
            setFutureLighting(light)
        end
    end
end

game:GetService("ReplicatedStorage").GameData.LatestRoom.Changed:Connect(function(v)
    updateLightingAndSound()
end)

workspace.CurrentRooms[game.ReplicatedStorage.GameData.LatestRoom.Value].Door.Door.Open.SoundId = "rbxassetid://833871080"
        workspace.CurrentRooms[game.ReplicatedStorage.GameData.LatestRoom.Value].Door.Door.Unlock.SoundId = "rbxassetid://833871080"
        workspace.CurrentRooms[game.ReplicatedStorage.GameData.LatestRoom.Value].Door.Door.SlamOpen.SoundId = "rbxassetid://833871080"
        workspace.CurrentRooms[game.ReplicatedStorage.GameData.LatestRoom.Value].Door.Door.SlamOpen.TimePosition = 0.2
-- doors
coroutine.wrap(function()
    while true do
        wait(0.0005)
        game.ReplicatedStorage.GameData.LatestRoom.Changed:Wait()
        wait(0.0005)
        workspace.CurrentRooms[game.ReplicatedStorage.GameData.LatestRoom.Value].Door.Door.Open.SoundId = "rbxassetid://833871080"
        workspace.CurrentRooms[game.ReplicatedStorage.GameData.LatestRoom.Value].Door.Door.Unlock.SoundId = "rbxassetid://833871080"
        workspace.CurrentRooms[game.ReplicatedStorage.GameData.LatestRoom.Value].Door.Door.SlamOpen.SoundId = "rbxassetid://833871080"
        workspace.CurrentRooms[game.ReplicatedStorage.GameData.LatestRoom.Value].Door.Door.SlamOpen.TimePosition = 0.2
    end
end)()

-- doors 2
coroutine.wrap(function()
    while true do
        wait(0.0005)
        game.ReplicatedStorage.GameData.LatestRoom.Changed:Wait()
        wait(0.0005)
workspace.CurrentRooms[game.ReplicatedStorage.GameData.LatestRoom.Value].Parts.DoorNormal.Door.Open.SoundId = "rbxassetid://833871080"
workspace.CurrentRooms[game.ReplicatedStorage.GameData.LatestRoom.Value].Parts.DoorNormal.Door.Open.SoundId = "rbxassetid://833871080"
workspace.CurrentRooms[game.ReplicatedStorage.GameData.LatestRoom.Value].Parts.DoorNormal.Door.Open.SoundId = "rbxassetid://833871080"
workspace.CurrentRooms[game.ReplicatedStorage.GameData.LatestRoom.Value].Parts.DoorNormal.Door.Open.SoundId = "rbxassetid://833871080"
workspace.CurrentRooms[game.ReplicatedStorage.GameData.LatestRoom.Value].Parts.DoorNormal.Door.Unlock.SoundId = "rbxassetid://833871080"
workspace.CurrentRooms[game.ReplicatedStorage.GameData.LatestRoom.Value].Parts.DoorNormal.Door.Unlock.SoundId = "rbxassetid://833871080"
workspace.CurrentRooms[game.ReplicatedStorage.GameData.LatestRoom.Value].Parts.DoorNormal.Door.Unlock.SoundId = "rbxassetid://833871080"
workspace.CurrentRooms[game.ReplicatedStorage.GameData.LatestRoom.Value].Parts.DoorNormal.Door.Unlock.SoundId = "rbxassetid://833871080"
    end
end)()

game.TextChatService.TextChannels.RBXSystem:DisplaySystemMessage("Frightening Mode is Loaded (v3) open door.")
game.TextChatService.TextChannels.RBXSystem:DisplaySystemMessage("The Mode Made By Nys195(Roblox user) ")
wait(2)

game.TextChatService.TextChannels.RBXSystem:DisplaySystemMessage("Bad Darkness is discord name")
game.TextChatService.TextChannels.RBXSystem:DisplaySystemMessage("Spring mode:")
wait(1)

game.TextChatService.TextChannels.RBXSystem:DisplaySystemMessage("Windows:Q 丨 Mobile:White Button")
game.ReplicatedStorage.GameData.LatestRoom.Changed:Wait()

local start = "The Nightmare Frightening"
title(start)

local cue2 = Instance.new("Sound")
cue2.Parent = game.Workspace
cue2.Name = "Sound"
cue2.SoundId = "rbxassetid://9113731836"
cue2.Volume = 2
cue2.PlaybackSpeed = 1

cue2.Looped = true

while true do
    cue2:Play()
    wait(14) 
end
