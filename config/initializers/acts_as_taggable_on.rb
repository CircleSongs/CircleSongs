ActsAsTaggableOn::Tag.class_eval do
  def self.ransackable_attributes(_auth_object = nil)
    %w[name taggings_count]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[taggings]
  end
end

ActsAsTaggableOn::Tagging.class_eval do
  def self.ransackable_attributes(_auth_object = nil)
    %w[context created_at id tag_id taggable_id taggable_type tagger_id tagger_type]
  end
end
