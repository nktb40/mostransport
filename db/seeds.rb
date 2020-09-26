# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'csv'
require 'net/http'
# ====================================
# Cities
# ====================================
puts "Cities: begin"
items = [
  {name: "Москва", code: "MSK", tile_stations_url: 'nktb.bev2q4f8', tile_routes_url: 'nktb.4pzcpmcq', longitude:37.6092$
  {name: "Южно-Сахалинск", code: "USH", tile_stations_url: 'nktb.bqt0c4vg', tile_routes_url: 'nktb.3kwvx7ka', longitude$
  {name: "Тула", code: "TUL", tile_stations_url: 'nktb.5ddsaiot', tile_routes_url: 'nktb.4bxbgu2q', longitude:37.487022$
  {name: "Белгород", code: "BEL", tile_stations_url: 'nktb.7uolu0mp', tile_routes_url: 'nktb.1c6vp99c', longitude:36.50$
  {name: "Нижний-Новгород", code: "NNG", tile_stations_url: 'nktb.9rbfma6e', tile_routes_url: 'nktb.2gsyq2nz', longitud$
  {name: "Самара", code: "SAM", tile_stations_url: 'nktb.9fb34p6e', tile_routes_url: 'nktb.be0kl4tk', longitude:50.0576$
  {name: "Волгоград", code: "VLG", tile_stations_url: 'nktb.48sxho4n', tile_routes_url: 'nktb.8uls4msn', longitude:44.2$
  {name: "Пермь", code: "PRM", tile_stations_url: 'nktb.41zv4yqe', tile_routes_url: 'nktb.9ownhtj0', longitude:56.09385$
  {name: "Челябинск", code: "CHLB", tile_stations_url: 'nktb.0dwrfe7c', tile_routes_url: 'nktb.1mwldo19', longitude:61.$
  {name: "Санкт-Петербург", code: "SPB", tile_stations_url: 'nktb.60lrqf8u', tile_routes_url: 'nktb.cz6vgyki', longitud$
  {name: "Красноярск", code: "KRS", tile_stations_url: 'nktb.8k5i1lhg', tile_routes_url: 'nktb.4lie71yx', longitude:92.$
  {name: "Ижевск", code: "IZH", tile_stations_url: 'nktb.26wu56d7', tile_routes_url: 'nktb.cz1da0xm', longitude:53.0880$
  {name: "Чебоксары", code: "CHB", tile_stations_url: 'nktb.5jiq7p00', tile_routes_url: 'nktb.60z6vzwg', longitude:47.1$
  {name: "Омск", code: "OMS", tile_stations_url: 'nktb.22k1ka1u', tile_routes_url: 'nktb.c1sius1t', longitude:73.075964$
  {name: "Иркутск", code: "IRK", tile_stations_url: 'nktb.70zxrdt5', tile_routes_url: 'nktb.47t18wuw', longitude:104.12$
]

items.each do |row|
  uri = URI("https://api.mapbox.com/geocoding/v5/mapbox.places/#{URI.encode(row[:name])}.json?proximity=#{row[:longitude]},#{row[:latitude]}&access_token=#{ENV.fetch('MAPBOX_KEY')}")
  result = JSON.parse(Net::HTTP.get(uri))
  bbox = result['features'][0]['bbox']
  item = City.find_or_initialize_by(code: row[:code])
  item.update!(name: row[:name], longitude: row[:longitude], latitude: row[:latitude], bbox: bbox, tile_stations_url: row[:tile_stations_url], tile_routes_url: row[:tile_routes_url])
end
puts "Cities: done"

# ====================================
# Stations
# ====================================
puts "Stations: begin"
CSV.foreach("seeds/stations/csv/stations.csv", :headers => true, :col_sep => ";") do |row|
  #puts row.to_hash
  city = City.find_by_code(row['city_code'])
  #route_ids = Route.where(route_code: JSON.parse(row['route_numbers'])).map(&:id)
  row = {
    source_id: row['id'],
    latitude: row['latitude'],
    longitude: row['longitude'],
    #route_ids: route_ids,
    route_numbers: row['route_numbers'],
    station_name: row['station_name'],
    geo_data: JSON.parse(row['geometry']),
    city_id: city.id
  }
  
  item = Station.find_or_initialize_by(source_id: row[:source_id], city_id: row[:city_id])
  item.update!(row)
end
puts "Stations: done"

# ====================================
# Routes
# ====================================
puts "Routes: begin"
CSV.foreach("seeds/routes/csv/routes.csv", :headers => true, :col_sep => ";") do |row|
  city = City.find_by_code(row['city_code'])
  
  row = {
  	source_id: row['id'],
    route_number: row['route_number'],
    route_code: row['route_code'],
    route_name: row['route_name'],
    type_of_transport: row['type_of_transport'],
    geo_data: JSON.parse(row['geometry']),
    city_id: city.id,
    circular_flag: row['circular_flag']
  }
  item = Route.find_or_initialize_by(source_id: row[:source_id], city_id: row[:city_id])
  item.update!(row)
end
puts "Routes: done"

# ====================================
# Routes info
# ====================================
puts "Routes info: begin"
CSV.foreach("seeds/routes/csv/routes_info.csv", :headers => true, :col_sep => ";") do |row|
  city = City.find_by_code(row['city_code'])
  
  row = {
    source_id: row['route_id'],
    city_id: city.id,
    route_interval: row['avg_interval'],
    route_length: row['route_length'],
    route_cost: row['route_cost'],
    straightness: row['straightness'],
    bbox: JSON.parse(row['bbox'])
  }
  item = Route.find_or_initialize_by(source_id: row[:source_id], city_id: row[:city_id])
  item.update!(row)
end
puts "Routes info: done"

# ====================================
# LnkStationRoutes
# ====================================
puts "LnkStationRoutes: begin"
file = "seeds/route2stops/route2stops.csv"

city = nil
city_code = nil
route = nil
route_code = nil

CSV.foreach(file, :headers => true, :col_sep => ";") do |row|
  #puts "#{row['route_code']} #{row['station_ids']}"
  #items = []
  
  if city_code != row['city_code']
  	city = City.find_by_code(row['city_code'])
  	city_code = row['city_code']
  end
  if route_code != row['route_id']
  	route = Route.find_by(source_id: row['route_id'], city_id: city.id)
  	route_code = row['route_id']
  end
  
  if route.present?
      station = Station.find_by(source_id: row['station_id'], city_id: city.id)
      item = {station_id: station.id, route_id: route.id, track_no: row['track_no'], route_type: row['route_type'], seq_no: row['seq_no']}
      #items << LnkStationRoute.new(item)
      s2r = LnkStationRoute.find_or_initialize_by(station_id: station.id, route_id: route.id, track_no: row['track_no'])
      s2r.update!(item)

    #LnkStationRoute.import items, batch_size: 1000, on_duplicate_key_update: {conflict_target: [:station_id, :route_id, :track_no], columns: [:seq_no, :route_type]}
  end
end

puts "LnkStationRoutes: done"

# ====================================
# Isohrones/ Public Transport
# ====================================
puts "Isohrones/ Public Transport: begin"

files = Dir.glob("seeds/isochrones/public_transport/*.csv")

files.each do |file_name|
  puts "*** Loading #{file_name}"
  items = []
  CSV.foreach(file_name, :headers => true, :col_sep => ";") do |row|
    #puts(row.to_hash)
    city = City.find_by_code(row['city_code'])
    station = Station.find_or_create_by(source_id: row['station_id'], city_id: city.id)
    row = {
      station_id: station.id,
      unique_code: row['id'], 
      source_station_id: row['station_id'], 
      contour: row['contour'], 
      profile: row['profile'],
      with_interval: row['with_interval'],
      with_changes: row['with_changes'],
      geo_data: JSON.parse(row['geometry']),
      properties: JSON.parse(row['properties']),
      city_id: city.id
    }

    items << Isochrone.new(row)
    if items.length == 1000
      Isochrone.import items, batch_size: 1000, on_duplicate_key_update: {conflict_target: [:unique_code], columns: [:station_id, :geo_data, :properties, :city_id]}
      items = []
    end
  end
  Isochrone.import items, batch_size: 1000, on_duplicate_key_update: {conflict_target: [:unique_code], columns: [:station_id, :geo_data, :properties, :city_id]}
end

puts "Isohrones/ Public Transport: done"

# ====================================
# Isohrones/ Walking, cycling, driving
# ====================================
["walking", "cycling", "driving"].each do |profile|

  puts "Isohrones/ #{profile}: begin"

  files = Dir.glob("seeds/isochrones/isochrones_#{profile}.csv")

  files.each do |file_name|
    puts "*** Loading #{file_name}"
    CSV.foreach(file_name, :headers => true, :col_sep => ";", :quote_char => "'") do |row|
      #puts(row.to_hash)
      city = City.find_by_code(row['city_code'])
      station = Station.find_or_create_by(source_id: row['station_id'], city_id: city.id)
      row = {
        station_id: station.id,
        unique_code: row['id'], 
        source_station_id: row['station_id'], 
        contour: row['contour'], 
        profile: row['profile'],
        geo_data: JSON.parse(row['geometry']),
        city_id: city.id
      }
      #puts row
      item = Isochrone.find_or_initialize_by(unique_code: row[:unique_code])
      item.update!(row)
    end
  end
  puts "Isohrones/ #{profile}: done"
end

# ====================================
# Isohrones/ Route Cover
# ====================================

puts "Isohrones/route_cover: begin"

files = Dir.glob("seeds/isochrones/isochrones_route_cover.csv")

files.each do |file_name|
  puts "*** Loading #{file_name}"
  CSV.foreach(file_name, :headers => true, :col_sep => ";") do |row|
    #puts(row.to_hash)
    city = City.find_by_code(row['city_code'])
    route = Route.find_or_create_by(source_id: row['route_id'], city_id: city.id)
    row = {
      route_id: route.id,
      unique_code: row['id'], 
      source_route_id: row['route_id'],
      contour: row['contour'], 
      profile: row['profile'],
      geo_data: JSON.parse(row['geometry']),
      city_id: city.id
    }
    #puts row
    item = Isochrone.find_or_initialize_by(unique_code: row[:unique_code])
    item.update!(row)
  end
end

puts "Isohrones/route_cover: done"

# ====================================
# Metric types
# ====================================
puts "Metric Type: begin"
rows = [
  {metric_code: "isochrone_area", metric_name: "Площадь изохрона (км2)", unit_code: "км2."},

  {metric_code: "houses_cnt", metric_name: "Кол-во домов", unit_code: ""},
  {metric_code: "houses_population", metric_name: "Кол-во жителей", unit_code: ""},

  {metric_code: "offices_cnt", metric_name: "Кол-во офисов", unit_code: ""},
  {metric_code: "offices_population", metric_name: "Кол-во работников", unit_code: ""},

  {metric_code: "universities_cnt", metric_name: "Кол-во университетов", unit_code: ""},
  {metric_code: "universities_population", metric_name: "Кол-во студентов", unit_code: ""}
]

rows.each do |row|
  item = MetricType.find_or_initialize_by(metric_code: row[:metric_code])
  item.update!(row)
end
puts "Metric Type: done"

# ====================================
# Metris
# ====================================
puts "Metrics: begin"

#Metric.delete_all

files = Dir.glob("seeds/metrics/*.csv")

files.each do |file_name|
  puts "*** Loading #{file_name}"
  items = []
  CSV.foreach(file_name, :headers => true, :col_sep => ";") do |row|
    #puts(row.to_hash)
    metric_type = MetricType.find_or_create_by(metric_code: row['metric_code'])
    isochrone = Isochrone.find_by(unique_code: row['isochrone_code'])
    row = {
      metric_type_id: metric_type.id,
      isochrone_id: isochrone.id, 
      isochrone_unique_code: row['isochrone_code'],
      metric_value: row['metric_value']
    }
    items << Metric.new(row)
    if items.length == 1000
      Metric.import items, batch_size: 1000, on_duplicate_key_update: {conflict_target: [:metric_type_id, :isochrone_id], columns: [:metric_value]}
      items = []
    end
  end
  Metric.import items, batch_size: 1000, on_duplicate_key_update: {conflict_target: [:metric_type_id, :isochrone_id], columns: [:metric_value]}
end
puts "Metrics: done"
