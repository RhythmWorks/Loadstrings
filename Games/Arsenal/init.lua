if not game.Players.LocalPlayer.Character then
	game.Players.LocalPlayer.CharacterAdded:Wait()
end

local function Chatted()
	local StarterGui = game:GetService("StarterGui")

	local callbacks = {
		r = function(args)
			if not args[2] then
				return
			end

			local before = getgenv().__0RXPT.AimbotRange

			getgenv().__0RXPT.AimbotRange = args[2]

			return {
				Title = "Aimbot Range Updated",
				Desc = "Before: " .. before .. "\nAfter: " .. args[2]
			}
		end,
	}
	
	local connection = game.Players.LocalPlayer.Chatted:Connect(function(message)
		local args = message:split(" ")
		local callback = callbacks[args[1]]
		
		if not callback then
			return
		end
		
		local notificationData = callback(args)
		
		StarterGui:SetCore("SendNotification", {
			Title = notificationData.Title, 
			Text = notificationData.Desc, 
			Duration = notificationData.Duration or 3
		})
	end)
	
	table.insert(getgenv().__0RXPT.Connections, connection)
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
		username.TextColor3 = player.TeamColor.Color or Color3.fromRGB(0, 0, 255)
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
	local aimbotEnabled = false
	local mouse = game.Players.LocalPlayer:GetMouse()

	local function getPlayerFromMouse()
		local localPlayer = game.Players.LocalPlayer
		local character = localPlayer.Character
		if not character or not character:FindFirstChild("HumanoidRootPart") then return nil end

		local camera = workspace.CurrentCamera
		local mouseRay = camera:ScreenPointToRay(mouse.X, mouse.Y)
		local ray = Ray.new(mouseRay.Origin, mouseRay.Direction * getgenv().__0RXPT.AimbotRange)
		local target, position

		local function isPlayerPart(part)
			local player = game.Players:GetPlayerFromCharacter(part.Parent)
			return player and player ~= localPlayer and player.Team ~= localPlayer.Team
		end

		local ignoreList = {localPlayer.Character}

		target, position = workspace:FindPartOnRayWithIgnoreList(ray, ignoreList, true)

		while target and not isPlayerPart(target) do
			table.insert(ignoreList, target)
			target, position = workspace:FindPartOnRayWithIgnoreList(ray, ignoreList, true)
		end

		return target and target.Parent
	end

	local function aimAt(target)
		local camera = workspace.CurrentCamera
		local character = target

        if character then
            local aimPart = math.random() < 0.5 and character:FindFirstChild("Head") or character:FindFirstChild("HumanoidRootPart")
            
            if aimPart then
                camera.CFrame = CFrame.new(camera.CFrame.Position, aimPart.Position)
            end
        end
	end

	local function onKeyPress(input, GPE)
		if input.KeyCode == Enum.KeyCode.E and not GPE then
			aimbotEnabled = not aimbotEnabled
		end
	end

	local function onUpdate()
		if aimbotEnabled then
			local targetCharacter = getPlayerFromMouse()
			if targetCharacter then
				aimAt(targetCharacter)
			end
		end
	end
	
	local inputBeganConnection = game:GetService("UserInputService").InputBegan:Connect(onKeyPress)
	local renderSteppedConnection = game:GetService("RunService").RenderStepped:Connect(onUpdate)
	
	table.insert(getgenv().__0RXPT.Connections, inputBeganConnection)
	table.insert(getgenv().__0RXPT.Connections, renderSteppedConnection)
end

local function initialize()
	if getgenv().__0RXPT then
		for _, connection in pairs(getgenv().__0RXPT.Connections) do
			connection:Disconnect()
		end
	end

	getgenv().__0RXPT = {
		WalkSpeed = game.Players.LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed,
		JumpPower = game.Players.LocalPlayer.Character:WaitForChild("Humanoid").JumpPower,
		AimbotRange = 300,
		
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

	Chatted()
	--ESP()
	Nametags()
	Aimbot()
end

initialize()
start()