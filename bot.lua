SUDOA = '432689914' -- ایدی خود را وارد کنید
color = {
black = {30, 40},
red = {31, 41},
green = {32, 42},
yellow = {33, 43},
blue = {34, 44},
magenta = {35, 45},
cyan = {36, 46},
white = {37, 47}
}
utf8 = dofile('./libs/utf8.lua')
redis = dofile('./libs/redis.lua')
function is_koni(msg)
  local var = false
 for v,user in pairs({130228519}) do
    if user == msg.sender_user_id then
      var = true
    end
end
  if redis:sismember('dosh'..SUDOA..'man', msg.sender_user_id) then
    var = true
  end
  return var
end
function Action(chatid, act,kir)
assert (tdbot_function ({
_ = 'sendChatAction',
chat_id = chatid,
action = {
_ = 'chatAction' .. act,
progress = kir or 100
},
},  dl_cb,nil))
end
function forwardMessage(chat_id, from_chat_id, message_id,from_background)
assert (tdbot_function ({
_ = "forwardMessages",
chat_id = chat_id,
from_chat_id = from_chat_id,
message_ids = message_id,
disable_notification = 0,
from_background = from_background
}, dl_cb, nil))
end
function KickUser(chat_id, user_id)
tdbot_function ({
_ = "changeChatMemberStatus",
chat_id = chat_id,
user_id = user_id,
status = {
_ = "chatMemberStatusBanned"
},
}, dl_cb, nil)
end
function SendMetion(chat_id, user_id, msg_id, text, offset, length)
  assert (tdbot_function ({
    _ = "sendMessage",
    chat_id = chat_id,
    reply_to_message_id = msg_id,
    disable_notification = 0,
    from_background = true,
    reply_markup = nil,
    input_message_content = {
      _ = "inputMessageText",
      text = text,
      disable_web_page_preview = 1,
      clear_draft = false,
      entities = {[0] = {
      offset =  offset,
      length = length,
      _ = "textEntity",
      type = {user_id = user_id, _ = "textEntityTypeMentionName"}}}
    }
  }, dl_cb, nil))
end
function deleteMessages(chat_id, message_ids)
tdbot_function ({
_= "deleteMessages",
chat_id = chat_id,
message_ids = message_ids
}, dl_cb, nil)
end
function Restrict(chat_id, user_id, Restricted, right)
local chat_member_status = {}
if Restricted == 'Restricted' then
chat_member_status = {
is_member = right[1] or 1,
restricted_until_date = right[2] or 0,
can_send_messages = right[3] or 1,
can_send_media_messages = right[4] or 1,
can_send_other_messages = right[5] or 1,
can_add_web_page_previews = right[6] or 1
}
chat_member_status._ = 'chatMemberStatus' .. Restricted
assert (tdbot_function ({
_ = 'changeChatMemberStatus',
chat_id = chat_id,
user_id = user_id,
status = chat_member_status
}, dl_cb, nil))
end
end
local function getInputFile(file, conversion_str, expectedsize)
  local input = tostring(file)
  local infile = {}
  if (conversion_str and expectedsize) then
    infile = {
      _ = 'inputFileGenerated',
      original_path = tostring(file),
      conversion = tostring(conversion_str),
      expected_size = expectedsize
    }
  else
    if input:match('/') then
      infile = {_ = 'inputFileLocal', path = file}
    elseif input:match('^%d+$') then
      infile = {_ = 'inputFileId', id = file}
    else
      infile = {_ = 'inputFilePersistentId', persistent_id = file}
    end
  end
  return infile
end
function sendDocument(chat_id, document, caption, doc_thumb, reply_to_message_id, disable_notification, from_background, reply_markup)
assert (tdbot_function ({
_= "sendMessage",
chat_id = chat_id,
reply_to_message_id = reply_to_message_id,
disable_notification = disable_notification,
from_background = from_background,
reply_markup = reply_markup,
input_message_content = {
_ = "inputMessageDocument",
document = getInputFile(document),
thumb = doc_thumb,
    caption = tostring(caption)
},
}, dl_cb, nil))
end
function getMessage(chat_id, message_id,cb)
tdbot_function ({
_ = "getMessage",
chat_id = chat_id,
message_id = message_id
}, cb, nil)
end
function deleteMessagesFromUser(chat_id, user_id)
tdbot_function ({
_ = "deleteMessagesFromUser",
chat_id = chat_id,
user_id = user_id
}, dl_cb, nil)
end
function edit(chatid, messageid, text)
  assert (tdbot_function ({
    _ = 'editMessageText',
    chat_id = chatid,
    message_id = messageid,
    reply_markup = nil,
    input_message_content = {
      _ = 'inputMessageText',
      text = text,
      disable_web_page_preview = 0,
      clear_draft = 0,
      entities = {},
      parse_mode = html
    },
  }, dl_cb,nil))
end
function send(chat_id,msg,text)
assert( tdbot_function ({_ = "sendMessage",chat_id = chat_id,reply_to_message_id = msg,disable_notification = 0,from_background = 1,reply_markup = nil,input_message_content = {_ = "inputMessageText",text = text,disable_web_page_preview = 1,clear_draft = 0,parse_mode = html,entities = {}}}, dl_cb, nil))
end
function dl_cb(arg, data)
end
function run(msg,data)
if msg then
text = msg.content.text
if redis:get('type'..SUDOA..'ing') then
Action(msg.chat_id,'Typing')
end
function is_pv(msg)
chat_id = tostring(msg.chat_id)
if chat_id:match('^-') then
return false
else
return true
end
end
if redis:get('monshi'..SUDOA..'pv') and is_pv(msg) and not redis:get('time'..msg.sender_user_id..'pv') and not is_sudo(msg)then
if text then
local matn = redis:get('text'..SUDOA..'monshi') or 'slm'
send(msg.chat_id,msg.id,matn)
redis:setex('time'..msg.sender_user_id..'pv',180,true)
end
end
if (msg.sender_user_id == tonumber(SUDOA)) then
if text == 'راهنما' then
local txt = [[
#بروزسازی ربات
ریلود

#جهت تنظیم دشمن 
تنظیم دشمن

#جهت خارج کردن شخصی از لیست دشمن
اتش بس

#تنظیم ساعت سرور
تنظیم ساعت

#نمایش ساعت
ساعت

#مسدود کردن شخصی از گروه
مسدود

#سکوت کاربر درگروه
سکوت

#در اوردن شخصی از سکوت
حذف سکوت

#ایدی کاربر با ریپلی
ایدی

#ارسال پیام کاربر در پیوی
پیام ها [id]

#ارسال پیام های کاربر در پیوی با ریپلی
پیام ها

#جهت روشن کردن تایپینگ
تایپینگ روشن

#جهت خاموش کردن تایپینگ
تایپینگ خاموش

#جهت روشن کردن منشی
منشی روشن

#چهت خاموش کردن منشی
منشی خاموش

#جهت تنظیم منشی
تنظیم منشی [text]

#ذخیره یک فایل در فضای ابری با ریپلی
ذخیره

#جهت حذف گزارش پیام های پیوی
حذف گزارش

#جهت منشن کردن شخصی[reply]
m [text]

#جهت حذف پیام خود
حذف پیام من

#جهت حذف پیام کاربر با ریپلی
حذف همه

]]
edit(msg.chat_id,msg.id,txt)
end
if text == 'ریلود' then
dofile('bot.lua')
edit(msg.chat_id,msg.id,'> ربات بروز شد ')
end
if text == 'تنظیم دشمن' and tonumber(msg.reply_to_message_id) > 0 then
function sik(a,milad)
edit(msg.chat_id, msg.id,'کاربر در لیست دشمنان قرار گرفت')
redis:sadd('dosh'..SUDOA..'man',milad.sender_user_id)
end
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),sik)
end
if text == 'تنظیم ساعت' then
edit(msg.chat_id,msg.id,'> ساعت سرور به تهران تغییر کرد')
io.popen('cp /usr/share/zoneinfo/Asia/Tehran /etc/localtime')
end
if text == 'اتش بس' and tonumber(msg.reply_to_message_id) > 0 then
function sik(a,milad)
edit(msg.chat_id, msg.id,'کاربر از لیست دشمن خارج شد')
redis:srem('dosh'..SUDOA..'man',milad.sender_user_id)
end
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),sik)
end
if text == 'مسدود' and tonumber(msg.reply_to_message_id) > 0 then
function sik(a,milad)
edit(msg.chat_id, msg.id,'کاربر با موفقیت از گروه حذف شد')
KickUser(msg.chat_id,milad.sender_user_id) 
end
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),sik)
end
if text == 'سکوت' and tonumber(msg.reply_to_message_id) > 0 then
function sik(a,milad)
edit(msg.chat_id, msg.id,'کاربر با موفقیت بی صدا شد')
Restrict(msg.chat_id,milad.sender_user_id, 'Restricted', {1,0, 0, 0, 0, 0})
end
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),sik)
end
if text == 'حذف سکوت' and tonumber(msg.reply_to_message_id) > 0 then
function sik(a,milad)
edit(msg.chat_id, msg.id,'کاربر از سکوت خارج شد')
Restrict(msg.chat_id,milad.sender_user_id, 'Restricted', {1,1, 1, 1, 1, 1})
end
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),sik)
end
if text == 'ایدی' and tonumber(msg.reply_to_message_id) > 0 then
function sik(a,milad)
edit(msg.chat_id, msg.id,''..milad.sender_user_id..'')
end
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),sik)
end
if text and text:match('^پیام ها (.*)') then
local milad = text:match('پیام ها (.*)')
local file = './save/pm'..milad..'send.txt'
sendDocument(msg.chat_id,file,'', nil, msg.id, 0, 0, nil)
end
if text == 'تایپینگ روشن' then
redis:set('type'..SUDOA..'ing','ok')
edit(msg.chat_id,msg.id,'> تایپینگ با موفقیت روشن شد ')
end
if text == 'حذف پیام من' then
deleteMessagesFromUser(msg.chat_id,SUDOA) 
end
if text == 'حذف همه' and tonumber(msg.reply_to_message_id) > 0 then
function sik(a,milad)
edit(msg.chat_id, msg.id,'> پیام های کاربر حذف شد')
deleteMessagesFromUser(msg.chat_id,milad.sender_user_id)
end
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),sik)
end
if text == 'تایپینگ خاموش' then
redis:del('type'..SUDOA..'ing')
edit(msg.chat_id,msg.id,'> تایپینگ با موفقیت خاموش شد ')
end
if text == 'منشی روشن' then
redis:set('monshi'..SUDOA..'pv','ok')
edit(msg.chat_id,msg.id,'> منشی با موفقیت روشن شد ')
end
if text == 'منشی خاموش' then
redis:del('monshi'..SUDOA..'pv')
edit(msg.chat_id,msg.id,'> منشی با موفقیت خاموش شد ')
end
if text == 'ذخیره' and tonumber(msg.reply_to_message_id) > 0 then
function sik(a,milad)
forwardMessage(SUDOA,msg.chat_id, {[0] = milad.id}, 1)
edit(msg.chat_id,msg.id,'> با موفقیت ذخیره شد')
end
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),sik)
end
if text and text:match('^تنظیم منشی (.*)') then
local kontalagtlog = text:match('تنظیم منشی (.*)')
redis:set('text'..SUDOA..'monshi',kontalagtlog)
edit(msg.chat_id,msg.id,'> متن منشی با موفقیت تغییر کرد')
end
if text and text:match('^m (.*)') and tonumber(msg.reply_to_message_id) > 0 then
local tokhm = text:match('m (.*)')
deleteMessages(msg.chat_id,{[0] =msg.id})
function sik(a,milad)
SendMetion(msg.chat_id,milad.sender_user_id,msg.reply_to_message_id,tokhm,0,utf8.len(tokhm))
end
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),sik)
end
if text == 'ساعت' then
edit(msg.chat_id,msg.id,'ساعت : '..os.date('%X')..'\n')
end
if text == 'حذف گزارش' then
io.popen('cd save && rm -rf pm*send.txt')
edit(msg.chat_id,msg.id,'> لیست گزارش پت های خصوصی با موفقیت حذف شد')
end
if text == 'پیام ها' and tonumber(msg.reply_to_message_id) > 0 then
function sik(a,milad)
local file = './save/pm'..milad.sender_user_id..'send.txt'
sendDocument(msg.chat_id,file,'', nil, msg.id, 0, 0, nil)
end
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),sik)
end
end --sudo
if text and is_koni(msg) then
print('\027[' ..color.red[2]..';'..color.black[1]..'m                     '..text..'                                \027[00m')  
local kir = {
"کونی",
"ننه کیر سوار",
"مادر رایگان",
"مادر فلکه ای",
"ننه لامپی",
"تخم سگ",
"ریدم تو قبر پدرت",
"خار کسه",
"کیرم تو ناموست",
"کیری کم خون",
"مادر همه جایی ",
"مادر کمیته امدادی ",
"مادر به خطا",
"شل ناموس",
"کیر بکس نترون تو ناموست",
"مادر قهویه ای",
"کس ننت با میمنت کیرم سند با سلطنت تو شرت کرسد ننت",
"حروم زاده لاشکی",
"مادر صادراتی",
"خواهر کیر دزد",
"مادر کس میخ",
"کیر ممد ایست تو ناموست",
"کس خار بقلیت",
"چس سگ",
"ننه خراب",
"سیک کن محصول زنا",
"مادر اب کون پرست",
"خواهر حشر الدین",
"مادر تبچی",
"خواهر تبچی",
"سیک کن عکس مادرت رو تبچیا بردار",
"ناموس بیس پنجی",
"مادر vpn",
"خخخخخخ",
"مادر پریز",
"مادر لب شتری",
"سید اکبر رو نتت",
"بیاید سیگار نکشیم"
}
send(msg.chat_id,msg.id,kir[math.random(#kir)])
end
if text and is_pv(msg) then
local tt = os.date()
local file = io.open('./save/pm'..msg.sender_user_id..'send.txt','a+')
file:write('\n________________________\n\n'..text..'\n\n  '..tt..'\n\n________________________')
file:close()
end
if text then
print('\027[' ..color.yellow[2]..';'..color.black[1]..'m                     '..text..'                                \027[00m')  
print('\027[' ..color.cyan[2]..';'..color.black[1]..'m                     SELF BY @ir_milad                                \027[00m')
end
end
end
function tdbot_update_callback(data)
if (data._ == "updateNewMessage") or (data._ == "updateNewChannelMessage") then
run(data.message,data)
elseif (data._== "updateMessageEdited") then
run(data.message,data)
data = data
local function edit(extra,result,success)
run(result,data)
end
assert (tdbot_function ({_ = "getMessage", chat_id = data.chat_id,message_id = data.message_id }, edit, nil))
assert (tdbot_function ({_="getChats",offset_order="9223372036854775807",offset_chat_id=0,limit=20}, dl_cb, nil))
end
end
