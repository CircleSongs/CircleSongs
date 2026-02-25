module SortableIndex
  def self.included(base)
    base.instance_eval do
      collection_action :sort, method: :post do
        params[:ids].each_with_index do |id, index|
          resource_class.where(id: id).update_all(position: index + 1)
        end
        head :ok
      end
    end
  end
end
