ActiveAdmin.register User do
  menu parent: "Site", priority: 3

  config.sort_order = :created_at_desc
  actions :all, except: %i[show destroy]
  permit_params :email, :password, :password_confirmation, :disabled
  filter :email
  filter :first_name
  filter :last_name
  filter :disabled

  index do
    column :email
    column :disabled do |user|
      boolean_icon(user.disabled)
    end
    column "Created", sortable: :created_at do |user|
      admin_date(user.created_at)
    end
    actions
  end

  controller do
    def update
      if params[:user][:password].blank?
        params[:user].delete(:password)
        params[:user].delete(:password_confirmation)
      end
      super
    end
  end

  form do |f|
    f.inputs do
      f.input :email
      f.input :password, hint: f.object.persisted? ? "Leave blank to keep current password" : nil
      f.input :password_confirmation
      f.input :disabled, as: :boolean
    end
    f.actions
  end
end
