class Language < ApplicationRecord
  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at id id_value name updated_at]
  end
end
