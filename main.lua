local LogConsole = {}
LogConsole.__index = LogConsole
LogConsole.Positions = {
	"top-left";
	"top-mid";
	"top_right";
	"mid_left";
	"mid_right";
	"bottom_left";
	"bottom_mid";
	"bottom_right";
}

local positioningData = {
	["top"] = 0;
	["mid"] = .5;
	["bottom"] = 1;
	["left"] = 0;
	["right"] = 1;
}

local function CreateGUI()
	local gui = Instance.new("ScreenGui")
	gui.Name = "LogConsole"
	gui.Parent = game.CoreGui
	
	local frame = Instance.new("Frame")
	frame.Name = "LogFrame"
	frame.BackgroundTransparency = 1
	frame.Size = UDim2.new(.25, 0, .5, 0)
	frame.Position = UDim2.new(0, 0, 0, 0)
	frame.Parent = gui
	
	local aspectRatio = Instance.new("UIAspectRatioConstraint")
	aspectRatio.AspectRatio = 1
	aspectRatio.DominantAxis = Enum.DominantAxis.Width
	aspectRatio.Parent = frame
	
	local listLayout = Instance.new("UIListLayout")
	listLayout.Padding = UDim.new(0, 10)
	listLayout.Parent = frame
	
	return gui
end

local function NewEntry(text)
	local entry = Instance.new("TextLabel")
	entry.Font = Enum.Font.Arial
	entry.Text = text
	entry.Size = UDim2.new(1, 0, 0, 20)
	entry.TextColor3 = Color3.fromRGB(255, 255, 255)
	entry.TextScaled = true
	entry.BackgroundTransparency = 1
	
	return entry
end

function LogConsole.new()
	local self = setmetatable({}, LogConsole)
	
	self._gui = CreateGUI()
	self._logFrame = self._gui.LogFrame
	self._logHistory = {}
	
	self.maxHistory = math.floor(self._logFrame.AbsoluteSize / 20)
	
	return self
end

function LogConsole:Init(options)
	local position = options.Position
	if not position or not table.find(self.Positions, position) then return end
	
	local vertical, horiontal = unpack(position:split('-'))
	
	self._logFrame.AnchorPoint = Vector2.new(
		positioningData[horiontal],
		positioningData[vertical]
	)
	
	self._logFrame.Position = UDim2.new(
		positioningData[horiontal],
		0,
		positioningData[vertical],
		0
	)
	
	self.maxHistory = math.floor(self._logFrame.AbsoluteSize.Y / 20)
	
	self:Log("Initiated log.")
end

function LogConsole:Log(text)
	local entry = NewEntry(text)
	entry.Parent = self._logFrame
	table.insert(self._logHistory, entry)
	if #self._logFrame:GetChildren() == self.maxHistory then
		local oldestLog = self._logHistory[#self._logHistory]
		oldestLog:Destroy()
	end
end

return LogConsole
