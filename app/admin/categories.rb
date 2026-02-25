ActiveAdmin.register Category do
  permit_params :name, :restricted, :description

  index do
    column :name
    column :description
    column :restricted do |category|
      if category.restricted?
        span class: "status_tag yes" do
          "Yes"
        end
      end
    end
    actions
  end
end
