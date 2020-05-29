# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'csv'
# ====================================
# Stations
# ====================================
puts "Stations: begin"
CSV.foreach("seeds/stations/bus_stops.csv", :headers => true, :col_sep => ";", :encoding => 'windows-1251:utf-8') do |row|
  #puts row.to_hash
  row = {
    source_id: row['ID'],
    name: row['Name'],
    latitude: row['Latitude_WGS84'],
    longitude: row['Longitude_WGS84'],
    route_numbers: row['RouteNumbers'],
    station_name: row['StationName'],
    geo_data: row['geoData']
  }
  item = Station.find_or_initialize_by(source_id: row[:source_id])
  item.update!(row)
end
puts "Stations: done"

# ====================================
# Routes
# ====================================
puts "Routes: begin"
CSV.foreach("seeds/routes/routes_enrich.csv", :headers => true) do |row|
  row = {
  	global_id: row['global_id'],
    route_number: row['RouteNumber'],
    route_code: row['route_code'],
    route_name: row['RouteName'],
    track_of_following: row['TrackOfFollowing'],
    reverse_track_of_following: row['ReverseTrackOfFollowing'],
    type_of_transport: row['TypeOfTransport'],
    carrier_name: row['CarrierName'],
    geo_data: row['geoData'],
    route_interval: row['Avg_fact_interval'],
    route_length: row['route_length'],
    route_cost: row['route_cost']
  }
  item = Route.find_or_initialize_by(global_id: row[:global_id])
  item.update!(row)
end
puts "Routes: done"

# ====================================
# LnkStationRoutes
# ====================================
puts "LnkStationRoutes: begin"
Station.all.each do |s|
  r_codes = s.route_numbers.split('; ')
  routes = Route.where(route_code: r_codes)

  routes.each do |r|
  	LnkStationRoute.find_or_create_by(station_id: s.id, route_id: r.id)
  end
end
puts "LnkStationRoutes: done"

# ====================================
# Isohrones/ Public Transport
# ====================================
puts "Isohrones/ Public Transport: begin"
files = Dir.glob("seeds/#{profile}/*.csv")

files.each do |file_name|
  puts "*** Loading #{file_name}"
  CSV.foreach(file_name, :headers => true, :col_sep => ";", :quote_char => "'") do |row|
    puts(row.to_hash)
    station = Station.find_or_create_by(source_id: row['global_id'])
    row = {
      station_id: station.id,
      unique_code: row['ID'], 
      source_station_id: row['global_id'], 
      contour: row['contour'], 
      profile: row['profile'],
      with_interval: row['with_interval'],
      geo_data: JSON.parse(row['polygon'])
    }
    item = Isochrone.find_or_initialize_by(unique_code: row[:unique_code])
    item.update!(row)
  end
end
puts "Isohrones/ Public Transport: done"

# ====================================
# Isohrones/ Walking
# ====================================
["walking, cycling, driving"].each do |profile|

  files = Dir.glob("seeds/#{profile}/*.csv")

  files.each do |file_name|
    puts "*** Loading #{file_name}"
    CSV.foreach(file_name, :headers => true, :col_sep => ",", :quote_char => '"') do |row|
      puts(row.to_hash)
      station = Station.find_or_create_by(source_id: row['global_id'])
      row = {
        station_id: station.id,
        unique_code: row['ID'], 
        source_station_id: row['global_id'], 
        contour: row['contour'], 
        profile: row['profile'],
        with_interval: row['with_interval'],
        geo_data: JSON.parse(row['polygon'])
      }
      item = Isochrone.find_or_initialize_by(unique_code: row[:unique_code])
      item.update!(row)
    end
  end

end
