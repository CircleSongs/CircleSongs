RSpec.describe Password do
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :value }
end
