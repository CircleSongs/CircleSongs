json.recording do
  json.html json.partial!('recordings/recording.html.haml', recording: @recording)
end

