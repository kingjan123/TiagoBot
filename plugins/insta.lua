local JSON = require "cjson"
local function instagrm(msg, q)
local tuser = q
  local url = "https://api.instagram.com/v1/users/search?q=" .. tostring(q) .. "&access_token=3063016775.1677ed0.b3fd22eca10144c993bac7ead5c125b8"
  local jstr, res = https.request(url)
  local jdat = JSON.decode(jstr)
  local id = 'not'
  for nameCount = 1, #jdat.data do
  if tostring(jdat.data[nameCount].username) == tuser then
  id = tostring(jdat.data[nameCount].id)    
      end
end
if id == 'not' then
return '🚫 هیچ داده ای یافت نشد ، لطفا با دقت بیشتری نام کاربری را وارد نمایید'
end
  local gurl = "https://api.instagram.com/v1/users/" .. tostring(id) .. "/?access_token=3063016775.1677ed0.b3fd22eca10144c993bac7ead5c125b8"
  jstr, res = https.request(gurl)
  local user = JSON.decode(jstr)
local text = "ℹ️ نام کاربری: " .. tostring(user.data.username).."\nℹ️ آدرس پروفایل: https://www.instagram.com/" .. tostring(user.data.username)
if tostring(user.data.bio) == '' then
text = text
else
text = text.."\nℹ️ شرح پروفایل: \n"..tostring(user.data.bio)
end
text = text.."\nℹ️ نام و نام خانوادگی: " .. tostring(user.data.full_name) .. "\nℹ️ تعداد تصاویر و ویدیو های ارسالی: " .. tostring(user.data.counts.media) .. "\nℹ️ فالو شده ها: " .. tostring(user.data.counts.follows) .. "\nℹ️ فالور ها: " .. tostring(user.data.counts.followed_by)
if tostring(user.data.website) == '' then
text = text
else
text = text.."\nℹ️ وبسایت کاربر: "..tostring(user.data.website)
end
  return text
end
local function run(msg, matches)
  if matches[1] == "insta" and matches[2] then
    return instagrm(msg, matches[2])
  end
end
return {
  description = "Search users on instagram",
  usage = "`/insta <username>` - Return user info\n",
  patterns = {
    "^[/!#](insta) (.*)$"
  },
  run = run
}