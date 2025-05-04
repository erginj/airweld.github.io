local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- GUI setup
local existingGui = PlayerGui:FindFirstChild("SideButtonGui")
if existingGui then existingGui:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "SideButtonGui"
gui.ResetOnSpawn = false
gui.Parent = PlayerGui

local button = Instance.new("TextButton")
button.Name = "WeldButton"
button.Size = UDim2.new(0, 110, 0, 40)
button.Position = UDim2.new(1, -15, 0.5, 0)
button.AnchorPoint = Vector2.new(1, 0.5)
button.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
button.Text = "Weld"
button.TextColor3 = Color3.new(1, 1, 1)
button.TextScaled = true
button.Font = Enum.Font.GothamMedium
button.AutoButtonColor = false
button.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = button

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 40)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(70, 70, 70))
}
gradient.Rotation = 90
gradient.Parent = button

-- Notification Loop
task.spawn(function()
    StarterGui:SetCore("SendNotification", {
        Title = "JOIN DISCORD",
        Text = "https://discord.gg/ringta",
        Duration = 15
    })
end)

-- Find model with DragAttachment
local function getModelWithAttachment()
	local runtimeItems = workspace:FindFirstChild("RuntimeItems")
	if not runtimeItems then return nil end

	for _, model in ipairs(runtimeItems:GetChildren()) do
		if model:IsA("Model") then
			for _, part in ipairs(model:GetDescendants()) do
				if (part:IsA("Part") or part:IsA("MeshPart")) and part:FindFirstChild("DragAttachment") then
					return model
				end
			end
		end
	end
	return nil
end

-- Smart platform detection
local function getPlatformBase()
	local tryPaths = {
		"armor.Functional.Platform.Base.Base",
		"armor.Platform.Base.Base",
		"golden.Platform.Base.Base",
		"cattle.Platform.Base.Base",
		"default.Platform.Base.Base"
	}

	for _, path in ipairs(tryPaths) do
		local success, result = pcall(function()
			local parts = string.split(path, ".")
			local obj = workspace
			for _, partName in ipairs(parts) do
				obj = obj:FindFirstChild(partName)
				if not obj then break end
			end
			return obj
		end)

		if success and result then return result end
	end

	return nil
end

-- Weld logic
local function weldToPlatform()
	local model = getModelWithAttachment()
	local platformBase = getPlatformBase()

	local remote = ReplicatedStorage:FindFirstChild("Shared")
	remote = remote and remote:FindFirstChild("Network")
	remote = remote and remote:FindFirstChild("RemoteEvent")
	remote = remote and remote:FindFirstChild("RequestWeld")

	if model and platformBase and remote then
		remote:FireServer(model, platformBase)
	else
		warn("Weld failed. Missing model, platform, or remote.")
	end
end

-- Button & Z key
button.MouseButton1Click:Connect(weldToPlatform)

UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.Z then
		weldToPlatform()
	end
end)
