local filename='data/remind.lua'
local cronned = load_from_file(filename)

local function save_cron(msg, text,date)
  local origin = get_receiver(msg)
  if not cronned[date] then
    cronned[date] = {}
  end
  local arr = { origin,  text } ;
  table.insert(cronned[date], arr)
  serialize_to_file(cronned, filename)
  return
end

local function delete_cron(date)
  for k,v in pairs(cronned) do
    if k == date then
	  cronned[k]=nil
    end
  end
  serialize_to_file(cronned, filename)
end

local function cron()
  for date, values in pairs(cronned) do
  	if date < os.time() then --time's up
	  	send_msg(values[1][1], "️❗یادآوری:\n"..values[1][2], ok_cb, false)
  		delete_cron(date) --TODO: Maybe check for something else? Like user
	end

  end
end

local function actually_run(msg, delay,text)
  save_cron(msg, text,delay)
  return "❗️  من در تاریخ " .. os.date("%x درزمان %H:%M",delay+16200) .. "به شما درباره:\n"..text.."\nیاد آوری میکنم\nتاریخ کنونی:" .. os.date("%x زمان کنونی: %H:%M:%S",os.time() + 16200)
end
local function run(msg, matches)
if not matches[1] or not matches[2] then
return lang_text(msg.to.id, 'seefcmds')
end

  local sum = 0
    local b,_ = string.gsub(matches[1],"[a-zA-Z]","")
    if string.find(matches[1], "m") then
      sum=sum+b*60
    end
    if string.find(matches[1], "h") then
      sum=sum+b*3600
    end
  local date=sum+os.time()
  local text = matches[2]

  local text = actually_run(msg, date, text)
  return text
end

return {
  description = "remind plugin",
  usage = {
  	"!remind 2h0m text"
  },
  patterns = {
    "^[!/#]remind ([0-9]+[hmHM]) (.+)$",
  }, 
  run = run,
  cron = cron
}