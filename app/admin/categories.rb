ActiveAdmin.register Category do
  permit_params :name, :restricted

  index do
    column :name
    column :restricted do |category|
      if category.restricted?
        span class: 'status_tag yes' do
          'Yes'
        end
      end
    end
    actions
  end
end
