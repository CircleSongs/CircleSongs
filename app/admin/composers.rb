ActiveAdmin.register Composer do
  menu priority: 4

  permit_params :name, :url

  filter :name
  filter :songs_count
  filter :url_present, as: :boolean, label: "Has URL"
  
  index do
    column :name, sortable: true do |composer|
      link_to composer.name, admin_composer_path(composer)
    end
    column :url do |composer|
      link_to composer.url, composer.url, target: '_blank', rel: 'noopener' if composer.url.present?
    end
    column :songs_count, sortable: true do |composer|
      link_to composer.songs_count, admin_songs_path(q: { composer_name_cont: composer.name })
    end
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
