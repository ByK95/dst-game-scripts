local require = GLOBAL.require


require "constants"
-- local brain = require("brains/testdragonflybrain")

modimport "main/treasurehunt"

PrefabFiles = {
	"icerocky",
    "slotmachine",
    "dubloon"
}

Assets = {
    Asset("ATLAS", "images/inventoryimages/dubloon.xml"),
    Asset("IMAGE", "images/inventoryimages/dubloon.tex"),
}

local function prettyPrint(tbl, indent)
    if indent == nil then
        indent = ""
    end

    local tableStack = {}

    local function helper(t, indent)
        if type(t) ~= "table" then
            return
        end

        for _,v in pairs(tableStack) do
            if v == t then
                print(indent .. "Circular reference detected")
                return
            end
        end

        table.insert(tableStack, t)

        for k,v in pairs(t) do
            if type(v) == "table" then
                print(indent .. tostring(k) .. " : {")
                helper(v, indent .. "  ")
                print(indent .. "}")
            else
                print(indent .. tostring(k) .. " : " .. tostring(v))
            end
        end

        table.remove(tableStack)
    end

    helper(tbl, indent)
end

-- ice_rocky = require("prefabs/ice_rocky")

-- Use the function to pretty print the GLOBAL table
-- prettyPrint(GLOBAL, "")

-- local function DragonflyPostInit(inst)
--     inst:SetStateGraph("testdragonfly")
--     inst:SetBrain(brain)
--     print("Override is happened 2.")
-- end

-- AddPrefabPostInit("dragonfly", DragonflyPostInit)