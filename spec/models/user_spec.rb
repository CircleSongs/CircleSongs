RSpec.describe User do
  describe "#active_for_authentication?" do
    it "returns true when not disabled" do
      user = described_class.new(disabled: false)
      expect(user.active_for_authentication?).to be true
    end

    it "returns false when disabled" do
      user = described_class.new(disabled: true)
      expect(user.active_for_authentication?).to be false
    end
  end

  describe "#inactive_message" do
    it "returns :disabled when disabled" do
      user = described_class.new(disabled: true)
      expect(user.inactive_message).to eq :disabled
    end

    it "returns the default message when not disabled" do
      user = described_class.new(disabled: false)
      expect(user.inactive_message).not_to eq :disabled
    end
  end
end
