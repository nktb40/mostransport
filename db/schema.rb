# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_01_05_170940) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cities", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.float "latitude"
    t.float "longitude"
    t.json "bbox"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "region_name"
    t.index ["code"], name: "index_cities_on_code", unique: true
  end

  create_table "houses", force: :cascade do |t|
    t.integer "city_id"
    t.integer "source_id"
    t.text "street_name"
    t.string "house_number"
    t.string "building"
    t.string "block"
    t.string "letter"
    t.text "address"
    t.integer "floor_count_min"
    t.integer "floor_count_max"
    t.integer "entrance_count"
    t.float "area_total"
    t.float "area_residential"
    t.integer "population"
    t.json "geometry"
    t.boolean "far_from_stops_flag"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city_id", "source_id"], name: "index_houses_on_city_id_and_source_id", unique: true
  end

  create_table "isochrones", force: :cascade do |t|
    t.integer "station_id"
    t.string "unique_code"
    t.string "source_station_id"
    t.integer "contour"
    t.string "profile"
    t.boolean "with_interval"
    t.json "geo_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "route_id"
    t.string "source_route_id"
    t.boolean "with_changes"
    t.json "properties"
    t.integer "city_id"
    t.index ["city_id"], name: "index_isochrones_on_city_id"
    t.index ["route_id", "profile", "contour"], name: "index_isochrones_on_route_id_and_profile_and_contour"
    t.index ["station_id", "contour", "profile"], name: "index_isochrones_on_station_id_and_contour_and_profile"
    t.index ["unique_code"], name: "index_isochrones_on_unique_code", unique: true
  end

  create_table "layer_types", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.string "source_name"
    t.string "draw_type"
    t.json "paint_rule"
    t.boolean "default"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "layers", force: :cascade do |t|
    t.integer "layer_type_id"
    t.string "tile_url"
    t.integer "city_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city_id", "layer_type_id"], name: "index_layers_on_city_id_and_layer_type_id", unique: true
  end

  create_table "lnk_station_routes", force: :cascade do |t|
    t.integer "station_id"
    t.integer "route_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "seq_no"
    t.integer "track_no"
    t.string "route_type"
    t.float "route_time"
    t.float "distance"
    t.index ["route_id"], name: "index_lnk_station_routes_on_route_id"
    t.index ["station_id", "route_id", "track_no"], name: "lnk_station_routes_main_index", unique: true
    t.index ["station_id"], name: "index_lnk_station_routes_on_station_id"
  end

  create_table "metric_types", force: :cascade do |t|
    t.string "metric_code"
    t.string "metric_name"
    t.string "unit_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "metrics", force: :cascade do |t|
    t.integer "metric_type_id"
    t.integer "isochrone_id"
    t.string "isochrone_unique_code"
    t.float "metric_value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["isochrone_id"], name: "index_metrics_on_isochrone_id"
    t.index ["isochrone_unique_code"], name: "index_metrics_on_isochrone_unique_code"
    t.index ["metric_type_id", "isochrone_id"], name: "index_metrics_on_metric_type_id_and_isochrone_id", unique: true
  end

  create_table "routes", force: :cascade do |t|
    t.string "route_number"
    t.string "route_code"
    t.string "route_name"
    t.string "type_of_transport"
    t.json "geo_data"
    t.float "route_interval"
    t.float "route_length"
    t.float "route_cost"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "straightness"
    t.json "bbox"
    t.string "source_id"
    t.integer "city_id"
    t.boolean "circular_flag"
    t.index ["city_id", "source_id"], name: "index_routes_on_city_id_and_source_id", unique: true
    t.index ["city_id"], name: "index_routes_on_city_id"
    t.index ["route_code", "city_id"], name: "index_routes_on_route_code_and_city_id"
  end

  create_table "station_metrics", force: :cascade do |t|
    t.integer "metric_type_id"
    t.integer "station_id"
    t.float "metric_value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["metric_type_id", "station_id"], name: "index_station_metrics_on_metric_type_id_and_station_id", unique: true
    t.index ["metric_type_id"], name: "index_station_metrics_on_metric_type_id"
    t.index ["station_id"], name: "index_station_metrics_on_station_id"
  end

  create_table "stations", force: :cascade do |t|
    t.string "source_id"
    t.float "latitude"
    t.float "longitude"
    t.string "route_numbers"
    t.string "station_name"
    t.json "geo_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "city_id"
    t.index ["city_id"], name: "index_stations_on_city_id"
    t.index ["source_id", "city_id"], name: "index_stations_on_source_id_and_city_id", unique: true
  end

end
