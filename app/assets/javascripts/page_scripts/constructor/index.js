Paloma.controller('Constructor',
{
  index: function(){
  	// ключ для Mapbox
    var publicToken = 'pk.eyJ1Ijoibmt0YiIsImEiOiJjazhscjEwanEwZmYyM25xbzVreWMyYTU1In0.dcztuEUgjlhgaalrc_KLMw';

    // Остановки ОТ
    var pointsTileset = "nktb.bev2q4f8" //ID tileset объектов
    var pointsSourceLayer = "bus_stops"; //Название SourceLayer

    // Слои с объектами на карте
    var data_layers = [
      {name_quantity: 'Кол-во домов', name_population: 'Кол-во жителей', name: 'houses', url: 'nktb.314cfju0',icon:'house'},
      {name_quantity: 'Кол-во офисов', name_population: 'Кол-во работников', name: 'offices', url: 'nktb.48uv4euq',icon:'suitcase'},
      {name_quantity: 'Кол-во университетов', name_population: 'Кол-во студентов', name: 'universities', url: 'nktb.3m9uqakn',icon:'college'}
    ];

    // Добавялем ключ для Mapbox
    mapboxgl.accessToken = publicToken;

    // Popup для остановки
    var point_popup = new mapboxgl.Popup();

    // Выбранные точки маршрута
    var selected_points = [];
    var map_markers = [];
    var metrics = [];

    // Инициализируем карту
    var map = new mapboxgl.Map({
      container: 'map',
      style: 'mapbox://styles/mapbox/streets-v11',
      center: [37.618936,55.754388],
      zoom: 11.5
    });

    map.on('load', function() {

      // Слой с изохронами маршрута
      map.addSource('isochrones', {
       type: 'geojson',
       data: {
         'type': 'FeatureCollection',
         'features': []
       }
      });

      map.addLayer({
       'id': 'isochrones',
       'type': 'fill',
       // Use "iso" as the data source for this layer
       'source': 'isochrones',
       'layout': {},
       'paint': {
          'fill-color': '#63d125',
          'fill-opacity': 0.5
        }
      });

      // Слой для рисования линий маршрутов конструктора
      map.addSource('line_routes', {
        'type': 'geojson',
        'data': {
          'type': 'FeatureCollection',
          'features': []
        }
      });

      map.addLayer({
        'id': 'line_routes',
        'type': 'line',
        'source': 'line_routes',
        'paint': {
          'line-width': 4,
          'line-color': '#448ee4'
        }
      });

      // Слой для отображения рассчитанного пути маршрута
      map.addSource('routes', {
        'type': 'geojson',
        'data': {
          'type': 'FeatureCollection',
          'features': []
        }
      });

      map.addLayer({
        'id': 'routes',
        'type': 'line',
        'source': 'routes',
        'paint': {
          'line-width': 6,
          'line-color': '#F7455D'
        }
      });

    	// Слой с остановками
  		map.addSource("points", {
  			  "type": "vector",
  			  "url": "mapbox://"+pointsTileset,
  			  "tileSize": 512
  			}
  		);

  		map.addLayer({
    			'id': 'points',
    			'type': 'circle',
    			'source': 'points',
    			'source-layer': pointsSourceLayer,
    			//'filter': false,
    			'paint': {
    			  'circle-radius': {
    			    'stops': [[9, 2], [22, 15]]
    			  },
    			  'circle-color': '#3976bc'
    			}
    	});

      // Загружаем слои с доп. данными
      data_layers.forEach(function(layer){
        map.addSource(layer.name, {
            "type": "vector",
            "url": "mapbox://"+layer.url,
            "tileSize": 512
          }
        );

        map.addLayer({
          'id': layer.name,
          'type': 'symbol',
          'source': layer.name,
          'source-layer': layer.name,
          'filter': false,
          'layout': {
            'icon-image': layer.icon+'-15',
            'icon-padding': 0,
            'icon-allow-overlap': true
          }
        });
      });

    });

    // Change the cursor to a pointer when it enters a feature in the 'points' layer.
    map.on('mouseenter', 'points', function(e) {
      map.getCanvas().style.cursor = 'pointer';
      addPointPopup(e);
    });

    // Change it back to a pointer when it leaves.
    map.on('mouseleave', 'points', function() {
      map.getCanvas().style.cursor = '';
      point_popup.remove();
    });

    // Добавление popup для остановок
    function addPointPopup(e){
      point_popup.setLngLat(e.lngLat)
        .setHTML(
          "<div class='loading loading--s none'></div>"
          +
          "<span><b>ID:</b> "+e.features[0].properties.global_id+"</span><br>"
          +
          "<span><b>Остановка:</b> "+e.features[0].properties.StationName+"</span><br>"
          +
          "<span><b>Маршруты:</b> "+e.features[0].properties.RouteNumbers+"</span>"
          )
        .addTo(map);
    }

    map.on('click', function(event) {
      selected_point = map.queryRenderedFeatures(event.point, { layers: ['points']})[0];
      $('.route_stop').removeClass('active_item');
      
      if(selected_point != null){
        global_id = selected_point.properties.global_id;

        if(selected_points.filter(function(p){return p.properties.global_id == global_id}).length == 0){
          selected_points.push(selected_point);
          marker = new mapboxgl.Marker().setLngLat(selected_point.geometry.coordinates).addTo(map);
          marker.stop_id = global_id;
          map_markers.push(marker);

          drawRouteList();
          drawLineRoute();

          $('#constr_btns').addClass('d-flex');
        } else {
          $('.route_stop[data-stop-id='+global_id+']').addClass('active_item');
        }
        
      }

    });

    // Обработчик нажатия конпки очистки маршрута
    $('#clean_route').on('click',function(e){
      metrics = [];
      selected_points = [];

      map_markers.forEach(function(m){m.remove()});
      map_markers = [];

      drawRouteList();
      drawLineRoute();
      displayMetrics();
      getDirectionRoute();

      $('#constr_btns').removeClass('d-flex');
    });

    // Обработчик нажатия конпки расчёта параметров маршрута
    $('#calculate_route').on('click',function(e){
      metrics = [];
      getDirectionRoute();
      getRouteIsochrones();
    });

    // Функция отображения списка остановок маршрута
    function drawRouteList(){
      $('#route_list').html("");
      if (selected_points.length > 0){
        $('#choose_points_alert').addClass('d-none');

        selected_points.forEach(function(stop,i){
          if(i > 0){
            div_html = '<div class="route_line"></div>' 
            $('#route_list').append(div_html)
          }          

          stop_html = '<div class="route_stop d-flex align-items-center pr-2 rounded" data-stop-id="'+stop.properties.global_id+'"">'
          +'<svg class="icon w30 h36 color-blue"><use xlink:href="#icon-marker"/></svg>'
          +'<span class="stop_name ml6">Мост</span>'
          +'<button type="button" class="close ml-auto remove-stop" aria-label="Close"><span aria-hidden="true">&times;</span></button>'
          +'</div>';
          stop_el = $(stop_html);
          $(stop_el).find('.stop_name').text(stop.properties.StationName);
          $('#route_list').append(stop_el);

        });
        
      } else {
        $('#choose_points_alert').removeClass('d-none');
      }
    }

    // Обработчик события удаления остановки
    $(document).on('click','.remove-stop',function(e){
      stop_id = $(e.target).closest('.route_stop').data('stop-id');
      deletePoint(stop_id);
    });

    // Функция удаления остановки из маршрута
    function deletePoint(stop_id){
      // Удаляем остановку из массива
      selected_points = selected_points.filter(function(p){return p.properties.global_id != stop_id});

      //Удаляем маркер
      map_markers.filter(function(m){return m.stop_id == stop_id})[0].remove();
      map_markers = map_markers.filter(function(m){return m.stop_id != stop_id});

      // Перерисовываем маршрут
      drawRouteList();
      drawLineRoute();
    }

    // Функция отрисовки маршрута прямыми линиями
    function drawLineRoute(){
      if (selected_points.length > 1){
        line_coords = selected_points.map(function(p){return p.geometry.coordinates});
        line = turf.lineString(line_coords);
        map.getSource('line_routes').setData(line);
      } else {
        map.getSource('line_routes').setData(turf.featureCollection([]));
      }
    }

    // Функция генерации маршрута через API MapBox
    function getDirectionRoute(){
      if (selected_points.length > 1){
        urlBase = "https://api.mapbox.com/directions/v5/mapbox/driving/"
        coords = selected_points.map(function(p){return p.geometry.coordinates.join(",")}).join(";");
        query = urlBase +coords+'?geometries=geojson'+'&access_token=' + publicToken

        $.get(query)
        .done(function(data) {
          route = data.routes[0]
          line = turf.feature(route.geometry);
          map.getSource('routes').setData(line);

          metrics.push({name:"Длина",value: (route.distance/1000).toFixed(2)+" км", order:0})
          displayMetrics();

          getStraightness();
        });
      } else {
        map.getSource('routes').setData(turf.featureCollection([]));
      }
    }

    // Расчёт коэф. прямолинейности
    function getStraightness(){
      urlBase = "https://api.mapbox.com/directions/v5/mapbox/driving/"
      
      start_point = selected_points[0].geometry.coordinates.join(",");
      end_point = null;

      if (selected_points[0].properties.global_id == selected_points.slice(-1)[0].properties.global_id){
        end_point = selected_points.slice(-2)[0].geometry.coordinates.join(",");
      } else {
        end_point = selected_points.slice(-1)[0].geometry.coordinates.join(",");
      }

      query = urlBase +start_point+";"+end_point+'?geometries=geojson'+'&access_token=' + publicToken

      $.get(query)
        .done(function(data) {
          route = data.routes[0];
          user_route_dist = parseFloat(metrics.find(function(m){return m.name == "Длина"}).value);
          straightness = ((route.distance/1000)/user_route_dist).toFixed(2);
          metrics.push({name:"Прямолинейность",value: straightness, order:1});
          displayMetrics();
        });
    }

    // Функция получения изохронов по остановкам маршрута
    function getRouteIsochrones(){
      params = {
        station_id: selected_points.map(function(p){return p.properties.global_id}),
        profile: 'walking',
        contour: 5
      }

      $.get("/map/get_isochrones", params)
        .done(function(data) {
          isochrones = turf.featureCollection(data.map(function(i){return turf.feature(i.geo_data)}));

          combined = turf.featureReduce(isochrones, function (prev, cur, indx) {
            union = turf.union(prev, cur)
            return union
          });

          map.getSource('isochrones').setData(combined);

          getIsochroneMetrics(combined);
      });
    }

    // Функция расчёта метрик изохрона маршрута
    function getIsochroneMetrics(isochrone){
      f = new Intl.NumberFormat('ru-RU', {style: 'decimal'});

      // Считаем площадь изохрона
      area = (turf.area(isochrone)/1000000).toFixed(2);
      metrics.push({name:"Площадь",value: f.format(area)+" км2", order:1});

      // Считаем кол-во объектов внутри изохрона
      data_layers.forEach(function(layer,i){
        objects = getObjectsInside(isochrone, layer.name);
        objects_cnt = objects.features.length;
        if(objects_cnt > 0){
          metrics.push({name:layer.name_quantity, value: objects.features.length, order:i+2});

          populations = objects.features.map(function(o){return o.properties.population})
          population = populations.reduce(function(p,c){return p+c})
          metrics.push({name:layer.name_population, value: f.format(population), order:i+3});
        }

      });
      // Отображаем все метрики
      displayMetrics();
    }

    // Функция расчёта кол-ва объектов и кол-ва людей внутри изохрона
    function getObjectsInside(feature, source_name){
      console.log("getObjectsInside");

      points = map.querySourceFeatures(source_name, { sourceLayer: source_name});
      
      points = turf.featureCollection(points);
      filtered = turf.pointsWithinPolygon(points, feature);

      // Убираем дубликаты точек
      filtered_points = [];
      filtered.features.forEach(function(p){
        ids = filtered_points.map(function(m){return m.properties.id});
        if (filtered_points.length == 0 || ids.includes(p.properties.id) == false){
          filtered_points.push(p);
        }
      });

      return turf.featureCollection(filtered_points);
    }

    // Функция отображения метрик
    function displayMetrics(){
      $('#route_stat tbody').html("");
      if(metrics.length > 0){
        $('#route_metrics').removeClass('d-none');
        metrics.sort(function(a, b){return a.order - b.order});
        metrics.forEach(function(metric){

          td_name = '<td>'+ metric.name +'</td>';
          td_val = '<td>'+ metric.value +'</td>';
          tr = '<tr>'+td_name+td_val+'</tr>';        

          $('#route_stat').find('tbody').append(tr);

        });
      } else {
        $('#route_metrics').addClass('d-none');
      }
    }

  }
});