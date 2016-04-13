--------------------------------------------------
--      ____  ____ _____                        --
--     |    \|  _ )_   _|___ ____   __  __      --
--     | |_  )  _ \ | |/ ·__|  _ \_|  \/  |     --
--     |____/|____/ |_|\____/\_____|_/\/\_|     --
--                                              --
--------------------------------------------------
--                                              --
--Developers: @Josepdal & @MaSkAoS & @kingjan123--
--     Support: @Skneos,  @iicc1 & @serx666     --
--                                              --
--------------------------------------------------

local function index_function(user_id)
  for k,v in pairs(_config.admin_users) do
    if user_id == v[1] then
    	print(k)
      return k
    end
  end
  -- If not found
  return false
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


local function admin_by_username(cb_extra, success, result)
    local chat_type = cb_extra.chat_type
    local chat_id = cb_extra.chat_id
        if success == 0 then
    if chat_type == 'chat' then
    send_msg('chat#id'..chat_id, '🚫 '..lang_text(chat_id, 'rankisup'), ok_cb, false)
    elseif chat_type == 'channel' then
    send_msg('channel#id'..chat_id, '🚫 '..lang_text(chat_id, 'rankisup'), ok_cb, false)
end
else
    local user_id = result.peer_id
    if user_num(user_id,chat_id) > 3 then
        if chat_type == 'chat' then
    send_msg('chat#id'..chat_id, '🚫 '..lang_text(chat_id, 'usernotfound'), ok_cb, false)
    elseif chat_type == 'channel' then
    send_msg('channel#id'..chat_id, '🚫 '..lang_text(chat_id, 'usernotfound'), ok_cb, false)
    end
    return
    end
    local user_name = result.username
    if is_admin(user_id) then
    	if chat_type == 'chat' then
	        send_msg('chat#id'..chat_id, 'ℹ️ '..lang_text(chat_id, 'alreadyAdmin'), ok_cb, false)
	    elseif chat_type == 'channel' then
	        send_msg('channel#id'..chat_id, 'ℹ️ '..lang_text(chat_id, 'alreadyAdmin'), ok_cb, false)
	    end
	else
	    table.insert(_config.admin_users, {tonumber(user_id), user_name})
		print(user_id..' added to _config table')
		save_config()
		    if result.username then
   local user_name = '@'..result.username
    else
   local user_name = 'ندارد'
    end
    if chat_type=='channel' then
	channel_set_mod('channel#id'..chat_id, 'user#id'..user_id, ok_cb, false)
	end
	    if chat_type == 'chat' then
	       send_msg('chat#id'..chat_id, '🆕 '..lang_text(chat_id, 'newAdmin')..'\n🚹 '..lang_text(chat_id, 'userusername')..': '..user_name..'\n🆔 '..lang_text(chat_id, 'user')..': '..user_id, ok_cb, false)
	    elseif chat_type == 'channel' then
	        send_msg('channel#id'..chat_id, '🆕 '..lang_text(chat_id, 'newAdmin')..'\n🚹 '..lang_text(chat_id, 'userusername')..': '..user_name..'\n🆔 '..lang_text(chat_id, 'user')..': '..user_id, ok_cb, false)
	    end
	end
end
end

local function owner_by_username(cb_extra, success, result)
    local chat_type = cb_extra.chat_type
    local chat_id = cb_extra.chat_id
        if success == 0 then
    if chat_type == 'chat' then
    send_msg('chat#id'..chat_id, '🚫 '..lang_text(chat_id, 'usernotfound'), ok_cb, false)
    elseif chat_type == 'channel' then
    send_msg('channel#id'..chat_id, '🚫 '..lang_text(chat_id, 'usernotfound'), ok_cb, false)
end
else
   local user_id = result.peer_id
        if result.username then
 user_name = '@'..result.username
    else
  user_name = 'ندارد'
    end
    local hash = 'owner:'..chat_id
    if tonumber(redis:get(hash)) == tonumber(user_id) then
    	if chat_type == 'chat' then
	        send_msg('chat#id'..chat_id, 'ℹ️ '..lang_text(chat_id, 'alreadyOwner'), ok_cb, false)
	    elseif chat_type == 'channel' then
	        send_msg('channel#id'..chat_id, 'ℹ️ '..lang_text(chat_id, 'alreadyOwner'), ok_cb, false)
	    end
	else
    if is_mod(chat_id, user_id) then
   local mhash = 'mod:'..chat_id..':'..user_id
    redis:del(mhash)
    end
	    redis:set(hash, tonumber(user_id))
	if chat_type=='channel' then
	channel_set_mod('channel#id'..chat_id, 'user#id'..user_id, ok_cb, false)
	end
	    if chat_type == 'chat' then
	        send_msg('chat#id'..chat_id, '🆕 '..lang_text(chat_id, 'newOwner')..'\n🚹 '..lang_text(chat_id, 'userusername')..': '..user_name..'\n🆔 '..lang_text(chat_id, 'user')..': '..user_id, ok_cb, false)
	    elseif chat_type == 'channel' then
	        send_msg('channel#id'..chat_id, '🆕 '..lang_text(chat_id, 'newOwner')..'\n🚹 '..lang_text(chat_id, 'userusername')..': '..user_name..'\n🆔 '..lang_text(chat_id, 'user')..': '..user_id, ok_cb, false)
	    end
	end
end
end

local function mod_by_username(cb_extra, success, result)
    local chat_type = cb_extra.chat_type
    local chat_id = cb_extra.chat_id
   
      if success == 0 then
    if chat_type == 'chat' then
    send_msg('chat#id'..chat_id, '🚫 '..lang_text(chat_id, 'usernotfound'), ok_cb, false)
    elseif chat_type == 'channel' then
    send_msg('channel#id'..chat_id, '🚫 '..lang_text(chat_id, 'usernotfound'), ok_cb, false)
end
else
    local user_id = result.peer_id
        if user_num(user_id,chat_id) > 1 then
        if chat_type == 'chat' then
    send_msg('chat#id'..chat_id, '🚫 '..lang_text(chat_id, 'rankisup'), ok_cb, false)
    elseif chat_type == 'channel' then
    send_msg('channel#id'..chat_id, '🚫 '..lang_text(chat_id, 'rankisup'), ok_cb, false)
    end
    return
    end
        if result.username then
 user_name = '@'..result.username
    else
  user_name = 'ندارد'
    end
    local hash = 'mod:'..chat_id..':'..user_id
    if redis:get(hash) then
    	if chat_type == 'chat' then
	        send_msg('chat#id'..chat_id, 'ℹ️ '..lang_text(chat_id, 'alreadyMod'), ok_cb, false)
	    elseif chat_type == 'channel' then
	        send_msg('channel#id'..chat_id, 'ℹ️ '..lang_text(chat_id, 'alreadyMod'), ok_cb, false)
	    end
	else
	    redis:set(hash, true)
    if chat_type=='channel' then
	channel_set_mod('channel#id'..chat_id, 'user#id'..user_id, ok_cb, false)
	end
	    if chat_type == 'chat' then
	        send_msg('chat#id'..chat_id, '🆕 '..lang_text(chat_id, 'newMod')..'\n🚹 '..lang_text(chat_id, 'userusername')..': '..user_name..'\n🆔 '..lang_text(chat_id, 'user')..': '..user_id, ok_cb, false)
	    elseif chat_type == 'channel' then
	        send_msg('channel#id'..chat_id, '🆕 '..lang_text(chat_id, 'newMod')..'\n🚹 '..lang_text(chat_id, 'userusername')..': '..user_name..'\n🆔 '..lang_text(chat_id, 'user')..': '..user_id, ok_cb, false)
	    end
	end
end
end
local function guest_by_username(cb_extra, success, result)
    local chat_type = cb_extra.chat_type
    local chat_id = cb_extra.chat_id
        if success == 0 then
    if chat_type == 'chat' then send_msg('chat#id'..chat_id, '🚫 '..lang_text(chat_id, 'usernotfound'), ok_cb, false)
        elseif chat_type == 'channel' then
    send_msg('channel#id'..chat_id, '🚫 '..lang_text(chat_id, 'usernotfound'), ok_cb, false)
end
else
    local user_id = result.peer_id
    local sender = cb_extra.sender
        if result.username then
 user_name = '@'..result.username
    else
   user_name = 'ندارد'
    end
if permissionst(sender,user_id,chat_id) then
if not is_owner(chat_id, user_id) then
	local nameid = index_function(user_id)
	local hash = 'mod:'..chat_id..':'..user_id
    if redis:get(hash) then
    redis:del(hash)
    end
	if is_admin(user_id) then
		table.remove(_config.admin_users, nameid)
		print(user_id..' added to _config table')
		save_config()
		end
	if chat_type=='channel' then
	channel_demote('channel#id'..chat_id, 'user#id'..user_id, ok_cb, false)
	end
    if chat_type == 'chat' then
        send_msg('chat#id'..chat_id, 'ℹ️ \n🚹 '..lang_text(chat_id, 'userusername')..': '..user_name..'\n🆔 '..lang_text(chat_id, 'user')..': '..user_id..'\n'..lang_text(chat_id, 'nowUser'), ok_cb, false)
    elseif chat_type == 'channel' then
        send_msg('channel#id'..chat_id, 'ℹ️ \n🚹 '..lang_text(chat_id, 'userusername')..': '..user_name..'\n🆔 '..lang_text(chat_id, 'user')..': '..user_id..'\n'..lang_text(chat_id, 'nowUser'), ok_cb, false)
    end
   else
   if chat_type == 'chat' then
send_large_msg('chat#id'..chat_id, '🚫 '..lang_text(chat_id, 'require_noown') , ok_cb, true)
elseif chat_type == 'channel' then
send_large_msg('channel#id'..chat_id, '🚫 '..lang_text(chat_id, 'require_noown') , ok_cb, true)
end
   end
else
if chat_type == 'chat' then
send_large_msg('chat#id'..chat_id, '🚫 '..lang_text(chat_id, 'require_up') , ok_cb, true)
elseif chat_type == 'channel' then
send_large_msg('channel#id'..chat_id, '🚫 '..lang_text(chat_id, 'require_up') , ok_cb, true)
end
end
end
end
local function set_admin(cb_extra, success, result)
	local chat_id = cb_extra.chat_id
    local user_id = cb_extra.user_id
   user_name = result.username
    local chat_type = cb_extra.chat_type
    if user_num(user_id,chat_id) > 3 then
        if chat_type == 'chat' then
    send_msg('chat#id'..chat_id, '🚫 '..lang_text(chat_id, 'usernotfound'), ok_cb, false)
    elseif chat_type == 'channel' then
    send_msg('channel#id'..chat_id, '🚫 '..lang_text(chat_id, 'usernotfound'), ok_cb, false)
    end
    return
    end
	if is_admin(tonumber(user_id)) then
    	if chat_type == 'chat' then
	        send_msg('chat#id'..chat_id, 'ℹ️ '..lang_text(chat_id, 'alreadyAdmin'), ok_cb, false)
	    elseif chat_type == 'channel' then
	        send_msg('channel#id'..chat_id, 'ℹ️ '..lang_text(chat_id, 'alreadyAdmin'), ok_cb, false)
	    end
	else
    	table.insert(_config.admin_users, {tonumber(user_id), user_name})
		print(user_id..' added to _config table')
		save_config()
		    if result.username then
    user_name = '@'..result.username
    else
    user_name = 'ندارد'
    end
    if chat_type=='channel' then
	channel_set_mod('channel#id'..chat_id, 'user#id'..user_id, ok_cb, false)
	end
	    if cb_extra.chat_type == 'chat' then
	        send_msg('chat#id'..chat_id, '🆕 '..lang_text(chat_id, 'newAdmin')..'\n🚹 '..lang_text(chat_id, 'userusername')..': '..user_name..'\n🆔 '..lang_text(chat_id, 'user')..': '..user_id, ok_cb, false)
	    elseif cb_extra.chat_type == 'channel' then
	        send_msg('channel#id'..chat_id, '🆕 '..lang_text(chat_id, 'newAdmin')..'\n🚹 '..lang_text(chat_id, 'userusername')..': '..user_name..'\n🆔 '..lang_text(chat_id, 'user')..': '..user_id, ok_cb, false)
	    end
	end
end

local function set_mod(cb_extra, success, result)
	local chat_id = cb_extra.chat_id
    local user_id = cb_extra.user_id
        if user_num(user_id,chat_id) > 1 then
        if chat_type == 'chat' then
    send_msg('chat#id'..chat_id, '🚫 '..lang_text(chat_id, 'usernotfound'), ok_cb, false)
    elseif chat_type == 'channel' then
    send_msg('channel#id'..chat_id, '🚫 '..lang_text(chat_id, 'usernotfound'), ok_cb, false)
    end
    return
    end
       if result.username then
    user_name = '@'..result.username
    else
     user_name = 'ندارد'
    end
    local chat_type = cb_extra.chat_type
    local hash = 'mod:'..chat_id..':'..user_id
	if redis:get(hash) then
    	if chat_type == 'chat' then
	        send_msg('chat#id'..chat_id, 'ℹ️ '..lang_text(chat_id, 'alreadyMod'), ok_cb, false)
	    elseif chat_type == 'channel' then
	        send_msg('channel#id'..chat_id, 'ℹ️ '..lang_text(chat_id, 'alreadyMod'), ok_cb, false)
	    end
	else
    	redis:set(hash, true)
    if chat_type=='channel' then
	channel_set_mod('channel#id'..chat_id, 'user#id'..user_id, ok_cb, false)
	end
	    if cb_extra.chat_type == 'chat' then
	        send_msg('chat#id'..chat_id, '🆕 '..lang_text(chat_id, 'newMod')..'\n🚹 '..lang_text(chat_id, 'userusername')..': '..user_name..'\n🆔 '..lang_text(chat_id, 'user')..': '..user_id, ok_cb, false)
	    elseif cb_extra.chat_type == 'channel' then
	        send_msg('channel#id'..chat_id, '🆕 '..lang_text(chat_id, 'newMod')..'\n🚹 '..lang_text(chat_id, 'userusername')..': '..user_name..'\n🆔 '..lang_text(chat_id, 'user')..': '..user_id, ok_cb, false)
	    end
	end
end

local function set_owner(cb_extra, success, result)
	local chat_id = cb_extra.chat_id
    local user_id = cb_extra.user_id
    if result.username then
   user_name = '@'..result.username
    else
    user_name = 'ندارد'
    end
    local chat_type = cb_extra.chat_type
    local hash = 'owner:'..chat_id
	if tonumber(redis:get(hash)) == tonumber(user_id) then
    	if chat_type == 'chat' then
	        send_msg('chat#id'..chat_id, 'ℹ️ '..lang_text(chat_id, 'alreadyOwner'), ok_cb, false)
	    elseif chat_type == 'channel' then
	        send_msg('channel#id'..chat_id, 'ℹ️ '..lang_text(chat_id, 'alreadyOwner'), ok_cb, false)
	    end
	else
    if is_mod(chat_id, user_id) then
   local mhash = 'mod:'..chat_id..':'..user_id
    redis:del(mhash)
    end
    	redis:set(hash, tonumber(user_id))
    if chat_type=='channel' then
	channel_set_mod('channel#id'..chat_id, 'user#id'..user_id, ok_cb, false)
	end
	    if cb_extra.chat_type == 'chat' then
	        send_msg('chat#id'..chat_id, '🆕 '..lang_text(chat_id, 'newOwner')..'\n🚹 '..lang_text(chat_id, 'userusername')..': '..user_name..'\n🆔 '..lang_text(chat_id, 'user')..': '..user_id, ok_cb, false)
	    elseif cb_extra.chat_type == 'channel' then
	        send_msg('channel#id'..chat_id, '🆕 '..lang_text(chat_id, 'newOwner')..'\n🚹 '..lang_text(chat_id, 'userusername')..': '..user_name..'\n🆔 '..lang_text(chat_id, 'user')..': '..user_id, ok_cb, false)
	    end
	end
end

local function set_guest(cb_extra, success, result)
	local chat_id = cb_extra.chat_id
    local user_id = cb_extra.user_id
    if result.username then
     user_name = '@'..result.username
    else
    user_name = 'ندارد'
    end
    local chat_type = cb_extra.chat_type
    if not is_owner(chat_id, user_id) then
    local nameid = index_function(tonumber(user_id))
    local hash = 'mod:'..chat_id..':'..user_id
    if redis:get(hash) then
    	redis:del(hash)
    end
    if is_admin(user_id) then
		table.remove(_config.admin_users, nameid)
		print(user_id..' added to _config table')
		save_config()
	end
	if chat_type=='channel' then
	channel_demote('channel#id'..chat_id, 'user#id'..user_id, ok_cb, false)
	end
    if cb_extra.chat_type == 'chat' then
        send_msg('chat#id'..chat_id, 'ℹ️\n🚹 '..lang_text(chat_id, 'userusername')..': '..user_name..'\n🆔 '..lang_text(chat_id, 'user')..': '..user_id..'\n'..lang_text(chat_id, 'nowUser'), ok_cb, false)
    elseif cb_extra.chat_type == 'channel' then
        send_msg('channel#id'..chat_id, 'ℹ️\n🚹 '..lang_text(chat_id, 'userusername')..': '..user_name..'\n🆔 '..lang_text(chat_id, 'user')..': '..user_id..'\n'..lang_text(chat_id, 'nowUser'), ok_cb, false)
    end
    else
   if chat_type == 'chat' then
send_large_msg('chat#id'..chat_id, '🚫 '..lang_text(chat_id, 'require_noown') , ok_cb, true)
elseif chat_type == 'channel' then
send_large_msg('channel#id'..chat_id, '🚫 '..lang_text(chat_id, 'require_noown') , ok_cb, true)
end
   end
end

local function admin_by_reply(extra, success, result)
    local result = backward_msg_format(result)
    local msg = result
    local chat_id = msg.to.id
    local user_id = msg.from.id
    local chat_type = msg.to.type
    user_info('user#id'..user_id, set_admin, {chat_type=chat_type, chat_id=chat_id, user_id=user_id})
end

local function mod_by_reply(extra, success, result)
    local result = backward_msg_format(result)
    local msg = result
    local chat_id = msg.to.id
    local user_id = msg.from.id
    local chat_type = msg.to.type
    user_info('user#id'..user_id, set_mod, {chat_type=chat_type, chat_id=chat_id, user_id=user_id})
end
local function owner_by_reply(extra, success, result)
    local result = backward_msg_format(result)
    local msg = result
    local chat_id = msg.to.id
    local user_id = msg.from.id
    local chat_type = msg.to.type
    user_info('user#id'..user_id, set_owner, {chat_type=chat_type, chat_id=chat_id, user_id=user_id})
end
local function guest_by_reply(extra, success, result)
    local result = backward_msg_format(result)
    local msg = result
local sender = extra.sender
    local chat_id = msg.to.id
    local user_id = msg.from.id
    local chat_type = msg.to.type
if permissionst(sender,msg.from.id,msg.to.id) then
    user_info('user#id'..user_id, set_guest, {chat_type=chat_type, chat_id=chat_id, user_id=user_id})
else
if chat_type == 'chat' then
send_large_msg('chat#id'..chat_id, '🚫 '..lang_text(chat_id, 'require_up') , ok_cb, true)
elseif chat_type == 'channel' then
send_large_msg('channel#id'..chat_id, '🚫 '..lang_text(chat_id, 'require_up') , ok_cb, true)
end
end
end

local function members_chat(cb_extra, success, result)
	local chat_id = cb_extra.chat_id
	local text = '🔆 '..lang_text(chat_id, 'memberList')..'\n🔹🔸🔹🔸🔹🔸🔹🔸🔹🔸🔹 🔸\n\n'
	for k,user in pairs(result.members) do
	if user.username then
uusername = '@'..user.username
else
uusername = 'ندارد'
end
	text = text..'🎫 '..lang_text(chat_id, 'userfirstname')..':'..string.gsub(user.print_name, "_", " ")..'\n🚹 '..lang_text(chat_id, 'userusername')..':'..uusername..'\n\n'
	end
	text = text..'🔹🔸🔹🔸🔹🔸🔹🔸🔹🔸🔹 🔸'
	return send_large_msg('chat#id'..chat_id, text, ok_cb, true)
end

local function members_channel(extra, success, result)
	local chat_id = extra.chat_id
	local text = '🔆 '..lang_text(chat_id, 'memberList')..'\n🔹🔸🔹🔸🔹🔸🔹🔸🔹🔸🔹 🔸\n\n'
	for k,user in ipairs(result) do
	if user.username then
uusername = '@'..user.username
else
uusername = 'ندارد'
end
	text = text..'🎫 '..lang_text(chat_id, 'userfirstname')..':'..string.gsub(user.print_name, "_", " ")..'\n🚹 '..lang_text(chat_id, 'userusername')..':'..uusername..'\n\n'
	end
	text = text..'🔹🔸🔹🔸🔹🔸🔹🔸🔹🔸🔹 🔸'
	return send_large_msg('channel#id'..chat_id, text, ok_cb, true)
end

local function mods_channel(extra, success, result)
	local chat_id = extra.chat_id
	local text = '🔆 '..lang_text(chat_id, 'modList')..'\n🔹🔸🔹🔸🔹🔸🔹🔸🔹🔸🔹 🔸\n\n'
	local owtext='💥 '..lang_text(chat_id, 'chatow')..'\n'
	local mtext=''
	local compare = text
	for k,user in ipairs(result) do
	if is_owner(chat_id,user.peer_id) then
	if user.username then
uusername = '@'..user.username
else
uusername = 'ندارد'
end
	owtext=owtext..'🎫 '..lang_text(chat_id, 'userfirstname')..':'..string.gsub(user.print_name, "_", " ")..'\n🚹 '..lang_text(chat_id, 'userusername')..':'..uusername..'\n\n'
	end
		hash = 'mod:'..chat_id..':'..user.peer_id
		if redis:get(hash) then
		if user.username then
uusername = '@'..user.username
else
uusername = 'ندارد'
end
				mtext= mtext..'🎫 '..lang_text(chat_id, 'userfirstname')..':'..string.gsub(user.print_name, "_", " ")..'\n🚹 '..lang_text(chat_id, 'userusername')..':'..uusername..'\n\n'
	end
	end
	if text..owtext..mtext == compare then
		text = text..'🔅 '..lang_text(chat_id, 'modEmpty')
	else
	text = text..owtext..mtext..'🔹🔸🔹🔸🔹🔸🔹🔸🔹🔸🔹 🔸'
	end
	return send_large_msg('channel#id'..chat_id, text, ok_cb, true)
end

local function mods_chat(extra, success, result)
	local chat_id = extra.chat_id
	local text = '🔆 '..lang_text(chat_id, 'modList')..'\n🔹🔸🔹🔸🔹🔸🔹🔸🔹🔸🔹 🔸\n\n'
	local owtext='💥 '..lang_text(chat_id, 'chatow')..'\n'
	local mtext=''
	local compare = text
	for k,user in pairs(result.members) do
			if is_owner(chat_id,user.peer_id) then
	if user.username then
uusername = '@'..user.username
else
uusername = 'ندارد'
end
	owtext=owtext..'🎫 '..lang_text(chat_id, 'userfirstname')..':'..string.gsub(user.print_name, "_", " ")..'\n🚹 '..lang_text(chat_id, 'userusername')..':'..uusername..'\n\n'
	end
		hash = 'mod:'..chat_id..':'..user.peer_id
		if redis:get(hash) then
		if user.username then
uusername = '@'..user.username
else
uusername = 'ندارد'
end
				mtext= mtext..'🎫 '..lang_text(chat_id, 'userfirstname')..':'..string.gsub(user.print_name, "_", " ")..'\n🚹 '..lang_text(chat_id, 'userusername')..':'..uusername..'\n\n'
	end
	end
	if text..owtext..mtext == compare then
		text = text..'🔅 '..lang_text(chat_id, 'modEmpty')
	else
	text = text..owtext..mtext..'🔹🔸🔹🔸🔹🔸🔹🔸🔹🔸🔹 🔸'
	end
	return send_large_msg('chat#id'..chat_id, text, ok_cb, true)
	end

local function run(msg, matches)
	user_id = msg.from.id
	chat_id = msg.to.id
	if matches[1] == 'rank' then
		if matches[2] == 'admin' then
			if permissions(user_id, chat_id, "rank_admin") then
				if msg.reply_id then
					get_message(msg.reply_id, admin_by_reply, false)
					return
				end
				if is_id(matches[3]) then
					chat_type = msg.to.type
					chat_id = msg.to.id
					user_id = matches[3]
					user_info('user#id'..user_id, set_admin, {chat_type=chat_type, chat_id=chat_id, user_id=user_id})
				else
					chat_type = msg.to.type
					chat_id = msg.to.id
					local member = string.gsub(matches[3], '@', '')
	         	resolve_username(member, admin_by_username, {chat_id=chat_id, member=member, chat_type=chat_type})
				end
			else
				return '🚫 '..lang_text(msg.to.id, 'require_sudo')
			end
		end
		
		if matches[2] == 'owner' then
			if permissions(user_id, chat_id, "rank_owner") then
				if msg.reply_id then
					get_message(msg.reply_id, owner_by_reply, false)
					return
				end
				if is_id(matches[3]) then
					chat_type = msg.to.type
					chat_id = msg.to.id
					user_id = matches[3]
					user_info('user#id'..user_id, set_owner, {chat_type=chat_type, chat_id=chat_id, user_id=user_id})
				else
					chat_type = msg.to.type
					chat_id = msg.to.id
					local member = string.gsub(matches[3], '@', '')
	            	resolve_username(member, owner_by_username, {chat_id=chat_id, member=member, chat_type=chat_type})
				end
			else
				return '🚫 '..lang_text(msg.to.id, 'require_owner')
			end
		end
		
		if matches[2] == 'mod' then
			if permissions(user_id, chat_id, "rank_mod") then
				if msg.reply_id then
					get_message(msg.reply_id, mod_by_reply, false)
					return
				end
				if is_id(matches[3]) then
					chat_type = msg.to.type
					chat_id = msg.to.id
					user_id = matches[3]
					user_info('user#id'..user_id, set_mod, {chat_type=chat_type, chat_id=chat_id, user_id=user_id})
				else
					chat_type = msg.to.type
					chat_id = msg.to.id
					local member = string.gsub(matches[3], '@', '')
	            	resolve_username(member, mod_by_username, {chat_id=chat_id, member=member, chat_type=chat_type})
				end
			else
				return '🚫 '..lang_text(msg.to.id, 'require_admin')
			end
		end
		if matches[2] == 'member' then
			if permissions(user_id, chat_id, "rank_guest") then
   local sender=msg.from.id
				if msg.reply_id then
					get_message(msg.reply_id, guest_by_reply, {sender=sender})
					return
				end
				if is_id(matches[3]) then
					chat_type = msg.to.type
					chat_id = msg.to.id
					user_id = matches[3]
if permissionst(msg.from.id,user_id,chat_id) then
user_info('user#id'..user_id, set_guest, {chat_type=chat_type, chat_id=chat_id, user_id=user_id})
else 
if chat_type == 'chat' then
send_large_msg('chat#id'..chat_id, '🚫 '..lang_text(chat_id, 'require_up') , ok_cb, true)
elseif chat_type == 'channel' then
send_large_msg('channel#id'..chat_id, '🚫 '..lang_text(chat_id, 'require_up') , ok_cb, true)
end
end
				else
					chat_type = msg.to.type
					chat_id = msg.to.id
					local member = string.gsub(matches[3], '@', '')
	            	resolve_username(member, guest_by_username, {sender=sender,chat_id=chat_id, member=member, chat_type=chat_type})
				end
			else
				return '🚫 '..lang_text(msg.to.id, 'require_owner')
			end
		end
	elseif matches[1] == 'admins' then
		  	-- Check users id in config
		      local chat_id = msg.to.id
		      local chat_type = msg.to.type
		  	local text = '🔆 '..lang_text(msg.to.id, 'adminList')..'\n🔹🔸🔹🔸🔹🔸🔹🔸🔹🔸🔹 🔸\n\n'
		  	local compare = text
		  	for v,user in pairs(_config.admin_users) do
		if user[2] then
uusername = '@'..user[2]
else
uusername = 'ندارد'
end
	text = text..'🆔 '..lang_text(chat_id, 'user')..':'..user[1]..'\n🚹 '..lang_text(chat_id, 'userusername')..':'..uusername..'\n\n'
			end
		  	if compare == text then
		  		text = text..'🔅 '..lang_text(chat_id, 'adminEmpty')
		  	else
		text=text..'🔹🔸🔹🔸🔹🔸🔹🔸🔹🔸🔹 🔸'
end 
return text
	elseif matches[1] == 'members' then
			local chat_id = msg.to.id
		 	if msg.to.type == 'chat' then
		 		local receiver = 'chat#id'..msg.to.id
			    chat_info(receiver, members_chat, {chat_id=chat_id})
			else
				local chan = ("%s#id%s"):format(msg.to.type, msg.to.id)
			    channel_get_users(chan, members_channel, {chat_id=chat_id})
			end
	elseif matches[1] == 'mods' then
		if permissions(user_id, chat_id, "mods") then
			local chat_id = msg.to.id
		 	if msg.to.type == 'chat' then
		 		local receiver = 'chat#id'..msg.to.id
			    chat_info(receiver, mods_chat, {chat_id=chat_id})
			else
				local chan = ("%s#id%s"):format(msg.to.type, msg.to.id)
			    channel_get_users(chan, mods_channel, {chat_id=chat_id})
			end
		else
			return '🚫 '..lang_text(msg.to.id, 'require_mod')
		end
	end
end

return {
  patterns = {
  	"^#(rank) (.*) (.*)$",
  	"^#(rank) (.*)$",
  	"^#(admins)$",
  	"^#(mods)$",
  	"^#(members)$"
  },
  run = run
}
