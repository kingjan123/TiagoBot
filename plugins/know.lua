local jocks_file = './data/jokes.lua'
local jocks_table
local know_file = './data/knows.lua'
local know_table
function read_jocks_file()
    local f = io.open(jocks_file, "r+")

    if f == nil then
        print ('Created a new jocks file on '..jocks_file)
        serialize_to_file({}, jocks_file)
    else
        print ('jokes loaded: '..jocks_file)
        f:close()
    end
    return loadfile (jocks_file)()
end
function read_know_file()
    local f = io.open(know_file, "r+")

    if f == nil then
        print ('Created a new know file on '..know_file)
        serialize_to_file({}, know_file)
    else
        print ('knows loaded: '..know_file)
        f:close()
    end
    return loadfile (know_file)()
end
function rem_jock(msg)
    local to_id = tostring(msg.to.id)
	local j = 0
    local jocks = jocks_table[to_id]
    if not jocks then
    return '🚫 '..lang_text(msg.to.id, 'require_noemjoke')
    end
	if #jocks == 0 then
    return '🚫 '..lang_text(msg.to.id, 'require_noemjoke')
    end
	for i=1, #jocks do
    if jocks[i] == msg.text:sub(10) then
    j = i
    end
end
if j == 0 then
    return '🚫 '..lang_text(msg.to.id, 'njockremoved')
end
	for k = j, #jocks do
    jocks[k] = jocks[k+1]
    end
    serialize_to_file(jocks_table, jocks_file)

    return 'ℹ️ '..lang_text(msg.to.id, 'jockremoved')
end
function save_jock(msg)
    local to_id = tostring(msg.to.id)
    
    if jocks_table == nil then
        jocks_table = {}
    end

    if jocks_table[to_id] == nil then
        print ('New jock key to_id: '..to_id)
        jocks_table[to_id] = {}
    end
    local jocks = jocks_table[to_id]
	for i=1, #jocks do
    if jocks[i] == msg.text:sub(10) then
	return '🚫 '..lang_text(msg.to.id, 'require_rjoke')
    end
    end
    jocks[#jocks+1] = msg.text:sub(10)

    serialize_to_file(jocks_table, jocks_file)

    return 'ℹ️ '..lang_text(msg.to.id, 'jockadded')
end
function rem_know(msg)
    local to_id = tostring(msg.to.id)
	local j = 0
    local knows = know_table[to_id]
    if not knows then
    return '🚫 '..lang_text(msg.to.id, 'require_noemknow')
    end
	if #knows == 0 then
    return '🚫 '..lang_text(msg.to.id, 'require_noemknow')
    end
	for i=1, #knows do
    if knows[i] == msg.text:sub(10) then
    j = i
    end
end
if j == 0 then
    return '🚫 '..lang_text(msg.to.id, 'nknowremoved')
end
	for k = j, #knows do
    knows[k] = knows[k+1]
    end
    serialize_to_file(know_table, know_file)

    return 'ℹ️ '..lang_text(msg.to.id, 'knowremoved')
end
function save_know(msg)
    local to_id = tostring(msg.to.id)
    
    if know_table == nil then
        know_table = {}
    end

    if know_table[to_id] == nil then
        print ('New jock key to_id: '..to_id)
        know_table[to_id] = {}
    end
    local knows = know_table[to_id]
    for i=1, #knows do
    if knows[i] == msg.text:sub(10) then
	return '🚫 '..lang_text(msg.to.id, 'require_rknow')
    end
    end
    knows[#knows+1] = msg.text:sub(10)

    serialize_to_file(know_table, know_file)

    return 'ℹ️ '..lang_text(msg.to.id, 'knowadded')
end
function rem_gjock(msg)
    local to_id = 'gjoke'
	local j = 0
    local jocks = jocks_table[to_id]
    if not jocks then
    return '🚫 '..lang_text(msg.to.id, 'require_gnoemjoke')
    end
	if #jocks == 0 then
    return '🚫 '..lang_text(msg.to.id, 'require_gnoemjoke')
    end
	for i=1, #jocks do
    if jocks[i] == msg.text:sub(11) then
    j = i
    end
end
if j == 0 then
    return '🚫 '..lang_text(msg.to.id, 'ngjockremoved')
end
	for k = j, #jocks do
    jocks[k] = jocks[k+1]
    end
    serialize_to_file(jocks_table, jocks_file)

    return 'ℹ️ '..lang_text(msg.to.id, 'gjockremoved')
end
function save_gjock(msg)
    local to_id = 'gjoke'
    
    if jocks_table == nil then
        jocks_table = {}
    end

    if jocks_table[to_id] == nil then
        print ('New jock key to_id: '..to_id)
        jocks_table[to_id] = {}
    end
    local jocks = jocks_table[to_id]
	for i=1, #jocks do
    if jocks[i] == msg.text:sub(11) then
	return '🚫 '..lang_text(msg.to.id, 'require_grjoke')
    end
    end
    jocks[#jocks+1] = msg.text:sub(11)

    serialize_to_file(jocks_table, jocks_file)

    return 'ℹ️ '..lang_text(msg.to.id, 'gjockadded')
end
function rem_gknow(msg)
    local to_id = 'gknow'
	local j = 0
    local knows = know_table[to_id]
    if not knows then
        return '🚫 '..lang_text(msg.to.id, 'require_gnoemknow')
    end
	if #knows == 0 then
    return '🚫 '..lang_text(msg.to.id, 'require_gnoemknow')
    end
	for i=1, #knows do
    if knows[i] == msg.text:sub(11) then
    j = i
    end
end
if j == 0 then
    return '🚫 '..lang_text(msg.to.id, 'ngknowremoved')
end
	for k = j, #knows do
    knows[k] = knows[k+1]
    end
    serialize_to_file(know_table, know_file)

    return 'ℹ️ '..lang_text(msg.to.id, 'gknowremoved')
end
function save_gknow(msg)
    local to_id = 'gknow'
    
    if know_table == nil then
        know_table = {}
    end

    if know_table[to_id] == nil then
        print ('New jock key to_id: '..to_id)
        know_table[to_id] = {}
    end
    local knows = know_table[to_id]
	for i=1, #knows do
    if knows[i] == msg.text:sub(11) then
	return '🚫 '..lang_text(msg.to.id, 'require_grknow')
    end
    end
    knows[#knows+1] = msg.text:sub(11)

    serialize_to_file(know_table, know_file)

    return 'ℹ️ '..lang_text(msg.to.id, 'gknowadded')
end
function get_jock(msg)
    local to_id = tostring(msg.to.id)
    local jocks_phrases

    jocks_table = read_jocks_file()
    jocks_phrases = jocks_table[to_id]
    if not jocks_phrases then
        return '🚫 '..lang_text(msg.to.id, 'require_noemjoke')
    end
        if #jocks_phrases == 0 then
        return '🚫 '..lang_text(msg.to.id, 'require_noemjoke')
    end
    return '😂 جوک تصادفی: '..jocks_phrases[math.random(1,#jocks_phrases)]
end
function get_know(msg)
    local to_id = tostring(msg.to.id)
    local knows_phrases

    know_table = read_know_file()
    knows_phrases = know_table[to_id]
    if not knows_phrases then
        return '🚫 '..lang_text(msg.to.id, 'require_noemknow')
    end
        if #knows_phrases == 0 then
        return '🚫 '..lang_text(msg.to.id, 'require_noemknow')
    end
    return '‼️ دانستنی تصادفی: '..knows_phrases[math.random(1,#knows_phrases)]
end
function get_gjock(msg)
    local jocks_phrases

    jocks_table = read_jocks_file()
    jocks_phrases = jocks_table["gjoke"]
    if not jocks_phrases then
        return '🚫 '..lang_text(msg.to.id, 'require_gnoemjoke')
    end
    if #jocks_phrases == 0 then
    return '🚫 '..lang_text(msg.to.id, 'require_gnoemjoke')
    end
    return '😂 جوک تصادفی: '..jocks_phrases[math.random(1,#jocks_phrases)]
end
function get_gknow(msg)
    local knows_phrases

    know_table = read_know_file()
    knows_phrases = know_table["gknow"]
    if not knows_phrases then
        return '🚫 '..lang_text(msg.to.id, 'require_gnoemknow')
    end
            if #knows_phrases == 0 then
        return '🚫 '..lang_text(msg.to.id, 'require_gnoemknow')
    end
    return '‼️ دانستنی تصادفی: '..knows_phrases[math.random(1,#knows_phrases)]
end
local function run(msg, matches)
if matches[1] == 'know' then
return get_know(msg)
elseif matches[1] == 'joke' then
return get_jock(msg)
elseif matches[1] == 'gknow' then
return get_gknow(msg)
elseif matches[1] == 'gjoke' then
return get_gjock(msg)
elseif matches[1] == 'addjoke' then
if not matches[2] then
return '🚫 '..lang_text(msg.to.id, 'require_joke')
end
if permissions(msg.from.id, msg.to.id, "jokeknow") then
jocks_table = read_jocks_file()
return save_jock(msg)
else
return '🚫 '..lang_text(msg.to.id, 'require_owner')
end
elseif matches[1] == 'remjoke' then
if not matches[2] then
return '🚫 '..lang_text(msg.to.id, 'require_joke')
end
if permissions(msg.from.id, msg.to.id, "jokeknow") then
jocks_table = read_jocks_file()
return rem_jock(msg)
else
return '🚫 '..lang_text(msg.to.id, 'require_owner')
end
elseif matches[1] == 'gremjoke' then
if not matches[2] then
return '🚫 '..lang_text(msg.to.id, 'require_joke')
end
if permissions(msg.from.id, msg.to.id, "gjokeknow") then
jocks_table = read_jocks_file()
return rem_gjock(msg)
else
return '🚫 '..lang_text(msg.to.id, 'require_admin')
end
elseif matches[1] == 'remknow' then
if not matches[2] then
return '🚫 '..lang_text(msg.to.id, 'require_know')
end
if permissions(msg.from.id, msg.to.id, "jokeknow") then
know_table = read_know_file()
return rem_know(msg)
else
return '🚫 '..lang_text(msg.to.id, 'require_owner')
end
elseif matches[1] == 'gremknow' then
if not matches[2] then
return '🚫 '..lang_text(msg.to.id, 'require_know')
end
if permissions(msg.from.id, msg.to.id, "gjokeknow") then
know_table = read_know_file()
return rem_gknow(msg)
else
return '🚫 '..lang_text(msg.to.id, 'require_admin')
end
elseif matches[1] == 'addknow' then
if not matches[2] then
return '🚫 '..lang_text(msg.to.id, 'require_know')
end
if permissions(msg.from.id, msg.to.id, "jokeknow") then
know_table = read_know_file()
return save_know(msg)
else
return '🚫 '..lang_text(msg.to.id, 'require_owner')
end
elseif matches[1] == 'gaddjoke' then
if not matches[2] then
return '🚫 '..lang_text(msg.to.id, 'require_joke')
end
if permissions(msg.from.id, msg.to.id, "gjokeknow") then
jocks_table = read_jocks_file()
return save_gjock(msg)
else
return '🚫 '..lang_text(msg.to.id, 'require_admin')
end
elseif matches[1] == 'gaddknow' then
if not matches[2] then
return '🚫 '..lang_text(msg.to.id, 'require_know')
end
if permissions(msg.from.id, msg.to.id, "gjokeknow") then
know_table = read_know_file()
return save_gknow(msg)
else
return '🚫 '..lang_text(msg.to.id, 'require_admin')
end
end
end
return {
patterns = {
    "^[#/!](know)$",
    "^[#/!](gknow)$",
    "^[#/!](joke)$",
    "^[#/!](gjoke)$",
    "^[#/!](addjoke) (.+)$",
    "^[#/!](addjoke)$",
    "^[#/!](remjoke) (.+)$",
    "^[#/!](remjoke)$",
    "^[#/!](gaddjoke) (.+)$",
    "^[#/!](gaddjoke)$",
    "^[#/!](gremjoke) (.+)$",
    "^[#/!](gremjoke)$",
    "^[#/!](addknow) (.+)$",
    "^[#/!](addknow)$",
    "^[#/!](remknow) (.+)$",
    "^[#/!](remknow)$",
    "^[#/!](gaddknow) (.+)$",
    "^[#/!](gaddknow)$",
    "^[#/!](gremknow) (.+)$",
    "^[#/!](gremknow)$"
    },
run = run
}