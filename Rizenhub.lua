-- Variáveis
local isESPEnabled = false
local isAutoBreathingEnabled = false
local loadingComplete = false
local screenSize = game:GetService("Workspace").CurrentCamera.ViewportSize

-- Função para criar a interface de carregamento e opções
local function createInterface()
    -- Criar a tela de carregamento
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "KgHubInterface"
    screenGui.Parent = game.Players.LocalPlayer.PlayerGui

    -- Fundo da tela
    local background = Instance.new("Frame")
    background.Size = UDim2.new(0, 500, 0, 300)
    background.Position = UDim2.new(0.5, -250, 0.5, -150)
    background.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    background.BackgroundTransparency = 0.9
    background.Parent = screenGui

    -- Título "KgHub"
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 50)
    title.Position = UDim2.new(0, 0, 0, 10)
    title.Text = "KgHub"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextScaled = true
    title.BackgroundTransparency = 1
    title.Parent = background

    -- Barra de carregamento
    local loadingBarBackground = Instance.new("Frame")
    loadingBarBackground.Size = UDim2.new(0, 400, 0, 20)
    loadingBarBackground.Position = UDim2.new(0.5, -200, 0.5, 70)
    loadingBarBackground.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    loadingBarBackground.Parent = background

    local loadingBar = Instance.new("Frame")
    loadingBar.Size = UDim2.new(0, 0, 1, 0)
    loadingBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    loadingBar.Parent = loadingBarBackground

    -- Texto de status de carregamento
    local loadingText = Instance.new("TextLabel")
    loadingText.Size = UDim2.new(1, 0, 0, 50)
    loadingText.Position = UDim2.new(0, 0, 0, 100)
    loadingText.Text = "Carregando..."
    loadingText.TextColor3 = Color3.fromRGB(255, 255, 255)
    loadingText.TextScaled = true
    loadingText.BackgroundTransparency = 1
    loadingText.Parent = background

    -- Barra de progresso de carregamento
    local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.In, 0, false, 0)
    local tween = game:GetService("TweenService"):Create(loadingBar, tweenInfo, {Size = UDim2.new(0, 400, 1, 0)})
    tween:Play()

    -- Quando o carregamento terminar, exibe as opções
    tween.Completed:Connect(function()
        loadingComplete = true
        loadingText.Text = "Carregamento concluído!"
        wait(1)

        -- Esconder a tela de carregamento
        background.Visible = false

        -- Exibir as opções
        local optionsFrame = Instance.new("Frame")
        optionsFrame.Size = UDim2.new(0, 500, 0, 300)
        optionsFrame.Position = UDim2.new(0.5, -250, 0.5, -150)
        optionsFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        optionsFrame.BackgroundTransparency = 0.9
        optionsFrame.Parent = screenGui

        -- Título "Opções"
        local optionsTitle = Instance.new("TextLabel")
        optionsTitle.Size = UDim2.new(1, 0, 0, 50)
        optionsTitle.Position = UDim2.new(0, 0, 0, 10)
        optionsTitle.Text = "Opções"
        optionsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        optionsTitle.TextScaled = true
        optionsTitle.BackgroundTransparency = 1
        optionsTitle.Parent = optionsFrame

        -- Texto de controle do ESP
        local espLabel = Instance.new("TextLabel")
        espLabel.Size = UDim2.new(1, 0, 0, 50)
        espLabel.Position = UDim2.new(0, 0, 0, 70)
        espLabel.Text = "ESP (F)"
        espLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        espLabel.TextScaled = true
        espLabel.BackgroundTransparency = 1
        espLabel.Parent = optionsFrame

        -- Texto de controle do Auto Breathing
        local breathingLabel = Instance.new("TextLabel")
        breathingLabel.Size = UDim2.new(1, 0, 0, 50)
        breathingLabel.Position = UDim2.new(0, 0, 0, 140)
        breathingLabel.Text = "Auto Breathing (F4)"
        breathingLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        breathingLabel.TextScaled = true
        breathingLabel.BackgroundTransparency = 1
        breathingLabel.Parent = optionsFrame
    end)
end

-- Função para simular pressionar a tecla G (Auto Breathing)
local function pressG()
    local UserInputService = game:GetService("UserInputService")
    local inputObject = Instance.new("InputObject")
    inputObject.KeyCode = Enum.KeyCode.G
    inputObject.UserInputType = Enum.UserInputType.Keyboard
    UserInputService.InputBegan:Fire(inputObject, false)
end

-- Função para criar o ESP para jogadores
local function createPlayerESP(player)
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        -- Criar a parte do ESP
        local espPart = Instance.new("Part")
        espPart.Name = "BodyESP"
        espPart.Size = Vector3.new(4, 6, 2)  -- Tamanho do quadrado
        espPart.Position = character.HumanoidRootPart.Position
        espPart.Anchored = true
        espPart.CanCollide = false
        espPart.Transparency = 0.5
        espPart.BrickColor = BrickColor.Red()  -- Cor vermelha para jogadores
        espPart.Parent = game.CoreGui

        -- Atualizar a posição do ESP
        game:GetService("RunService").Heartbeat:Connect(function()
            if character and character:FindFirstChild("HumanoidRootPart") then
                espPart.Position = character.HumanoidRootPart.Position + Vector3.new(0, 5, 0)  -- Levanta o quadrado um pouco acima da cabeça
            else
                espPart:Destroy()  -- Remove o ESP se o personagem for destruído
            end
        end)

        -- Exibir a vida e o nome do jogador
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            -- Criar o BillboardGui para o nome e a vida
            local healthLabel = Instance.new("BillboardGui")
            healthLabel.Size = UDim2.new(0, 100, 0, 50)
            healthLabel.StudsOffset = Vector3.new(0, 3, 0)
            healthLabel.Adornee = character.Head
            healthLabel.Parent = character.Head

            local textLabel = Instance.new("TextLabel")
            textLabel.Size = UDim2.new(1, 0, 1, 0)
            textLabel.Text = player.Name .. "\nHP: " .. math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth)
            textLabel.TextColor3 = Color3.fromRGB(255, 0, 0)  -- Cor vermelha para jogadores
            textLabel.BackgroundTransparency = 1  -- Sem fundo
            textLabel.TextWrapped = true  -- Quebra o texto automaticamente
            textLabel.Parent = healthLabel

            humanoid.HealthChanged:Connect(function()
                -- Atualiza a vida do jogador
                if humanoid then
                    textLabel.Text = player.Name .. "\nHP: " .. math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth)
                end
            end)
        end
    end
end

-- Função para alternar o ESP
local function toggleESP()
    isESPEnabled = not isESPEnabled
    if isESPEnabled then
        print("ESP Ativado")
    else
        print("ESP Desativado")
    end
end

-- Função para alternar o Auto Breathing
local function toggleAutoBreathing()
    isAutoBreathingEnabled = not isAutoBreathingEnabled
    if isAutoBreathingEnabled then
        print("Auto Breathing Ativado")
        pressG()  -- Simula o pressionamento da tecla G
    else
        print("Auto Breathing Desativado")
    end
end

-- Função para alternar a ativação do ESP com a tecla F
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.KeyCode == Enum.KeyCode.F then
        toggleESP()
    elseif input.KeyCode == Enum.KeyCode.F4 then
        toggleAutoBreathing()
    end
end)

-- Criar a interface e o ESP
createInterface()

-- Criar ESP para os jogadores no início
for _, player in pairs(game.Players:GetPlayers()) do
    if player ~= game.Players.LocalPlayer then
        player.CharacterAdded:Connect(function()
            if isESPEnabled then
                createPlayerESP(player)
            end
        end)
    end
end

-- Monitorar a adição de novos jogadores para criar o ESP para eles
game.Players.PlayerAdded:Connect(function(player)
    if player ~= game.Players.LocalPlayer then
        player.CharacterAdded:Connect(function()
            if isESPEnabled then
                createPlayerESP(player)
            end
        end)
    end
end)

-- Monitorar a remoção de jogadores
game.Players.PlayerRemoving:Connect(function(player)
    if player ~= game.Players.LocalPlayer then
        local character = player.Character
        if character and character:FindFirstChild("BodyESP") then
            character.BodyESP:Destroy()  -- Remove o ESP do jogador
        end
    end
end)

-- Monitorar a adição de NPCs para criar o ESP para eles
workspace.ChildAdded:Connect(function(child)
    if child:IsA("Model") and child:FindFirstChild("Humanoid") then
        if isESPEnabled then
            createNPCESP(child)
        end
    end
end)

-- Monitorar a remoção de NPCs
workspace.ChildRemoved:Connect(function(child)
    if child:IsA("Model") and child:FindFirstChild("Humanoid") then
        if child:FindFirstChild("BodyESP") then
            child.BodyESP:Destroy()  -- Remove o ESP do NPC
        end
    end
end)

-- Função para criar o ESP para NPCs
local function createNPCESP(npc)
    if npc and npc:FindFirstChild("HumanoidRootPart") then
        -- Criar a parte do ESP para NPC
        local espPart = Instance.new("Part")
        espPart.Name = "BodyESP"
        espPart.Size = Vector3.new(4, 6, 2)  -- Tamanho do quadrado
        espPart.Position = npc.HumanoidRootPart.Position
        espPart.Anchored = true
        espPart.CanCollide = false
        espPart.Transparency = 0.5
        espPart.BrickColor = BrickColor.Blue()  -- Cor azul para NPCs
        espPart.Parent = game.CoreGui

        -- Atualizar a posição do ESP
        game:GetService("RunService").Heartbeat:Connect(function()
            if npc and npc:FindFirstChild("HumanoidRootPart") then
                espPart.Position = npc.HumanoidRootPart.Position + Vector3.new(0, 5, 0)  -- Levanta o quadrado um pouco acima da cabeça
            else
                espPart:Destroy()  -- Remove o ESP se o NPC for destruído
            end
        end)

        -- Exibir a vida e o nome do NPC
        local humanoid = npc:FindFirstChildOfClass("Humanoid")
        if humanoid then
            -- Criar o BillboardGui para o nome e a vida
            local healthLabel = Instance.new("BillboardGui")
            healthLabel.Size = UDim2.new(0, 100, 0, 50)
            healthLabel.StudsOffset = Vector3.new(0, 3, 0)
            healthLabel.Adornee = npc.Head
            healthLabel.Parent = npc.Head

            local textLabel = Instance.new("TextLabel")
            textLabel.Size = UDim2.new(1, 0, 1, 0)
            textLabel.Text = npc.Name .. "\nHP: " .. math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth)
            textLabel.TextColor3 = Color3.fromRGB(0, 0, 255)  -- Cor azul para NPCs
            textLabel.BackgroundTransparency = 1  -- Sem fundo
            textLabel.TextWrapped = true  -- Quebra o texto automaticamente
            textLabel.Parent = healthLabel

            humanoid.HealthChanged:Connect(function()
                -- Atualiza a vida do NPC
                if humanoid then
                    textLabel.Text = npc.Name .. "\nHP: " .. math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth)
                end
            end)
        end
    end
end

-- Função para garantir que o ESP funcione para todos os NPCs ao iniciar
for _, npc in pairs(workspace:GetChildren()) do
    if npc:IsA("Model") and npc:FindFirstChild("Humanoid") then
        if isESPEnabled then
            createNPCESP(npc)
        end
    end
end

-- Função para garantir que o Auto Breathing funcione
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.KeyCode == Enum.KeyCode.F4 then
        toggleAutoBreathing()  -- Alterna o Auto Breathing
    end
end)

-- Monitorar a adição de NPCs no workspace e criar o ESP para novos NPCs
workspace.ChildAdded:Connect(function(child)
    if child:IsA("Model") and child:FindFirstChild("Humanoid") then
        if isESPEnabled then
            createNPCESP(child)
        end
    end
end)

-- Ajuste de comportamento para ESP ao iniciar e durante o jogo
game:GetService("Players").PlayerAdded:Connect(function(player)
    if player ~= game.Players.LocalPlayer then
        player.CharacterAdded:Connect(function()
            if isESPEnabled then
                createPlayerESP(player)
            end
        end)
    end
end)
