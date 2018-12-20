ActiveAdmin.register Song do

  permit_params :title, :composer, song_links_attributes: [:title, :url]

  index do
    column :title
    column :composer
    actions
  end

  form do |f|
    f.inputs 'Details' do
      f.input :title
      f.input :composer
    end
    f.inputs do
      f.has_many :song_links, heading: 'Links',
        allow_destroy: true,
      new_record: true do |a|
        a.input :title
        a.input :url
      end
    end

    f.actions
  end

  show do
    attributes_table do
      row :title
      row :composer
    end
    panel "Links" do
      table_for song.song_links do
        column :title
        column :url
      end
    end
  end

end
