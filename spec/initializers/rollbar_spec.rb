require "rails_helper"

RSpec.describe Rollbar do
  let(:filters) { described_class.configuration.exception_level_filters }

  # Rails already answers these with a 4xx; reporting them is just noise
  # from bots, scanners and stale links.
  %w[
    ActionController::RoutingError
    ActionController::InvalidAuthenticityToken
    ActionController::UnknownFormat
    ActionController::BadRequest
    ActionDispatch::Http::MimeNegotiation::InvalidType
    ActiveRecord::RecordNotFound
  ].each do |exception|
    it "ignores #{exception}" do
      expect(filters[exception]).to eq("ignore")
    end
  end

  it "reports NoMethodError as critical" do
    expect(filters["NoMethodError"]).to eq("critical")
  end
end
