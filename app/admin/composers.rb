ActiveAdmin.register Composer do
  permit_params :name, :url

  filter :name
  filter :url
  
  index do
    column :name, sortable: true
    column :url do |composer|
      link_to composer.url, composer.url, target: '_blank', rel: 'noopener' if composer.url.present?
    end
    column :songs_count, sortable: true
    actions
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :url
    end
    f.actions
  end

  show do
    attributes_table do
      row :name
      row :url do |composer|
        link_to composer.url, composer.url, target: '_blank', rel: 'noopener' if composer.url.present?
      end
    end
  end
end
