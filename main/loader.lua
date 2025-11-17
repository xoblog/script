getgenv().MultiLoader = true

local GameConfigs = {
    [121864768012064] = { 
        name = "Fish It",
        script = "https://raw.githubusercontent.com/xoblog/script/refs/heads/main/main/fish_it.lua"
    },
    [126884695634066] = {
        name = "Grow A Garden", 
        script = "https://raw.githubusercontent.com/xoblog/script/refs/heads/main/main/grow_a_garden.lua"
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
    if success then
        print("✅ Successfully fetched: " .. url)
        return result
    else
        warn("❌ Failed to fetch: " .. url)
        return nil
    end
end

local function loadScript(scriptUrl, scriptName)
    if cache.loaded then 
        print("⚠️ Script already loaded, skipping...")
        return false 
    end

    print("📥 Loading: " .. scriptName)
    local content = safeHttpGet(scriptUrl)
    if not content then 
        warn("❌ No content received for: " .. scriptName)
        return false 
    end

    local success, err = pcall(loadstring(content))
    if success then
        print("✅ Successfully loaded: " .. scriptName)
        cache.loaded = true
        return true
    else
        warn("❌ Failed to load script " .. scriptName .. ": " .. tostring(err))
        return false
    end
end

local function executeLoader()
    local currentGame = GameConfigs[cache.placeId]
    
    if not currentGame then
        print("❌ No script configured for PlaceId: " .. cache.placeId)
        return false
    end

    print("🎮 Detected game: " .. currentGame.name)
    return loadScript(currentGame.script, currentGame.name)
end

-- Main execution
if not cache.loaded then
    print("🚀 Starting MultiLoader...")
    local success, err = pcall(executeLoader)
    
    if success then
        print("🎉 MultiLoader execution completed")
    else
        warn("💥 MultiLoader error: " .. tostring(err))
    end
else
    print("✅ MultiLoader already executed")
end