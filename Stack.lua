--- STEAMODDED HEADER
--- MOD_NAME: Better Stack
--- MOD_ID: BetterStack
--- MOD_AUTHOR: [WilsontheWolf]
--- MOD_DESCRIPTION: Output more useful stack traces when the game crashes.

----------------------------------------------
------------MOD CODE -------------------------

local STP
local STP_ERR

function SMODS.INIT.BetterStack()
    local mod = SMODS.findModByID("BetterStack")
	local file, err = love.filesystem.read(mod.path .. "StackTracePlus.lua")
	if not file then
		print("[BetterStack] Could not find StackTracePlus. Did you install the mod correctly?")
		print(err)
		STP_ERR = "Could not find StackTracePlus. Did you install the mod correctly? Error:".."\n"..err;
		return
	end
    local func, err = load(file)
    if func then 
	    local ok, S = pcall(func)
	      if ok then
	        STP = S
			debug.traceback = STP.stacktrace
	      else
	        print("[BetterStack] StackTracePlus Execution error:", add)
	        STP_ERR = "StackTracePlus Execution error\n" .. err
        end
    end
    if err then 
    	print("[BetterStack] Could not load StackTracePlus", err)
    	STP_ERR = "Could not load StackTracePlus\n" .. err
   	end
end

local crashHandler = love.errhand;
function love.errhand(msg)
	print(msg..(STP and STP.stacktrace() or ""))
	if STP_ERR then 
		msg = "An Error Occured and Better Stack could not be loaded. Details:\n" .. STP_ERR .. "\n\nOriginal Error:\n" .. msg
	elseif not STP then
		msg = "An Unkown Error Occured and Better Stack could not be loaded.\n\nOriginal Error:\n" .. msg
	elseif _RELEASE_MODE then
		msg = msg.."\n"..STP.stacktrace() -- The game shows the stack for me if release mode is false
	end
	return crashHandler(msg)
end


----------------------------------------------
------------MOD CODE END----------------------
