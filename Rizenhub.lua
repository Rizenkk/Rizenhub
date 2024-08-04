local RizenHub = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local CloseButton = Instance.new("TextButton")
local MinimizeButton = Instance.new("TextButton")
local MaximizeButton = Instance.new("TextButton")
local ColorDropdown = Instance.new("Frame")
local ColorButton = Instance.new("TextButton")
local AutoSetSpawnPoint = Instance.new("TextButton")
local SelectWeapon = Instance.new("TextButton")
local AutoFarmLevel = Instance.new("TextButton")
local AutoFarmNearest = Instance.new("TextButton")
local AutoFarmChest = Instance.new("TextButton")

local autoFarmChestActive = false
local minimized = false

RizenHub.Name = "RizenHub"
RizenHub.Parent = game.CoreGui

MainFrame.Name = "MainFrame"
MainFrame.Parent = RizenHub
MainFrame.BackgroundColor3 = Color3.new(0.2, 0, 0)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -150)
MainFrame.Size = UDim2.new(0, 300, 0, 300)
MainFrame.Active = true
MainFrame.Draggable = true

Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.new(0.3, 0, 0)
Title.Size = UDim2.new(0, 300, 0, 50)
Title.Font = Enum.Font.SourceSans
Title.Text = "Rizen Hub | Blox Fruits"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 24

local function createButton(name, text, position, parent, size)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Parent = parent
    button.BackgroundColor3 = Color3.new(0.4, 0, 0)
    button.Position = position
    button.Size = size or UDim2.new(0, 280, 0, 30)
    button.Font = Enum.Font.SourceSans
    button.Text = text
    button.TextColor3 = Color3.new(1, 1, 1)
    button.TextSize = 18
    button.TextWrapped = true
    return button
end

local function toggleButtonState(button)
    if button.BackgroundColor3 == Color3.new(0.4, 0, 0) then
        button.BackgroundColor3 = Color3.new(0, 0.4, 0)
        button.Text = button.Text .. " (Ativado)"
    else
        button.BackgroundColor3 = Color3.new(0.4, 0, 0)
        button.Text = button.Text:gsub(" %(Ativado%)", "")
    end
end

local function setVisibility(visible)
    for _, child in pairs(MainFrame:GetChildren()) do
        if child ~= Title and child ~= MinimizeButton and child ~= CloseButton and child ~= MaximizeButton and child ~= ColorButton and child ~= ColorDropdown then
            child.Visible = visible
        end
    end
    ColorButton.Visible = visible
end

local function changeInterfaceColor(color)
    MainFrame.BackgroundColor3 = color
    Title.BackgroundColor3 = color:lerp(Color3.new(0.3, 0, 0), 0.5)
    for _, child in pairs(MainFrame:GetChildren()) do
        if child:IsA("TextButton") and child.Name ~= "CloseButton" and child.Name ~= "MinimizeButton" and child.Name ~= "MaximizeButton" and child.Name ~= "ColorButton" then
            child.BackgroundColor3 = color
        end
    end
end

CloseButton = createButton("CloseButton", "X", UDim2.new(0, 270, 0, 10), MainFrame, UDim2.new(0, 20, 0, 20))
CloseButton.MouseButton1Click:Connect(function()
    RizenHub:Destroy()
end)

MinimizeButton = createButton("MinimizeButton", "-", UDim2.new(0, 240, 0, 10), MainFrame, UDim2.new(0, 20, 0, 20))
MinimizeButton.MouseButton1Click:Connect(function()
    if minimized then
        MainFrame.Size = UDim2.new(0, 300, 0, 300)
        setVisibility(true)
        MinimizeButton.Text = "-"
        minimized = false
    else
        MainFrame.Size = UDim2.new(0, 300, 0, 50)
        setVisibility(false)
        MinimizeButton.Text = "+"
        minimized = true
    end
end)

MaximizeButton = createButton("MaximizeButton", "⬜", UDim2.new(0, 210, 0, 10), MainFrame, UDim2.new(0, 20, 0, 20))
MaximizeButton.MouseButton1Click:Connect(function()
    if MainFrame.Size == UDim2.new(0, 300, 0, 300) then
        MainFrame.Size = UDim2.new(1, -20, 1, -20)
        MainFrame.Position = UDim2.new(0, 10, 0, 10)
    else
        MainFrame.Size = UDim2.new(0, 300, 0, 300)
        MainFrame.Position = UDim2.new(0.5, -150, 0.5, -150)
    end
end)

ColorButton = createButton("ColorButton", "Select Color", UDim2.new(0, 10, 0, 260), MainFrame)
ColorDropdown.Name = "ColorDropdown"
ColorDropdown.Parent = MainFrame
ColorDropdown.BackgroundColor3 = Color3.new(0.3, 0, 0)
ColorDropdown.Position = UDim2.new(0, 10, 0, 290)
ColorDropdown.Size = UDim2.new(0, 280, 0, 150)
ColorDropdown.Visible = false

local colors = {
    ["Red"] = Color3.new(1, 0, 0),
    ["Blue"] = Color3.new(0, 0, 1),
    ["White"] = Color3.new(1, 1, 1),
    ["Purple"] = Color3.new(0.5, 0, 0.5),
    ["Black"] = Color3.new(0, 0, 0)
}

local colorIndex = 0
for colorName, colorValue in pairs(colors) do
    local button = createButton(colorName .. "Button", colorName, UDim2.new(0, 10, 0, colorIndex * 30), ColorDropdown, UDim2.new(0, 260, 0, 30))
    button.MouseButton1Click:Connect(function()
        changeInterfaceColor(colorValue)
        ColorDropdown.Visible = false
    end)
    colorIndex = colorIndex + 1
end

ColorButton.MouseButton1Click:Connect(function()
    ColorDropdown.Visible = not ColorDropdown.Visible
end)

AutoSetSpawnPoint = createButton("AutoSetSpawnPoint", "Auto Set Spawn Point", UDim2.new(0, 10, 0, 60), MainFrame)
AutoSetSpawnPoint.MouseButton1Click:Connect(function()
    toggleButtonState(AutoSetSpawnPoint)
    -- Adicione o código para Auto Set Spawn Point aqui
end)

SelectWeapon = createButton("SelectWeapon", "Select Weapon", UDim2.new(0, 10, 0, 100), MainFrame)
SelectWeapon.MouseButton1Click:Connect(function()
    -- Adicione o código para Select Weapon aqui
end)

AutoFarmLevel = createButton("AutoFarmLevel", "Auto Farm Level", UDim2.new(0, 10, 0, 140), MainFrame)
AutoFarmLevel.MouseButton1Click:Connect(function()
    toggleButtonState(AutoFarmLevel)
    -- Adicione o código para Auto Farm Level aqui
end)

AutoFarmNearest = createButton("AutoFarmNearest", "Auto Farm Nearest", UDim2.new(0, 10, 0, 180), MainFrame)
AutoFarmNearest.MouseButton1Click:Connect(function()
    toggleButtonState(AutoFarmNearest)
    -- Adicione o código para Auto Farm Nearest aqui
end)

AutoFarmChest = createButton("AutoFarmChest", "Auto Farm Chest (Tween
