ActsAsTaggableOn::Tag.class_eval do
  def self.ransackable_attributes(_auth_object = nil)
    %w[name]
  end
end
