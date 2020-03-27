module MailerMacros
  def last_email
    ActionMailer::Base.deliveries.last
  end

  def reset_email
    ActionMailer::Base.deliveries = []
  end
end

RSpec.configure do |config|
  config.include MailerMacros
  config.before { reset_email }
end
