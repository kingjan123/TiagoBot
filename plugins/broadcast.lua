local function run(msg, matches)
	if matches[1] == 's2a' then
		if permissions(msg.from.id, msg.to.id, "chatlist") then
    for v,chat in pairs(_chats.chats) do
				local response = matches[2]
				send_msg('chat#id'..chat[1], response,ok_cb,false)
				send_msg('channel#id'..chat[1], response,ok_cb,false)
			end
		else
			return '🚫 '..lang_text(msg.to.id, 'require_admin')
		end
	end
end
return {
  patterns = {
    "^[#!/](s2a) (.+)$"
  },
  run = run
}
