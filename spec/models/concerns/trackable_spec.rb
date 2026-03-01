require "rails_helper"

RSpec.describe Trackable do
  let(:user) { users(:admin) }

  describe "on create" do
    it "sets created_by and updated_by from Current.user" do
      Current.user = user
      vocab = Vocabulary.create!(text: "hello", translation: "hola")

      expect(vocab.created_by).to eq(user)
      expect(vocab.updated_by).to eq(user)
    end

    it "does not overwrite an explicitly set created_by" do
      other_user = users(:homer)
      Current.user = user
      vocab = Vocabulary.create!(text: "hello", translation: "hola", created_by: other_user)

      expect(vocab.created_by).to eq(other_user)
      expect(vocab.updated_by).to eq(user)
    end
  end

  describe "on update" do
    it "sets updated_by from Current.user" do
      vocab = Vocabulary.create!(text: "hello", translation: "hola")

      Current.user = user
      vocab.update!(translation: "updated")

      expect(vocab.updated_by).to eq(user)
    end
  end

  describe "when no user is set" do
    it "leaves created_by and updated_by nil" do
      Current.user = nil
      vocab = Vocabulary.create!(text: "hello", translation: "hola")

      expect(vocab.created_by).to be_nil
      expect(vocab.updated_by).to be_nil
    end
  end
end
