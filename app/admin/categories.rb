ActiveAdmin.register Category do

  permit_params :name, :protected

  index do
    column :name
    column :protected do |category|
      if category.protected?
        span class: 'status_tag yes' do
          'Yes'
        end
      end
    end

    actions
  end
end
