local function addword(msg, name)
    local hash = 'chat:'..msg.to.id..':badword'
    redis:hset(hash, name, 'newword')
    return "کلمه جدید به فیلتر کلمات اضافه شد\n>"..name
end
local function gaddword(msg, name)
    local hash = 'bot:badword'
    redis:hset(hash, name, 'newword')
    return "کلمه جدید به فیلتر کلمات اضافه شد\n>"..name
end
local function get_variables_hash(msg)
 return 'chat:'..msg.to.id..':badword'
end 
local function gget_variables_hash(msg)
 return 'bot:badword'
end 
local function list_variablesbad(msg)
  local hash = get_variables_hash(msg)
  local ghash = gget_variables_hash(msg)
  local text = '❌ لیست کلمات غیر مجاز:\n\n📛کلمات غیر مجاز روبات:\n\n'
  if ghash then
    local names = redis:hkeys(ghash)
    for i=1, #names do
      text = text..'> '..names[i]..'\n'
end
else
text = text..'وجود ندارد.\n'
end
text=text..' \n⛔️کلمات غیر مجاز چت:\n\n'
if hash then
    local cnames = redis:hkeys(hash)
    for i=1, #cnames do
      text = text..'> '..cnames[i]..'\n'
end
    else
text = text..'وجود ندارد.\n'
end
    return text
end
function clear_commandbad(msg, var_name)
  --Save on redis  
  local hash = get_variables_hash(msg)
  redis:del(hash, var_name)
  return 'پاک شدند'
end
function gclear_commandbad(msg, var_name)
  --Save on redis  
  local hash = gget_variables_hash(msg)
  redis:del(hash, var_name)
  return 'پاک شدند'
end
local function list_variables2(msg, value)
  local chhash = 'badwords:'..msg.to.id
  if redis:get(chhash) then
  local hash = get_variables_hash(msg)
  local ghash = gget_variables_hash(msg)
  if hash then
    local cnames = redis:hkeys(hash)
    for i=1, #cnames do
	if string.match(value, cnames[i]) and not permissions(msg.from.id, msg.to.id, "badwp") then
	if msg.to.type == 'channel' then
	delete_msg(msg.id,ok_cb,false)
	end
end
    end
  end
if ghash then
    local names = redis:hkeys(ghash)
    for i=1, #names do
	if string.match(value, names[i]) and not permissions(msg.from.id, msg.to.id, "badwp") then
	if msg.to.type == 'channel' then
	delete_msg(msg.id,ok_cb,false)
	end
end
    end
end
end
end
local function get_valuebad(msg, var_name)
  local hash = get_variables_hash(msg)
  if hash then
    local value = redis:hget(hash, var_name)
    if not value then
      return
    else
      return value
    end
  end
end
function clear_commandsbad(msg, cmd_name)
  --Save on redis  
  local hash = get_variables_hash(msg)
  redis:hdel(hash, cmd_name)
  return ''..cmd_name..'  پاک شد'
end
function gclear_commandsbad(msg, cmd_name)
  --Save on redis  
  local hash = get_variables_hash(msg)
  redis:hdel(hash, cmd_name)
  return ''..cmd_name..'  پاک شد'
end

local function run(msg, matches)
  if matches[1] == 'aw' then
  if not permissions(msg.from.id, msg.to.id, "badw") then
   return "🚫 "..lang_text(msg.to.id, 'require_owner')
  end
   if not matches[2] then
  return "🚫 "..lang_text(msg.to.id, 'require_vv')
  end
  local name = string.sub(matches[2], 1, 50)

  local text = addword(msg, name)
  return text
  elseif matches[1] == 'gaw' then
  if not permissions(msg.from.id, msg.to.id, "gbadw") then
   return "🚫 "..lang_text(msg.to.id, 'require_admin')
  end
       if not matches[2] then
  return "🚫 "..lang_text(msg.to.id, 'require_vv')
  end
  local name = string.sub(matches[2], 1, 50)

  local text = gaddword(msg, name)
  return text
  elseif matches[1] == 'bwlist' then
  return list_variablesbad(msg)
  elseif matches[1] == 'clearbw' then
if not permissions(msg.from.id, msg.to.id, "badw") then
return "🚫 "..lang_text(msg.to.id, 'require_owner')
end
   if not matches[2] then
  return "🚫 "..lang_text(msg.to.id, 'require_vv')
  end
  local asd = '1'
    return clear_commandbad(msg, asd)
      elseif matches[1] == 'gclearbw' then
if not permissions(msg.from.id, msg.to.id, "gbadw") then
return "🚫 "..lang_text(msg.to.id, 'require_admin')
end
     if not matches[2] then
  return "🚫 "..lang_text(msg.to.id, 'require_vv')
  end
  local asd = '1'
    return gclear_commandbad(msg, asd)
  elseif matches[1] == 'rw' then
   if not permissions(msg.from.id, msg.to.id, "badw") then
  return "🚫 "..lang_text(msg.to.id, 'require_owner')
  end
       if not matches[2] then
  return "🚫 "..lang_text(msg.to.id, 'require_vv')
  end
    return clear_commandsbad(msg, matches[2])
      elseif matches[1] == 'grw' then
   if not permissions(msg.from.id, msg.to.id, "gbadw") then
  return "🚫 "..lang_text(msg.to.id, 'require_admin')
  end
     if not matches[2] then
  return "🚫 "..lang_text(msg.to.id, 'require_vv')
  end
    return gclear_commandsbad(msg, matches[2])
  else
    local name = msg.from.print_name
  
    return list_variables2(msg, matches[1])
  end
end

return {
  patterns = {
    "^[!/#](rw) (.*)$",
    "^[!/#](aw) (.*)$",
    "^[!/#](bwlist)$",
    "^[!/#](clearbw)$",
    "^[!/#](grw) (.*)$",
    "^[!/#](gaw) (.*)$",
    "^[!/#](gclearbw)$",
    "^(.+)$",
	   
  },
  run = run
}
