var map;
// Параметр доступных слоёв для выбранного города
var availableLayers = [];

Paloma.controller('Constructor',
{
  index: function(){
  	// ключ для Mapbox
    var publicToken = 'pk.eyJ1Ijoibmt0YiIsImEiOiJjazhscjEwanEwZmYyM25xbzVreWMyYTU1In0.dcztuEUgjlhgaalrc_KLMw';

    // Слои с объектами на карте
    var data_layers = [
      {name_quantity: 'Кол-во домов', name_population: 'Кол-во жителей', name: 'houses', url: 'nktb.314cfju0',icon:'house'},
      {name_quantity: 'Кол-во офисов', name_population: 'Кол-во работников', name: 'offices', url: 'nktb.48uv4euq',icon:'suitcase'},
      {name_quantity: 'Кол-во университетов', name_population: 'Кол-во студентов', name: 'universities', url: 'nktb.3m9uqakn',icon:'college'}
    ];

    // Добавялем ключ для Mapbox
    mapboxgl.accessToken = publicToken;

    // Popup для остановки
    var obj_popup = new mapboxgl.Popup();
    var point_popup = new mapboxgl.Popup();

    // Выбранные точки маршрута
    var selected_points = [];
    var marker = new mapboxgl.Marker();
    var map_markers = [];
    var metrics = [];

    // Инициализируем карту
    map = new mapboxgl.Map({
      container: 'map',
      style: 'mapbox://styles/mapbox/streets-v11',
      //style: 'mapbox://styles/nktb/ckhz47ok9163u19mvnu6494pl',
      center: [37.618936,55.754388],
      zoom: 11.5
    });

    // Выбранный город
    var selected_city_id = $("#city_select").val();
    // Центруем карту по границам выбранного города
    centerMap();

    // Загрузка слоёв для выбранного города
    getCityLayers();

    // Функция обработки события переключения города
    $("#city_select").on('click',function(e){
      selected_city_id = e.target.value;
      getCityLayers();
      centerMap();
      city_code = $('#city_select').find(':selected').data('code');
      window.history.pushState('constructor', 'Mostransport', 'constructor?city='+city_code);
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
          'fill-color': '#00ceff',//'#63d125',
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
          'line-color': ["case",["has","color"],["get","color"],'#F7455D']
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
    map.on('mouseenter', 'STATIONS', function(e) {
      map.getCanvas().style.cursor = 'pointer';
      addPointPopup(point_popup,e);
    });

    // Change it back to a pointer when it leaves.
    map.on('mouseleave', 'STATIONS', function() {
      map.getCanvas().style.cursor = '';
      point_popup.remove();
    });

    // Перемещаем карту в границу, выбранного города
    function centerMap(){
      bbox = $('#city_select').find(':selected').data('bbox');
      map.fitBounds(bbox, {
        padding: {top: 10, bottom:10, left: 10, right: 10}
      });
    }

    // Добавление popup для остановок
    function addPointPopup(popup, e){
      popup.setLngLat(e.lngLat)
        .setHTML(
          "<div class='loading loading--s none'></div>"
          +
          "<span><b>Остановка:</b> "+e.features[0].properties.StationName+"</span><br>"
          +
          "<span><b>Маршруты:</b> "+e.features[0].properties.RouteNumbers+"</span>"
          )
        .addTo(map);
    }

    // ========== Переключение инструментов ==========//

    var selected_tool = $('#tools_btns .btn.active').data('target');
    $('#tools_btns .btn').on('click',function(){
      $('#tools_btns .btn').removeClass('active');
      $(this).addClass('active');

      active_id = $(this).data('target');
      $('.tool_panel').addClass('d-none');
      $('#'+active_id).removeClass('d-none');

      selected_tool = active_id;
    });


    // Обработчик события клика на карте
    map.on('click', function(event) {
      event.features = map.queryRenderedFeatures(event.point, { layers: ['STATIONS']});
      selected_point = event.features[0];

      $('.route_stop').removeClass('active_item');

      // Маршрутизация по функциям в зависимости от выбранного инструмента
      if(selected_point != null){
        if(selected_tool == 'station_info'){
          marker.setLngLat(selected_point.geometry.coordinates).setPopup(obj_popup).addTo(map);
          // create the popup
          addPointPopup(obj_popup,event);

          getStationInfo(selected_point);
        }
        else if(selected_tool == 'constructor'){
          drawPoint(selected_point);
        }
      }

    });

    // ========== Функции конструктора маршрутов ==========//

    // Функция установки нового маркера для маршрута
    function drawPoint(selected_point){
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
          +'<svg class="bi bi-geo-alt text-blue mr-2" width="1.5em" height="1.5em" viewBox="0 0 16 16" fill="currentColor" xmlns="http://www.w3.org/2000/svg">'
          +'<path fill-rule="evenodd" d="M8 16s6-5.686 6-10A6 6 0 0 0 2 6c0 4.314 6 10 6 10zm0-7a3 3 0 1 0 0-6 3 3 0 0 0 0 6z"/>'
          +'</svg>'
          +'<span class="stop_name">Мост</span>'
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
      map.setFilter('routes', true);
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

    // ========== Управление отображениея слоёв на карте ============//

    // Функция подгрузки  URL слоёв города
    function getCityLayers(){
      // Удаляем загруженные слои текущего города
      availableLayers.forEach(function(l){
        if (map.getLayer(l)) {
          map.removeLayer(l);
          map.removeSource(l);
        }
      });

      params = {
        city_id: selected_city_id
      }

      $.get("/constructor/get_layers", params)
        .done(function(data) {
          //console.log(data);
        });
    }

    // Обработчик события выбора маршрутов в строке поиска
    $(document).on('changed.bs.select', '#layers_search', function (e, clickedIndex, isSelected) {
      layer_params = $('#layers_search').val();
      
      selected_layers = layer_params.map(function(l){return JSON.parse(l).layer_code});

      // Отображаем выбранные слои
      layer_params.forEach(function(p){
        showLayer(JSON.parse(p));
      });

      // Скрываем, те которые не выбраны
      availableLayers.forEach(function(l){
        if(!selected_layers.includes(l)){
          hideLayer(l);
        }
      });
    });

    // Функция отображения слоя
    function showLayer(params){
      layer_code = params.layer_code;

      // Если слой уже загружен, делаем его видимым
      if (map.getLayer(layer_code)) {
        map.setFilter(layer_code,true);
      }
      // Иначе загружаем слой
      else {
        drawLayer(params);
      }
    }

    // Функция скрытия слоя
    function hideLayer(layer_code){
      if (map.getLayer(layer_code)) {
        map.setFilter(layer_code,false);
      }
    }

    // Функция загрузки нового слоя
    function drawLayer(params){
      layer_code = params.layer_code;
      tile_url = params.tile_url;
      source_name = params.source_name;
      draw_type = params.draw_type;
      paint_rule = JSON.parse(params.paint_rule);

      map.addSource(layer_code, {
          "type": "vector",
          "url": "mapbox://"+tile_url,
          "tileSize": 512
        }
      );

      map.addLayer({
          'id': layer_code,
          'type': draw_type,
          'source': layer_code,
          'source-layer': source_name,
          'paint': paint_rule
      });
    }

    // ========== Информация об остановках ============//
    function getStationInfo(selected_station){
      params = {
        station_source_id: selected_station.properties.global_id,
        selected_city_id: selected_city_id
      }

      $.get("/constructor/get_station_info", params)
        .done(function(data) {
        });
    }
  }
});