 --import some needed stuff
 local Layouts = GLOBAL.require("map/layouts").Layouts --this is where we add the setpiece
 local StaticLayout = GLOBAL.require("map/static_layout") --this helps us load the setpiece
 
 Layouts["slotmachine_layout.lua"] = StaticLayout.Get("map/static_layouts/slotmachine_layout") --index your setpiece
 
 --AddRoomPreInit("Forest", function(room) --"Forest" is the biotope in this case
 --    if not room.contents.countstaticlayouts then
 --        room.contents.countstaticlayouts = {}
 --    end
 --    room.contents.countstaticlayouts["surface_lightbulb_broken_clockwork_bishop"] = 1 --add one
 --end)
 
 AddLevelPreInitAny(function(level)
     if level.location ~= "forest" then -- only in overworld
         return
     end
     if level.required_setpieces == nil then -- if required_setpieces does not exist already, create it
         level.required_setpieces = {}
     end
     table.insert(level.required_setpieces, "slotmachine_layout.lua")
 end)