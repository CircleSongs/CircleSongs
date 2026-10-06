require "rails_helper"
require "mini_magick"

RSpec.describe ImageUploader do
  let(:fixture) { Rails.root.join("spec/fixtures/files/image.jpeg") }

  def dimensions(uploaded_file)
    uploaded_file.open { |io| MiniMagick::Image.read(io.read).dimensions }
  end

  describe "derivatives" do
    let(:attacher) { described_class::Attacher.new }

    before do
      File.open(fixture, "rb") { |file| attacher.assign(file) }
      attacher.create_derivatives
    end

    it "generates large and thumb derivatives", :aggregate_failures do
      expect(attacher.derivatives.keys).to contain_exactly(:large, :thumb)
      expect(attacher.derivatives.values).to all(be_a(Shrine::UploadedFile))
    end

    it "limits the large derivative to 1000x400 preserving aspect ratio" do
      width, height = dimensions(attacher.derivatives[:large])
      expect([width, height]).to eq([296, 400])
    end

    it "limits the thumb derivative to 100x100 preserving aspect ratio" do
      width, height = dimensions(attacher.derivatives[:thumb])
      expect([width, height]).to eq([74, 100])
    end
  end

  describe "Song#image_url" do
    it "returns the derivative URL once derivatives exist", :aggregate_failures do
      song = songs(:hotel_california)
      File.open(fixture, "rb") { |file| song.image = file }
      song.save!
      song.reload

      expect(song.image_derivatives.keys).to contain_exactly(:large, :thumb)
      expect(song.image_url(:thumb)).to eq(song.image_derivatives[:thumb].url)
    end
  end
end
