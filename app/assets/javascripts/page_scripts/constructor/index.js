var map;
// Параметр доступных слоёв для выбранного города
var availableLayers = [];
var default_layers = [];

Paloma.controller('Constructor',
{
  index: function(){

  	// ключ для Mapbox
    var publicToken = 'pk.eyJ1Ijoibmt0YiIsImEiOiJjazhscjEwanEwZmYyM25xbzVreWMyYTU1In0.dcztuEUgjlhgaalrc_KLMw';

    // Добавялем ключ для Mapbox
    mapboxgl.accessToken = publicToken;

    // Popup для остановки
    var obj_popup = new mapboxgl.Popup();
    var point_popup = new mapboxgl.Popup();

    var selectpickerWhiteList = $.fn.selectpicker.Constructor.DEFAULTS.whiteList;
    selectpickerWhiteList.span = ['title'];

    // Выбранные точки маршрута
    var selected_points = [];
    var marker = new mapboxgl.Marker();
    var map_markers = [];
    var metrics = [];

    // Список слоёв для инструментов карты
    var toolsLayers = [];

    // Инициализируем карту
    map = new mapboxgl.Map({
      container: 'map',
      style: 'mapbox://styles/mapbox/streets-v11',
      //style: 'mapbox://styles/nktb/ckhz47ok9163u19mvnu6494pl',
      center: [37.618936,55.754388],
      zoom: 11.5
    });

    map.addControl(new mapboxgl.NavigationControl(),'bottom-right')

    // Выбранный город
    var selected_city_id = $("#city_select").val();
    // Центруем карту по границам выбранного города
    centerMap();

    // Функция обработки события переключения города
    $("#city_select").on('click',function(e){
      selected_city_id = e.target.value;
      getCityLayers();
      getCityRoutes();
      centerMap();
      city_code = $('#city_select').find(':selected').data('code');
      window.history.pushState('constructor', 'Mostransport', 'constructor?city='+city_code);
    });

    map.on('load', function() {
      // Загрузка слоёв для выбранного города
      getCityLayers();
      getCityRoutes();
      $('#tools_btns').removeClass('d-none').addClass('d-flex');
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

    // Функция загрузки нового слоя
    function addNewLayer(name, type, paint){
      
      if (toolsLayers.includes(name) == false) {
        toolsLayers.push(name);

        map.addSource(name, {
          'type': 'geojson',
          'data': {
            'type': 'FeatureCollection',
            'features': []
          }
        });

        map.addLayer({
          'id': name,
          'type': type,
          'source': name,
          'paint': paint
        }, 'STATIONS');

      }
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

      if(active_id == 'station_info'){
        initStationInfoLayers();
      } 
      else if(active_id == 'route_search'){
        initRouteSearchLayers();
      }
      else if(active_id == 'constructor'){
        initConstructorLayers();
      }
      else if(active_id == 'isochrones'){
        initIsochronesLayers();
      }
      else if(active_id == 'dtp_map'){
        initDtpMapLayers();
      }
      else if(active_id == 'city_metrics'){
        initCityMetrics();
      }

      // Перекоючаем слои
      switch_tools_layers(selected_tool);

    });

    // Переключение слоёв инструментов
    function switch_tools_layers(selected_tool){
      selected_layers = toolsLayers.filter(function(l){return l.toLowerCase().startsWith(selected_tool) == true});
      selected_layers.forEach(function(l){
        map.setLayoutProperty(l, 'visibility', 'visible');
      });

      unselected_layers = toolsLayers.filter(function(l){return l.toLowerCase().startsWith(selected_tool) == false});
      unselected_layers.forEach(function(l){
        map.setLayoutProperty(l, 'visibility', 'none');
      });
    }

    // Обработчик события закрытия панели инструментов
    $('.close-tool').on('click',function(){
      $(this).closest('.tool_panel').addClass('d-none');
    });


    // Обработчик события клика на карте
    map.on('click', function(event) {
      event.features = map.queryRenderedFeatures(event.point, { layers: ['STATIONS','route_search']});

      $('.route_stop').removeClass('active_item');

      // Маршрутизация по функциям в зависимости от выбранного инструмента
      if(event.features[0] != null){
        selected_point = event.features[0];

        if(selected_tool == 'station_info'){
          $('#choose_stops_alert').addClass('d-none');
          marker.setLngLat(selected_point.geometry.coordinates).setPopup(obj_popup).addTo(map);
          addPointPopup(obj_popup,event);
          getStationInfo(selected_point);
        }
        else if(selected_tool == 'constructor'){
          drawPoint(selected_point);
        }
        else if(selected_tool == 'isochrones'){
          marker.setLngLat(selected_point.geometry.coordinates).setPopup(obj_popup).addTo(map);
          addPointPopup(obj_popup,event);
          getIsochrones(selected_point);
        }
        else if(selected_tool == 'route_search'){
          getRouteInfo(selected_point.properties.route_id);
        }
      }

    });

    // ========== Метрики города ======================//
    function initCityMetrics(){
      params = {
        selected_city_id: selected_city_id
      }

      $.get("/constructor/get_city_metrics", params);
    }

    // ========== Информация об остановках ============//

    // Функция инициализации слоёв для отображения информции об остановках
    function initStationInfoLayers(){
      // Изохроны
      addNewLayer("station_info_iso", 'fill', 
        {
          'fill-color': '#00ceff',
          'fill-opacity': 0.5
        });

      // Маршруты
      addNewLayer('station_info_routes', 'line', 
        {
          'line-width': 6,
          'line-color': ["get","color"]
        });
    }

    // Функция получения информации об остановке
    function getStationInfo(selected_station){
      params = {
        station_source_id: selected_station.properties.global_id,
        selected_city_id: selected_city_id
      }

      $.get("/constructor/get_station_info", params)
        .done(function(data) {
        });
    }


    // ========== Поиск маршрутов ===================//
    
    // Функция инициализации слоёв для отображения информации о маршрутах
    function initRouteSearchLayers(){
      // Изохроны
      addNewLayer("route_search_iso", 'fill', 
        {
          'fill-color': '#00ceff',
          'fill-opacity': 0.5
        });
      // Маршруты
      addNewLayer('route_search', 'line', 
        {
          'line-width': 5,
          'line-color': ["case",["has","color"],["get","color"],'#F7455D']
        });
    }

    // Функция подгрузки списка маршрутов для выбранного города
    function getCityRoutes(){
      params = {
        city_id: selected_city_id
      };
      $.get('/routes/get_city_routes',params);
      $('#selected_routes').html("");
    }

    // Обработчик события выбора маршрута в списке маршрутов
    $(document).on('click', '.route_link', function (e) {
      e.preventDefault();
      route_id = $(this).data("route_id");
      getRouteInfo(route_id);
    });

    // Функция получения ифнормации о маршруте
    function getRouteInfo(route_id){
      params = {
        route_id: route_id
      };
      $.get('/routes/show', params);
    }

    // Обработчик события выбора маршрутов в строке поиска
    $(document).on('changed.bs.select', '#route_select', function (e, clickedIndex, isSelected) {
      filterCityRoutes();
    });

    // Фильтрация списка маршруторв города
    function filterCityRoutes(){
      route_codes = $('#route_select').val();

      $('#selected_routes table tbody tr').each(function(e){
        if(route_codes.length == 0){
          $(this).removeClass('d-none');
        }
        else if(route_codes.includes($(this).data('route-code'))){
          $(this).removeClass('d-none');
        }
        else {
          $(this).addClass('d-none');
        }
      });
    }

    // ========== Изохроны ==========//

    // Доступные опции времени изохронов
    var times = [30,20,10];

    // Выбранные по умолчанию параметры изохронов
    var profile = 'public_transport';
    var minutes = [0,10,20,30];
    var use_intervals = false;
    var use_changes = false;
    var selected_point;

    // Функция инициализации слоёв для отображения Изохронов
    function initIsochronesLayers(){
      // Изохроны
      addNewLayer("isochrones_iso", 'fill', 
        {
          'fill-color': ["case",
                          ["==",["get","contour"],10],'#63d125',
                          ["==",["get","contour"],20],'#efd700',
                          ["==",["get","contour"],30],'#ef8725',
                          '#efac00'
                        ],
          'fill-opacity': 0.5
        },'isochrones_change_routes');

      // Пересадочные маршруты
      addNewLayer('isochrones_change_routes', 'line', 
        {
          'line-width': 3,
          'line-color': '#979797'
        },'isochrones_routes');

      // Маршруты
      addNewLayer('isochrones_routes', 'line', 
        {
          'line-width': 5,
          'line-color': ["case",["has","color"],["get","color"],'#F7455D']
        });

    }

    // Отправка запроса для получения изохронов по выбранной точке
    function getIsochrones(selected_point){

      params = {
        station_id: [selected_point.properties.global_id],
        profile: profile,
        with_interval: use_intervals,
        with_changes: use_changes,
        city_id: selected_city_id,
        show_routes: (profile == 'public_transport')
      }

      $.get("/isochrones/show", params);

    }

    // Обработка событий переключения параметров изохронов
    $('#params').on('change', function(e) {
      if (e.target.name === 'profile') {
        profile = e.target.value;
      } 
      
      if(profile == 'public_transport'){
        use_intervals = document.getElementById('use_intervals').checked;
        use_changes = document.getElementById('use_changes').checked;
      } else {
        use_intervals = null;
        use_changes = null;
      }

      getIsochrones(selected_point);

    });

    // Функция обработки событий переключения времени изохронов
    $('button[name="duration"]').on('click',function(e){
      e.preventDefault();
      btn = e.target;
      val = $(btn).data("value");

      if(minutes.includes(val)){
        minutes = minutes.filter(function(el){return el != val});
        $(btn).removeClass("active");
      } else{
        minutes.push(val);
        $(btn).addClass("active");
      }
      
      // Устанавливаем фильтры на слой с остановками
      filter_minutes = ["match",["get", "contour"], minutes, true, false];
      map.setFilter('isochrones_iso', filter_minutes);

    });

    // ========== Функции карты ДТП ==========//

    // Функция инициализации фильтров для карты ДТП
    function initDtpMapLayers(){
      // Включаем слой с картой ДТП
      params = JSON.parse($('#layers_search option[name="dtp_map"]').html());
      showLayer(params);
      toolsLayers.push("dtp_map");

      // Добавляем Обработчики для фильтров
      $(document).on('changed.bs.select', '.dtp-filter', function (e, clickedIndex, isSelected) {
        filterDtpMap();
      });

    }

    function filterDtpMap(){
      // Получаем список выбранных значений
      dtp_year = $('#dtp_year').val();
      dtp_category = $('#dtp_category').val();
      dtp_severity = $('#dtp_severity').val();
      dtp_light = $('#dtp_light').val();
      dtp_participant_categories = $('#dtp_participant_categories').val();

      // Готовим параметры фильтров
      if(dtp_year.length > 0){
        filter_year = ["match",["slice",["get", "datetime"],0,4], dtp_year, true, false];
      } else {
        filter_year = true;
      }

      if(dtp_category.length > 0){
        filter_category = ["match",["get", "category"], dtp_category, true, false];
      } else {
        filter_category = true;
      }

      if(dtp_severity.length > 0){
        filter_severity = ["match",["get", "severity"], dtp_severity, true, false];
      } else {
        filter_severity = true;
      }

      if(dtp_light.length > 0){
        filter_light = ["match",["get", "light"], dtp_light, true, false];
      } else {
        filter_light = true;
      }

      if(dtp_participant_categories.length > 0){
        filter_participant_categories = ["in",dtp_participant_categories,["get", "participant_categories"]];
        //filter_participant_categories = ["any"]
      } else {
        filter_participant_categories = true;
      }

      // Добавляем фильтры на слой с дтп
      map.setFilter('dtp_map', ["all",filter_year, filter_category, filter_severity, filter_light, filter_participant_categories]);
    }

    // ========== Функции конструктора маршрутов ==========//

    // Функция инициализации слоёв для конструктора маршрутов
    function initConstructorLayers(){
      // Изохроны
      addNewLayer("constructor_iso", 'fill', 
        {
          'fill-color': '#00ceff',
          'fill-opacity': 0.5
        });

      // Маршруты
      addNewLayer('constructor_routes', 'line', 
        {
          'line-width': 4,
          'line-color': '#448ee4'
        });

      addNewLayer('constructor_compute_routes', 'line', 
        {
          'line-width': 6,
          'line-color': '#F7455D'
        });
    }

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
        map.getSource('constructor_routes').setData(line);
      } else {
        map.getSource('constructor_routes').setData(turf.featureCollection([]));
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
          map.getSource('constructor_compute_routes').setData(line);

          metrics.push({name:"Длина",value: (route.distance/1000).toFixed(2)+" км", order:0})
          displayMetrics();

          getStraightness();
        });
      } else {
        map.getSource('constructor_compute_routes').setData(turf.featureCollection([]));
      }
      map.setFilter('constructor_compute_routes', true);
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

          map.getSource('constructor_iso').setData(combined);

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

      // Очищаем слои для инструментов текущего города
      toolsLayers.forEach(function(l){
        if (map.getLayer(l)) {
          map.getSource(l).setData(turf.featureCollection([]));
        }
      });

      params = {
        city_id: selected_city_id
      }

      $.get("/constructor/get_layers", params)
        .done(function(data) {
          default_layers.forEach(function(l){
            params = JSON.parse($('#layers_search option[name="'+l+'"]').html());
            showLayer(params);
          });
          //initCityMetrics();
        });
    }

    // Обработчик события выбора слоя
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
        console.log("exits");
        map.setFilter(layer_code,true);
      }
      // Иначе загружаем слой
      else {
        console.log("draw");
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
      },(layer_code == 'STATIONS') ? 'building-number-label' : 'STATIONS');

      // Change the cursor to a pointer when it enters a feature in the 'points' layer.
      map.on('mouseenter', layer_code, function(e) {
        map.getCanvas().style.cursor = 'pointer';
        addPopup(point_popup,e);
      });

      // Change it back to a pointer when it leaves.
      map.on('mouseleave', layer_code, function() {
        map.getCanvas().style.cursor = '';
        point_popup.remove();
      });
    }

    // Добавление popup для всех слоёв
    function addPopup(popup, e){
      html = "";
      props = e.features[0].properties

      for (p in props) {
        html += "<span><b>"+p+":</b> "+props[p]+"</span><br>"
      }

      popup.setLngLat(e.lngLat)
        .setHTML(html)
        .addTo(map);
    }

  }
});