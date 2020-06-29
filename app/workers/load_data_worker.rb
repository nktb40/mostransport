class LoadDataWorker
	require 'csv'
	include Sidekiq::Worker
	sidekiq_options retry: 0

	def perform
		puts "start: LoadDataWorker at #{Time.current}"
		
		load_metrics

		puts "finish: LoadDataWorker at #{Time.current}"
	end

	# ====================================
	# Stations
	# ====================================
	def load_stations
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
	end

	# ====================================
	# Routes
	# ====================================
	def load_routes
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
		    geo_data: JSON.parse(row['geoData']),
		    route_interval: row['avg_fact_interval'],
		    route_length: row['route_length'],
		    route_cost: row['route_cost'],
		    straightness: row['straightness'],
		    bbox: JSON.parse(row['bbox']),
		    source_id: row['ID']
		  }
		  item = Route.find_or_initialize_by(global_id: row[:global_id])
		  item.update!(row)
		end
		puts "Routes: done"
	end
	
	# ====================================
	# LnkStationRoutes
	# ====================================
	def load_lnk_station_routes
		puts "LnkStationRoutes: begin"
		file = "seeds/routes/route2stops.csv"

		LnkStationRoute.delete_all
		items = []
		CSV.foreach(file, :headers => true, :col_sep => ";") do |row|
		  route = Route.find_by(route_code: row['route_code'])
		  if route.present?
		    station_ids = JSON.parse(row['stop_id'])

		    station_ids.each_with_index do |id,i|
		      station = Station.find_by(source_id: id)
		      #link = LnkStationRoute.find_or_initialize_by(station_id: station.id, route_id: route.id, track_no: row['track_no'])
		      #link.update!(seq_no: i+1)
		      item = {station_id: station.id, route_id: route.id, track_no: row['track_no'], seq_no: i+1}
		      items << LnkStationRoute.new(item)
		    end
		  end
		end
		LnkStationRoute.import items, validate: false, batch_size: 1000
		puts "LnkStationRoutes: done"
	end

	# ====================================
	# Isohrones/ Public Transport
	# ====================================
	def load_isochrones_public_transport
		puts "Isohrones/ Public Transport: begin"

		files = Dir.glob("seeds/public_transport/*.csv")

		files.each do |file_name|
		  puts "*** Loading #{file_name}"
		  items = []
		  CSV.foreach(file_name, :headers => true, :col_sep => ";") do |row|
		    #puts(row.to_hash)
		    puts row['polygon']
		    station = Station.find_or_create_by(source_id: row['global_id'])
		    row = {
		      station_id: station.id,
		      unique_code: row['ID'], 
		      source_station_id: row['global_id'], 
		      contour: row['contour'], 
		      profile: row['profile'],
		      with_interval: row['with_interval'],
		      with_changes: row['with_changes'],
		      geo_data: JSON.parse(row['polygon']),
		      properties: JSON.parse(row['properties'])
		    }
		    puts row
		    #item = Isochrone.find_or_initialize_by(unique_code: row[:unique_code])
		    #item.update!(row)

		    items << Isochrone.new(row)
		  end
		  Isochrone.import items, batch_size: 1000, on_duplicate_key_update: {conflict_target: [:unique_code], columns: [:station_id, :geo_data, :properties]}
		end

		puts "Isohrones/ Public Transport: done"
	end

	# ====================================
	# Isohrones/ Walking
	# ====================================
	def load_isochrones_walking
		["walking", "cycling", "driving"].each do |profile|

		  puts "Isohrones/ #{profile}: begin"

		  files = Dir.glob("seeds/#{profile}/*.csv")

		  files.each do |file_name|
		    puts "*** Loading #{file_name}"
		    CSV.foreach(file_name, :headers => true, :col_sep => ",", :quote_char => '"') do |row|
		      #puts(row.to_hash)
		      station = Station.find_or_create_by(source_id: row['global_id'])
		      row = {
		        station_id: station.id,
		        unique_code: row['id'], 
		        source_station_id: row['global_id'], 
		        contour: row['contour'], 
		        profile: row['profile'],
		        with_interval: row['with_interval'],
		        geo_data: JSON.parse(row['polygon'])
		      }
		      #puts row
		      item = Isochrone.find_or_initialize_by(unique_code: row[:unique_code])
		      item.update!(row)
		    end
		  end

		  puts "Isohrones/ #{profile}: done"

		end
	end

	# ====================================
	# Isohrones/ Route Cover
	# ====================================
	def load_isochrones_route_cover
		puts "Isohrones/route_cover: begin"

		files = Dir.glob("seeds/route_cover/*.csv")

		files.each do |file_name|
		  puts "*** Loading #{file_name}"
		  CSV.foreach(file_name, :headers => true, :col_sep => ",", :quote_char => '"') do |row|
		    #puts(row.to_hash)
		    route = Route.find_or_create_by(source_id: row['global_id'])
		    row = {
		      route_id: route.id,
		      unique_code: row['id'], 
		      source_route_id: row['global_id'], 
		      contour: row['contour'], 
		      profile: row['profile'],
		      geo_data: JSON.parse(row['polygon'])
		    }
		    #puts row
		    item = Isochrone.find_or_initialize_by(unique_code: row[:unique_code])
		    item.update!(row)
		  end
		end

		puts "Isohrones/route_cover: done"
	end

	# ====================================
	# Metric types
	# ====================================
	def load_metric_types
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
	end

	# ====================================
	# Metris
	# ====================================
	def load_metrics
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
		    #item = Metric.find_or_initialize_by(metric_type_id: row[:metric_type_id], isochrone_id: row[:isochrone_id])
		    #item.update!(row)
		  end
		  Metric.import items, batch_size: 1000, on_duplicate_key_update: {conflict_target: [:metric_type_id, :isochrone_id], columns: [:metric_value]}
		end
		puts "Metrics: done"
	end
end