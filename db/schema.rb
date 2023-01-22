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

ActiveRecord::Schema[7.0].define(version: 2023_01_22_172210) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "timescaledb"

  create_table "channels", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "sensor_type", null: false
    t.string "location"
    t.string "device_id"
    t.string "product_id"
    t.datetime "last_entry_timestamp", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["device_id"], name: "index_channels_on_device_id", unique: true
    t.index ["sensor_type"], name: "index_channels_on_sensor_type"
  end

  create_table "measurements", id: false, force: :cascade do |t|
    t.bigint "channel_id", null: false
    t.text "metric", null: false
    t.float "value"
    t.datetime "created_at", null: false
    t.index ["channel_id", "metric", "created_at"], name: "index_measurements_on_channel_id_and_metric_and_created_at", unique: true
    t.index ["channel_id"], name: "index_measurements_on_channel_id"
  end

  create_table "taggings", force: :cascade do |t|
    t.bigint "tag_id"
    t.string "taggable_type"
    t.bigint "taggable_id"
    t.string "tagger_type"
    t.bigint "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at", precision: nil
    t.string "tenant", limit: 128
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "taggings_taggable_context_idx"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type", "taggable_id"], name: "index_taggings_on_taggable_type_and_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
    t.index ["tagger_type", "tagger_id"], name: "index_taggings_on_tagger_type_and_tagger_id"
    t.index ["tenant"], name: "index_taggings_on_tenant"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "ubibot_auths", id: false, force: :cascade do |t|
    t.datetime "created_at", precision: nil, default: "2023-01-22 19:37:40"
    t.datetime "expired_at", precision: nil
    t.datetime "server_time", precision: nil
    t.string "token"
    t.index ["created_at", "expired_at"], name: "index_ubibot_auths_on_created_at_and_expired_at", unique: true
    t.index ["created_at"], name: "index_ubibot_auths_on_created_at"
    t.index ["expired_at"], name: "index_ubibot_auths_on_expired_at"
  end

  add_foreign_key "measurements", "channels"
  add_foreign_key "taggings", "tags"
end
