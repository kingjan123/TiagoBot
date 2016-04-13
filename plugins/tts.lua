local function run(msg, matches)
  local eq = matches[1]

  local url = "http://www.farsireader.com/PlayText.aspx?Text="..eq.."Punc=false"
  local receiver = get_receiver(msg)
  send_audio_from_url(receiver, url, send_title, {receiver, title})
end

return {
  description = "Convert text to voice",
  usage = {
    "tts [text]: Convert text to voice"
  },
  patterns = {
    "^[Tt]ts (.+)$"
  },
  run = run
}