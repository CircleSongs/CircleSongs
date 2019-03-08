class ContactForm < MailForm::Base
  attribute :name
  attribute :email, validate: /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i, allow_blank: true
  attribute :subject
  attribute :message, validate: true
  attribute :nickname, captcha: true

  def headers
    {
      subject: subject,
      to: ENV['contact_form_email'],
      from: %("#{name}" <#{email}>)
    }
  end
end
