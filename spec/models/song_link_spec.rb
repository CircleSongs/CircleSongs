RSpec.describe SongLink do
  it { is_expected.to have_many(:comments) }
end
