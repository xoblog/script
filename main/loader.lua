getgenv().MultiLoader = true

-- Config Game yang Didukung
local GameConfigs = {
    [121864768012064] = { -- Fishing Simulator
        name = "Fish It",
        script =
        "https://raw.githubusercontent.com/xoblog/best/refs/heads/main/fishit_xoblog.lua"
    },
    [126884695634066] = {
        name = "Grow A Garden",
        script =
        "https://raw.githubusercontent.com/xoblog/best/refs/heads/main/grow_a_garden_xoblog.lua"
    }
}

-- Cache untuk menghindari redundant operations
local cache = {
    loaded = false,
    placeId = game.PlaceId
}

-- Optimized HTTP Request dengan timeout
local function safeHttpGet(url)
    local success, result = pcall(function()
        return game:HttpGet(url, true)
    end)
    return success and result or nil
end

-- Unified Load Function
local function loadScript(scriptUrl, scriptName)
    if cache.loaded then return false end

    local content = safeHttpGet(scriptUrl)
    if not content then return false end

    local success, err = pcall(loadstring(content))
    if success then
        cache.loaded = true
        print("✅ " .. (scriptName or "Script") .. " Loaded!")
        return true
    else
        warn("❌ Load Error: " .. tostring(err))
        return false
    end
end

-- Minimal GUI System
local function createLoaderUI(gameName)
    local gui = Instance.new("ScreenGui")
    gui.Name = "QuickLoader"
    gui.Parent = game.CoreGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 250, 0, 80)
    frame.Position = UDim2.new(0.5, -125, 0.5, -40)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    frame.Parent = gui

    local title = Instance.new("TextLabel")
    title.Text = gameName and "🎮 " .. gameName or "🌐 Universal"
    title.Size = UDim2.new(1, 0, 0, 25)
    title.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 14
    title.Font = Enum.Font.Gotham
    title.Parent = frame

    local status = Instance.new("TextLabel")
    status.Text = "Loading..."
    status.Size = UDim2.new(1, 0, 0, 30)
    status.Position = UDim2.new(0, 0, 0.4, 0)
    status.BackgroundTransparency = 1
    status.TextColor3 = Color3.fromRGB(200, 200, 200)
    status.TextSize = 12
    status.Parent = frame

    return gui, status
end

-- Main Execution Flow
local function executeLoader()
    local currentGame = GameConfigs[cache.placeId]
    local loaderUI, statusLabel = createLoaderUI(currentGame and currentGame.name)

    -- Priority: Game-specific → Universal fallback
    local loadSuccess = false

    if currentGame then
        statusLabel.Text = "Loading " .. currentGame.name
        loadSuccess = loadScript(currentGame.script, currentGame.name)
    end

    if not loadSuccess then
        statusLabel.Text = "retry inject again"
    end

    -- Auto-close setelah delay singkat
    delay(3, function()
        if loaderUI and loaderUI.Parent then
            loaderUI:Destroy()
        end
    end)
end

-- Protected Execution
if not cache.loaded then
    local success, err = pcall(executeLoader)
    if not success then
        warn("Loader Critical Error: " .. tostring(err))
    end
end
