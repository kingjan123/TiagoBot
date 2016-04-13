api_key = 'AIzaSyBpbmuB8-3ihywbqxMvOaqEZmoZOPgcjqA'

base_api = "https://maps.googleapis.com/maps/api"
timeFormat = "%H:%M:%S"

-- Need the utc time for the google api
function utctime()
  return os.time(os.date("!*t"))
end

-- Use the geocoding api to get the lattitude and longitude with accuracy specifier
-- CHECKME: this seems to work without a key??
function get_latlong(area)
  print('oki')
  local api      = base_api .. "/geocode/json?"
  local parameters = "address=".. (URL.escape(area) or "")
    parameters = parameters.."&key=AIzaSyBpbmuB8-3ihywbqxMvOaqEZmoZOPgcjqA"

  -- Do the request
  local curl = 'curl -X GET "'..api..parameters..'"'
  cmd = io.popen(curl)
  local res = cmd:read('*all')
  local data = json:decode(res)
  if (data.status == "ZERO_RESULTS") then
    return nil
  end
  if (data.status == "OK") then
    -- Get the data
    lat  = data.results[1].geometry.location.lat
    lng  = data.results[1].geometry.location.lng
    acc  = data.results[1].geometry.location_type
    fadd= data.results[1].formatted_address
  end
end

-- Use timezone api to get the time in the lat,
-- Note: this needs an API key
function get_time(lat,lng)
  local api  = base_api .. "/timezone/json?"

  -- Get a timestamp (server time is relevant here)
  local timestamp = utctime()
  local parameters = "location=" ..
    URL.escape(lat) .. "," ..
    URL.escape(lng) .. 
    "&timestamp="..URL.escape(timestamp)
  if api_key ~=nil then
    parameters = parameters .. "&key="..api_key
  end

  local res,code = https.request(api..parameters)
  if code ~= 200 then return nil end
  local data = json:decode(res)
  
  if (data.status == "ZERO_RESULTS") then
    return nil
  end
  if (data.status == "OK") then
    -- Construct what we want
    -- The local time in the location is:
    -- timestamp + rawOffset + dstOffset
    local localTime = timestamp + data.rawOffset + data.dstOffset
    return localTime, data.timeZoneId
  end
  return localTime
end

function getformattedLocalTime(area)
   get_latlong(area)
  if lat == nil and lng == nil then
    return 'هیچ نتیجه ای برای  "'..area..'" موجود نیست لطفا با دقت بیشتری منطقه وارد نمایید.'
  end
  local localTime, timeZoneId = get_time(lat,lng)
  return "⏱تاریخ و زمان کنونی در : "..fadd.."\n🕒زمان:"..os.date(timeFormat,localTime)
end

function run(msg, matches)
  if matches[2] then
    return getformattedLocalTime(matches[2])
  else
    return getformattedLocalTime('iran')
  end
end

return {
  description = "Displays the local time in an area", 
  usage = "time [area]: Displays the local time in that area",
  patterns = {
  "^[!/#](time) (.*)$",
  "^[!/#](time)$",
  }, 
  run = run
}