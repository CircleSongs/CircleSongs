class ContactForm < MailForm::Base
  DEFAULT_FROM_NAME = "Contact Form".freeze
  DEFAULT_FROM_EMAIL = Rails.application.credentials.contact_email
  DEFAULT_SUBJECT = "Medicine Songs - Contact Form".freeze

  attribute :name
  attribute :email, validate: /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i, allow_blank: true
  attribute :subject
  attribute :message, validate: true
  attribute :nickname, captcha: true

  def headers
    {
      subject: subject_text,
      to: Rails.application.credentials.contact_email,
      from: "#{from_name} <#{from_email}>"
    }
  end

  private

  def from_name
    name.presence || DEFAULT_FROM_NAME
  end

  def from_email
    email.presence || DEFAULT_FROM_EMAIL
  end

  def subject_text
    subject.presence || DEFAULT_SUBJECT
  end
end
