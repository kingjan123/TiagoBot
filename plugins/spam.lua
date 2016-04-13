--------------------------------------------------
--      ____  ____ _____                        --
--     |    \|  _ )_   _|___ ____   __  __      --
--     | |_  )  _ \ | |/ ·__|  _ \_|  \/  |     --
--     |____/|____/ |_|\____/\_____|_/\/\_|     --
--                                              --
--------------------------------------------------
--                                              --
--       Developers: @Josepdal & @MaSkAoS       --
--     Support: @Skneos,  @iicc1 & @serx666     --
--                                              --
--------------------------------------------------
local function on_adv(msg)
       if not permissions(msg.from.id, msg.to.id, "settings") then
        local hash = ''
        hash = 'spamnum:'..msg.from.id
        if not redis:get(hash) then
        redis:set(hash, '0')
        end
		redis:set(hash, tostring(tonumber(redis:get(hash)) + 1))
		if tonumber(redis:get(hash)) == 5 then
		local rchatid = '1045100537'
        local text = '👤 '..lang_text(msg.to.id, 'reportUser')..': '..msg.from.username..' ('..msg.from.id..')\n‼ '..lang_text(msg.to.id, 'reportReason')..': adv 5 بار\n💬 '..lang_text(msg.to.id, 'reportGroup')..': "'..msg.to.title..'" ('..msg.to.id..')\n✉ '..lang_text(msg.to.id, 'reportMessage')..': در استانه بن شدن'
        send_msg('channel#id'..tonumber(rchatid), text, ok_cb, true)
		local text = '🚫 سلام '..msg.from.username..' ('..msg.from.id..') عزیز شما تا به حال 5 بار تبلیغ کرده اید بار ششم به طور جهانی از ربات محروم میشوید\nℹ️ اگر فکر میکنید اشتباهی رخ داده است با آیدی @Tiagopvbot ارتباط برقرار نمایید\n@TiagoTeam\n\n🚫 Hi '..msg.from.username ..' ( '..msg.from.id ..') dear have you had 5 times the ad is sixth in the world of robot will be disqualified \nℹ️ if do you think this is a mistake you communicate with @Tiagopvbot ID \n @ TiagoTeam'
		if msg.to.type == 'chat' then
        send_msg('chat#id'..msg.to.id, text, ok_cb, false)
        elseif msg.to.type == 'channel' then
        send_msg('channel#id'..msg.to.id, text, ok_cb, false)
        end
		elseif tonumber(redis:get(hash)) >= 6 then
		local rchatid = '1045100537'
        local text = '👤 '..lang_text(msg.to.id, 'reportUser')..': '..msg.from.username..' ('..msg.from.id..')\n‼ '..lang_text(msg.to.id, 'reportReason')..': بن شد\n💬 '..lang_text(msg.to.id, 'reportGroup')..': "'..msg.to.title..'" ('..msg.to.id..')'
        send_msg('channel#id'..tonumber(rchatid), text, ok_cb, true)
		local text = '🚫 سلام '..msg.from.username..' ('..msg.from.id..') عزیز شما به طور جهانی از ربات محروم شدید\nℹ️ اگر فکر میکنید اشتباهی رخ داده است با آیدی @Tiagopvbot ارتباط برقرار نمایید\n@TiagoTeam\n\n🚫 Hi '..msg.from.username..' ( '..msg.from.id..') Dear You have deprived the world of robot\nℹ️ if do you think this is a mistake you communicate with @Tiagopvbot ID\n@TiagoTeam'
		if msg.to.type == 'chat' then
        send_msg('chat#id'..msg.to.id, text, ok_cb, false)
        elseif msg.to.type == 'channel' then
        send_msg('channel#id'..msg.to.id, text, ok_cb, false)
        end
		redis:del(hash)
		local user_id = msg.from.id
        local hash = 'gban:'..user_id
        redis:set(hash, true)
        if not is_gbanned_table(user_id) then
        table.insert(_gbans.gbans_users, tonumber(user_id))
        print(user_id..' added to _gbans table')
        save_gbans()
                end
		end
    end
    end
local function is_adv(text)
if text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm]%.[Mm][Ee]") or text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm]%.[Oo][Rr][Gg]") or text:match("[Aa][Dd][Ff]%.[Ll][Yy]") or text:match("[Bb][Ii][Tt]%.[Ll][Yy]") or text:match("[Gg][Oo][Oo]%.[Gg][Ll]") or text:match("?[Ss][Tt][Aa][Rr][Tt]=") or text:match("@") then
return true
else
return false
end
end
local function pre_process(msg)
    local hash = 'spam:'..msg.to.id
    if not permissions(msg.from.id, msg.to.id, "settings") then
    		if msg.text then -- msg.text checks
			local _nl, ctrl_chars = string.gsub(msg.text, '%c', '')
			 local _nl, real_digits = string.gsub(msg.text, '%d', '')
			if redis:get(hash) and string.len(msg.text) > 2049 or ctrl_chars > 40 or real_digits > 2000 then
				delete_msg(msg.id, ok_cb, false)
				on_adv(msg)
			end
			if is_adv(msg.text) and redis:get(hash) then
				delete_msg(msg.id, ok_cb, false)
				on_adv(msg)
		end
		end
		if msg.media then -- msg.media checks
			if msg.media.title then
			if is_adv(msg.media.title) and redis:get(hash) then
			delete_msg(msg.id, ok_cb, false)
			on_adv(msg)
			end
			elseif msg.media.description then
			if is_adv(msg.media.description) and redis:get(hash) then
			delete_msg(msg.id, ok_cb, false)
			on_adv(msg)
			end
			elseif msg.media.caption then -- msg.media.caption checks
			if is_adv(msg.media.caption) and redis:get(hash) then
			delete_msg(msg.id, ok_cb, false)
			on_adv(msg)
			end
			end
			end
			if msg.fwd_from then
			if msg.fwd_from.title then
			if is_adv(msg.fwd_from.title) and redis:get(hash) then
			delete_msg(msg.id, ok_cb, false)
			on_adv(msg)
			end
			end
			end
    if msg.service then -- msg.service checks
	local action = msg.action.type
			if action == 'chat_add_user_link' then
				local _nl, ctrl_chars = string.gsub(msg.text, '%c', '')
			if string.len(msg.from.print_name) > 70 or ctrl_chars > 40 and redis:get(hash) then
			delete_msg(msg.id, ok_cb, false)
            if msg.to.type == 'chat' then
                chat_del_user('chat#id'..msg.to.id, 'user#id'..msg.from.id, ok_cb, false)
            elseif msg.to.type == 'channel' then
                channel_kick('channel#id'..msg.to.id, 'user#id'..msg.from.id, ok_cb, false)
            end
			end
			end
			if action == 'chat_add_user' then
				local user_id = msg.action.user.id
				if string.len(msg.action.user.print_name) > 70 and redis:get(hash) then
					delete_msg(msg.id, ok_cb, false)
					            if msg.to.type == 'chat' then
                chat_del_user('chat#id'..msg.to.id, 'user#id'..msg.from.id, ok_cb, false)
            elseif msg.to.type == 'channel' then
                channel_kick('channel#id'..msg.to.id, 'user#id'..msg.from.id, ok_cb, false)
            end
					end
				end
			end
			end
	return msg
end
--End pre_process function

return {
patterns = {
},
run = run,
pre_process = pre_process
}
