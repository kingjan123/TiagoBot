--------------------------------------------------
--                                              --
--------------------------------------------------
--                                              --
--Developers: @Josepdal & @MaSkAoS @kingjan123  --
--     Support: @mohammad_zaq     --
--                                              --
--------------------------------------------------
function run(msg, matches)
  if matches[1] == 'help' then
  return lang_text(msg.to.id, 'thelp')
  end
  if matches[1] == 'ownercmds' then
if permissions(msg.from.id, msg.to.id, "ownercmds") then
  return lang_text(msg.to.id, 'townercmds')
else
return "🚫 "..lang_text(msg.to.id, 'require_owner')
end
end
  if matches[1] == 'modcmds' then
if permissions(msg.from.id, msg.to.id, "modcmds") then
  return lang_text(msg.to.id, 'tmodcmds')
else
return "🚫 "..lang_text(msg.to.id, 'require_mod')
end
end
  if matches[1] == 'admincmds' then
if permissions(msg.from.id, msg.to.id, "admincmds") then
  return lang_text(msg.to.id, 'tadmincmds')
else
return "🚫 "..lang_text(msg.to.id, 'require_admin')
end
end
  if matches[1] == 'sudocmds' then
if permissions(msg.from.id, msg.to.id, "sudocmds") then
  return lang_text(msg.to.id, 'tsudocmds')
  else
return "🚫 "..lang_text(msg.to.id, 'require_sudo')
end
end
  if matches[1] == 'funcmds' then
  return lang_text(msg.to.id, 'tfuncmds')
  end
  if matches[1] == 'cmds' then
  return lang_text(msg.to.id, 'tcmds')
  end
end
return {
patterns = {
"^[/!#](help)$",
"^[/!#](cmds)$",
"^[/!#](ownercmds)$",
"^[/!#](sudocmds)$",
"^[/!#](admincmds)$",
"^[/!#](modcmds)$",
"^[/!#](funcmds)$"
}, 
run = run 
}