
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
  #'layers',
  #'stations',
  #'routes',
  #'routes_info',
  #'lnk_route_stations',
  #'iso_public_trans',
  #'iso_c_w_d',
  #'iso_route_cover',
  #'metric_type',
  #'metrics',
  #'station_metrics'
]

# ====================================
# Cities
# ====================================
if seeds_params.include? 'cities'

  puts "Cities: begin"
  items = [
    {name: "Москва", code: "MSK", tile_stations_url: 'nktb.bev2q4f8', tile_routes_url: 'nktb.4pzcpmcq', tile_density_url: 'nktb.1z61v7du', longitude:37.6092076, latitude: 55.7548403},
    {name: "Южно-Сахалинск", code: "USH", tile_stations_url: 'nktb.bqt0c4vg', tile_routes_url: 'nktb.3kwvx7ka', tile_density_url: 'nktb.9kw4dho7', longitude:142.7246706, latitude: 46.9613965},
    {name: "Тула", code: "TUL", tile_stations_url: 'nktb.5ddsaiot', tile_routes_url: 'nktb.4bxbgu2q', tile_density_url: 'nktb.c1rb8ird', longitude:37.4870222, latitude: 54.1849333},
    {name: "Белгород", code: "BEL", tile_stations_url: 'nktb.7uolu0mp', tile_routes_url: 'nktb.1c6vp99c', tile_density_url: 'nktb.33lodhfg', longitude:36.5029235, latitude: 50.5895904},
    {name: "Нижний-Новгород", code: "NNG", tile_stations_url: 'nktb.9rbfma6e', tile_routes_url: 'nktb.2gsyq2nz', tile_density_url: 'nktb.bv0h10b4', longitude:43.7857419, latitude: 56.2921286},
    {name: "Самара", code: "SAM", tile_stations_url: 'nktb.9fb34p6e', tile_routes_url: 'nktb.be0kl4tk', tile_density_url: 'nktb.0liejzag', longitude:50.0576522, latitude: 53.2610309},
    {name: "Волгоград", code: "VLG", tile_stations_url: 'nktb.48sxho4n', tile_routes_url: 'nktb.8uls4msn', tile_density_url: 'nktb.9c9d6799', longitude:44.2258444, latitude: 48.6705316},
    {name: "Пермь", code: "PRM", tile_stations_url: 'nktb.41zv4yqe', tile_routes_url: 'nktb.9ownhtj0', tile_density_url: 'nktb.ch3vv1rz', longitude:56.0938513, latitude: 58.0205905},
    {name: "Челябинск", code: "CHLB", tile_stations_url: 'nktb.0dwrfe7c', tile_routes_url: 'nktb.1mwldo19', tile_density_url: 'nktb.6itaoccn', longitude:61.2681459, latitude: 55.1521245},
    {name: "Санкт-Петербург", code: "SPB", tile_stations_url: 'nktb.60lrqf8u', tile_routes_url: 'nktb.cz6vgyki', tile_density_url: 'nktb.3xka12kh', longitude:29.8138143, latitude: 59.9404595},
    {name: "Красноярск", code: "KRS", tile_stations_url: 'nktb.8k5i1lhg', tile_routes_url: 'nktb.4lie71yx', tile_density_url: 'nktb.dat75syb', longitude:92.7256524, latitude:56.0266501},
    {name: "Ижевск", code: "IZH", tile_stations_url: 'nktb.26wu56d7', tile_routes_url: 'nktb.cz1da0xm', tile_density_url: 'nktb.7r524zyn', longitude:53.0880191, latitude:56.8637312},
    {name: "Чебоксары", code: "CHB", tile_stations_url: 'nktb.5jiq7p00', tile_routes_url: 'nktb.60z6vzwg', tile_density_url: 'nktb.1yknjs0w', longitude:47.1893787, latitude:56.1041997},
    {name: "Омск", code: "OMS", tile_stations_url: 'nktb.22k1ka1u', tile_routes_url: 'nktb.c1sius1t', tile_density_url: 'nktb.6s7okxvr', longitude:73.075964, latitude:54.985554},
    {name: "Иркутск", code: "IRK", tile_stations_url: 'nktb.70zxrdt5', tile_routes_url: 'nktb.47t18wuw', tile_density_url: 'nktb.2n3m6cac', longitude:104.1270759, latitude:52.2982526},
    {name: "Екатеринбург", code: "EKT", tile_stations_url: 'nktb.6tb6c67r', tile_routes_url: 'nktb.6ebd2f3k', tile_density_url: 'nktb.dka2dr7x', longitude:104.1270759, latitude:52.2982526},
    {name: "Якутск", code: "YKT", tile_stations_url: 'nktb.aybaqs3f', tile_routes_url: 'nktb.1lsjnm5c', tile_density_url: 'nktb.bxzje18l', longitude:129.5617053, latitude:62.0312626},
    {name: "Кемерово", code: "KEM", tile_stations_url: 'nktb.bo4ax1g9', tile_routes_url: 'nktb.91lylb9f', tile_density_url: 'nktb.4t4hl7ly', longitude:85.9425084, latitude:55.4042374},
    {name: "Нижневартовск", code: "NZV", tile_stations_url: 'nktb.6hgu3ier', tile_routes_url: 'nktb.1eop9ovk', tile_density_url: 'nktb.831vmgu1', longitude:76.5073705, latitude:60.9222496},
    {name: "Тюмень", code: "TYM", tile_stations_url: 'nktb.beo64q1o', tile_routes_url: 'nktb.6kcu0utf', tile_density_url: 'nktb.1d217ocz', longitude:65.534328, latitude:57.153033},
    {name: "Уфа", code: "UFA", tile_stations_url: 'nktb.cd5rs1wf', tile_routes_url: 'nktb.ddnew0ep', tile_density_url: 'nktb.9q42zhz8', longitude:55.957829, latitude: 54.734773},
    {name: "Казань", code: "KAZ", tile_stations_url: 'nktb.201n6o5p', tile_routes_url: 'nktb.bwff542v', tile_density_url: 'nktb.bd9cqkqm', longitude:49.106324, latitude:55.798551},
    {name: "Воронеж", code: "VOJ", tile_stations_url: 'nktb.876fmxvv', tile_routes_url: 'nktb.dq9g9a57', tile_density_url: 'nktb.a37gsmg5', longitude:39.200287, latitude:51.661535},
    {name: "Владимир", code: "VLD", tile_stations_url: 'nktb.dlx0296g', tile_routes_url: 'nktb.4pujm5jy', tile_density_url: 'nktb.27cxdbse', longitude:40.407030, latitude:56.129042},
    {name: "Краснодар", code: "KRD", tile_stations_url: 'nktb.12z7yui3', tile_routes_url: 'nktb.7x6xx9td', tile_density_url: 'nktb.0c4feiu2', longitude:38.9078796, latitude:45.0592777},
    {name: "Пенза", code: "PEZ", tile_stations_url: 'nktb.5nqhc58n', tile_routes_url: 'nktb.93uynnol', tile_density_url: 'nktb.b5xdicga', longitude:45.019529, latitude:53.194546},
    {name: "Саратов", code: "SRV", tile_stations_url: 'nktb.0fa4dnxi', tile_routes_url: 'nktb.05la62go', tile_density_url: 'nktb.2lb631sa', longitude:46.034158, latitude:51.533103},
    {name: "Томск", code: "TSK", tile_stations_url: 'nktb.dhx67pwf', tile_routes_url: 'nktb.9wckylbh', tile_density_url: 'nktb.akc9ibxb', longitude:84.948197, latitude:56.484680},
    {name: "Владивосток", code: "VDK", tile_stations_url: 'nktb.3v9v2y3m', tile_routes_url: 'nktb.3xuvucos', tile_density_url: 'nktb.dizax8et', longitude:131.873530, latitude:43.1056200},
    {name: "Новосибирск", code: "NSK", tile_stations_url: 'nktb.7nw3jf28', tile_routes_url: 'nktb.c6i7om4i', tile_density_url: 'nktb.5j9wr6q0', longitude:82.920430, latitude:55.030199},
    {name: "Великий Новгород", code: "VNO", tile_stations_url: 'nktb.VNO-bus_stops', tile_routes_url: 'nktb.VNO-routes', tile_density_url: 'nktb.doqruynk', longitude:31.275475, latitude:58.521475},
    {name: "Мурманск", code: "MNK", tile_stations_url: 'nktb.MNK-bus_stops', tile_routes_url: 'nktb.MNK-routes', tile_density_url: 'nktb.4i13e8lt', longitude:33.074540, latitude:68.969563},
    {name: "Киров", code: "KIR", tile_stations_url: 'nktb.KIR-bus_stops', tile_routes_url: 'nktb.KIR-routes', tile_density_url: 'nktb.KIR-density', longitude:49.668023, latitude:58.603581}
  ]

  items.each do |row|
    uri = URI("https://api.mapbox.com/geocoding/v5/mapbox.places/#{URI.encode(row[:name])}.json?proximity=#{row[:longitude]},#{row[:latitude]}&access_token=#{ENV.fetch('MAPBOX_KEY')}")
    result = JSON.parse(Net::HTTP.get(uri))
    bbox = result['features'][0]['bbox']
    item = City.find_or_initialize_by(code: row[:code])
    item.update!(name: row[:name], longitude: row[:longitude], latitude: row[:latitude], bbox: bbox, tile_stations_url: row[:tile_stations_url], tile_routes_url: row[:tile_routes_url], tile_density_url: row[:tile_density_url])
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
    {name: "Расстояние между остановками", code: 'stops_distance', source_name: 'stops_distance', draw_type: 'line', paint_rule: '{"line-width": 5, "line-color": ["case", ["<", ["get", "distance"], 300], "#d0ea2c", ["<",["get", "distance"], 400], "#fefe33", ["<",["get", "distance"], 500], "#f4bc04", ["<",["get", "distance"], 600], "#f09906", "#eb5310"]}', default: false}
  ]
  items.each do |row|
    item = LayerType.find_or_initialize_by(code: row[:code])
    item.update!(name: row[:name], source_name: row[:source_name], draw_type: row[:draw_type], paint_rule: row[:paint_rule], default: row[:default])
  end
  puts "LayerTypes: done"

end

# ====================================
# Layers
# ====================================

if seeds_params.include? 'layers'
  puts "Layers: begin"
  items = [
    {city_code: "MSK", layer_type_code: "STATIONS", tile_url: "nktb.bev2q4f8"},
    {city_code: "MSK", layer_type_code: "ROUTES", tile_url: "nktb.4pzcpmcq"},
    {city_code: "MSK", layer_type_code: "DENSITY", tile_url: "nktb.cwpmw7ol"},
    {city_code: "MSK", layer_type_code: "bus_lines", tile_url: "nktb.9zwnwosv"},
    {city_code: "MSK", layer_type_code: "stops_cover", tile_url: "nktb.MSK-stops_cover"},
    {city_code: "MSK", layer_type_code: "stops_distance", tile_url: "nktb.ccnm81tv"},

    {city_code: "USH", layer_type_code: "STATIONS", tile_url: "nktb.bqt0c4vg"},
    {city_code: "USH", layer_type_code: "ROUTES", tile_url: "nktb.3kwvx7ka"},
    {city_code: "USH", layer_type_code: "DENSITY", tile_url: "nktb.9kw4dho7"},
    {city_code: "USH", layer_type_code: "bus_lines", tile_url: "nktb.9zwnwosv"},
    {city_code: "USH", layer_type_code: "voronoi", tile_url: "nktb.1nxaw7c4"},
    {city_code: "USH", layer_type_code: "stops_cover", tile_url: "nktb.USH-stops_cover"},
    {city_code: "USH", layer_type_code: "stops_distance", tile_url: "nktb.USH-stops_distance"},

    {city_code: "TUL", layer_type_code: "STATIONS", tile_url: "nktb.5ddsaiot"},
    {city_code: "TUL", layer_type_code: "ROUTES", tile_url: "nktb.4bxbgu2q"},
    {city_code: "TUL", layer_type_code: "DENSITY", tile_url: "nktb.c1rb8ird"},
    {city_code: "TUL", layer_type_code: "bus_lines", tile_url: "nktb.9zwnwosv"},
    {city_code: "TUL", layer_type_code: "voronoi", tile_url: "nktb.1nxaw7c4"},
    {city_code: "TUL", layer_type_code: "stops_cover", tile_url: "nktb.TUL-stops_cover"},
    {city_code: "TUL", layer_type_code: "stops_distance", tile_url: "nktb.TUL-stops_distance"}, 
    {city_code: "TUL", layer_type_code: "houses_far_stops", tile_url: "nktb.TUL-houses_far_stops"},   

    {city_code: "YKT", layer_type_code: "STATIONS", tile_url: "nktb.aybaqs3f"},
    {city_code: "YKT", layer_type_code: "ROUTES", tile_url: "nktb.1lsjnm5c"},
    {city_code: "YKT", layer_type_code: "DENSITY", tile_url: "nktb.bxzje18l"},
    {city_code: "YKT", layer_type_code: "bus_lines", tile_url: "nktb.9zwnwosv"},
    {city_code: "YKT", layer_type_code: "DENSITY2", tile_url: "nktb.797o7umz"},
    {city_code: "YKT", layer_type_code: "voronoi", tile_url: "nktb.1nxaw7c4"},
    {city_code: "YKT", layer_type_code: "stops_cover", tile_url: "nktb.YKT-stops_cover"},
    {city_code: "YKT", layer_type_code: "stops_distance", tile_url: "nktb.YKT-stops_distance"},

    {city_code: "BEL", layer_type_code: "STATIONS", tile_url: "nktb.7uolu0mp"},
    {city_code: "BEL", layer_type_code: "ROUTES", tile_url: "nktb.1c6vp99c"},
    {city_code: "BEL", layer_type_code: "DENSITY", tile_url: "nktb.33lodhfg"},
    {city_code: "BEL", layer_type_code: "bus_lines", tile_url: "nktb.9zwnwosv"},
    {city_code: "BEL", layer_type_code: "voronoi", tile_url: "nktb.1nxaw7c4"},
    {city_code: "BEL", layer_type_code: "stops_cover", tile_url: "nktb.BEL-stops_cover"},
    {city_code: "BEL", layer_type_code: "stops_distance", tile_url: "nktb.BEL-stops_distance"},

    {city_code: "NNG", layer_type_code: "STATIONS", tile_url: "nktb.9rbfma6e"},
    {city_code: "NNG", layer_type_code: "ROUTES", tile_url: "nktb.2gsyq2nz"},
    {city_code: "NNG", layer_type_code: "DENSITY", tile_url: "nktb.bv0h10b4"},
    {city_code: "NNG", layer_type_code: "bus_lines", tile_url: "nktb.9zwnwosv"},
    {city_code: "NNG", layer_type_code: "voronoi", tile_url: "nktb.1nxaw7c4"},
    {city_code: "NNG", layer_type_code: "stops_cover", tile_url: "nktb.NNG-stops_cover"},
    {city_code: "NNG", layer_type_code: "stops_distance", tile_url: "nktb.NNG-stops_distance"},

    {city_code: "SAM", layer_type_code: "STATIONS", tile_url: "nktb.9fb34p6e"},
    {city_code: "SAM", layer_type_code: "ROUTES", tile_url: "nktb.be0kl4tk"},
    {city_code: "SAM", layer_type_code: "DENSITY", tile_url: "nktb.0liejzag"},
    {city_code: "SAM", layer_type_code: "bus_lines", tile_url: "nktb.9zwnwosv"},
    {city_code: "SAM", layer_type_code: "voronoi", tile_url: "nktb.1nxaw7c4"},
    {city_code: "SAM", layer_type_code: "stops_cover", tile_url: "nktb.SAM-stops_cover"},
    {city_code: "SAM", layer_type_code: "stops_distance", tile_url: "nktb.SAM-stops_distance"},

    {city_code: "VLG", layer_type_code: "STATIONS", tile_url: "nktb.48sxho4n"},
    {city_code: "VLG", layer_type_code: "ROUTES", tile_url: "nktb.8uls4msn"},
    {city_code: "VLG", layer_type_code: "DENSITY", tile_url: "nktb.9c9d6799"},
    {city_code: "VLG", layer_type_code: "bus_lines", tile_url: "nktb.9zwnwosv"},
    {city_code: "VLG", layer_type_code: "voronoi", tile_url: "nktb.1nxaw7c4"},
    {city_code: "VLG", layer_type_code: "stops_cover", tile_url: "nktb.VLG-stops_cover"},
    {city_code: "VLG", layer_type_code: "stops_distance", tile_url: "nktb.VLG-stops_distance"},

    {city_code: "PRM", layer_type_code: "STATIONS", tile_url: "nktb.41zv4yqe"},
    {city_code: "PRM", layer_type_code: "ROUTES", tile_url: "nktb.9ownhtj0"},
    {city_code: "PRM", layer_type_code: "DENSITY", tile_url: "nktb.ch3vv1rz"},
    {city_code: "PRM", layer_type_code: "bus_lines", tile_url: "nktb.9zwnwosv"},
    {city_code: "PRM", layer_type_code: "voronoi", tile_url: "nktb.1nxaw7c4"},
    {city_code: "PRM", layer_type_code: "stops_cover", tile_url: "nktb.PRM-stops_cover"},
    {city_code: "PRM", layer_type_code: "stops_distance", tile_url: "nktb.PRM-stops_distance"},

    {city_code: "CHLB", layer_type_code: "STATIONS", tile_url: "nktb.0dwrfe7c"},
    {city_code: "CHLB", layer_type_code: "ROUTES", tile_url: "nktb.1mwldo19"},
    {city_code: "CHLB", layer_type_code: "DENSITY", tile_url: "nktb.6itaoccn"},
    {city_code: "CHLB", layer_type_code: "bus_lines", tile_url: "nktb.9zwnwosv"},
    {city_code: "CHLB", layer_type_code: "voronoi", tile_url: "nktb.1nxaw7c4"},
    {city_code: "CHLB", layer_type_code: "stops_cover", tile_url: "nktb.CHLB-stops_cover"},
    {city_code: "CHLB", layer_type_code: "stop_routes", tile_url: "nktb.bbla47bw"},
    {city_code: "CHLB", layer_type_code: "stops_distance", tile_url: "nktb.CHLB-stops_distance"},

    {city_code: "SPB", layer_type_code: "STATIONS", tile_url: "nktb.60lrqf8u"},
    {city_code: "SPB", layer_type_code: "ROUTES", tile_url: "nktb.cz6vgyki"},
    {city_code: "SPB", layer_type_code: "DENSITY", tile_url: "nktb.3xka12kh"},
    {city_code: "SPB", layer_type_code: "bus_lines", tile_url: "nktb.9zwnwosv"},
    {city_code: "SPB", layer_type_code: "stops_availability", tile_url: "nktb.d0mf3vxa"},
    {city_code: "SPB", layer_type_code: "voronoi", tile_url: "nktb.1nxaw7c4"},
    {city_code: "SPB", layer_type_code: "stops_cover", tile_url: "nktb.SPB-stops_cover"},
    {city_code: "SPB", layer_type_code: "stops_distance", tile_url: "nktb.SPB-stops_distance"},

    {city_code: "KRS", layer_type_code: "STATIONS", tile_url: "nktb.8k5i1lhg"},
    {city_code: "KRS", layer_type_code: "ROUTES", tile_url: "nktb.4lie71yx"},
    {city_code: "KRS", layer_type_code: "DENSITY", tile_url: "nktb.dat75syb"},
    {city_code: "KRS", layer_type_code: "bus_lines", tile_url: "nktb.9zwnwosv"},
    {city_code: "KRS", layer_type_code: "voronoi", tile_url: "nktb.0d66nmvs"},
    {city_code: "KRS", layer_type_code: "stops_cover", tile_url: "nktb.KRS-stops_cover"},
    {city_code: "KRS", layer_type_code: "stops_distance", tile_url: "nktb.KRS-stops_distance"},
    {city_code: "KRS", layer_type_code: "dtp_map", tile_url: ""},

    {city_code: "IZH", layer_type_code: "STATIONS", tile_url: "nktb.26wu56d7"},
    {city_code: "IZH", layer_type_code: "ROUTES", tile_url: "nktb.cz1da0xm"},
    {city_code: "IZH", layer_type_code: "bus_lines", tile_url: "nktb.9zwnwosv"},
    {city_code: "IZH", layer_type_code: "DENSITY", tile_url: "nktb.7r524zyn"},
    {city_code: "IZH", layer_type_code: "voronoi", tile_url: "nktb.1nxaw7c4"},
    {city_code: "IZH", layer_type_code: "stops_cover", tile_url: "nktb.IZH-stops_cover"},
    {city_code: "IZH", layer_type_code: "stops_distance", tile_url: "nktb.IZH-stops_distance"},

    {city_code: "CHB", layer_type_code: "STATIONS", tile_url: "nktb.5jiq7p00"},
    {city_code: "CHB", layer_type_code: "ROUTES", tile_url: "nktb.60z6vzwg"},
    {city_code: "CHB", layer_type_code: "DENSITY", tile_url: "nktb.1yknjs0w"},
    {city_code: "CHB", layer_type_code: "bus_lines", tile_url: "nktb.9zwnwosv"},
    {city_code: "CHB", layer_type_code: "voronoi", tile_url: "nktb.1nxaw7c4"},
    {city_code: "CHB", layer_type_code: "stops_cover", tile_url: "nktb.CHB-stops_cover"},
    {city_code: "CHB", layer_type_code: "stops_distance", tile_url: "nktb.CHB-stops_distance"},

    {city_code: "OMS", layer_type_code: "STATIONS", tile_url: "nktb.22k1ka1u"},
    {city_code: "OMS", layer_type_code: "ROUTES", tile_url: "nktb.c1sius1t"},
    {city_code: "OMS", layer_type_code: "DENSITY", tile_url: "nktb.6s7okxvr"},
    {city_code: "OMS", layer_type_code: "bus_lines", tile_url: "nktb.9zwnwosv"},      
    {city_code: "OMS", layer_type_code: "voronoi", tile_url: "nktb.1nxaw7c4"},
    {city_code: "OMS", layer_type_code: "stops_cover", tile_url: "nktb.OMS-stops_cover"},
    {city_code: "OMS", layer_type_code: "stops_distance", tile_url: "nktb.OMS-stops_distance"},

    {city_code: "IRK", layer_type_code: "STATIONS", tile_url: "nktb.70zxrdt5"},
    {city_code: "IRK", layer_type_code: "ROUTES", tile_url: "nktb.47t18wuw"},
    {city_code: "IRK", layer_type_code: "DENSITY", tile_url: "nktb.2n3m6cac"},
    {city_code: "IRK", layer_type_code: "bus_lines", tile_url: "nktb.9zwnwosv"},      
    {city_code: "IRK", layer_type_code: "voronoi", tile_url: "nktb.1nxaw7c4"},
    {city_code: "IRK", layer_type_code: "stops_cover", tile_url: "nktb.IRK-stops_cover"},
    {city_code: "IRK", layer_type_code: "stops_distance", tile_url: "nktb.IRK-stops_distance"},

    {city_code: "EKT", layer_type_code: "STATIONS", tile_url: "nktb.6tb6c67r"},
    {city_code: "EKT", layer_type_code: "ROUTES", tile_url: "nktb.6ebd2f3k"},
    {city_code: "EKT", layer_type_code: "DENSITY", tile_url: "nktb.dka2dr7x"},
    {city_code: "EKT", layer_type_code: "bus_lines", tile_url: "nktb.9zwnwosv"},      
    {city_code: "EKT", layer_type_code: "voronoi", tile_url: "nktb.1nxaw7c4"},
    {city_code: "EKT", layer_type_code: "stops_cover", tile_url: "nktb.EKT-stops_cover"},
    {city_code: "EKT", layer_type_code: "stops_distance", tile_url: "nktb.EKT-stops_distance"},

    {city_code: "KEM", layer_type_code: "STATIONS", tile_url: "nktb.bo4ax1g9"},
    {city_code: "KEM", layer_type_code: "ROUTES", tile_url: "nktb.91lylb9f"},
    {city_code: "KEM", layer_type_code: "DENSITY", tile_url: "nktb.4t4hl7ly"},
    {city_code: "KEM", layer_type_code: "bus_lines", tile_url: "nktb.9zwnwosv"},      
    {city_code: "KEM", layer_type_code: "voronoi", tile_url: "nktb.1nxaw7c4"},
    {city_code: "KEM", layer_type_code: "stops_cover", tile_url: "nktb.KEM-stops_cover"},
    {city_code: "KEM", layer_type_code: "stops_distance", tile_url: "nktb.KEM-stops_distance"},

    {city_code: "NZV", layer_type_code: "STATIONS", tile_url: "nktb.6hgu3ier"},
    {city_code: "NZV", layer_type_code: "ROUTES", tile_url: "nktb.1eop9ovk"},
    {city_code: "NZV", layer_type_code: "DENSITY", tile_url: "nktb.831vmgu1"},
    {city_code: "NZV", layer_type_code: "bus_lines", tile_url: "nktb.9zwnwosv"},
    {city_code: "NZV", layer_type_code: "voronoi", tile_url: "nktb.1nxaw7c4"},
    {city_code: "NZV", layer_type_code: "stops_cover", tile_url: "nktb.NZV-stops_cover"},
    {city_code: "NZV", layer_type_code: "stops_distance", tile_url: "nktb.NZV-stops_distance"},

    {city_code: "TYM", layer_type_code: "STATIONS", tile_url: "nktb.beo64q1o"},
    {city_code: "TYM", layer_type_code: "ROUTES", tile_url: "nktb.6kcu0utf"},
    {city_code: "TYM", layer_type_code: "DENSITY", tile_url: "nktb.1d217ocz"},
    {city_code: "TYM", layer_type_code: "bus_lines", tile_url: "nktb.9zwnwosv"},
    {city_code: "TYM", layer_type_code: "DENSITY2", tile_url: "nktb.28vf4hv4"},
    {city_code: "TYM", layer_type_code: "voronoi", tile_url: "nktb.1nxaw7c4"},
    {city_code: "TYM", layer_type_code: "stops_cover", tile_url: "nktb.TYM-stops_cover"},
    {city_code: "TYM", layer_type_code: "stops_distance", tile_url: "nktb.TYM-stops_distance"},

    {city_code: "UFA", layer_type_code: "STATIONS", tile_url: "nktb.cd5rs1wf"},
    {city_code: "UFA", layer_type_code: "ROUTES", tile_url: "nktb.ddnew0ep"},
    {city_code: "UFA", layer_type_code: "DENSITY", tile_url: "nktb.9q42zhz8"},
    {city_code: "UFA", layer_type_code: "bus_lines", tile_url: "nktb.9zwnwosv"},
    {city_code: "UFA", layer_type_code: "voronoi", tile_url: "nktb.1nxaw7c4"},
    {city_code: "UFA", layer_type_code: "stops_cover", tile_url: "nktb.UFA-stops_cover"},
    {city_code: "UFA", layer_type_code: "stops_distance", tile_url: "nktb.UFA-stops_distance"},

    {city_code: "KAZ", layer_type_code: "STATIONS", tile_url: "nktb.201n6o5p"},
    {city_code: "KAZ", layer_type_code: "ROUTES", tile_url: "nktb.bwff542v"},
    {city_code: "KAZ", layer_type_code: "DENSITY", tile_url: "nktb.bd9cqkqm"},
    {city_code: "KAZ", layer_type_code: "bus_lines", tile_url: "nktb.9zwnwosv"},
    {city_code: "KAZ", layer_type_code: "voronoi", tile_url: "nktb.1nxaw7c4"},
    {city_code: "KAZ", layer_type_code: "stops_cover", tile_url: "nktb.KAZ-stops_cover"},
    {city_code: "KAZ", layer_type_code: "stops_distance", tile_url: "nktb.KAZ-stops_distance"},

    {city_code: "VOJ", layer_type_code: "STATIONS", tile_url: "nktb.876fmxvv"},
    {city_code: "VOJ", layer_type_code: "ROUTES", tile_url: "nktb.dq9g9a57"},
    {city_code: "VOJ", layer_type_code: "DENSITY", tile_url: "nktb.a37gsmg5"},
    {city_code: "VOJ", layer_type_code: "bus_lines", tile_url: "nktb.9zwnwosv"},
    {city_code: "VOJ", layer_type_code: "voronoi", tile_url: "nktb.1nxaw7c4"},
    {city_code: "VOJ", layer_type_code: "stops_cover", tile_url: "nktb.VOJ-stops_cover"},
    {city_code: "VOJ", layer_type_code: "stops_distance", tile_url: "nktb.VOJ-stops_distance"},

    {city_code: "VLD", layer_type_code: "STATIONS", tile_url: "nktb.dlx0296g"},
    {city_code: "VLD", layer_type_code: "ROUTES", tile_url: "nktb.4pujm5jy"},
    {city_code: "VLD", layer_type_code: "DENSITY", tile_url: "nktb.27cxdbse"},
    {city_code: "VLD", layer_type_code: "bus_lines", tile_url: "nktb.9zwnwosv"},
    {city_code: "VLD", layer_type_code: "voronoi", tile_url: "nktb.1nxaw7c4"},
    {city_code: "VLD", layer_type_code: "stops_cover", tile_url: "nktb.VLD-stops_cover"},
    {city_code: "VLD", layer_type_code: "stops_distance", tile_url: "nktb.VLD-stops_distance"},

    {city_code: "KRD", layer_type_code: "STATIONS", tile_url: "nktb.12z7yui3"},
    {city_code: "KRD", layer_type_code: "ROUTES", tile_url: "nktb.7x6xx9td"},
    {city_code: "KRD", layer_type_code: "DENSITY", tile_url: "nktb.0c4feiu2"},
    {city_code: "KRD", layer_type_code: "bus_lines", tile_url: "nktb.9zwnwosv"},
    {city_code: "KRD", layer_type_code: "voronoi", tile_url: "nktb.1nxaw7c4"},
    {city_code: "KRD", layer_type_code: "stops_cover", tile_url: "nktb.KRD-stops_cover"},
    {city_code: "KRD", layer_type_code: "stops_distance", tile_url: "nktb.KRD-stops_distance"},

    {city_code: "PEZ", layer_type_code: "STATIONS", tile_url: "nktb.5nqhc58n"},
    {city_code: "PEZ", layer_type_code: "ROUTES", tile_url: "nktb.93uynnol"},
    {city_code: "PEZ", layer_type_code: "DENSITY", tile_url: "nktb.b5xdicga"},
    {city_code: "PEZ", layer_type_code: "bus_lines", tile_url: "nktb.9zwnwosv"},
    {city_code: "PEZ", layer_type_code: "voronoi", tile_url: "nktb.1nxaw7c4"},
    {city_code: "PEZ", layer_type_code: "stops_cover", tile_url: "nktb.PEZ-stops_cover"},
    {city_code: "PEZ", layer_type_code: "stops_distance", tile_url: "nktb.PEZ-stops_distance"},

    {city_code: "SRV", layer_type_code: "ROUTES", tile_url: "nktb.05la62go"},
    {city_code: "SRV", layer_type_code: "STATIONS", tile_url: "nktb.0fa4dnxi"},
    {city_code: "SRV", layer_type_code: "DENSITY", tile_url: "nktb.2lb631sa"},
    {city_code: "SRV", layer_type_code: "bus_lines", tile_url: "nktb.9zwnwosv"},
    {city_code: "SRV", layer_type_code: "voronoi", tile_url: "nktb.1nxaw7c4"},
    {city_code: "SRV", layer_type_code: "stops_cover", tile_url: "nktb.SRV-stops_cover"},
    {city_code: "SRV", layer_type_code: "stops_distance", tile_url: "nktb.SRV-stops_distance"},

    {city_code: "TSK", layer_type_code: "STATIONS", tile_url: "nktb.dhx67pwf"},
    {city_code: "TSK", layer_type_code: "ROUTES", tile_url: "nktb.9wckylbh"},
    {city_code: "TSK", layer_type_code: "DENSITY", tile_url: "nktb.akc9ibxb"},
    {city_code: "TSK", layer_type_code: "bus_lines", tile_url: "nktb.9zwnwosv"},
    {city_code: "TSK", layer_type_code: "voronoi", tile_url: "nktb.1nxaw7c4"},
    {city_code: "TSK", layer_type_code: "stops_cover", tile_url: "nktb.TSK-stops_cover"},
    {city_code: "TSK", layer_type_code: "stops_distance", tile_url: "nktb.TSK-stops_distance"},

    {city_code: "VDK", layer_type_code: "STATIONS", tile_url: "nktb.3v9v2y3m"},
    {city_code: "VDK", layer_type_code: "ROUTES", tile_url: "nktb.3xuvucos"},
    {city_code: "VDK", layer_type_code: "DENSITY", tile_url: "nktb.dizax8et"},
    {city_code: "VDK", layer_type_code: "bus_lines", tile_url: "nktb.9zwnwosv"},
    {city_code: "VDK", layer_type_code: "stops_cover", tile_url: "nktb.VDK-stops_cover"},
    {city_code: "VDK", layer_type_code: "stops_distance", tile_url: "nktb.VDK-stops_distance"},

    {city_code: "NSK", layer_type_code: "STATIONS", tile_url: "nktb.7nw3jf28"},
    {city_code: "NSK", layer_type_code: "ROUTES", tile_url: "nktb.c6i7om4i"},
    {city_code: "NSK", layer_type_code: "DENSITY", tile_url: "nktb.5j9wr6q0"},
    {city_code: "NSK", layer_type_code: "bus_lines", tile_url: "nktb.9zwnwosv"},
    {city_code: "NSK", layer_type_code: "stops_cover", tile_url: "nktb.NSK-stops_cover"},
    {city_code: "NSK", layer_type_code: "houses_far_stops", tile_url: "nktb.2pn1xsa2"},
    {city_code: "NSK", layer_type_code: "stops_distance", tile_url: "nktb.NSK-stops_distance"},

    {city_code: "VNO", layer_type_code: "STATIONS", tile_url: "nktb.VNO-bus_stops"},
    {city_code: "VNO", layer_type_code: "ROUTES", tile_url: "nktb.VNO-routes"},
    {city_code: "VNO", layer_type_code: "DENSITY", tile_url: "nktb.doqruynk"},
    {city_code: "VNO", layer_type_code: "bus_lines", tile_url: "nktb.9zwnwosv"},
    {city_code: "VNO", layer_type_code: "stops_cover", tile_url: "nktb.VNO-stops_cover"},
    {city_code: "VNO", layer_type_code: "dtp_map", tile_url: "nktb.VNO-dtp_map"},
    {city_code: "VNO", layer_type_code: "dtp_ochagi", tile_url: "nktb.VNO-dtp_ochagi"},
    {city_code: "VNO", layer_type_code: "stops_distance", tile_url: "nktb.VNO-stops_distance"},

    {city_code: "MNK", layer_type_code: "STATIONS", tile_url: "nktb.MNK-bus_stops"},
    {city_code: "MNK", layer_type_code: "ROUTES", tile_url: "nktb.MNK-routes"},
    {city_code: "MNK", layer_type_code: "DENSITY", tile_url: "nktb.4i13e8lt"},
    {city_code: "MNK", layer_type_code: "DENSITY2", tile_url: "nktb.3gae5mx7"},
    {city_code: "MNK", layer_type_code: "bus_lines", tile_url: "nktb.9zwnwosv"},
    {city_code: "MNK", layer_type_code: "stops_cover", tile_url: "nktb.MNK-stops_cover"},
    {city_code: "MNK", layer_type_code: "stops_distance", tile_url: "nktb.MNK-stops_distance"},

    {city_code: "KIR", layer_type_code: "STATIONS", tile_url: "nktb.KIR-bus_stops"},
    {city_code: "KIR", layer_type_code: "ROUTES", tile_url: "nktb.KIR-routes"},
    {city_code: "KIR", layer_type_code: "DENSITY", tile_url: "nktb.KIR-density"},
    {city_code: "KIR", layer_type_code: "bus_lines", tile_url: "nktb.9zwnwosv"},
    {city_code: "KIR", layer_type_code: "stops_cover", tile_url: "nktb.KIR-stops_cover"},
    {city_code: "KIR", layer_type_code: "stops_distance", tile_url: "nktb.KIR-stops_distance"}

  ]
  items.each do |row|
    city_id = City.find_by_code(row[:city_code]).id
    layer_type_id = LayerType.find_by_code(row[:layer_type_code]).id

    item = Layer.find_or_initialize_by(city_id: city_id, layer_type_id: layer_type_id)
    item.update!(tile_url: row[:tile_url])
  end
  puts "Layers: done"

end

# ====================================
# Stations
# ====================================
if seeds_params.include? 'stations'

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

end

# ====================================
# Routes
# ====================================
if seeds_params.include? 'routes'

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

end

# ====================================
# Routes info
# ====================================

if seeds_params.include? 'routes_info'

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

end

# ====================================
# LnkStationRoutes
# ====================================
if seeds_params.include? 'lnk_route_stations'

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
end

# ====================================
# Isohrones/ Public Transport
# ====================================

if seeds_params.include? 'iso_public_trans'
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
end

# ====================================
# Isohrones/ Walking, cycling, driving
# ====================================
if seeds_params.include? 'iso_c_w_d'
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
end

# ====================================
# Isohrones/ Route Cover
# ====================================

if seeds_params.include? 'route_cover'

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

# ====================================
# Metris
# ====================================
if seeds_params.include? 'metrics'
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
end

# ====================================
# StationMetris: accessibility
# ====================================
if seeds_params.include? 'station_metrics'
  puts "Station Metrics: begin"

  metric_type_in = MetricType.find_by(metric_code: 'isochrone_area')
  metric_type_out = MetricType.find_by(metric_code: 'accessibility')

  #created_iso_ids = StationMetric.where(metric_type_id: metric_type_out.id).map(&:isochrone_id)
  #puts(created_iso_ids)
  metrics_in = Metric.where(metric_type_id: metric_type_in.id).where('isochrone_unique_code LIKE ?', "%-walking-5")#.where.not(isochrone_id: created_iso_ids)

  items = []

  metrics_in.each do |row|
    iso = Isochrone.find(row.isochrone_id)
    item = {
      metric_type_id: metric_type_out.id,
      station_id: iso.station_id, 
      metric_value: (row.metric_value*100/0.78).round(2)
    }
    #puts(item)
    items << StationMetric.new(item)
    if items.length == 1000
      StationMetric.import items, batch_size: 1000, on_duplicate_key_update: {conflict_target: [:metric_type_id, :station_id], columns: [:metric_value]}
      items = []
    end
  end
  StationMetric.import items, batch_size: 1000, on_duplicate_key_update: {conflict_target: [:metric_type_id, :station_id], columns: [:metric_value]}

  puts "Station Metrics: done"
end
