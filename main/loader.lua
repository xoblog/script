getgenv().MultiLoader = true

local GameConfigs = {
    [6701277882] = {  -- GameId Fish It
        name = "Fish It", 
        script = "https://raw.githubusercontent.com/xoblog/script/refs/heads/main/main/fish-it.lua"
    },
    [7436755782] = {  -- GameId Grow A Garden
        name = "Grow A Garden",
        script = "https://raw.githubusercontent.com/xoblog/script/refs/heads/main/main/grow_a_garden.lua"
    }
}

local cache = {
    loaded = false,
    gameId = game.GameId  -- Ganti ke GameId
}

local function safeHttpGet(url)
    local success, result = pcall(function()
        return game:HttpGet(url, true)
    end)
    return success and result or nil
end

local function loadScript(scriptUrl, scriptName)
    if cache.loaded then return false end

    local content = safeHttpGet(scriptUrl)
    if not content then return false end

    local success, err = pcall(loadstring(content))
    if success then
        cache.loaded = true
        return true
    else
        return false
    end
end

local function executeLoader()
    local currentGame = GameConfigs[cache.gameId]  -- Pakai gameId
    local loadSuccess = false

    if currentGame then
        print("Loading: " .. currentGame.name)
        loadSuccess = loadScript(currentGame.script, currentGame.name)
    else
        print("No script for GameId: " .. cache.gameId)
    end

    return loadSuccess
end

if not cache.loaded then
    local success, err = pcall(executeLoader)
    if not success then
        print("Loader error: " .. tostring(err))
    end
end