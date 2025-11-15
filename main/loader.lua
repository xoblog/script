getgenv().MultiLoader = true

local GameConfigs = {
    [121864768012064] = { 
        name = "Fish It",
        script = "https://raw.githubusercontent.com/xoblog/best/refs/heads/main/fishit_xoblog.lua"
    },
    [126884695634066] = {
        name = "Grow A Garden",
        script = "https://raw.githubusercontent.com/xoblog/best/refs/heads/main/grow_a_garden_xoblog.lua"
    }
}

local cache = {
    loaded = false,
    placeId = game.PlaceId
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
    local currentGame = GameConfigs[cache.placeId]
    local loadSuccess = false

    if currentGame then
        loadSuccess = loadScript(currentGame.script, currentGame.name)
    end

    return loadSuccess
end

if not cache.loaded then
    local success, err = pcall(executeLoader)
    if not success then
    end
end