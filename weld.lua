local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Remove old GUI if it exists
local existingGui = PlayerGui:FindFirstChild("SideButtonGui")
if existingGui then
	existingGui:Destroy()
end

-- Create GUI
local gui = Instance.new("ScreenGui")
gui.Name = "SideButtonGui"
gui.ResetOnSpawn = false
gui.Parent = PlayerGui

-- Create Stylish Button
local button = Instance.new("TextButton")
button.Name = "SidePrintButton"
button.Size = UDim2.new(0, 110, 0, 40)
button.Position = UDim2.new(1, -15, 0.5, 0)
button.AnchorPoint = Vector2.new(1, 0.5)
button.BackgroundColor3 = Color3.fromRGB(25, 150, 25)
button.BackgroundTransparency = 0.1
button.BorderSizePixel = 0
button.Text = "Weld"
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.TextScaled = true
button.Font = Enum.Font.GothamMedium
button.AutoButtonColor = false
button.Parent = gui

-- Style
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = button

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 180, 40)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(70, 220, 70))
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



-- Platform detection
local function findValidPlatform()
	local platformPaths = {
		workspace:FindFirstChild("cattle"),
		workspace:FindFirstChild("golden"),
		workspace:FindFirstChild("default"),
		workspace:FindFirstChild("armor") and workspace.armor:FindFirstChild("Functional")
	}

	for _, root in ipairs(platformPaths) do
		if root and root:FindFirstChild("Platform") then
			local platform = root.Platform
			if platform:FindFirstChild("Base") and platform.Base:FindFirstChild("Base") then
				return platform.Base.Base
			end
		end
	end

	return nil
end

-- Weld handler
button.MouseButton1Click:Connect(function()
	local runtimeItems = workspace:FindFirstChild("RuntimeItems")
	if not runtimeItems then return end

	local platformBase = findValidPlatform()
	if not platformBase then
		warn("No valid platform found.")
		return
	end

	local remote = ReplicatedStorage:FindFirstChild("Shared")
	if not remote then return end
	remote = remote:FindFirstChild("Network")
	if not remote then return end
	remote = remote:FindFirstChild("RemoteEvent")
	if not remote then return end
	remote = remote:FindFirstChild("RequestWeld")
	if not remote then return end

	for _, model in ipairs(runtimeItems:GetChildren()) do
		if model:IsA("Model") then
			for _, part in ipairs(model:GetDescendants()) do
				if (part:IsA("Part") or part:IsA("MeshPart")) and part:FindFirstChild("DragAttachment") then
					remote:FireServer(model, platformBase)
					return
				end
			end
		end
	end
end)
