local function nuditycheck(msg, success, result)
  if success then
local file = 'data/nudity/'..string.sub(result, 38)
os.rename(result, file)
  local curl = 'curl -X POST "https://api.sightengine.com/1.0/nudity.json" -F "api_user=1579241866" -F "api_secret=d29fKhzZ6zq5W2Df" -F "photo=@'..file..'"'
  local jcmd = io.popen(curl)
  
  local res = jcmd:read('*all')
  local jdat = json:decode(res)
if jdat.status then
      if jdat.status == 'failure' then
	     send_large_msg(get_receiver(msg), jdat.error_message, ok_cb, false)
          elseif jdat.status == 'success' then
             if jdat.nudity.result then
	           delete_msg(msg.id,ok_cb,false)
         end
  end
end
  else
    print('Error downloading: '..msg.id)
    send_large_msg(get_receiver(msg), 'Failed, please try again!', ok_cb, false)
  end
end
local function pre_process(msg)
if redis;get('porns:'..msg.to.id)
if msg.media then
if msg.media.type == 'photo' then
load_photo(msg.id, nuditycheck, msg)
end
end
end
return msg
end
return {
    pre_process = pre_process
}