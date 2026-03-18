class ContactForm < MailForm::Base
  DEFAULT_FROM_NAME = "Contact Form".freeze
  DEFAULT_SUBJECT = "Medicine Songs - Contact Form".freeze

  def self.default_from_email
    Rails.application.credentials.contact_email
  end

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
      email.presence || self.class.default_from_email
    end

    def subject_text
      subject.presence || DEFAULT_SUBJECT
    end
end
