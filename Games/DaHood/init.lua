if not game.Players.LocalPlayer.Character then
	game.Players.LocalPlayer.CharacterAdded:Wait()
end

local function InfJump()
	local UserInputService = game:GetService("UserInputService")

	local connection = UserInputService.InputBegan:Connect(function(input, GPE)
		if GPE then
			return
		end;

		if input.KeyCode == Enum.KeyCode.Space then
			game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(
				game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity.X,
				getgenv().__0RXPT.JumpPower,
				game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity.Z
			)
		end
	end)
	
	table.insert(getgenv().__0RXPT.Connections, connection)
end

local function __updateValues()
	local connection = game.Players.LocalPlayer.Character:WaitForChild("Humanoid"):GetPropertyChangedSignal("WalkSpeed"):Connect(function()
		game.Players.LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed = getgenv().__0RXPT.WalkSpeed
	end)
	
	game.Players.LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed = getgenv().__0RXPT.WalkSpeed

	table.insert(getgenv().__0RXPT.Connections, connection)
	
	local connection3
	
	local connection2 = game.Players.LocalPlayer.CharacterAdded:Connect(function()
		connection:Disconnect()
		
		if connection3 then
			connection3:Disconnect()
		end
		
		connection3 = game.Players.LocalPlayer.Character:WaitForChild("Humanoid"):GetPropertyChangedSignal("WalkSpeed"):Connect(function()
			game.Players.LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed = getgenv().__0RXPT.WalkSpeed
		end)
		
		game.Players.LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed = getgenv().__0RXPT.WalkSpeed

		table.insert(getgenv().__0RXPT.Connections, connection3)
	end)
	
	table.insert(getgenv().__0RXPT.Connections, connection2)
end

local function Chatted()
	local callbacks = {
		w = function(args)
			if not args[2] then
				return
			end

			getgenv().__0RXPT.WalkSpeed = args[2]
		end,
		
		j = function(args)
			if not args[2] then
				return
			end
			
			getgenv().__0RXPT.JumpPower = args[2]
		end,
		
		t = function(args)
			local targetName = args[2]
			
			if not targetName then
				return
			end
			
			local function targetToPlayer()
				for _, player in game.Players:GetPlayers() do
					if player.Name:lower():sub(1, #targetName) == targetName:lower() or player.DisplayName:lower():sub(1, #targetName) == targetName:lower() then
						return player
					end
				end
			end
			
			local target = targetToPlayer()
			
			if not target then
				return
			end
			
			if game.Players.LocalPlayer.Character and target.Character then
				game.Players.LocalPlayer.Character:MoveTo(target.Character.HumanoidRootPart.Position)
			end
		end,
		
		tp = function(args)
			local place = args[2]
			
			if not place then
				return
			end
			
			local validPlaces = {
				sb = CFrame.new(102.218552, -41.9520454, 155.67485, -0.0250389744, -4.28941611e-08, 0.99968648, 5.23341406e-08, 1, 4.42184174e-08, -0.99968648, 5.3424916e-08, -0.0250389744),
				gs = CFrame.new(585.799011, 48.9980545, -258.916016, -0.149291411, 5.78674886e-08, -0.988793254, -5.20826493e-09, 1, -5.77369832e-08, 0.988793254, -3.46973872e-09, -0.149291411),
				military = CFrame.new(34.5886307, 25.6280289, -847.770447, -0.969403386, 1.46822163e-08, 0.245473161, 3.48346489e-08, 1, 7.77543647e-08, -0.245473161, 8.39263166e-08, -0.969403386),
				bank = CFrame.new(-469.143127, 23.0624428, -284.77594, -0.00361009198, -9.95440814e-08, 0.999993503, -1.87097786e-08, 1, 9.94771838e-08, -0.999993503, -1.83505353e-08, -0.00361009198),
				upgunz = CFrame.new(483.231262, 48.0685234, -621.341553, 0.999577522, -4.98066255e-09, -0.0290649869, 5.24277688e-09, 1, 8.9420169e-09, 0.0290649869, -9.0906207e-09, 0.999577522),
				downgunz = CFrame.new(-577.353516, 8.31280613, -737.450012, -0.275331497, 2.72395884e-08, 0.961349368, 2.18519203e-09, 1, -2.77089036e-08, -0.961349368, -5.52840085e-09, -0.275331497),
				hs = CFrame.new(409.615143, 48.0249748, -47.2364235, 0.999689043, 9.51778212e-09, -0.0249370839, -8.27047941e-09, 1, 5.01211019e-08, 0.0249370839, -4.9899274e-08, 0.999689043),
			}
			
			place = validPlaces[place]
			
			if not place then
				return
			end
			
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = place
		end,
	}
	
	local connection = game.Players.LocalPlayer.Chatted:Connect(function(message)
		local args = message:split(" ")
		local callback = callbacks[args[1]]
		
		if not callback then
			return
		end
		
		callback(args)
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
		username.TextColor3 = Color3.fromRGB(0, 0, 255)
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

local function JCollide()
	local UserInputService = game:GetService("UserInputService")

	local connection = UserInputService.InputBegan:Connect(function(input, GPE)
		if GPE then
			return
		end;

		if input.KeyCode == Enum.KeyCode.J then
			local obj = game.Players.LocalPlayer:GetMouse().Target
			
			if obj:IsA("BasePart") then
				obj.CanCollide = not obj.CanCollide
			end
		end
	end)

	table.insert(getgenv().__0RXPT.Connections, connection)
end

local function Aimbot()
	local aimbotEnabled = false
	local range = 100
	local mouse = game.Players.LocalPlayer:GetMouse()

	local function getPlayerFromMouse()
		local localPlayer = game.Players.LocalPlayer
		local character = localPlayer.Character
		if not character or not character:FindFirstChild("HumanoidRootPart") then return nil end

		local camera = workspace.CurrentCamera
		local mouseRay = camera:ScreenPointToRay(mouse.X, mouse.Y)
		local ray = Ray.new(mouseRay.Origin, mouseRay.Direction * range)
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

		if character and character:FindFirstChild("Head") then
			camera.CFrame = CFrame.new(camera.CFrame.Position, character.Head.Position)
		elseif character and character:FindFirstChild("HumanoidRootPart") then
			camera.CFrame = CFrame.new(camera.CFrame.Position, character.HumanoidRootPart.Position)
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
	game.Players.LocalPlayer.Character:WaitForChild("Humanoid").UseJumpPower = true
	
	if getgenv().__0RXPT then
		for _, connection in pairs(getgenv().__0RXPT.Connections) do
			connection:Disconnect()
		end
	end

	getgenv().__0RXPT = {
		WalkSpeed = game.Players.LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed,
		JumpPower = game.Players.LocalPlayer.Character:WaitForChild("Humanoid").JumpPower,
		
		Connections = {},
	}
	
	__updateValues()
end

local function start()
	local StarterGui = game:GetService("StarterGui")

	StarterGui:SetCore("SendNotification", {
		Title = "0rxpt's Script", 
		Text = "Da Hood script loaded. Have fun!", 
		Duration = 10
	})

	InfJump()
	Chatted()
	ESP()
	Nametags()
	JCollide()
    Aimbot()
end

initialize()
start()