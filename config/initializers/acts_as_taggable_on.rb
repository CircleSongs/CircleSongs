ActsAsTaggableOn::Tag.class_eval do
  def self.ransackable_attributes(_auth_object = nil)
    %w[name taggings_count]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[taggings]
  end
end
