require "rails_helper"

RSpec.describe ApplicationHelper, type: :helper do
  let(:user) { users(:admin) }

  before do
    allow(helper).to receive(:current_user) { user }
  end

  describe "#theme_font_size" do
    it "returns 80 for zero taggings" do
      expect(helper.theme_font_size(0, 10)).to eq 80
    end

    it "returns 150 for the max count" do
      expect(helper.theme_font_size(10, 10)).to eq 150
    end

    it "scales proportionally" do
      expect(helper.theme_font_size(5, 10)).to eq 115
    end
  end

  describe "#feature_enabled?" do
    context "when the feature is disabled" do
      it "returns false" do
        expect(helper.feature_enabled?(:hide_admin_login)).to be false
      end
    end

    context "when the feature is enabled for current_user" do
      before do
        Flipper.enable_actor :hide_admin_login, user
      end

      it "returns true" do
        expect(helper.feature_enabled?(:hide_admin_login)).to be true
      end
    end

    context "when the feature is enabled for a different user" do
      let(:homer) { users(:homer) }

      before do
        Flipper.enable_actor :hide_admin_login, homer
      end

      it "returns false" do
        expect(helper.feature_enabled?(:hide_admin_login)).to be false
      end
    end
  end
end
