local function chat_list(msg)
    local message = '🔆 '..lang_text(msg.to.id, 'chatList')..'\nℹ️ '..lang_text(msg.to.id, 'joinchatHelp')..'\n\n'
    local compare = message
    for v,chat in pairs(_chats.chats) do
        message = message..'🔅 '..chat[2]..' ('..chat[1]..')\n'
    end
    if compare == message then
	message = message..'🔅 '..lang_text(msg.to.id, 'chatEmpty')
	end
    local file = io.open("./data/listed_groups.txt", "w")
    file:write(message)
    file:flush()
    file:close()
	return message
end
local function run(msg, matches)
    if matches[1] == 'chats' and permissions(msg.from.id, msg.to.id, "chatlist") then
		return chat_list(msg)
	end
	if matches[1] == 'chatlist' and permissions(msg.from.id, msg.to.id, "chatlist") then
		if msg.to.type == 'chat' or msg.to.type == 'channel' then
			chat_list(msg)
			send_document("chat#id"..msg.to.id, "./data/listed_groups.txt", ok_cb, false)
			send_document("channel#id"..msg.to.id, "./data/listed_groups.txt", ok_cb, false)
		elseif msg.to.type == 'user' then
			chat_list(msg)
			send_document("user#id"..msg.from.id, "./data/listed_groups.txt", ok_cb, false)
		end
		end
end
return {
patterns = {
    "^[#/!](chats)$",
    "^[#/!](chatlist)$"
    },
run = run
}