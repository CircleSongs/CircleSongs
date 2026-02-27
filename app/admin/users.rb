ActiveAdmin.register User do
  menu parent: "Site", priority: 3

  config.sort_order = :created_at_desc
  actions :all, except: [:show]
  permit_params :email, :password, :password_confirmation
  filter :email
  filter :first_name
  filter :last_name

  index do
    column :email
    column "Created", sortable: :created_at do |user|
      safe_join([user.created_at.strftime("%-m/%-d/%y"), user.created_at.strftime("%-l:%M%P").strip], tag.br)
    end
    actions
  end

  form do |f|
    f.inputs do
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end
end
