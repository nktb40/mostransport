# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'csv'
# # ====================================
# # Stations
# # ====================================
# puts "Stations: begin"
# CSV.foreach("seeds/stations/bus_stops.csv", :headers => true, :col_sep => ";", :encoding => 'windows-1251:utf-8') do |row|
#   #puts row.to_hash
#   row = {
#     source_id: row['ID'],
#     name: row['Name'],
#     latitude: row['Latitude_WGS84'],
#     longitude: row['Longitude_WGS84'],
#     route_numbers: row['RouteNumbers'],
#     station_name: row['StationName'],
#     geo_data: row['geoData']
#   }
#   item = Station.find_or_initialize_by(source_id: row[:source_id])
#   item.update!(row)
# end
# puts "Stations: done"

# # ====================================
# # Routes
# # ====================================
# puts "Routes: begin"
# CSV.foreach("seeds/routes/routes_enrich.csv", :headers => true) do |row|
#   row = {
#   	global_id: row['global_id'],
#     route_number: row['RouteNumber'],
#     route_code: row['route_code'],
#     route_name: row['RouteName'],
#     track_of_following: row['TrackOfFollowing'],
#     reverse_track_of_following: row['ReverseTrackOfFollowing'],
#     type_of_transport: row['TypeOfTransport'],
#     carrier_name: row['CarrierName'],
#     geo_data: row['geoData'],
#     route_interval: row['avg_fact_interval'],
#     route_length: row['route_length'],
#     route_cost: row['route_cost']
#   }
#   item = Route.find_or_initialize_by(global_id: row[:global_id])
#   item.update!(row)
# end
# puts "Routes: done"

# # ====================================
# # LnkStationRoutes
# # ====================================
# puts "LnkStationRoutes: begin"
# Station.all.each do |s|
#   r_codes = s.route_numbers.split('; ')
#   routes = Route.where(route_code: r_codes)

#   routes.each do |r|
#   	LnkStationRoute.find_or_create_by(station_id: s.id, route_id: r.id)
#   end
# end
# puts "LnkStationRoutes: done"

# # ====================================
# # Isohrones/ Public Transport
# # ====================================
# puts "Isohrones/ Public Transport: begin"
# files = Dir.glob("seeds/public_transport/*.csv")

# files.each do |file_name|
#   puts "*** Loading #{file_name}"
#   CSV.foreach(file_name, :headers => true, :col_sep => ";", :quote_char => "'") do |row|
#     #puts(row.to_hash)
#     station = Station.find_or_create_by(source_id: row['global_id'])
#     row = {
#       station_id: station.id,
#       unique_code: row['ID'], 
#       source_station_id: row['global_id'], 
#       contour: row['contour'], 
#       profile: row['profile'],
#       with_interval: row['with_interval'],
#       geo_data: JSON.parse(row['polygon'])
#     }
#     item = Isochrone.find_or_initialize_by(unique_code: row[:unique_code])
#     item.update!(row)
#   end
# end
# puts "Isohrones/ Public Transport: done"

# # ====================================
# # Isohrones/ Walking
# # ====================================
# ["walking", "cycling", "driving"].each do |profile|

#   puts "Isohrones/ #{profile}: begin"

#   files = Dir.glob("seeds/#{profile}/*.csv")

#   files.each do |file_name|
#     puts "*** Loading #{file_name}"
#     CSV.foreach(file_name, :headers => true, :col_sep => ",", :quote_char => '"') do |row|
#       #puts(row.to_hash)
#       station = Station.find_or_create_by(source_id: row['global_id'])
#       row = {
#         station_id: station.id,
#         unique_code: row['id'], 
#         source_station_id: row['global_id'], 
#         contour: row['contour'], 
#         profile: row['profile'],
#         with_interval: row['with_interval'],
#         geo_data: JSON.parse(row['polygon'])
#       }
#       #puts row
#       item = Isochrone.find_or_initialize_by(unique_code: row[:unique_code])
#       item.update!(row)
#     end
#   end

#   puts "Isohrones/ #{profile}: done"

# end

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

# # ====================================
# # Metris
# # ====================================
# puts "Metrics: begin"

# files = Dir.glob("seeds/metrics/*.csv")

# files.each do |file_name|
#   puts "*** Loading #{file_name}"
#   CSV.foreach(file_name, :headers => true, :col_sep => ";") do |row|
#     puts(row.to_hash)
#     metric_type = MetricType.find_or_create_by(metric_code: row['metric_code'])
#     isochrone = Isochrone.find_by(unique_code: row['isochrone_code'])
#     row = {
#       metric_type_id: metric_type.id,
#       isochrone_id: isochrone.id, 
#       isochrone_unique_code: row['isochrone_code'],
#       metric_value: row['metric_value']
#     }
#     item = Metric.find_or_initialize_by(metric_type_id: row[:metric_type_id], isochrone_id: row[:isochrone_id])
#     item.update!(row)
#   end
# end
# puts "Metrics: done"

# # ==================
# # Test metrics
# # ==================
# rows = [
#   {"metric_code"=>"isochrone_area", "isochrone_code"=>"1001928-public_transport-10-1", "metric_value"=>"64"},
#   {"metric_code"=>"offices_cnt", "isochrone_code"=>"1001928-public_transport-10-1", "metric_value"=>"120"},
#   {"metric_code"=>"offices_population", "isochrone_code"=>"1001928-public_transport-10-1", "metric_value"=>"3450"},
#   {"metric_code"=>"houses_cnt", "isochrone_code"=>"1001928-public_transport-10-1", "metric_value"=>"540"},
#   {"metric_code"=>"houses_population", "isochrone_code"=>"1001928-public_transport-10-1", "metric_value"=>"6827"}
# ]
# rows.each do |row|
#   metric_type = MetricType.find_or_create_by(metric_code: row['metric_code'])
#   isochrone = Isochrone.find_by(unique_code: row['isochrone_code'])

#   row = {
#       metric_type_id: metric_type.id,
#       isochrone_id: isochrone.id, 
#       isochrone_unique_code: row['isochrone_code'],
#       metric_value: row['metric_value']
#   }

#   item = Metric.find_or_initialize_by(metric_type_id: row[:metric_type_id], isochrone_id: row[:isochrone_id])
#   item.update!(row)
# end