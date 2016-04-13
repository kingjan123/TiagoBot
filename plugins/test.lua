
local function run(msg)
    local text = 'ℹ️ '..msg.to.peer_id..','..msg.to.id
send_msg('channel#id'..msg.to.id, '\u0627', ok_cb, true)
print('\u0627')
end
return {
patterns = {
    "^[#!/]test$"
    },
run = run
}