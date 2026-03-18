def uuid # rubocop:disable Rails/Delegate
  SecureRandom.uuid
end

def pause
  STDIN.gets
end

def webkit_debug
  page.driver.enable_logging
end
