module TrackableShow
  def self.included(base)
    base.instance_eval do
      sidebar "Audit", only: :show do
        attributes_table_for resource do
          row :created_by do |r|
            r.created_by&.email
          end
          row :updated_by do |r|
            r.updated_by&.email
          end
          row :created_at
          row :updated_at
        end
      end
    end
  end
end
