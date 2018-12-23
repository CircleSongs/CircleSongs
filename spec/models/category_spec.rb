RSpec.describe Category do
  it { is_expected.to belong_to(:song) }
end
