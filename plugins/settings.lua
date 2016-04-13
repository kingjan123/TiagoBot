--------------------------------------------------
--      ____  ____ _____                        --
--     |    \|  _ )_   _|___ ____   __  __      --
--     | |_  )  _ \ | |/ ·__|  _ \_|  \/  |     --
--     |____/|____/ |_|\____/\_____|_/\/\_|     --
--                                              --
--------------------------------------------------
--                                              --
--Developers: @Josepdal & @MaSkAoS & @kingjan123--
--     Support: @mohamad_zaq                    --
--                                              --
--												--
--------------------------------------------------

do

local function create_group(msg, group_name)
    local group_creator = msg.from.print_name
    create_group_chat(group_creator, group_name, ok_cb, false)
    return 'ℹ️ '..lang_text(msg.to.id, 'createGroup:1')..' "'..string.gsub(group_name, '_', ' ')..'" '..lang_text(msg.to.id, 'createGroup:2')
end
local function create_group2(cb_extra, success, result)
    local group_name = cb_extra.group_name
    local group_creator = result.print_name
    local msg = result.msg
    create_group_chat(group_creator, group_name, ok_cb, false)
    print('ok')
end
local function owincreate(extra, success, result)
    local chat_id = extra.chat_id
	for k,user in pairs(result.members) do
	if tonumber(user.peer_id) == 191104143 then
 else
     local ohash = 'owner:'..chat_id
     redis:set(ohash, tonumber(user.peer_id))
	end
end
    send_large_msg('chat#id'..chat_id, '🆕 '..lang_text(chat_id, 'newGroupWelcome'), ok_cb, true)
	end
local function index_function(chat_title)
  for k,v in pairs(_chats.chats) do
    if chat_title == v[2] then
    	print(k)
      return k
    end
  end
  -- If not found
  return false
end
local function index_function3(chat_title)
  for k,v in pairs(_chats.chats) do
    if chat_title == v[2] then
      return v[1]
    end
  end
  -- If not found
  return false
end
local function index_function2(chat_id)
  for k,v in pairs(_chats.chats) do
    if chat_id == v[1] then
    	print(k)
      return k
    end
  end
  -- If not found
  return false
end
local function sttophoto(msg, success, result)
  if success then
    local file = 'data/stickers/'..msg.from.id..'.png'
    os.rename(result, file)
    send_large_msg(get_receiver(msg), lang_text(msg.to.id, 'u_image'), ok_cb, false)
    send_document(get_receiver(msg), file, ok_cb, false)
    send_photo(get_receiver(msg), file, ok_cb, false)
	local hash = 'stophoto:'..msg.to.id..':'..msg.from.id
    redis:del(hash)
  else
    print('Error downloading: '..msg.id)
    send_large_msg(get_receiver(msg), 'Failed, please try again!', ok_cb, false)
  end
end
local function phtosticker(msg, success, result)
  if success then
    local file = 'data/stickers/'..msg.from.id..'.webp'
    local nfile = 'data/stickers/'..msg.from.id..'.png'
    os.rename(result, file)
        local infile = io.open(file, "r")
        local instr = infile:read("*a")
        infile:close()
        local outfile = io.open(nfile, "w")
        outfile:write(instr)
        outfile:close()
    send_large_msg(get_receiver(msg), lang_text(msg.to.id, 'u_sticker'), ok_cb, false)
    send_document(get_receiver(msg), file, ok_cb, false)
    send_document(get_receiver(msg), nfile, ok_cb, false)
	local hash = 'ptosticker:'..msg.to.id..':'..msg.from.id
    redis:del(hash)

  else
    print('Error downloading: '..msg.id)
    send_large_msg(get_receiver(msg), 'Failed, please try again!', ok_cb, false)
  end
end
local function remove_message(extra, success, result)
    msg = backward_msg_format(result)
    delete_msg(msg.id, ok_cb, false)
end

local function set_group_photo(msg, success, result)
    local receiver = get_receiver(msg)
    if success then
        local file = 'data/photos/chat_photo_'..msg.to.id..'.jpg'
        print('File downloaded to:', result)
        os.rename(result, file)
        print('File moved to:', file)
        if msg.to.type == 'channel' then
        	channel_set_photo (receiver, file, ok_cb, false)
	elseif msg.to.type == 'chat' then
		chat_set_photo(receiver, file, ok_cb, false)
	end
        return 'ℹ️ '..lang_text(msg.to.id, 'photoSaved')
    else
        print('Error downloading: '..msg.id)
        return 'ℹ️ '..lang_text(msg.to.id, 'photoSaved')
    end
end
local function upmembers_channel(extra, success, result)
	local chatid = extra.chatid
	local ochatid = extra.ochatid
	for k,user in ipairs(result) do
	local hash = 'umsgs:'..user.peer_id..':'..ochatid
	local chos = redis:get(hash)
	redis:del(hash)
	local hash = 'umsgs:'..user.peer_id..':'..chatid
	redis:set(hash, tonumber(chos))
	local mhash = 'mod:'..ochatid..':'..user.peer_id
	if redis:get(mhash) then
	redis:del(mhash)
	local nhash = 'mod:'..chatid..':'..user.peer_id
	redis:set(nhash,true)
	end
	end
end
local function pre_process(msg)
if not msg.service then
    local hash = 'totalmsgs'
    redis:incr(hash)
    local hash = 'chattotalmsgs:'..msg.to.id
    redis:incr(hash)
    local hash = 'usertotalmsgs:'..msg.from.id
    redis:incr(hash)
    local hash = 'umsgs:'..msg.from.id..':'..msg.to.id
    redis:incr(hash)
	end
    if msg.action and msg.action.type then
    local action = msg.action.type
    if action == 'migrated_from' then
	local ochatid = index_function3(string.gsub(msg.to.title, '_', ' '))
	local chatid = msg.to.id
	local hash = 'chattotalmsgs:'..ochatid
	local chos = redis:get(hash)
	redis:del(hash)
	local hash = 'chattotalmsgs:'..msg.to.id
	redis:set(hash, tonumber(chos))
	local hash = 'owner:'..ochatid
	local choo = redis:get(hash)
	redis:del(hash)
	local hash = 'owner:'..msg.to.id
	redis:set(hash, tonumber(choo))
	channel_get_users('channel#id'..msg.to.id, upmembers_channel, {ochatid=ochatid, chatid=chatid})
	local nameid = index_function(string.gsub(msg.to.title, '_', ' '))
    	table.remove(_chats.chats, nameid)
		table.insert(_chats.chats, {tonumber(msg.to.id), string.gsub(msg.to.title, '_', ' ')})
		save_chats()
	elseif action == 'chat_rename' then
	local nameid = index_function2(tonumber(msg.to.id))
	    table.remove(_chats.chats, nameid)
	    table.insert(_chats.chats, {tonumber(msg.to.id), string.gsub(msg.action.title, '_', ' ')})
		save_chats()
    end
	end
    local hash = 'flood:max:'..msg.to.id
    if not redis:get(hash) then
        floodMax = 5
    else
        floodMax = tonumber(redis:get(hash))
    end

    local hash = 'flood:time:'..msg.to.id
    if not redis:get(hash) then
        floodTime = 3
    else
        floodTime = tonumber(redis:get(hash))
    end
	--plugins check
	        if not msg.media then
            webp = 'nothing'
        else
            webp = msg.media.caption
        end
        if webp == 'sticker.webp' then
		local hash = 'stophoto:'..msg.to.id..':'..msg.from.id
			if redis:get(hash) then
			load_document(msg.id, sttophoto, msg)
			end
		else
		local hash = 'stophoto:'..msg.to.id..':'..msg.from.id
			if redis:get(hash) then
              if msg.to.type == 'chat' then
              send_msg('chat#id'..msg.to.id, 'ℹ️ شما استیکری ارسال نکردید عملیات شما در این گروه لغو شد', ok_cb, false)
              elseif msg.to.type == 'channel' then
              send_msg('channel#id'..msg.to.id, 'ℹ️ شما استیکری ارسال نکردید عملیات شما در این سوپر گروه لغو شد', ok_cb, false)
              end
			  redis:del(hash)
			end
        end
		      if msg.media then
            if msg.media.type == 'photo' then
                local hash = 'ptosticker:'..msg.to.id..':'..msg.from.id
                if redis:get(hash) then
                    load_photo(msg.id, phtosticker, msg)
                end
			elseif msg.media.caption:match(".png") then
			local hash = 'ptosticker:'..msg.to.id..':'..msg.from.id
                if redis:get(hash) then
                    load_document(msg.id, phtosticker, msg)
                end
			else
			local hash = 'ptosticker:'..msg.to.id..':'..msg.from.id
			if redis:get(hash) then
              if msg.to.type == 'chat' then
              send_msg('chat#id'..msg.to.id, 'ℹ️ شما تصویری ارسال نکردید عملیات شما در این گروه لغو شد', ok_cb, false)
              elseif msg.to.type == 'channel' then
              send_msg('channel#id'..msg.to.id, 'ℹ️ شما تصویری ارسال نکردید عملیات شما در این سوپر گروه لغو شد', ok_cb, false)
              end
			  redis:del(hash)
			end
            end
			else
			local hash = 'ptosticker:'..msg.to.id..':'..msg.from.id
			if redis:get(hash) then
              if msg.to.type == 'chat' then
              send_msg('chat#id'..msg.to.id, 'ℹ️ شما تصویری ارسال نکردید عملیات شما در این گروه لغو شد', ok_cb, false)
              elseif msg.to.type == 'channel' then
              send_msg('channel#id'..msg.to.id, 'ℹ️ شما تصویری ارسال نکردید عملیات شما در این سوپر گروه لغو شد', ok_cb, false)
              end
			  redis:del(hash)
			end
        end
    if not permissions(msg.from.id, msg.to.id, "pre_process") then
        --Checking flood
        local hashse = 'anti-flood:'..msg.to.id
        if not redis:get(hashse) then
            print('anti-flood enabled')
            -- Check flood
            if msg.from.type == 'user' then
                if not permissions(msg.from.id, msg.to.id, "no_flood_ban") then
                    -- Increase the number of messages from the user on the chat
                    local hash = 'flood:'..msg.from.id..':'..msg.to.id..':msg-num'
                    local msgs = tonumber(redis:get(hash) or 0)
                    if msgs > floodMax then
                        local receiver = get_receiver(msg)
                        local user = msg.from.id
                        local chat = msg.to.id
                        local channel = msg.to.id
                        local bhash = 'banned:'..msg.to.id..':'..msg.from.id
                        redis:set(bhash, true)
                        if msg.to.type == 'chat' then
                            send_msg('chat#id'..msg.to.id, lang_text(chat, 'user')..' @'..msg.from.username..' ('..msg.from.id..') '..lang_text(chat, 'isFlooding'), ok_cb, true)
                            chat_del_user('chat#id'..msg.to.id, 'user#id'..msg.from.id, ok_cb, true)
                        elseif msg.to.type == 'channel' then
                            send_msg('channel#id'..msg.to.id, lang_text(chat, 'user')..' @'..msg.from.username..' ('..msg.from.id..') '..lang_text(chat, 'isFlooding'), ok_cb, true)
                            channel_kick('channel#id'..msg.to.id, 'user#id'..msg.from.id, ok_cb, true)
                        end
                    end
                    redis:setex(hash, floodTime, msgs+1)
                end
            end
        end

        if msg.action and msg.action.type then
            local action = msg.action.type
            if action == 'chat_add_user' or action == 'chat_add_user_link' then
            	hash = 'antibot:'..msg.to.id
            	if redis:get(hash) then
	                if string.sub(msg.action.user.username:lower(), -3) == 'bot' then
	                    if msg.to.type == 'chat' then
	                        chat_del_user('chat#id'..msg.to.id, 'user#id'..msg.action.user.id, ok_cb, true)
	                    elseif msg.to.type == 'channel' then
	                        channel_kick('channel#id'..msg.to.id, 'user#id'..msg.action.user.id, ok_cb, true)
	                    end
	                end
	            end
            end
        end
        --Cheking Contact
        if msg.media then
        if msg.media.type == 'contact' then
        hash = 'contacts:'..msg.to.id
            if redis:get(hash) then
                delete_msg(msg.id, ok_cb, false)
            end
        end
        end
        --Checking stickers
        if not msg.media then
            webp = 'nothing'
        else
            webp = msg.media.caption
        end
        if webp == 'sticker.webp' then
            hash = 'stickers:'..msg.to.id
            if redis:get(hash) then
                delete_msg(msg.id, ok_cb, false)
            end
        end
        if not msg.media then
            mp4 = 'nothing'
        else
            if msg.media.type == 'document' then
                mp4 = msg.media.caption or 'audio'
            end
        end
        --Checking GIFs and MP4 files
        if mp4 == 'giphy.mp4' then
            hash = 'gifs:'..msg.to.id
            if redis:get(hash) then
                delete_msg(msg.id, ok_cb, false)
            end
        else
            if msg.media then
                if msg.media.type == 'document' then
                    gifytpe = string.find(mp4, 'gif.mp4') or 'audio'
                    if gifytpe == 'audio' then
                        hash = 'audio:'..msg.to.id
                        if redis:get(hash) then
                            delete_msg(msg.id, ok_cb, false)
                        end
                    else
                        hash = 'gifs:'..msg.to.id
                        if redis:get(hash) then
                            delete_msg(msg.id, ok_cb, false)
                        end
                    end
                end
            end
        end
        --Checking photos
        if msg.media then
            if msg.media.type == 'photo' then
                local hash = 'photo:'..msg.to.id
                if redis:get(hash) then
                    delete_msg(msg.id, ok_cb, false)
                end
            end
        end

        --Checking muteall
        local hash = 'muteall:'..msg.to.id
        if redis:get(hash) then
            delete_msg(msg.id, ok_cb, false)
        end
    else
	     local hash = 'setphoto:'..msg.to.id..':'..msg.from.id
         if redis:get(hash) then
        if msg.media then
            if msg.media.type == 'photo' then
                    redis:del(hash)
                    load_photo(msg.id, set_group_photo, msg)
                    delete_msg(msg.id, ok_cb, false)
					end
		else
		            if msg.to.type == 'chat' then
              send_msg('chat#id'..msg.to.id, 'ℹ️ شما تصویری ارسال نکردید عملیات شما در این گروه لغو شد', ok_cb, false)
              elseif msg.to.type == 'channel' then
              send_msg('channel#id'..msg.to.id, 'ℹ️ شما تصویری ارسال نکردید عملیات شما در این سوپر گروه لغو شد', ok_cb, false)
              end
		redis:del(hash)
            end
        end
    end
    return msg
end
local function run(msg, matches)
    if matches[1] == 'tophoto' then
	hash = 'stophoto:'..msg.to.id..':'..msg.from.id
    	redis:set(hash, true)
    	return 'ℹ️ لطفا استیکری را ارسال فرمایید'
    end
	    if matches[1] == 'tosticker' then
	hash = 'ptosticker:'..msg.to.id..':'..msg.from.id
    	redis:set(hash, true)
    	return 'ℹ️ لطفا تصویری را ارسال فرمایید'
    end
    if matches[1] == 'lock' then
                      if matches[2] == 'sticker' then
                        hash = 'stickers:'..msg.to.id
                        redis:set(hash, true)
                        if msg.to.type == 'chat' then
                            send_msg('chat#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'noStickersT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            send_msg('channel#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'noStickersL'), ok_cb, false)
                        end
                    return
                       elseif matches[2] == 'badword' then
                        hash = 'badwords:'..msg.to.id
                        redis:set(hash, true)
                        if msg.to.type == 'chat' then
                            send_msg('chat#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'noBadwordsT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            send_msg('channel#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'noBadwordsL'), ok_cb, false)
                        end
                    return
					    elseif matches[2] == 'porn' then
                        hash = 'porns:'..msg.to.id
                        redis:set(hash, true)
                        if msg.to.type == 'chat' then
                            send_msg('chat#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'noPornsT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            send_msg('channel#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'noPornsL'), ok_cb, false)
                        end
                    return
                        elseif matches[2] == 'contact' then
                        hash = 'contacts:'..msg.to.id
                        redis:set(hash, true)
                        if msg.to.type == 'chat' then
                            send_msg('chat#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'noContactsT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            send_msg('channel#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'noContactsL'), ok_cb, false)
                        end
                    return
                elseif matches[2] == 'gif' then
                        hash = 'gifs:'..msg.to.id
                        redis:set(hash, true)
                        if msg.to.type == 'chat' then
                            send_msg('chat#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'noGifsT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            send_msg('channel#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'noGifsL'), ok_cb, false)
                        end       
                    return
                elseif matches[2] == 'photo' then
                        hash = 'photo:'..msg.to.id
                        redis:set(hash, true)
                        if msg.to.type == 'chat' then
                            send_msg('chat#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'noPhotosT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            send_msg('channel#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'noPhotosL'), ok_cb, false)
                        end
                    return
                elseif matches[2] == 'bot' then
                        hash = 'antibot:'..msg.to.id
                        redis:set(hash, true)
                        if msg.to.type == 'chat' then
                            send_msg('chat#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'noBotsT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            send_msg('channel#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'noBotsL'), ok_cb, false)
                        end                    
                    return
                 elseif matches[2] == 'arabic' then
                        hash = 'arabic:'..msg.to.id
                        redis:set(hash, true)
                        if msg.to.type == 'chat' then
                            send_msg('chat#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'noArabicT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            send_msg('channel#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'noArabicL'), ok_cb, false)
                        end                    
                    return
                elseif matches[2] == 'audio' then
                        hash = 'audio:'..msg.to.id
                        redis:set(hash, true)
                        if msg.to.type == 'chat' then
                            send_msg('chat#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'noAudiosT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            send_msg('channel#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'noAudiosL'), ok_cb, false)
                        end                    
                    return               
                elseif matches[2] == 'flood' then
                        hash = 'anti-flood:'..msg.to.id
                        redis:del(hash)
                        if msg.to.type == 'chat' then
                            send_msg('chat#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'noFloodT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            send_msg('channel#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'noFloodL'), ok_cb, false)
                        end                    
                    return
                elseif matches[2] == 'adv' then
                        local hash = 'spam:'..msg.to.id
                        redis:set(hash, true)
                        if msg.to.type == 'chat' then
                            send_msg('chat#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'notAllowedSpamT'), ok_cb, true)
                        elseif msg.to.type == 'channel' then
                            send_msg('channel#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'notAllowedSpamL'), ok_cb, true)
                        end
                        return
				elseif matches[2] == 'setphoto' then
                        local hash = 'setphoto:'..msg.to.id
                        redis:set(hash, true)
                        if msg.to.type == 'chat' then
                            send_msg('chat#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'notChatSetphoto'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            send_msg('channel#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'notChannelSetphoto'), ok_cb, false)
                        end
                        return
				elseif matches[2] == 'setname' then
                        local hash = 'name:'..msg.to.id
                        redis:set(hash, true)
                        if msg.to.type == 'chat' then
                            send_msg('chat#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'notChatRename'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            send_msg('channel#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'notChannelRename'), ok_cb, false)
                        end
                        return	
                elseif matches[2] == 'join' then
                    hash = 'lockmember:'..msg.to.id
                        redis:set(hash, true)
                        if msg.to.type == 'chat' then
                            send_msg('chat#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'lockMembersT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            send_msg('channel#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'lockMembersL'), ok_cb, false)
                        end
                    return 
end					
    elseif matches[1] == 'unlock' then
                      if matches[2] == 'sticker' then
                        hash = 'stickers:'..msg.to.id
                        redis:del(hash)
                        if msg.to.type == 'chat' then
                            send_msg('chat#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'stickersT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            send_msg('channel#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'stickersL'), ok_cb, false)
                        end
                    return
                       elseif matches[2] == 'badword' then
                        hash = 'badwords:'..msg.to.id
                        redis:del(hash)
                        if msg.to.type == 'chat' then
                            send_msg('chat#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'badwordsT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            send_msg('channel#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'badwordsL'), ok_cb, false)
                        end
                    return
					    elseif matches[2] == 'porn' then
                        hash = 'porns:'..msg.to.id
                        redis:del(hash)
                        if msg.to.type == 'chat' then
                            send_msg('chat#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'pornsT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            send_msg('channel#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'pornsL'), ok_cb, false)
                        end
                    return
                        elseif matches[2] == 'contact' then
                        hash = 'contacts:'..msg.to.id
                        redis:del(hash)
                        if msg.to.type == 'chat' then
                            send_msg('chat#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'contactsT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            send_msg('channel#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'contactsL'), ok_cb, false)
                        end
                    return
                elseif matches[2] == 'gif' then
                        hash = 'gifs:'..msg.to.id
                        redis:del(hash)
                        if msg.to.type == 'chat' then
                            send_msg('chat#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'gifsT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            send_msg('channel#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'gifsL'), ok_cb, false)
                        end       
                    return
                elseif matches[2] == 'photo' then
                        hash = 'photo:'..msg.to.id
                        redis:del(hash)
                        if msg.to.type == 'chat' then
                            send_msg('chat#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'photosT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            send_msg('channel#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'photosL'), ok_cb, false)
                        end
                    return
                elseif matches[2] == 'bot' then
                        hash = 'antibot:'..msg.to.id
                        redis:del(hash)
                        if msg.to.type == 'chat' then
                            send_msg('chat#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'botsT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            send_msg('channel#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'botsL'), ok_cb, false)
                        end                    
                    return
                 elseif matches[2] == 'arabic' then
                        hash = 'arabic:'..msg.to.id
                        redis:del(hash)
                        if msg.to.type == 'chat' then
                            send_msg('chat#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'arabicT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            send_msg('channel#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'arabicL'), ok_cb, false)
                        end                    
                    return
                elseif matches[2] == 'audio' then
                        hash = 'audio:'..msg.to.id
                        redis:del(hash)
                        if msg.to.type == 'chat' then
                            send_msg('chat#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'audiosT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            send_msg('channel#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'audiosL'), ok_cb, false)
                        end                    
                    return               
                elseif matches[2] == 'flood' then
                        hash = 'anti-flood:'..msg.to.id
                        redis:set(hash, true)
                        if msg.to.type == 'chat' then
                            send_msg('chat#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'floodT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            send_msg('channel#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'floodL'), ok_cb, false)
                        end                    
                    return
                elseif matches[2] == 'adv' then
                        local hash = 'spam:'..msg.to.id
                        redis:del(hash)
                        if msg.to.type == 'chat' then
                            send_msg('chat#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'allowedSpamT'), ok_cb, true)
                        elseif msg.to.type == 'channel' then
                            send_msg('channel#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'allowedSpamL'), ok_cb, true)
                        end
                        return
						elseif matches[2] == 'setphoto' then
                        local hash = 'setphoto:'..msg.to.id
                        redis:del(hash)
                        if msg.to.type == 'chat' then
                            send_msg('chat#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'chatSetphoto'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            send_msg('channel#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'channelSetphoto'), ok_cb, false)
                        end
                        return
				elseif matches[2] == 'setname' then
                        local hash = 'name:'..msg.to.id
                        redis:del(hash)
                        if msg.to.type == 'chat' then
                            send_msg('chat#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'chatRename'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            send_msg('channel#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'channelRename'), ok_cb, false)
                        end
                        return	
                elseif matches[2] == 'join' then
                    hash = 'lockmember:'..msg.to.id
                        redis:del(hash)
                        if msg.to.type == 'chat' then
                            send_msg('chat#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'notLockMembersT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            send_msg('channel#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'notLockMembersL'), ok_cb, false)
                        end
                    return
                        end					
		elseif matches[1] == 'set' then
        if permissions(msg.from.id, msg.to.id, "settings") then
		local hash = ''
		if matches[2] == 'name' then
            hash = 'name:'..msg.to.id
            if not redis:get(hash) then
                if msg.to.type == 'chat' then
                    rename_chat(msg.to.peer_id, matches[3], ok_cb, false)
                elseif msg.to.type == 'channel' then
                    rename_channel(msg.to.peer_id, matches[3], ok_cb, false)
                end
            end
			elseif matches[2] == 'link' then
			 hash = 'link:'..msg.to.id
            redis:set(hash, matches[3])
            if msg.to.type == 'chat' then
                send_msg('chat#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'linkSaved'), ok_cb, true)
            elseif msg.to.type == 'channel' then
                send_msg('channel#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'linkSaved'), ok_cb, true)
            end
			elseif matches[2] == 'photo' then
            hash = 'setphoto:'..msg.to.id
            if not redis:get(hash) then
                    hash = 'setphoto:'..msg.to.id..':'..msg.from.id
                    redis:set(hash, true)
                    if msg.to.type == 'chat' then
                        send_msg('chat#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'sendPhoto'), ok_cb, true)
                    elseif msg.to.type == 'channel' then
                        send_msg('channel#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'sendPhoto'), ok_cb, true)
                    end
            else
                return 'ℹ️ '..lang_text(msg.to.id, 'setPhotoError')
            end
			                elseif matches[2] == 'floodtime' then
                    if not matches[3] then
                    else
                        hash = 'flood:time:'..msg.to.id
                        redis:set(hash, matches[3])
                        if msg.to.type == 'chat' then
                            send_msg('chat#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'floodTime')..matches[3], ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            send_msg('channel#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'floodTime')..matches[3], ok_cb, false)
                        end
                    end
                    return
                elseif matches[2] == 'maxflood' then
                    if not matches[3] then
                    else
                        hash = 'flood:max:'..msg.to.id
                        redis:set(hash, matches[3])
                        if msg.to.type == 'chat' then
                            send_msg('chat#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'floodMax')..matches[3], ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            send_msg('channel#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'floodMax')..matches[3], ok_cb, false)
                        end
                    end
			elseif matches[2] == 'description' then
            local text = matches[3]
            local chat = 'channel#id'..msg.to.id
            if msg.to.type == 'channel' then
                channel_set_about(chat, text, ok_cb, false)
                return 'ℹ️ '..lang_text(msg.to.id, 'desChanged')
            else
                return 'ℹ️ '..lang_text(msg.to.id, 'desOnlyChannels')
            end
			end
            return
        else
            return '🚫 '..lang_text(msg.to.id, 'require_mod')
        end
    end
    if matches[1] == 'settings' then
        if permissions(msg.from.id, msg.to.id, "settings") then
                if msg.to.type == 'chat' then
                    text = '⚙ '..lang_text(msg.to.id, 'gSettings')..':\n\n'
                elseif msg.to.type == 'channel' then
                    text = '⚙ '..lang_text(msg.to.id, 'sSettings')..':\n\n'
                end
                local allowed = lang_text(msg.to.id, 'allowed')..' ✅'
                local noAllowed = lang_text(msg.to.id, 'noAllowed')..' 🚫'
                local sD = '💠'
				--Enable/disable Flood
                local hash = 'anti-flood:'..msg.to.id
                if redis:get(hash) then
                    sFlood = allowed
                else
                    sFlood = noAllowed
                end
                text = text..sD..' '..lang_text(msg.to.id, 'flood')..': '..sFlood..'\n\n'
				--Enable/disable bws
                local hash = 'badwords:'..msg.to.id
                if not redis:get(hash) then
                    sBadword = allowed
                else
                    sBadword = noAllowed
                end
                text = text..sD..' '..lang_text(msg.to.id, 'badwords')..': '..sBadword..'\n\n'
				--Enable/disable porns
                local hash = 'porns:'..msg.to.id
                if not redis:get(hash) then
                    sPorn = allowed
                else
                    sPorn = noAllowed
                end
                text = text..sD..' '..lang_text(msg.to.id, 'porns')..': '..sPorn..'\n\n'
				--Enable/disable adv
                local hash = 'spam:'..msg.to.id
                if redis:get(hash) then
                    sSpam = noAllowed
                else
                    sSpam = allowed
                end
                text = text..sD..' '..lang_text(msg.to.id, 'spam')..': '..sSpam..'\n\n'

                --Enable/disable arabic messages
                local hash = 'arabic:'..msg.to.id
                if not redis:get(hash) then
                    sArabe = allowed
                else
                    sArabe = noAllowed
                end
                text = text..sD..' '..lang_text(msg.to.id, 'arabic')..': '..sArabe..'\n\n'
                --Enable/disable bots
                local hash = 'antibot:'..msg.to.id
                if not redis:get(hash) then
                    sBots = allowed
                else
                    sBots = noAllowed
                end
                text = text..sD..' '..lang_text(msg.to.id, 'bots')..': '..sBots..'\n\n'
                --Lock/unlock numbers of channel members
                local hash = 'lockmember:'..msg.to.id
                if redis:get(hash) then
                    sLock = noAllowed
                else
                    sLock = allowed
                end
                text = text..sD..' '..lang_text(msg.to.id, 'glockmember')..': '..sLock..'\n\n'
				                --Enable/disable setphoto
                local hash = 'setphoto:'..msg.to.id
                if not redis:get(hash) then
                    sSPhoto = allowed
                else
                    sSPhoto = noAllowed
                end
                text = text..sD..' '..lang_text(msg.to.id, 'setphoto')..': '..sSPhoto..'\n\n'

                --Enable/disable changing group name
                local hash = 'name:'..msg.to.id
                if redis:get(hash) then
                    sName = noAllowed
                else
                    sName = allowed
                end
                text = text..sD..' '..lang_text(msg.to.id, 'gName')..': '..sName..'\n\n'
				--Enable/disable Stickers
                local hash = 'stickers:'..msg.to.id
                if redis:get(hash) then
                    sStickers = noAllowed
                else
                    sStickers = allowed
                end
                text = text..sD..' '..lang_text(msg.to.id, 'stickers')..': '..sStickers..'\n\n'
			    
                --Enable/disable send photos
                local hash = 'photo:'..msg.to.id
                if redis:get(hash) then
                    sPhoto = noAllowed
                else
                    sPhoto = allowed
                end
                text = text..sD..' '..lang_text(msg.to.id, 'photos')..': '..sPhoto..'\n\n'

                --Enable/disable gifs
                local hash = 'gifs:'..msg.to.id
                if redis:get(hash) then
                    sGif = noAllowed
                else
                    sGif = allowed
                end
                text = text..sD..' '..lang_text(msg.to.id, 'gifs')..': '..sGif..'\n\n'

                --Enable/disable send audios
                local hash = 'audio:'..msg.to.id
                if redis:get(hash) then
                    sAudio = noAllowed
                else
                    sAudio = allowed
                end
                text = text..sD..' '..lang_text(msg.to.id, 'audios')..': '..sAudio..'\n\n'

                --Enable/disable contacts
                local hash = 'contacts:'..msg.to.id
                if not redis:get(hash) then
                    sContact = allowed
                else
                    sContact = noAllowed
                end
                text = text..sD..' '..lang_text(msg.to.id, 'contacts')..': '..sContact..'\n\n'
				
                local hash = 'langset:'..msg.to.id
                if redis:get(hash) == 'fa' then
                    sLang = 'فارسی'
                elseif redis:get(hash) == 'en' then
                    sLang = 'English'
                else
                    sLang = lang_text(msg.to.id, 'noSet')
                end
                text = text..'🌐 '..lang_text(msg.to.id, 'language')..': '..sLang..'\n\n'
                local hash = 'flood:max:'..msg.to.id
                if not redis:get(hash) then
                    floodMax = 5
                else
                    floodMax = redis:get(hash)
                end

                local hash = 'flood:time:'..msg.to.id
                if not redis:get(hash) then
                    floodTime = 3
                else
                    floodTime = redis:get(hash)
                end

                text = text..'🔺 '..lang_text(msg.to.id, 'mFlood')..': '..floodMax..'\n\n🔺 '..lang_text(msg.to.id, 'tFlood')..': '..floodTime..'\n'            
                
                --Send settings to group or supergroup
                if msg.to.type == 'chat' then
                    send_msg('chat#id'..msg.to.id, text, ok_cb, false)
                elseif msg.to.type == 'channel' then
                    send_msg('channel#id'..msg.to.id, text, ok_cb, false)
                end
                return
        else
            return '🚫 '..lang_text(msg.to.id, 'require_mod')
        end
		elseif matches[1] == 'rem' then
        if permissions(msg.from.id, msg.to.id, "settings") then
            if msg.reply_id then
                get_message(msg.reply_id, remove_message, false)
                get_message(msg.id, remove_message, false)
            end
            return
        else
            return '🚫 '..lang_text(msg.to.id, 'require_mod')
        end
    elseif matches[1] == 'lang' then
        if permissions(msg.from.id, msg.to.id, "set_lang") then
            hash = 'langset:'..msg.to.id
            redis:set(hash, matches[2])
            return 'ℹ️ '..lang_text(msg.to.id, 'langUpdated')
        else
            return '🚫 '..lang_text(msg.to.id, 'require_sudo')
        end
    elseif matches[1] == 'newlink' then
        if permissions(msg.from.id, msg.to.id, "setlink") then
        	local receiver = get_receiver(msg)
            local hash = 'link:'..msg.to.id
    		local function cb(extra, success, result)
    			if result then
    				redis:set(hash, result)
    			end
	            if success == 0 then
	                return send_large_msg(receiver, 'I can\'t create a newlink.', ok_cb, true)
	            end
    		end
    		if msg.to.type == 'chat' then
                result = export_chat_link(receiver, cb, true)
            elseif msg.to.type == 'channel' then
                result = export_channel_link(receiver, cb, true)
            end
    		if result then
	            if msg.to.type == 'chat' then
	                send_msg('chat#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'linkSaved'), ok_cb, true)
	            elseif msg.to.type == 'channel' then
	                send_msg('channel#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'linkSaved'), ok_cb, true)
	            end
	        end
            return
        else
            return '?? '..lang_text(msg.to.id, 'require_admin')
        end
    elseif matches[1] == 'link' then
        if permissions(msg.from.id, msg.to.id, "link") then
            hash = 'link:'..msg.to.id
            local linktext = redis:get(hash)
            if linktext then
                if msg.to.type == 'chat' then
                    send_msg('chat#id'..msg.to.id, '🌐 '..lang_text(msg.to.id, 'groupLink')..': '..linktext, ok_cb, true)
                elseif msg.to.type == 'channel' then
                    send_msg('channel#id'..msg.to.id, '🌐 '..lang_text(msg.to.id, 'sGroupLink')..': '..linktext, ok_cb, true)
                end
            else
                if msg.to.type == 'chat' then
                    send_msg('chat#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'noLinkSet'), ok_cb, true)
                elseif msg.to.type == 'channel' then
                    send_msg('channel#id'..msg.to.id, 'ℹ️ '..lang_text(msg.to.id, 'noLinkSet'), ok_cb, true)
                end
            end
            return
        else
            return '🚫 '..lang_text(msg.to.id, 'require_mod')
        end
    elseif matches[1] == 'tosupergroup' then
        if msg.to.type == 'chat' then
            if permissions(msg.from.id, msg.to.id, "tosupergroup") then
                chat_upgrade('chat#id'..msg.to.id, ok_cb, false)
                return 'ℹ️ '..lang_text(msg.to.id, 'chatUpgrade')
            else
                return '🚫 '..lang_text(msg.to.id, 'require_sudo')
            end
        else
            return 'ℹ️ '..lang_text(msg.to.id, 'notInChann')
        end
    elseif matches[1] == 'setdescription' then
        if permissions(msg.from.id, msg.to.id, "description") then
            local text = matches[2]
            local chat = 'channel#id'..msg.to.id
            if msg.to.type == 'channel' then
                channel_set_about(chat, text, ok_cb, false)
                return 'ℹ️ '..lang_text(msg.to.id, 'desChanged')
            else
                return 'ℹ️ '..lang_text(msg.to.id, 'desOnlyChannels')
            end
        else
            return '🚫 '..lang_text(msg.to.id, 'require_admin')
        end
    elseif matches[1] == 'muteall' and matches[2] then
    	if permissions(msg.from.id, msg.to.id, "muteall") then
    		print(1)
    		local hash = 'muteall:'..msg.to.id
    		redis:setex(hash, tonumber(matches[2]), true)
    		print(2)
            return 'ℹ️ '..lang_text(msg.to.id, 'muteAllX:1')..' '..matches[2]..' '..lang_text(msg.to.id, 'muteAllX:2')
        else
            return '🚫 '..lang_text(msg.to.id, 'require_admin')
        end
    elseif matches[1] == 'muteall' then
    	if permissions(msg.from.id, msg.to.id, "muteall") then
    		local hash = 'muteall:'..msg.to.id
    		redis:set(hash, true)
            return 'ℹ️ '..lang_text(msg.to.id, 'muteAll')
        else
            return '🚫 '..lang_text(msg.to.id, 'require_admin')
        end
    elseif matches[1] == 'unmuteall' then
    	if permissions(msg.from.id, msg.to.id, "muteall") then
    		local hash = 'muteall:'..msg.to.id
    		redis:del(hash)
            return 'ℹ️ '..lang_text(msg.to.id, 'unmuteAll')
        else
            return '🚫 '..lang_text(msg.to.id, 'require_admin')
        end
    elseif matches[1] == 'creategroup' and matches[2] then
		if permissions(msg.from.id, msg.to.id, "creategroup") then
	            group_name = matches[2]
		    return create_group(msg, group_name)
		end
				   elseif matches[1] == 'pcreategroup' and matches[2] and matches[3] then
		if permissions(msg.from.id, msg.to.id, "creategroup") then
		    user_info('user#id'..matches[2], create_group2, {msg=msg, group_name=matches[3]})
		end
    elseif matches[1] == 'chat_created' and msg.from.id == 0 then
    table.insert(_chats.chats, {tonumber(msg.to.id), string.gsub(msg.to.title, '_', ' ')})
	print(msg.to.id..' added to _chats table')
	save_chats()
	local chat_id = msg.to.id
	chat_info('chat#id'..msg.to.id, owincreate, {chat_id=chat_id})
    end
end

return {
    patterns = {
        '^[!/#](settings)$',
		'^[!/#](set) ([^%s]+) (.*)$',
		'^[!/#](set) (.*)$',
        '^[!/#](lock) (.*)$',
        '^[!/#](unlock) (.*)$',
        '^[!/#](rem)$',
        '^[!/#](muteall)$',
        '^[!/#](muteall) (.*)$',
        '^[!/#](unmuteall)$',
        '^[!/#](link)$',
        '^[!/#](newlink)$',
        '^[!/#](tosupergroup)$',
        '^[!/#](lang) (.*)$',
        '^[!/#](creategroup) (.*)$',
        '^[!/#](pcreategroup) (%d*) (.*)$',
		'^[!/#](tophoto)$',
		'^[!/#](tosticker)$',
 		'^!!tgservice (.+)$'
    },
    pre_process = pre_process,
    run = run
}
end
