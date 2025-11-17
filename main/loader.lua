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

local placeId = game.PlaceId
local currentGame = GameConfigs[placeId]

print("Starting MultiLoader...")

if currentGame then
    print("Detected game: " .. currentGame.name)
    print("Loading: " .. currentGame.name)
    
    local success, content = pcall(function()
        return game:HttpGet(currentGame.script)
    end)
    
    if success and content and content ~= "" then
        local loadSuccess, err = pcall(loadstring(content))
        if loadSuccess then
            print("✓ MultiLoader execution completed")
        else
            print("✗ Script error: " .. tostring(err))
        end
    else
        print("✗ Failed to fetch: " .. currentGame.script)
        print("✗ No content received for: " .. currentGame.name)
    end
else
    print("No script available for this game: " .. placeId)
end

print("-- MultiLoader execution completed")