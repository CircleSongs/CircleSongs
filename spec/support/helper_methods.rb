def uuid
  SecureRandom.uuid
end

def pause
  puts "pausing..."
  STDIN.gets
end

def webkit_debug
  page.driver.enable_logging
end
