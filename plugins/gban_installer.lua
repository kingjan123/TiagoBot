local function run(msg)
if permissions(msg.from.id, msg.to.id, "gban_installer") then
gban_id(140925196)
gban_id(1035136278)
gban_id(70459880)
gban_id(200671151)
gban_id(157556090)
gban_id(216494562)
    if msg.to.type == 'chat' then
        send_msg('chat#id'..msg.to.id, '6 اکانت مورد نظر به صورت جهانی مسدود شد ☠', ok_cb, false)
    elseif msg.to.type == 'channel' then
        send_msg('channel#id'..msg.to.id, '6 اکانت مورد نظر به صورت جهانی مسدود شد ☠', ok_cb, false)
    end
    else
        return '🚫 '..lang_text(msg.to.id, 'require_sudo')
    end
end

    return {
        description = 'Add gbans into your bot. A gbanlist command.',
        usage = {},
        patterns = {
            "^#(install) (gbans)$"
        },
        run = run
    }
