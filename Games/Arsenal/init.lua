if not game.Players.LocalPlayer.Character then
	game.Players.LocalPlayer.CharacterAdded:Wait()
end

local function ESP()
	local function create(player)
		local character = player.Character or player.CharacterAdded:Wait()

		if character:FindFirstChild("__ESP") then
			character.__ESP:Destroy()
		end

		local highlight = Instance.new("Highlight", character)
		highlight.Name = "__ESP"
		highlight.OutlineColor = Color3.new(0, 0, 255)
		highlight.FillTransparency = 1
		highlight.Enabled = true
	end
	
	for _, player in pairs(game.Players:GetPlayers()) do
		if player ~= game.Players.LocalPlayer then
			if player.Character then
				task.spawn(create, player)
			end

			local connection = player.CharacterAdded:Connect(function()
				create(player)
			end)

			table.insert(getgenv().__0RXPT.Connections, connection)
		end
	end

	local connection = game.Players.PlayerAdded:Connect(function(player)
		if player.Character then
			task.spawn(create, player)
		end

		local connection2 = player.CharacterAdded:Connect(function()
			create(player)
		end)

		table.insert(getgenv().__0RXPT.Connections, connection2)
	end)
	
	table.insert(getgenv().__0RXPT.Connections, connection)
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
	
	for _, player in pairs(game.Players:GetPlayers()) do
		if player ~= game.Players.LocalPlayer then
			if player.Character then
				task.spawn(create, player)
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

	local connection = game.Players.PlayerAdded:Connect(function(player)
		if player.Character then
			task.spawn(create, player)
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
	local mouse = game.Players.LocalPlayer:GetMouse()
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

	getgenv().__0RXPT.Drawing = fovcircle

	local function updateColor()
		fovcircle.Color = getgenv().__0RXPT.TargetTeamColor
	end

	local function getPlayerFromMouse()
		local localPlayer = game.Players.LocalPlayer
		local character = localPlayer.Character
		if not character or not character:FindFirstChild("HumanoidRootPart") then return nil end
	
		local mouseRay = camera:ScreenPointToRay(mouse.X, mouse.Y)
		local ray = Ray.new(mouseRay.Origin, mouseRay.Direction * getgenv().__0RXPT.AimbotRange)
		local target
	
		local function isPlayerPart(part)
			local localPlayer = game.Players.LocalPlayer
			local player = game.Players:GetPlayerFromCharacter(part.Parent)
			
			if player and player ~= localPlayer then
				local allSameTeam = true
				for _, otherPlayer in ipairs(game.Players:GetPlayers()) do
					if otherPlayer ~= localPlayer and otherPlayer.Team ~= player.Team then
						allSameTeam = false
						break
					end
				end
				
				if not allSameTeam then
					return player.Team ~= localPlayer.Team
				else
					return true -- All players are on the same team (free-for-all)
				end
			end
			
			return false
		end
	
		local ignoreList = {localPlayer.Character}
	
		target = workspace:FindPartOnRayWithIgnoreList(ray, ignoreList, true)
	
		while target and not isPlayerPart(target) do
			table.insert(ignoreList, target)
			target = workspace:FindPartOnRayWithIgnoreList(ray, ignoreList, true)
		end
	
		return target and target.Parent
	end

	local function aimAt(target)
		local character = target
	
		if character then
			local aimPart = math.random() < 0.5 and character:FindFirstChild("Head") or character:FindFirstChild("HumanoidRootPart")

			if aimPart then
				local raycastParams = RaycastParams.new()
				raycastParams.FilterDescendantsInstances = {game.Players.LocalPlayer.Character, character}
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
				getgenv().__0RXPT.TargetTeamColor = game.Players[targetCharacter.Name].Team.TeamColor.Color or Color3.new(1, 1, 1)
				aimAt(targetCharacter)
			else
				getgenv().__0RXPT.TargetTeamColor = Color3.new(1, 1, 1)
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
		if getgenv().__0RXPT.Drawing then
			getgenv().__0RXPT.Drawing:Destroy()
		end

		for _, connection in pairs(getgenv().__0RXPT.Connections) do
			connection:Disconnect()
		end
	end

	getgenv().__0RXPT = {
		WalkSpeed = game.Players.LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed,
		JumpPower = game.Players.LocalPlayer.Character:WaitForChild("Humanoid").JumpPower,
		AimbotRange = 300,
		TargetTeamColor = Color3.new(1, 1, 1),
		WallCheck = false,
		FOVRadius = 1,

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

	--ESP()
	Nametags()
	Aimbot()
end

initialize()
start()