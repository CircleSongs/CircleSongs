ActiveAdmin.register Password do
  actions :all, :except => [:destroy, :show]
  permit_params :name, :value

  index do
    column :name
    column :value
    actions
  end

  form do |f|
    f.inputs 'Details' do
      f.input :name, input_html: { disabled: !f.object.new_record? }
      f.input :value
      actions
    end
  end
end
