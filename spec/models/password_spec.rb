RSpec.describe Password do
  it { is_expected.to validate :name }
  it { is_expected.to validate :value }
end
