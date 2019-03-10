class BrokenLinkForm < MailForm::Base
  DEFAULT_FROM = "Broken Links <contact@#{ENV['base_domain']}>".freeze

  attribute :recording_id, validate: true
  attribute :nickname, captcha: true

  def headers
    {
      subject: subject_text,
      to: ENV['contact_form_email'],
      from: DEFAULT_FROM,
      message: message
    }
  end

  private

  def recording
    @recording ||= Recording.find(recording_id)
  end

  def subject_text
    I18n.t('broken_link_forms.email.subject', title: song.title)
  end

  def message
    <<~EOS
      Broken link reported for #{song.title}:
      #{recording.title}
      #{recording.url}
    EOS
  end

  def song
    @song ||= recording.song
  end
end
