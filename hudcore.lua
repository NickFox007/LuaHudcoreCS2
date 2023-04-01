require "libs.timers"

--[[

function _GetPlayerInst(client)
	return PlayerInstanceFromIndex(Entities:FindAllByClassname("cs_player_controller")[tonumber(client)]:GetEntityIndex())
end


function HC_ShowPanelStatus(client, text, duration)
	local netTable = {}
	netTable["player_controller_and_pawn"] = Entities:FindAllByClassname("cs_player_controller")[tonumber(client)]:GetPawn()			
	netTable["loc_token"] = text
	netTable["duration"] = duration
	FireGameEvent( "show_survival_respawn_status", netTable )
end

--]]  -- It doesn't work in CS2 now


function HC_ReplaceColorCodes(text)
	text = string.gsub(text, "{white}", "\x01")
	text = string.gsub(text, "{darkred}", "\x02")
	text = string.gsub(text, "{purple}", "\x03")
	text = string.gsub(text, "{darkgreen}", "\x04")
	text = string.gsub(text, "{lightgreen}", "\x05")
	text = string.gsub(text, "{green}", "\x06")
	text = string.gsub(text, "{red}", "\x07")
	text = string.gsub(text, "{lightgray}", "\x08")
	text = string.gsub(text, "{yellow}", "\x09")
	text = string.gsub(text, "{orange}", "\x10")
	text = string.gsub(text, "{darkgray}", "\x0A")
	text = string.gsub(text, "{blue}", "\x0B")
	text = string.gsub(text, "{darkblue}", "\x0C")
	text = string.gsub(text, "{gray}", "\x0D")
	text = string.gsub(text, "{darkpurple}", "\x0E")
	text = string.gsub(text, "{lightred}", "\x0F")
	return text
end

--[[
function HC_TestColorCodes()
	HC_PrintChatAll("{white}white{red}red{darkpurple}darkpurple{green}green{lightgreen}lightgreen{darkgreen}darkgreen{darkred}darkred\n {gray}gray{yellow}yellow{orange}orange{lightgray}lightgray{blue}blue\n {darkblue}darkblue{darkgray}darkgray{purple}purple{lightred}lightred")
end
--]]

function HC_PrintCenterTextAll(text)
	ScriptPrintMessageCenterAll(text)
end

function HC_PrintChatAll(text)		
	ScriptPrintMessageChatAll(" " .. HC_ReplaceColorCodes(text))
end

function HC_ShowPanelInfo(text, duration)
	local netTable = {}	
	netTable["funfact_token"] = text
	
	FireGameEvent( "cs_win_panel_round", netTable )
	
	Timers:CreateTimer({
		endTime = duration,
		callback = function()
			HC_ResetPanelInfo()    
		end
	})
end

function HC_ResetPanelInfo()	
	FireGameEvent( "round_start", nil )
end


function HC_ShowInstructorHint(text, duration, icon)
	
	local targetname = UniqueString("instructor")
	local instr_ent = SpawnEntityFromTableSynchronous("env_instructor_hint",{
		targetname = targetname,
        hint_caption = text,
        hint_timeout = duration,
		hint_icon_onscreen = icon
    })
	
	DoEntFire("!self","ShowHint",targetname,0,nil,instr_ent);
	
	Timers:CreateTimer({
		endTime = duration,
		callback = function()
			UTIL_Remove(instr_ent)    
		end
	})
		
end
