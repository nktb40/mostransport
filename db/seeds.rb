
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'csv'
require 'net/http'
#=====================================
# Seeds Load Params
#=====================================
seeds_params = [
  #'cities',
  'layer_types',
  #'metric_type'
]

# ====================================
# Cities
# ====================================
if seeds_params.include? 'cities'

  puts "Cities: begin"
  items = [
    {name: "Москва", code: "MSK", longitude:37.6092076, latitude: 55.7548403},
    {name: "Южно-Сахалинск", longitude:142.7246706, latitude: 46.9613965},
    {name: "Тула", code: "TUL", longitude:37.4870222, latitude: 54.1849333},
    {name: "Белгород", code: "BEL", longitude:36.5029235, latitude: 50.5895904},
    {name: "Нижний-Новгород", code: "NNG", longitude:43.7857419, latitude: 56.2921286},
    {name: "Самара", code: "SAM", longitude:50.0576522, latitude: 53.2610309},
    {name: "Волгоград", code: "VLG", longitude:44.2258444, latitude: 48.6705316},
    {name: "Пермь", code: "PRM", longitude:56.0938513, latitude: 58.0205905},
    {name: "Челябинск", code: "CHLB", longitude:61.2681459, latitude: 55.1521245},
    {name: "Санкт-Петербург", code: "SPB", longitude:29.8138143, latitude: 59.9404595},
    {name: "Красноярск", code: "KRS", longitude:92.7256524, latitude:56.0266501},
    {name: "Ижевск", code: "IZH", longitude:53.0880191, latitude:56.8637312},
    {name: "Чебоксары", code: "CHB", longitude:47.1893787, latitude:56.1041997},
    {name: "Омск", code: "OMS", longitude:73.075964, latitude:54.985554},
    {name: "Иркутск", code: "IRK", longitude:104.1270759, latitude:52.2982526},
    {name: "Екатеринбург", code: "EKT", longitude:104.1270759, latitude:52.2982526},
    {name: "Якутск", code: "YKT", longitude:129.5617053, latitude:62.0312626},
    {name: "Кемерово", code: "KEM", longitude:85.9425084, latitude:55.4042374},
    {name: "Нижневартовск", code: "NZV", longitude:76.5073705, latitude:60.9222496},
    {name: "Тюмень", code: "TYM", longitude:65.534328, latitude:57.153033},
    {name: "Уфа", code: "UFA", longitude:55.957829, latitude: 54.734773},
    {name: "Казань", code: "KAZ", longitude:49.106324, latitude:55.798551},
    {name: "Воронеж", code: "VOJ", longitude:39.200287, latitude:51.661535},
    {name: "Владимир", code: "VLD", longitude:40.407030, latitude:56.129042},
    {name: "Краснодар", code: "KRD", longitude:38.9078796, latitude:45.0592777},
    {name: "Пенза", code: "PEZ", longitude:45.019529, latitude:53.194546},
    {name: "Саратов", code: "SRV", longitude:46.034158, latitude:51.533103},
    {name: "Томск", code: "TSK",  longitude:84.948197, latitude:56.484680},
    {name: "Владивосток", code: "VDK", longitude:131.873530, latitude:43.1056200},
    {name: "Новосибирск", code: "NSK", longitude:82.920430, latitude:55.030199},
    {name: "Великий Новгород", code: "VNO", longitude:31.275475, latitude:58.521475},
    {name: "Мурманск", code: "MNK", longitude:33.074540, latitude:68.969563},
    {name: "Киров", code: "KIR", longitude:49.668023, latitude:58.603581}
  ]

  items.each do |row|
    uri = URI("https://api.mapbox.com/geocoding/v5/mapbox.places/#{URI.encode(row[:name])}.json?proximity=#{row[:longitude]},#{row[:latitude]}&access_token=#{ENV.fetch('MAPBOX_KEY')}")
    result = JSON.parse(Net::HTTP.get(uri))
    bbox = result['features'][0]['bbox']
    item = City.find_or_initialize_by(code: row[:code])
    item.update!(name: row[:name], longitude: row[:longitude], latitude: row[:latitude], bbox: bbox)
  end
  puts "Cities: done"

end

# ====================================
# LayerTypes
# ====================================
if seeds_params.include? 'layer_types'

  puts "LayerTypes: begin"
  items = [
    {name: "Остановки", code: "STATIONS", source_name: "bus_stops", draw_type: "circle", paint_rule:'{"circle-radius": {"stops": [[9, 2], [22, 15]]},"circle-color": "#3976bc"}', default: true},
    {name: "Маршруты", code: "ROUTES", source_name: "routes", draw_type: "line", paint_rule:'{"line-width": 3,"line-color": "#F7455D"}', default: false},
    {name: "Выделенные полосы", code: "bus_lines", source_name: "bus_lines", draw_type: "line", paint_rule:'{"line-width": 3,"line-color": "#ffd800"}', default: false},
    {name: "Плотность маршрутов", code: "DENSITY", source_name: "density", draw_type: "line", paint_rule:'{"line-width": ["case",["all",[">=",["get","field_2"],1],["<",["get","field_2"],5]],3,["all",[">=",["get","field_2"],5],["<",["get","field_2"],10]],5,["all",[">=",["get","field_2"],10],["<",["get","field_2"],15]],7,9],"line-color": ["case",["all",[">=",["get","field_2"],1],["<",["get","field_2"],5]],"#42d103",["all",[">=",["get","field_2"],5],["<",["get","field_2"],10]],"#efee0a",["all",[">=",["get","field_2"],10],["<",["get","field_2"],15]],"#f3b307","#e13d02"]}', default: false},
    {name: "Плотность рейсов", code: "DENSITY2", source_name: "density2", draw_type: "line",  paint_rule:'{"line-width": ["case",["all",[">=",["get","field_2"],1],["<",["get","field_2"],5]],3,["all",[">=",["get","field_2"],5],["<",["get","field_2"],10]],5,["all",[">=",["get","field_2"],10],["<",["get","field_2"],15]],7,9],"line-color": ["case",["all",[">=",["get","field_2"],1],["<",["get","field_2"],5]],"#42d103",["all",[">=",["get","field_2"],5],["<",["get","field_2"],10]],"#efee0a",["all",[">=",["get","field_2"],10],["<",["get","field_2"],15]],"#f3b307","#e13d02"]}', default: false},
    {name: "Пешие изохроны 5 мин", code: "WALK_ISO_5MIN", source_name: "isochrones", draw_type: "fill", paint_rule:'{"fill-color": "#00ceff","fill-opacity": 0.3}', default: false},
    {name: "Диаграмма Вороного", code: "voronoi", source_name: "voronoi", draw_type: "line", paint_rule:'{"line-color": "#242323","line-opacity": 0.3}', default: false},
    {name: "Покрытие остановками", code: "stops_cover", source_name: "stops_cover", draw_type: "fill", paint_rule:'{"fill-color": "#00ceff","fill-opacity": 0.3}', default: false},
    {name: "Дома далеко от остановок", code: "houses_far_stops", source_name: "houses_far_stops", draw_type: "circle", paint_rule:'{"circle-radius": 7,"circle-color": "#e77d91", "circle-opacity": 0.8}', default: false},
    {name: "Карта ДТП", code: "dtp_map", source_name: "dtp_map", draw_type: "circle", paint_rule:'{"circle-radius": 5,"circle-color": "#f4bc04"}', default: false},
    {name: "Очаги ДТП", code: "dtp_ochagi", source_name: "dtp_ochagi", draw_type: "circle", paint_rule:'{"circle-radius": 10,"circle-color": "#eb5310"}', default: false},
    {name: "Подходы к остановкам", code: 'stop_routes', source_name: "stop_routes", draw_type: "line", paint_rule: '{"line_width": 3, "line-color":["case",["==",["get", "distance"],200], "#42d103", ["==", ["get", "distance"], 300], "#f3b307", ["==", ["get","distance"], 400], "#ffa500", ["==", ["get", "distance"], 500], "ff4700", "#e13d02"]}', default: false},
    {name: "Расстояние между остановками", code: 'stops_distance', source_name: 'stops_distance', draw_type: 'line', paint_rule: '{"line-width": 5, "line-color": ["case", ["<", ["get", "distance"], 300], "#d0ea2c", ["<",["get", "distance"], 400], "#fefe33", ["<",["get", "distance"], 500], "#f4bc04", ["<",["get", "distance"], 600], "#f09906", "#eb5310"]}', default: false},
    {name: "Камеры ГИБДД", code: "traffic_cameras", source_name: "traffic_cameras", draw_type: "circle", paint_rule:'{"circle-radius": 5,"circle-color": "#5038bc", "circle-opacity": 0.8}', default: false}
  ]
  items.each do |row|
    item = LayerType.find_or_initialize_by(code: row[:code])
    item.update!(name: row[:name], source_name: row[:source_name], draw_type: row[:draw_type], paint_rule: row[:paint_rule], default: row[:default])
  end
  puts "LayerTypes: done"

end

# ====================================
# Metric types
# ====================================
if seeds_params.include? 'metric_type'
  puts "Metric Type: begin"
  rows = [
    {metric_code: "isochrone_area", metric_name: "Площадь изохрона (км2)", unit_code: "км2."},

    {metric_code: "houses_cnt", metric_name: "Кол-во домов", unit_code: ""},
    {metric_code: "houses_population", metric_name: "Кол-во жителей", unit_code: ""},

    {metric_code: "offices_cnt", metric_name: "Кол-во офисов", unit_code: ""},
    {metric_code: "offices_population", metric_name: "Кол-во работников", unit_code: ""},

    {metric_code: "universities_cnt", metric_name: "Кол-во университетов", unit_code: ""},
    {metric_code: "universities_population", metric_name: "Кол-во студентов", unit_code: ""},

    {metric_code: "accessibility", metric_name: "Пешеходная доступность", unit_code: ""}    
  ]

  rows.each do |row|
    item = MetricType.find_or_initialize_by(metric_code: row[:metric_code])
    item.update!(row)
  end
  puts "Metric Type: done"
end
