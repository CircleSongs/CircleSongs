module Trackable
  extend ActiveSupport::Concern

  module RansackSupport
    def ransackable_attributes(auth_object = nil)
      super + %w[created_by_id updated_by_id]
    end

    def ransackable_associations(auth_object = nil)
      super + %w[created_by updated_by]
    end
  end

  included do
    belongs_to :created_by, class_name: "User", optional: true
    belongs_to :updated_by, class_name: "User", optional: true

    before_create { self.created_by ||= Current.user }
    before_save { self.updated_by = Current.user }

    singleton_class.prepend RansackSupport
  end
end
