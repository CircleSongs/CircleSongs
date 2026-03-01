module TrackableShow
  extend ActiveSupport::Concern

  included do
    sidebar "Audit", only: :show do
      attributes_table_for resource do
        row(:created_by) { |r| r.created_by&.email }
        row(:updated_by) { |r| r.updated_by&.email }
        row :created_at
        row :updated_at
      end
    end
  end
end
