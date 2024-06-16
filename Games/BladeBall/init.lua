local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local ballsFolder = workspace:WaitForChild("Balls")
local baseMagnitudeThreshold = 50
local thresholdIncrement = 0 -- Increment per second
local targetBrickColor = BrickColor.new("Persimmon")

local timePassed = 0

local function updateTime()
    timePassed = timePassed + RunService.Heartbeat:Wait()
end

local function getAdjustedMagnitudeThreshold()
    return baseMagnitudeThreshold + (timePassed * thresholdIncrement)
end

local function checkProximity()
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    local playerPosition = character.HumanoidRootPart.Position
    local magnitudeThreshold = getAdjustedMagnitudeThreshold()

    for _, part in ipairs(ballsFolder:GetChildren()) do
        if part:IsA("BasePart") and part.BrickColor == targetBrickColor then
            local partPosition = part.Position
            local distance = (playerPosition - partPosition).Magnitude

            if distance <= magnitudeThreshold then
                mouse1click()
            end
        end
    end
end

local function resetTimePassed()
    timePassed = 0
end

local function onCharacterAdded(newCharacter)
    character = newCharacter
    local humanoid = character:WaitForChild("Humanoid")

    local c1 = humanoid.Died:Connect(function()
        timePassed = 0
    end)

    local c2 = character:WaitForChild("Left Leg").Touched:Connect(function(hit)
        if hit.Name == "BallFloor" then
            resetTimePassed()
        end
    end)

    table.insert(getgenv().__CONNECTIONS, c1)
    table.insert(getgenv().__CONNECTIONS, c2)
end

if getgenv().__CONNECTIONS then
    for _, c in pairs(getgenv().__CONNECTIONS) do
        c:Disconnect()
    end
end

getgenv().__CONNECTIONS = {}

local c1 = localPlayer.CharacterAdded:Connect(onCharacterAdded)

if localPlayer.Character then
    onCharacterAdded(localPlayer.Character)
end

table.insert(getgenv().__CONNECTIONS, c1)
table.insert(getgenv().__CONNECTIONS, RunService.Heartbeat:Connect(updateTime))
table.insert(getgenv().__CONNECTIONS, RunService.RenderStepped:Connect(checkProximity))