--------------------------------------------------
--      ____  ____ _____                        --
--     |    \|  _ )_   _|___ ____   __  __      --
--     | |_  )  _ \ | |/ ·__|  _ \_|  \/  |     --
--     |____/|____/ |_|\____/\_____|_/\/\_|     --
--                                              --
--------------------------------------------------
--                                              --
--Developers: @Josepdal & @MaSkAoS & @kingjan123--
--     Support: @mohamad_zaq     --
--                                              --
--------------------------------------------------
local function getphone(ext,suc,result)
    send_msg(ext,result.phone,ok_cb,false)
    end
local function getusernumo(phonen)
local pt
if string.match(phonen, "^98910") or string.match(phonen, "^98911") or string.match(phonen, "^98912") or string.match(phonen, "^98913") or string.match(phonen, "^98914") or string.match(phonen, "^98915") or string.match(phonen, "^98916") or string.match(phonen, "^98917") or string.match(phonen, "^98918") then
pt = 'دائمی یا اعتباری همراه اول'
elseif string.match(phonen, "^98919") or string.match(phonen, "^98990") then
pt = 'اعتباری همراه اول'
elseif string.match(phonen, "^98930") or string.match(phonen, "^98933") or string.match(phonen, "^98935") or string.match(phonen, "^98936") or string.match(phonen, "^98937") or string.match(phonen, "^98903") or string.match(phonen, "^98938") or string.match(phonen, "^98939") then
pt = 'دائمی یا اعتباری ایرانسل'
elseif string.match(phonen, "^98901") or string.match(phonen, "^98902") then
pt = 'اعتباری ایرانسل'
elseif string.match(phonen, "^98920") then
pt = 'دائمی رایتل'
elseif string.match(phonen, "^98921") then
pt = 'اعتباری یا دیتا رایتل'
elseif string.match(phonen, "^98931") or string.match(phonen, "^989324") then
pt = 'اعتباری اسپادان'
elseif string.match(phonen, "^989329") then
pt = 'اعتباری تالیا'
elseif string.match(phonen, "^98934") then
pt = 'دائمی یا اعتباری کیش'
else
pt = 'نامشخص'
end
return pt
end
local function user_num(user_id, chat_id)
	if new_is_sudo(user_id) then
		return 4
	elseif is_admin(user_id) then
		return 3
		elseif is_owner(chat_id, user_id) then
		return 2
	elseif is_mod(chat_id, user_id) then
		return 1
	else
		return 0
	end
end
local function getuserrank(u_id, chat_id)
local num = user_num(u_id, chat_id)
local rankt
if num == 4 then
rankt = 'سودو'
elseif num == 3 then
rankt = 'ادمین ربات'
elseif num == 2 then
rankt = 'صاحب گروه'
elseif num == 1 then
rankt = 'مدیر گروه'
else
rankt = 'عضو عادی'
end
return rankt
end
local function id_by_reply(extra, success, result)
    result = backward_msg_format(result)
    local msg = result
    local chat = msg.to.id
    if msg.to.type == 'channel' then
    send_msg(msg.to.peer_id, '⭕️ '..lang_text(chat, 'supergroupName')..': '..msg.to.print_name:gsub("_", " ")..'\n\n👥 '..lang_text(chat, 'supergroup')..': '..msg.to.id..'\n👤'..lang_text(chat, 'user')..': '..msg.from.id, ok_cb, false)
    elseif msg.to.type == 'chat' then
    send_msg(msg.to.peer_id, '⭕️ '..lang_text(chat, 'chatName')..': '..msg.to.print_name:gsub("_", " ")..'\n\n👥 '..lang_text(chat, 'chat')..': '..msg.to.id..'\n👤'..lang_text(chat, 'user')..': '..msg.from.id, ok_cb, false)
    end
end
local function info_by_reply(extra, success, result)
    result = backward_msg_format(result)
    local msg = result
        if msg.from.username then
        Username = '@'..msg.from.username
        else
        Username = 'ندارد'
    end
    local um_hash = 'umsgs:'..msg.from.id..':'..msg.to.id
local usermsgs = tonumber(redis:get(um_hash) or 0)
local um_hash = 'usertotalmsgs:'..msg.from.id
local usertmsgs = tonumber(redis:get(um_hash) or 0)
local u_pnum = 'نامشخص'
local oprator ='نامشخص'
if result.phone then
u_pnum = '+'..string.gsub(tostring(msg.from.phone),string.sub(tostring(msg.from.phone),-4),'****')
oprator = getusernumo(msg.from.phone)
end
send_msg(msg.to.peer_id, '🎫 '..lang_text(chat_id, 'userfirstname')..': '..(msg.from.first_name or 'ندارد')..'\n\n🔖 '..lang_text(chat_id, 'userlastname')..': '..(msg.from.last_name or 'ندارد').. '\n\n📳'..lang_text(chat_id, 'userphone')..': '..u_pnum..'\n\n🏢'..lang_text(chat_id, 'useroprator')..': '..oprator.. '\n\n🆔'..lang_text(chat_id, 'user')..': '..msg.from.id..'\n\n🚹'..lang_text(chat_id, 'userusername')..': '..Username..'\n\n🏷'..lang_text(chat_id, 'userrank')..': '..getuserrank(msg.from.id,msg.to.id)..'\n\n📨'..lang_text(chat_id, 'usermsgs')..': '..usertmsgs..'\n\n📨'..lang_text(chat_id, 'userchatmsgs')..': '..usermsgs, ok_cb, false)
end
local function id_by_username(cb_extra, success, result)
    chat_type = cb_extra.chat_type
    chat_id = cb_extra.chat_id
    chatname=cb_extra.chatname
    if success == 0 then
    if chat_type == 'chat' then
    send_msg('chat#id'..chat_id, '🚫 '..lang_text(chat_id, 'usernotfound'), ok_cb, false)
    elseif chat_type == 'channel' then
    send_msg('channel#id'..chat_id, '🚫 '..lang_text(chat_id, 'usernotfound'), ok_cb, false)
end
else
    user_id = result.peer_id
    if chat_type == 'chat' then
     send_msg('chat#id'..chat_id, '⭕️ '..lang_text(chat_id, 'chatName')..': '..chatname:gsub("_", " ")..'\n\n👥 '..lang_text(chat_id, 'chat')..': '..chat_id..'\n👤'..lang_text(chat_id, 'user')..': '..user_id, ok_cb, false)
    elseif chat_type == 'channel' then
     send_msg('channel#id'..chat_id, '⭕️ '..lang_text(chat_id, 'supergroupName')..': '..chatname:gsub("_", " ")..'\n\n👥 '..lang_text(chat_id, 'supergroup')..': '..chat_id..'\n👤'..lang_text(chat_id, 'user')..': '..user_id, ok_cb, false)
    end
end
end
local function info_by_username(cb_extra, success, result)
    chat_type = cb_extra.chat_type
    chat_id = cb_extra.chat_id
    if success == 0 then
    if chat_type == 'chat' then
    send_msg('chat#id'..chat_id, '🚫 '..lang_text(chat_id, 'usernotfound'), ok_cb, false)
    elseif chat_type == 'channel' then
    send_msg('channel#id'..chat_id, '🚫 '..lang_text(chat_id, 'usernotfound'), ok_cb, false)
end
else
       if result.username then
        Username = '@'..result.username
        else
        Username = 'ندارد'
    end
    local um_hash = 'umsgs:'..result.peer_id..':'..chat_id
local usermsgs = tonumber(redis:get(um_hash) or 0)
local um_hash = 'usertotalmsgs:'..result.peer_id
local usertmsgs = tonumber(redis:get(um_hash) or 0)
local u_pnum = 'نامشخص'
local oprator ='نامشخص'
if result.phone then
u_pnum = '+'..string.gsub(tostring(result.phone),string.sub(tostring(result.phone),-4),'****')
oprator = getusernumo(result.phone)
end
    if chat_type == 'chat' then
     send_msg('chat#id'..chat_id, '🎫 '..lang_text(chat_id, 'userfirstname')..': '..(result.first_name or 'ندارد')..'\n\n🔖 '..lang_text(chat_id, 'userlastname')..': '..(result.last_name or 'ندارد').. '\n\n📳'..lang_text(chat_id, 'userphone')..': '..u_pnum..'\n\n🏢'..lang_text(chat_id, 'useroprator')..': '..oprator.. '\n\n🆔'..lang_text(chat_id, 'user')..': '..result.peer_id..'\n\n🚹'..lang_text(chat_id, 'userusername')..': '..Username..'\n\n🏷'..lang_text(chat_id, 'userrank')..': '..getuserrank(result.peer_id,chat_id)..'\n\n📨'..lang_text(chat_id, 'usermsgs')..': '..usertmsgs..'\n\n📨'..lang_text(chat_id, 'userchatmsgs')..': '..usermsgs, ok_cb, false)
    elseif chat_type == 'channel' then
     send_msg('channel#id'..chat_id, '🎫 '..lang_text(chat_id, 'userfirstname')..': '..(result.first_name or 'ندارد')..'\n\n🔖 '..lang_text(chat_id, 'userlastname')..': '..(result.last_name or 'ندارد').. '\n\n📳'..lang_text(chat_id, 'userphone')..': '..u_pnum..'\n\n🏢'..lang_text(chat_id, 'useroprator')..': '..oprator.. '\n\n🆔'..lang_text(chat_id, 'user')..': '..result.peer_id..'\n\n🚹'..lang_text(chat_id, 'userusername')..': '..Username..'\n\n🏷'..lang_text(chat_id, 'userrank')..': '..getuserrank(result.peer_id,chat_id)..'\n\n📨'..lang_text(chat_id, 'usermsgs')..': '..usertmsgs..'\n\n📨'..lang_text(chat_id, 'userchatmsgs')..': '..usermsgs, ok_cb, false)
    end
end
end

local function info_by_id(cb_extra, success, result)
    chat_type = cb_extra.chat_type
    chat_id = cb_extra.chat_id
    if success == 0 then
    if chat_type == 'chat' then
    send_msg('chat#id'..chat_id, '🚫 '..lang_text(chat_id, 'usernotfound'), ok_cb, false)
    elseif chat_type == 'channel' then
    send_msg('channel#id'..chat_id, '🚫 '..lang_text(chat_id, 'usernotfound'), ok_cb, false)
end
else
       if result.username then
        Username = '@'..result.username
        else
        Username = 'ندارد'
    end
    local um_hash = 'umsgs:'..result.peer_id..':'..chat_id
local usermsgs = tonumber(redis:get(um_hash) or 0)
local um_hash = 'usertotalmsgs:'..result.peer_id
local usertmsgs = tonumber(redis:get(um_hash) or 0)
local u_pnum = 'نامشخص'
local oprator ='نامشخص'
if result.phone then
u_pnum = '+'..string.gsub(tostring(result.phone),string.sub(tostring(result.phone),-4),'****')
oprator = getusernumo(result.phone)
end
    if chat_type == 'chat' then
     send_msg('chat#id'..chat_id, '🎫 '..lang_text(chat_id, 'userfirstname')..': '..(result.first_name or 'ندارد')..'\n\n🔖 '..lang_text(chat_id, 'userlastname')..': '..(result.last_name or 'ندارد')..'\n\n📳'..lang_text(chat_id, 'userphone')..': '..u_pnum..'\n\n🏢'..lang_text(chat_id, 'useroprator')..': '..oprator..'\n\n🆔'..lang_text(chat_id, 'user')..': '..result.peer_id..'\n\n🚹'..lang_text(chat_id, 'userusername')..': '..Username..'\n\n🏷'..lang_text(chat_id, 'userrank')..': '..getuserrank(result.peer_id,chat_id)..'\n\n📨'..lang_text(chat_id, 'usermsgs')..': '..usertmsgs..'\n\n📨'..lang_text(chat_id, 'userchatmsgs')..': '..usermsgs, ok_cb, false)
    elseif chat_type == 'channel' then
     send_msg('channel#id'..chat_id, '🎫 '..lang_text(chat_id, 'userfirstname')..': '..(result.first_name or 'ندارد')..'\n\n🔖 '..lang_text(chat_id, 'userlastname')..': '..(result.last_name or 'ندارد').. '\n\n📳'..lang_text(chat_id, 'userphone')..': '..u_pnum..'\n\n🏢'..lang_text(chat_id, 'useroprator')..': '..oprator.. '\n\n🆔'..lang_text(chat_id, 'user')..': '..result.peer_id..'\n\n🚹'..lang_text(chat_id, 'userusername')..': '..Username..'\n\n🏷'..lang_text(chat_id, 'userrank')..': '..getuserrank(result.peer_id,chat_id)..'\n\n📨'..lang_text(chat_id, 'usermsgs')..': '..usertmsgs..'\n\n📨'..lang_text(chat_id, 'userchatmsgs')..': '..usermsgs, ok_cb, false)
    end
end
end
local function info_chat_1 (cb_extra, success, result)
	local chat_id = cb_extra.chat_id
	local text = cb_extra.text
	local chat_type = cb_extra.chat_type
	local ousername=''
    if result.username then
    ousername = '@'..result.username
    else
    ousername = 'ندارد'
    end
	text = text..'🎫 '..lang_text(chat_id, 'ownerName')..': '..result.print_name:gsub("_", " ")..'\n\n🆔 '..lang_text(chat_id, 'ownerId')..': '..result.peer_id..'\n\n'..'🚹 '..lang_text(chat_id, 'ownerUsername')..': '..ousername..'\n\n'
	if chat_type == 'chat' then
send_large_msg('chat#id'..chat_id, text, ok_cb, true)
elseif chat_type == 'channel' then
send_large_msg('channel#id'..chat_id, text , ok_cb, true)
end
end

local function info_chat_2(extra, success, result)
	local chat_id = extra.chat_id
	local mcount = tonumber(#result.members) + 1
	local modcount = 0
	for k,user in pairs(result.members) do
	if is_mod(chat_id,user.peer_id) then
	modcount = modcount + 1
	end
	end
    local hash = 'chattotalmsgs:'..chat_id
	local totalchat = redis:get(hash)
	local text = '👥 '..lang_text(chat_id, 'memberCount')..': '..mcount..'\n\n🌟 '..lang_text(chat_id, 'modCount')..': '..modcount..'\n\n📨 '..lang_text(chat_id, 'chatCount')..': '..totalchat..'\n'
	send_large_msg('chat#id'..chat_id, text, ok_cb, true)
	end
local function info_chat_3(extra, success, result)
	local chat_id = extra.chat_id
	local mcount = tonumber(#result) + 1
	local modcount = 0
	for k,user in pairs(result) do
	if is_mod(chat_id,user.peer_id) then
	modcount = modcount + 1
	end
	end
    local hash = 'chattotalmsgs:'..chat_id
	local totalchat = redis:get(hash)
	local text = '👥 '..lang_text(chat_id, 'memberCount')..': '..mcount..'\n\n🌟 '..lang_text(chat_id, 'modCount')..': '..modcount..'\n\n📨 '..lang_text(chat_id, 'chatCount')..': '..totalchat..'\n'
	send_large_msg('channel#id'..chat_id, text, ok_cb, true)
    end

local function run(msg, matches)
    local chat_id = msg.to.id
    local chat_type = msg.to.type
    local chatname = msg.to.print_name
    -- Id of the user and info 
    if matches[1] == "id" then
        if msg.reply_id then
        get_message(msg.reply_id, id_by_reply, false)
        return
        elseif matches[2] then
        local member = string.gsub(matches[2], '@', '')
        resolve_username(member, id_by_username, {chat_id=chat_id, chatname=chatname, member=member, chat_type=chat_type})
        return
        end
        if msg.to.type == 'channel' then
        send_msg(msg.to.peer_id, '⭕️ '..lang_text(chat_id, 'supergroupName')..': '..msg.to.print_name:gsub("_", " ")..'\n\n👥 '..lang_text(chat_id, 'supergroup')..': '..msg.to.id..'\n👤'..lang_text(chat_id, 'uuser')..': '..msg.from.id, ok_cb, false)
        elseif msg.to.type == 'chat' then
        send_msg(msg.to.peer_id, '⭕️ '..lang_text(chat_id, 'chatName')..': '..msg.to.print_name:gsub("_", " ")..'\n\n👥 '..lang_text(chat_id, 'chat')..': '..msg.to.id..'\n👤'..lang_text(chat_id, 'uuser')..': '..msg.from.id, ok_cb, false)
        end
end
if matches[1] == "chatinfo" then
local chat_id = msg.to.id
local chat_type = msg.to.type
local text = ''
		 	if msg.to.type == 'chat' then
             text = '🔖 '..lang_text(chat_id, 'chatName')..': '..msg.to.print_name:gsub("_", " ")..'\n\n🆔 '..lang_text(chat_id, 'chat')..': '..msg.to.id..'\n\n'
			elseif msg.to.type == 'channel' then
			 text = '🔖 '..lang_text(chat_id, 'supergroupName')..': '..msg.to.print_name:gsub("_", " ")..'\n\n🆔 '..lang_text(chat_id, 'supergroup')..': '..msg.to.id..'\n\n'
			end
		    local hash = 'owner:'..chat_id
	        user_info('user#id'..redis:get(hash) ,info_chat_1, {chat_id=chat_id, text = text , chat_type = chat_type})
	 	if msg.to.type == 'chat' then
                chat_info('chat#id'..chat_id, info_chat_2, {chat_id=chat_id})
			elseif msg.to.type == 'channel' then
			channel_get_users('channel#id'..chat_id, info_chat_3, {chat_id=chat_id})
			end
end
if matches[1] == "info" then
        if msg.reply_id then
        get_message(msg.reply_id, info_by_reply, false)
        return
        elseif matches[2] then
        if is_id(matches[2]) then
        user_info('user#id'..matches[2], info_by_id, {chat_id=chat_id, chat_type=chat_type})
        return
        end
        local member = string.gsub(matches[2], '@', '')
        resolve_username(member, info_by_username, {chat_id=chat_id, member=member, chat_type=chat_type})
        return
        end
        if msg.from.username then
        Username = '@'..msg.from.username
        else
        Username = 'ندارد'
    end
    local um_hash = 'umsgs:'..msg.from.id..':'..msg.to.id
local usermsgs = tonumber(redis:get(um_hash) or 0)
local um_hash = 'usertotalmsgs:'..msg.from.id
local usertmsgs = tonumber(redis:get(um_hash) or 0)
local u_pnum = 'نامشخص'
local oprator ='نامشخص'
if msg.from.phone then
u_pnum = '+'..string.gsub(tostring(msg.from.phone),string.sub(tostring(msg.from.phone),-4),'****')
oprator = getusernumo(msg.from.phone)
end
send_msg(msg.to.peer_id, '🎫 '..lang_text(chat_id, 'userfirstname')..': '..(msg.from.first_name or 'ندارد')..'\n\n🔖 '..lang_text(chat_id, 'userlastname')..': '..(msg.from.last_name or 'ندارد').. '\n\n📳'..lang_text(chat_id, 'userphone')..': '..u_pnum..'\n\n🏢'..lang_text(chat_id, 'useroprator')..': '..oprator.. '\n\n🆔'..lang_text(chat_id, 'user')..': '..msg.from.id..'\n\n🚹'..lang_text(chat_id, 'userusername')..': '..Username..'\n\n🏷'..lang_text(chat_id, 'userrank')..': '..getuserrank(msg.from.id,msg.to.id)..'\n\n📨'..lang_text(chat_id, 'usermsgs')..': '..usertmsgs..'\n\n📨'..lang_text(chat_id, 'userchatmsgs')..': '..usermsgs, ok_cb, false)
end

if matches[1] == "phone" then
   user_info('user#id'..msg.from.id,getphone,msg.to.peer_id)
end

end
return {
  patterns = {
    "^[!#/](info)$",
    "[!#/](chatinfo)$",
    "^[!#/](id)$",
    "^[!#/](phone)$",
    "^[!#/](info) (.*)$",
    "^[!#/](id) (.*)$"
  },
  run = run
}
