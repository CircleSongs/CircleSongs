ActiveAdmin.register Song do

  permit_params :name, :author, song_links_attributes: [:source, :url]

  form do |f|
    f.inputs 'Details' do
      f.input :name
      f.input :author
    end
    f.inputs do
      f.has_many :song_links, heading: 'Links',
        allow_destroy: true,
      new_record: true do |a|
        a.input :source
        a.input :url
      end
    end

    f.actions
  end

  show do
    attributes_table do
      row :name
      row :author
    end
    panel "Links" do
      table_for song.song_links do
        column :source
        column :url
        # ...
      end
    end
  end

end
