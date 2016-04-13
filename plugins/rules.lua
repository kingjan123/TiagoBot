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
--			Created by @Josepdal & @A7F			--
--												--
--------------------------------------------------

local function set_rules_channel(msg, text)
  	local rules = text
  	local hash = 'channel:id:'..msg.to.id..':rules'
  	redis:set(hash, rules)
end

local function del_rules_channel(chat_id)
  	local hash = 'channel:id:'..chat_id..':rules'
  	redis:del(hash)
end
local function set_wmsg_channel(msg, text)
  	local wmsg = text
  	local hash = 'chat:'..msg.to.id..':tdesc'
  	redis:set(hash, wmsg)
end

local function del_wmsg_channel(chat_id)
  	local hash = 'chat:'..chat_id..':tdesc'
  	redis:del(hash)
end
local function init_def_rules(chat_id)
  	local rules = 'ℹ️ Rules:\n'
              ..'1⃣ No Flood.\n'
              ..'2⃣ No Spam.\n'
              ..'3⃣ Try to stay on topic.\n'
              ..'4⃣ Forbidden any racist, sexual, homophobic or gore content.\n'
              ..'➡️ Repeated failure to comply with these rules will cause ban.'
              
  	local hash='channel:id:'..chat_id..':rules'
  	redis:set(hash, rules)
end
local function init_def_desc(chat_id)
  	local desc = 'سلام TNAME (TUSERNAME)عزیز\nبه گروه TGPNAME خوش آمدید ، شما میتوانید به کمک دستور /help راهنمایی دریافت کنید.'
              
  	local hash='chat:'..chat_id..':tdesc'
  	redis:set(hash, desc)
end

local function ret_rules_channel(msg)
  	local chat_id = msg.to.id
  	local hash = 'channel:id:'..msg.to.id..':rules'
  	if redis:get(hash) then
  		return redis:get(hash)
  	else
  		init_def_rules(chat_id)
  		return redis:get(hash)
  	end
end
local function ret_wmsg_channel(msg)
  	local chat_id = msg.to.id
  	local hash = 'chat:'..msg.to.id..':tdesc'
  	if redis:get(hash) then
  		return redis:get(hash)..'\n\n❗️'..lang_text(msg.to.id, 'wmsgh')
  	else
  		init_def_desc(chat_id)
  		return redis:get(hash)..'\n\n❗️'..lang_text(msg.to.id, 'wmsgh')
  	end
end

local function run(msg, matches)
  
    if matches[1] == 'rules' then
      	return ret_rules_channel(msg)
    elseif matches[1] == 'wmsg' then
    return ret_wmsg_channel(msg)
    elseif matches[1] == 'setrules' then
    	if permissions(msg.from.id, msg.to.id, 'rules') then
    		set_rules_channel(msg, matches[2])
    		return 'ℹ️ '..lang_text(msg.to.id, 'setRules')
  		else
  		  return "🚫 "..lang_text(msg.to.id, 'require_owner')
    	end
    elseif matches[1] == 'remrules' then
    	if permissions(msg.from.id, msg.to.id, 'rules') then
    		del_rules_channel(msg.to.id)
    		return 'ℹ️ '..lang_text(msg.to.id, 'remRules')
    		else
  		  return "🚫 "..lang_text(msg.to.id, 'require_owner')
		  end
		      elseif matches[1] == 'setwmsg' then
    	if permissions(msg.from.id, msg.to.id, 'wmsg') then
    		set_wmsg_channel(msg, matches[2])
    		return 'ℹ️ '..lang_text(msg.to.id, 'wmsg')
  		else
  		  return "🚫 "..lang_text(msg.to.id, 'require_owner')
    	end
    elseif matches[1] == 'remwmsg' then
    	if permissions(msg.from.id, msg.to.id, 'rules') then
    		del_wmsg_channel(msg.to.id)
    		return 'ℹ️ '..lang_text(msg.to.id, 'rwmsg')
    		else
  		  return "🚫 "..lang_text(msg.to.id, 'require_owner')
  		  end
    end
    
end

return {
  patterns = {
    '^[#/!](rules)$',
    '^[#/!](wmsg)$',
    '^[#/!](setrules) (.+)$',
    '^[#/!](remrules)$',
    '^[#/!](setwmsg) (.+)$',
    '^[#/!](remwmsg)$'
  }, 
  run = run 
}