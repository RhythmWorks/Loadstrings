if not game:GetService("Players").LocalPlayer.Character then
	game:GetService("Players").LocalPlayer.CharacterAdded:Wait()
end

local function ESP()
	local camera = workspace.CurrentCamera
	local boxSizeOffset = 3000

	local function boxESP(player)
		local BoxOutline = Drawing.new("Square")
		BoxOutline.Visible = false
		BoxOutline.Color = Color3.new(1, 1, 1)
		BoxOutline.Thickness = 3
		BoxOutline.Transparency = 0
		BoxOutline.Filled = false

		table.insert(getgenv().__0RXPT.Drawings, BoxOutline)

		local Box = Drawing.new("Square")
		Box.Visible = false
		Box.Thickness = 3
		Box.Color = Color3.new(1,1,1)
		Box.Transparency = 0.5
		Box.Filled = false

		table.insert(getgenv().__0RXPT.Drawings, Box)

		local connection = game:GetService("RunService").RenderStepped:Connect(function()
			if player.Character and player.Character:FindFirstChild ("Humanoid") and player.Character:FindFirstChild ("HumanoidRootPart") and player ~= game:GetService("Players").LocalPlayer and player.Character.Humanoid.Health > 0 then
				local _, onScreen = camera:worldToViewportPoint(player.Character.HumanoidRootPart.Position)
				local RootPart = player.Character.HumanoidRootPart
				local Head = player.Character.Head

				local RootPosition = camera:WorldToViewportPoint(RootPart.Position)
				local HeadPosition = camera:WorldToViewportPoint(Head.Position + Vector3.new(0, 0.5, 0))
				local LegPosition = camera:WorldToViewportPoint(RootPart.Position - Vector3.new(0, 3.5, 0))
				
				if onScreen then
					BoxOutline.Size = Vector2.new(boxSizeOffset / RootPosition.Z, HeadPosition.Y - LegPosition.Y)
					BoxOutline.Position = Vector2.new(RootPosition.X - BoxOutline.Size.X / 2, RootPosition.Y - BoxOutline.Size.Y / 2)
					BoxOutline.Visible = true
					Box.Size = Vector2.new(boxSizeOffset / RootPosition.Z, HeadPosition.Y - LegPosition.Y)
					Box.Position = Vector2.new(RootPosition.X - Box.Size.X / 2, RootPosition.Y - Box.Size.Y / 2)
					Box.Visible = true
					Box.Color = player.TeamColor.Color or Color3.new(1, 0, 0)
					--BoxOutline.Color = player.TeamColor.Color or Color3.new(1, 0, 0)
				else
					BoxOutline.Visible = false
					Box.Visible = false
				end
			else
				BoxOutline.Visible = false
				Box.Visible = false
			end
		end)

		table.insert(getgenv().__0RXPT.Connections, connection)
	end

	for _, player in pairs(game:GetService("Players"):GetChildren()) do
		task.defer(boxESP, player)
	end

	table.insert(getgenv().__0RXPT.Connections, game:GetService("Players").PlayerAdded:Connect(boxESP))
end

local function Tracers()
	local camera = workspace.CurrentCamera

	local function lineESP(player)
		local Tracer = Drawing.new("Line")
		Tracer.Visible = false
		Tracer.Color = Color3.new(1, 1, 1)
		Tracer.Thickness = 1
		Tracer.Transparency = 1

		table.insert(getgenv().__0RXPT.Drawings, Tracer)

		local connection = game:GetService("RunService").RenderStepped:Connect(function()
			if player.Character and player.Character:FindFirstChild ("Humanoid") and player.Character:FindFirstChild ("HumanoidRootPart") and player ~= game:GetService("Players").LocalPlayer and player.Character.Humanoid.Health > 0 then
				local Vector, onScreen = camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
				
				if onScreen then
					Tracer.Visible = true
					Tracer.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 1)
					Tracer.To = Vector2.new(Vector.X, Vector.Y)
					Tracer.Color = player.TeamColor.Color or Color3.new(1, 1, 1)
				else
					Tracer.Visible = false
				end
			else
				Tracer.Visible = false
			end
		end)

		table.insert(getgenv().__0RXPT.Connections, connection)
	end

	for _, player in pairs(game:GetService("Players"):GetChildren()) do
		task.defer(lineESP, player)
	end

	table.insert(getgenv().__0RXPT.Connections, game:GetService("Players").PlayerAdded:Connect(lineESP))
end

local function Nametags()
	local function create(player)
		local character = player.Character or player.CharacterAdded:Wait()

		if character:FindFirstChild("__Nametag") then
			character.__Nametag:Destroy()
		end
		
		local nametag = Instance.new("BillboardGui")
		nametag.Name = "__Nametag"
		nametag.Active = true
		nametag.AlwaysOnTop = true
		nametag.ClipsDescendants = true
		nametag.LightInfluence = 1
		nametag.Size = UDim2.fromOffset(400, 15)
		nametag.StudsOffset = Vector3.new(0, 3.25, 0)
		nametag.ResetOnSpawn = false
		nametag.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

		local username = Instance.new("TextLabel")
		username.Name = "Username"
		username.FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json")
		username.Text = if player.DisplayName == player.Name then player.Name else `{player.DisplayName} (@{player.Name})`
		username.TextColor3 = player.TeamColor.Color or Color3.new(1, 1, 1)
		username.TextScaled = true
		username.TextSize = 14
		username.TextWrapped = true
		username.AnchorPoint = Vector2.new(0.5, 0.5)
		username.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		username.BackgroundTransparency = 1
		username.BorderColor3 = Color3.fromRGB(0, 0, 0)
		username.BorderSizePixel = 0
		username.Position = UDim2.fromScale(0.5, 0.5)
		username.Size = UDim2.fromScale(1, 1)
		username.Parent = nametag
		
		nametag.Parent = character
	end
	
	for _, player in pairs(game:GetService("Players"):GetPlayers()) do
		if player ~= game:GetService("Players").LocalPlayer then
			if player.Character then
				task.defer(create, player)
			end

			player:GetPropertyChangedSignal("Team"):Connect(function()
				create(player)
			end)
			
			local connection = player.CharacterAdded:Connect(function()
				create(player)
			end)

			table.insert(getgenv().__0RXPT.Connections, connection)
		end
	end

	local connection = game:GetService("Players").PlayerAdded:Connect(function(player)
		if player.Character then
			task.defer(create, player)
		end

		player:GetPropertyChangedSignal("Team"):Connect(function()
			create(player)
		end)
		
		local connection2 = player.CharacterAdded:Connect(function()
			create(player)
		end)

		table.insert(getgenv().__0RXPT.Connections, connection2)
	end)

	table.insert(getgenv().__0RXPT.Connections, connection)
end

local function Aimbot()
	local StarterGui = game:GetService("StarterGui")

	local aimbotEnabled = false
	local mouse = game:GetService("Players").LocalPlayer:GetMouse()
	local camera = workspace.CurrentCamera

	local validFOVRadiuses = {
		100,
		150,
		200,
		250,
		300,
		350,
		400,
	}

	local fovcircle = Drawing.new("Circle")
	fovcircle.Visible = true
	fovcircle.Radius = validFOVRadiuses[getgenv().__0RXPT.FOVRadius]
	fovcircle.Color = getgenv().__0RXPT.TargetTeamColor
	fovcircle.Thickness = 1
	fovcircle.Filled = false
	fovcircle.Transparency = 1
	fovcircle.Position = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)

	local updatePosConnection = game:GetService("RunService").RenderStepped:Connect(function()
		fovcircle.Position = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
	end)

	table.insert(getgenv().__0RXPT.Connections, updatePosConnection)
	table.insert(getgenv().__0RXPT.Drawings, fovcircle)

	local function updateColor()
		fovcircle.Color = getgenv().__0RXPT.TargetTeamColor
	end

	local function getPlayerFromMouse()
		local localPlayer = game:GetService("Players").LocalPlayer
		local character = localPlayer.Character
		if not character or not character:FindFirstChild("HumanoidRootPart") then return nil end
	
		local closestCharacter = nil
		local mousePosition = Vector2.new(mouse.X, mouse.Y)
		local closestDistance = 500
	
		local function isPlayerPart(part)
			local player = game:GetService("Players"):GetPlayerFromCharacter(part.Parent)
			
			if player and player ~= localPlayer then
				return not player.Character.HumanoidRootPart:FindFirstChild("TeammateLabel")
			end
			
			return false
		end
	
		for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
			if player ~= localPlayer and player.Character then
				local aimPart = math.random() < 0.5 and player.Character:FindFirstChild("Head") or player.Character:FindFirstChild("HumanoidRootPart")
				if aimPart and isPlayerPart(aimPart) then
					local aimPartPos, isOnScreen = camera:WorldToViewportPoint(aimPart.Position)
					if isOnScreen then
						local aimPartScreenPos = Vector2.new(aimPartPos.X, aimPartPos.Y)
						local distance = (mousePosition - aimPartScreenPos).Magnitude
						if distance < closestDistance and distance < validFOVRadiuses[getgenv().__0RXPT.FOVRadius] then
							closestDistance = distance
							closestCharacter = player.Character
						end
					end
				end
			end
		end
	
		return closestCharacter
	end

	local function aimAt(target)
		local character = target
	
		if character then
			local aimPart = math.random() < 0.5 and character:FindFirstChild("Head") or character:FindFirstChild("HumanoidRootPart")

			if aimPart then
				local raycastParams = RaycastParams.new()
				raycastParams.FilterDescendantsInstances = {game:GetService("Players").LocalPlayer.Character, character}
				raycastParams.IgnoreWater = true

				local raycastResult = workspace:Raycast(camera.CFrame.Position, aimPart.Position - camera.CFrame.Position, raycastParams)

				if not raycastResult or raycastResult.Instance == aimPart or getgenv().__0RXPT.WallCheck == true then
					local charPartPos, isOnScreen = camera:WorldToViewportPoint(aimPart.Position)

					if isOnScreen then
						local mousePosition = Vector2.new(mouse.X, mouse.Y)
						local targetPosition = Vector2.new(charPartPos.X, charPartPos.Y)
						local mag = (mousePosition - targetPosition).Magnitude

						if mag < validFOVRadiuses[getgenv().__0RXPT.FOVRadius] then
							camera.CFrame = CFrame.new(camera.CFrame.Position, aimPart.Position)
						end
					end
				end
			end
		end
	end

	local function onKeyPress(input, GPE)
		if GPE then
			return
		end

		local validInputs = {
			E = function()
				aimbotEnabled = not aimbotEnabled

				StarterGui:SetCore("SendNotification", {
					Title = "Aimbot:",
					Text = aimbotEnabled and "Enabled" or "Disabled",
					Duration = 3
				})
			end,

			O = function()
				getgenv().__0RXPT.WallCheck = not getgenv().__0RXPT.WallCheck

				StarterGui:SetCore("SendNotification", {
					Title = "Wall Check:",
					Text = getgenv().__0RXPT.WallCheck and "Enabled" or "Disabled",
					Duration = 3
				})
			end,

			Eight = function()
				getgenv().__0RXPT.FOVRadius += 1

				if getgenv().__0RXPT.FOVRadius > #validFOVRadiuses then
					getgenv().__0RXPT.FOVRadius = 1
				end

				fovcircle.Radius = validFOVRadiuses[getgenv().__0RXPT.FOVRadius]
			end
		}

		local inputCallback = validInputs[input.KeyCode.Name]

		if inputCallback then
			inputCallback()
		end
	end

	local function onUpdate()
		if aimbotEnabled then
			local targetCharacter = getPlayerFromMouse()
			if targetCharacter then
				--getgenv().__0RXPT.TargetTeamColor = game:GetService("Players")[targetCharacter.Name].Team.TeamColor.Color or Color3.new(1, 1, 1)
				aimAt(targetCharacter)
			else
				--getgenv().__0RXPT.TargetTeamColor = Color3.new(1, 1, 1)
			end

			updateColor()
		end
	end
	
	local inputBeganConnection = game:GetService("UserInputService").InputBegan:Connect(onKeyPress)
	local renderSteppedConnection = game:GetService("RunService").RenderStepped:Connect(onUpdate)
	
	table.insert(getgenv().__0RXPT.Connections, inputBeganConnection)
	table.insert(getgenv().__0RXPT.Connections, renderSteppedConnection)
end

local function initialize()
	if getgenv().__0RXPT then
		for _, drawing in pairs(getgenv().__0RXPT.Drawings) do
			drawing:Remove()
		end

		for _, connection in pairs(getgenv().__0RXPT.Connections) do
			connection:Disconnect()
		end
	end

	getgenv().__0RXPT = {
		WalkSpeed = game:GetService("Players").LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed,
		JumpPower = game:GetService("Players").LocalPlayer.Character:WaitForChild("Humanoid").JumpPower,
		AimbotRange = 300,
		TargetTeamColor = Color3.new(1, 1, 1),
		WallCheck = false,
		FOVRadius = 1,

		Drawings = {},
		Connections = {},
	}
end

local function start()
	local StarterGui = game:GetService("StarterGui")

	StarterGui:SetCore("SendNotification", {
		Title = "0rxpt's Script", 
		Text = "Arsenal script loaded. Have fun!", 
		Duration = 10
	})

	ESP()
	Tracers()
	Nametags()
	Aimbot()
end

initialize()
start()

print("[[ CXTHub Initialized]]")