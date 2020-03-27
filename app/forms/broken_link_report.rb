class BrokenLinkReport < MailForm::Base
  DEFAULT_FROM = "Broken Links <contact@#{Rails.application.credentials.base_domain}>".freeze

  attribute :recording_id, validate: true
  attribute :nickname, captcha: true

  def headers
    {
      subject: subject_text,
      to: Rails.application.credentials.contact_form_email,
      from: DEFAULT_FROM,
      message: message
    }
  end

  def recording
    @recording ||= Recording.find(recording_id)
  end

  private

  def subject_text
    I18n.t('broken_link_forms.email.subject', title: song.title)
  end

  def message
    <<~TEXT
      Broken link reported for #{song.title}:
      #{recording.title}
      #{Rails.application.routes.url_helpers.song_path(song)}
    TEXT
  end

  def song
    @song ||= recording.song
  end
end
