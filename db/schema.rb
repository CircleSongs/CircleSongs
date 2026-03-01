# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_03_01_011722) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pg_stat_statements"
  enable_extension "pgcrypto"
  enable_extension "unaccent"

  create_table "active_storage_attachments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.uuid "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "categories", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.uuid "created_by_id"
    t.text "description"
    t.string "name"
    t.integer "position"
    t.boolean "restricted", default: false
    t.datetime "updated_at", precision: nil, null: false
    t.uuid "updated_by_id"
  end

  create_table "categories_songs", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "category_id"
    t.uuid "song_id"
  end

  create_table "chord_forms", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.string "chord"
    t.uuid "created_by_id"
    t.text "fingering"
    t.uuid "updated_by_id"
  end

  create_table "composers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.uuid "created_by_id"
    t.text "description"
    t.string "name"
    t.integer "songs_count", default: 0, null: false
    t.datetime "updated_at", null: false
    t.uuid "updated_by_id"
    t.string "url"
  end

  create_table "flipper_features", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "key", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_flipper_features_on_key", unique: true
  end

  create_table "flipper_gates", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "feature_key", null: false
    t.string "key", null: false
    t.datetime "updated_at", null: false
    t.text "value"
    t.index ["feature_key", "key", "value"], name: "index_flipper_gates_on_feature_key_and_key_and_value", unique: true
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.string "scope"
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "languages", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.uuid "created_by_id"
    t.string "name"
    t.integer "position"
    t.datetime "updated_at", precision: nil, null: false
    t.uuid "updated_by_id"
  end

  create_table "languages_songs", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "language_id"
    t.uuid "song_id"
  end

  create_table "passwords", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.uuid "created_by_id"
    t.string "name"
    t.datetime "updated_at", null: false
    t.uuid "updated_by_id"
    t.string "value"
  end

  create_table "playlists", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.uuid "created_by_id"
    t.text "description"
    t.integer "position"
    t.string "title"
    t.datetime "updated_at", null: false
    t.uuid "updated_by_id"
    t.string "url"
  end

  create_table "recordings", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.uuid "created_by_id"
    t.text "description"
    t.text "embedded_player"
    t.string "external_media_url"
    t.integer "position"
    t.boolean "reported"
    t.uuid "song_id"
    t.string "title"
    t.datetime "updated_at", precision: nil, null: false
    t.uuid "updated_by_id"
    t.string "url"
  end

  create_table "song_chord_forms", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "chord_form_id"
    t.integer "position"
    t.uuid "song_id"
  end

  create_table "songs", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.string "alternate_title"
    t.text "chords"
    t.uuid "composer_id"
    t.string "composer_name"
    t.string "composer_url"
    t.datetime "created_at", precision: nil, null: false
    t.uuid "created_by_id"
    t.text "description"
    t.boolean "featured", default: false, null: false
    t.text "image_data"
    t.text "lyrics"
    t.string "slug"
    t.string "title"
    t.text "translation"
    t.datetime "updated_at", precision: nil, null: false
    t.uuid "updated_by_id"
    t.index ["composer_id"], name: "index_songs_on_composer_id"
    t.index ["featured"], name: "index_songs_on_featured", where: "featured"
    t.index ["slug"], name: "index_songs_on_slug", unique: true
  end

  create_table "taggings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "context", limit: 128
    t.datetime "created_at"
    t.uuid "tag_id"
    t.uuid "taggable_id"
    t.string "taggable_type"
    t.uuid "tagger_id"
    t.string "tagger_type"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_type", "taggable_id"], name: "index_taggings_on_taggable"
    t.index ["taggable_type", "taggable_id"], name: "index_taggings_on_taggable_type_and_taggable_id"
    t.index ["tagger_type", "tagger_id"], name: "index_taggings_on_tagger"
  end

  create_table "tags", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.integer "taggings_count", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "users", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.boolean "admin", default: false
    t.datetime "created_at", precision: nil, null: false
    t.boolean "disabled", default: false, null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "first_name"
    t.string "last_name"
    t.datetime "remember_created_at", precision: nil
    t.datetime "reset_password_sent_at", precision: nil
    t.string "reset_password_token"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "vocabularies", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.uuid "created_by_id"
    t.string "text"
    t.string "translation"
    t.datetime "updated_at", null: false
    t.uuid "updated_by_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "categories", "users", column: "created_by_id"
  add_foreign_key "categories", "users", column: "updated_by_id"
  add_foreign_key "chord_forms", "users", column: "created_by_id"
  add_foreign_key "chord_forms", "users", column: "updated_by_id"
  add_foreign_key "composers", "users", column: "created_by_id"
  add_foreign_key "composers", "users", column: "updated_by_id"
  add_foreign_key "languages", "users", column: "created_by_id"
  add_foreign_key "languages", "users", column: "updated_by_id"
  add_foreign_key "passwords", "users", column: "created_by_id"
  add_foreign_key "passwords", "users", column: "updated_by_id"
  add_foreign_key "playlists", "users", column: "created_by_id"
  add_foreign_key "playlists", "users", column: "updated_by_id"
  add_foreign_key "recordings", "users", column: "created_by_id"
  add_foreign_key "recordings", "users", column: "updated_by_id"
  add_foreign_key "songs", "users", column: "created_by_id"
  add_foreign_key "songs", "users", column: "updated_by_id"
  add_foreign_key "taggings", "tags"
  add_foreign_key "vocabularies", "users", column: "created_by_id"
  add_foreign_key "vocabularies", "users", column: "updated_by_id"
end
