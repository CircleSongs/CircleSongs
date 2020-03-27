json.recording do
  json.id @recording.id
  json.html json.partial!('recordings/recording.html.haml', recording: @recording)
end
