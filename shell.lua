TheSim = {
    -- Define any methods or properties that are accessed in main.lua
    ShouldInitDebugger = function() 
        return false
    end,
    SetReverbPreset = function()
    end
    -- ... (define other methods or properties as needed)
}

kleiloadlua = function(...)
end

MODS_ROOT = ""

dofile("scripts/main.lua")
-- Load your custom script
dofile("_scripts/ice_rocky.lua")
