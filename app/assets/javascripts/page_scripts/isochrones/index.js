var map;
Paloma.controller('Isochrones',
{
  index: function(){
    //=========================================
    // Инициализация карты и её слоёв
    //=========================================
    // ключ для Mapbox
    var publicToken = 'pk.eyJ1Ijoibmt0YiIsImEiOiJjazhscjEwanEwZmYyM25xbzVreWMyYTU1In0.dcztuEUgjlhgaalrc_KLMw';

    // Остановки ОТ
    var station_tiles = [
      {city_code: 'MSK', tile_url: 'nktb.bev2q4f8'},
      {city_code: 'USH', tile_url: 'nktb.6v5aby4g'},
    ];
    var pointsTileset = $("#city_select").find(':selected').data('tile_url'); //ID tileset объектов
    var pointsSourceLayer = "bus_stops"; //Название SourceLayer

    // Данные по вспомогательным объектам
    var data_layers = [
      {name_quantity: 'Кол-во домов', name_population: 'Кол-во жителей', name: 'houses', url: 'nktb.314cfju0',icon:'house'},
      {name_quantity: 'Кол-во офисов', name_population: 'Кол-во работников', name: 'offices', url: 'nktb.48uv4euq',icon:'suitcase'},
      {name_quantity: 'Кол-во университетов', name_population: 'Кол-во студентов', name: 'universities', url: 'nktb.3m9uqakn',icon:'college'}
    ];

    // Доступные опции времени изохронов
    var times = [30,20,10];

    // Добавялем ключ для Mapbox
    mapboxgl.accessToken = publicToken;

    // Инициализируем карту
    map = new mapboxgl.Map({
      container: 'map',
      style: 'mapbox://styles/mapbox/streets-v11',
      center: [37.618936,55.754388],
      zoom: 11.5
    });

    // Выбранный город
    var selected_city_id = $("#city_select").val();

    // Функция обработки события переключения города
    $("#city_select").on('click',function(e){
      selected_city_id = e.target.value;

      // Загружаем источник данных для остановок
      pointsTileset = $(this).find(':selected').data('tile_url');
      init_stations_layer();

      // Перемещаем карту в границу, выбранного города
      bbox = $(this).find(':selected').data('bbox');
      map.fitBounds(bbox, {
        padding: {top: 10, bottom:10, left: 10, right: 10}
      });
    });
     
    // create the marker
    var marker = new mapboxgl.Marker();

    // Popup для маркера
    var obj_popup = new mapboxgl.Popup();
    var point_popup = new mapboxgl.Popup();

    // Загрузка Tileset-ов для отображения объектов на карте
    function init_stations_layer(){

      if (map.getLayer("points")) {
          map.removeLayer("points");
          map.removeLayer("selected_points");
      }

      if (map.getSource("points")) {
          map.removeSource("points");
      }

      map.addSource("points", {
          "type": "vector",
          "url": "mapbox://"+pointsTileset,
          "tileSize": 512
        }
      );

      // Слой для отображения всех станций
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

      // Слой для отображения выбранных станций
      map.addLayer({
        'id': 'selected_points',
        'type': 'circle',
        'source': 'points',
        'source-layer': pointsSourceLayer,
        'filter': false,
        'paint': {
          'circle-radius': {
            'stops': [[9, 2], [22, 15]]
          },
          'circle-color': '#3976bc'
        }
      });
    }

    // Загрузка слоёв данных
    map.on('load', function() {

      // Слой для отображения индивидуальных изохронов
      map.addSource('pointIsochrones', {
       type: 'geojson',
       data: {
         'type': 'FeatureCollection',
         'features': []
       }
      });

      map.addLayer({
       'id': 'pointIsoLayer',
       'type': 'fill',
       // Use "iso" as the data source for this layer
       'source': 'pointIsochrones',
       'layout': {},
       'paint': {
          'fill-color': ["case",
                          ["==",["get","contour"],10],'#63d125',
                          ["==",["get","contour"],20],'#efd700',
                          ["==",["get","contour"],30],'#ef8725',
                          '#efac00'
                        ],
          //["concat",'cycling-',["get","contour"]]
          'fill-opacity': 0.5
        }
      });
      

      // Слой для отображения пересадочных маршрутов на карте
      map.addSource('changes_routes', {
        'type': 'geojson',
        'data': {
          'type': 'FeatureCollection',
          'features': []
        }
      });

      map.addLayer({
        'id': 'changes_routes',
        'type': 'line',
        'source': 'changes_routes',
        'paint': {
          'line-width': 3,
          'line-color': '#979797'
        }
      });

      // Слой для отображения маршрутов на карте
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
          'line-width': 3,
          'line-color': '#F7455D'
        }
      });

      // Загружаем слой с остановками
      init_stations_layer();


      // Change the cursor to a pointer when it enters a feature in the 'points' layer.
      data_layers.map(function(l){return l.name}).concat('points').forEach(function(l){
        map.on('mouseenter', l, function(e) {
          map.getCanvas().style.cursor = 'pointer';
          if(e.features[0].source == 'points'){
            addPointPopup(e);
          }
        });

        // Change it back to a pointer when it leaves.
        map.on('mouseleave', l, function() {
          map.getCanvas().style.cursor = '';
          obj_popup.remove();
          point_popup.remove();
        });
      });

      // Добавление popup для остановок
      function addPointPopup(e){
        point_popup.setLngLat(e.lngLat)
          .setHTML(
            "<div class='loading loading--s none'></div>"
            +
            "<span><b>ID:</b> "+e.features[0].properties.global_id+"</span><br>"
            +
            "<p>Остановка: "+e.features[0].properties.StationName+"</p>"
            +
            "<p>Маршруты: "+e.features[0].properties.RouteNumbers+"</p>"
            )
          .addTo(map);
      }

      map.on('click', function(event) {
        //console.log(event);
        prev_selected_point = selected_point;
        selected_point = map.queryRenderedFeatures(event.point, { layers: ['points']})[0];
           
        if(selected_point != null){
          console.log("selected_point");
          console.log(selected_point);

          // create the popup
          var popup = new mapboxgl.Popup({ offset: 40 }).setHTML(
            "<div class='loading loading--s none'></div>"
            +
            "<span><b>ID:</b> "+selected_point.properties.global_id+"</span><br>"
            +
            "<p>Остановка: "+selected_point.properties.StationName+"</p>"
            +
            "<p>Маршруты: "+selected_point.properties.RouteNumbers+"</p>"
          );
          
          // Добавляем маркер
          marker.setLngLat(selected_point.geometry.coordinates);
          marker.setPopup(popup);
          marker.addTo(map);
          marker.togglePopup();

          // Скрываем другие точки
          map.setPaintProperty('points', 'circle-color', '#aeaeae');
        } else {
          // Если не выбрана остановка, то показываем все точки
          map.setPaintProperty('points', 'circle-color', '#3976bc');
        }

        filterMap();
      });
      

    });


    //=========================================
    // Построение изохрона для выбранной точки
    //=========================================

    var selected_point;
    var prev_selected_point;       
    var prev_profile;
    var profile = 'public_transport';
    var minutes = [0,10,20,30];
    var use_intervals = false;
    var use_changes = false;

    // Target the "params" form in the HTML
    var params = document.getElementById('params');

    // When a user changes the value of profile or duration by clicking a button, change the parameter's value and make the API query again
    params.addEventListener('change', function(e) {
      if (e.target.name === 'profile') {
        prev_profile = profile;
        profile = e.target.value;
      } 
      
      if(profile == 'public_transport'){
        use_intervals = document.getElementById('use_intervals').checked;
        use_changes = document.getElementById('use_changes').checked;
      } else {
        use_intervals = null;
        use_changes = null;
      }

      prev_selected_point = selected_point;
      filterMap();

    });

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
      
      prev_selected_point = selected_point;
      filterMap();
    });

    // Функция фильтрации изохронов на карте
    function filterMap(){

      // Фильтры
      filter_minutes = ["match",["get", "contour"], minutes, true, false];
      filter_profile = ["==",["get", "profile"], profile];
      
      // Устанавливаем фильтры на слой с остановками
      map.setFilter('pointIsoLayer', ["all",filter_profile, filter_minutes]);

      if(selected_point != null){

        // Очищаем InfoBox
        hideInfoBox();

        if(selected_point != prev_selected_point || prev_profile != profile){
        	// Очищаем слои с маршрутом и с индивидуальными изохронами
	        map.getSource('pointIsochrones').setData({'type': 'FeatureCollection','features': []});
	        map.getSource('routes').setData({'type': 'FeatureCollection','features': []});

	        // Отправляем запрос на получение изохронов для точки
	        getIsochrones();

	        // Отправляем запрос на получение линий маршрутов 
	        if (profile == 'public_transport'){
	          getRoutes();
	        }
        }

      } 
    }

    // Отправка запроса для получения изохронов по выбранной точке
    function getIsochrones(){
      //console.log(selected_point);
      $('.loading').removeClass('none');

      params = {
        station_id: [selected_point.properties.global_id],
        profile: profile,
        with_interval: use_intervals,
        with_changes: use_changes,
        city_id: selected_city_id
      }

      console.log(params);

      $.get("/isochrones/get_isochrones", params)
      .done(function(data) {
  	    console.log("get_isochrones");
  	    console.log(data);

  	    isoFeatures = getIsochroneFeatures(data);
        console.log(isoFeatures);
        map.getSource('pointIsochrones').setData(isoFeatures);
        
        isochrone_ids = data.map(function(i){return i.id});
        getMetrics(isochrone_ids);

        // Подсвечиваем остановки выбранных маршрутов
        if(profile == "public_transport"){
          selected_stops = Array.from(new Set(data.map(function(d){return d.properties.stop_ids}).reduce(function(a, b){return a.concat(b)})));
          console.log(selected_stops);
          map.setFilter('selected_points', ["in",["get","global_id"], ["literal",selected_stops]]);
          
          // Получаем линии пересадочных маршрутов
          route_codes = Array.from(new Set(data.map(function(d){return d.properties.routes}).reduce(function(a, b){return a.concat(b)})));
          getChangesRoutes(route_codes);
        }
  	  })
  	  .always(function() {
  	    $('.loading').addClass('none');
  	  });
      }

    // Отправка запроса для получения координат маршрутов
    function getRoutes(){
      params = {
        station_id: selected_point.properties.global_id,
        city_id: selected_city_id
      }

      $.get("/isochrones/get_routes", params)
      .done(function(data) {
      	console.log(data);
  	    routeFeatures = getRouteFeatures(data);
          map.getSource('routes').setData(routeFeatures);
          displayRouteStat(routeFeatures);
  	  })
  	  .always(function() {
  	    $('.loading').addClass('none');
  	  });
    }

    // Отправка запроса для получения координат пересадочных маршрутов
    function getChangesRoutes(route_codes){
      params = {
        route_codes: route_codes,
        city_id: selected_city_id
      }

      $.get("/isochrones/get_changes_routes", params)
      .done(function(data) {
        console.log("Changes routes");
        console.log(data);
        routeFeatures = getRouteFeatures(data);
        map.getSource('changes_routes').setData(routeFeatures);
      })
      .always(function() {
        $('.loading').addClass('none');
      });
    }

    // Отправка запроса для получения метрик изохрона
    function getMetrics(isochrone_ids){
      params = {
        isochrone_ids: isochrone_ids
      }

      $.get("/isochrones/get_metrics", params)
      .done(function(data) {
        console.log("Metrics:");
        console.log(data);
        displayMetrics(data)
      })
      .always(function() {
        $('.loading').addClass('none');
      });
    }

    function getIsochroneFeatures(isochrones){

      isochrones = isochrones.sort(function(a, b){return b.contour - a.contour});

      data = {
         'type': 'FeatureCollection',
         'features': []
      };

      isochrones.forEach(function(p){

        feature = {
          "type": "Feature",
          "properties": {
            "id": p.unique_code,
            "profile": p.profile, 
            "global_id": p.source_station_id, 
            "contour": p.contour
          },
          "geometry": p.geo_data
        };

        data.features.push(feature);
      });
      return data;
    }

    function getRouteFeatures(routesArray){
      data = {
         'type': 'FeatureCollection',
         'features': []
      };

      routesArray.forEach(function(route){
        geometry = route.geo_data;

        feature = {
          'type': 'Feature',
          'trackOfFollowing': route.track_of_following,
          'reverseTrackOfFollowing': route.reverse_track_of_following,
          'routeNumber': route.route_number,
          'typeOfTransport': route.type_of_transport,
          'route_code': route.route_code,
          'route_cost': route.route_cost,
          'route_length': route.route_length,
          'route_interval': route.route_interval,
          'straightness': route.straightness
        };

        feature.geometry = geometry;

        data.features.push(feature);
      });

      return data;
    }

    // Функция отображения метрик изохрорна
    function displayMetrics(metrics){
      $('#stop_stat').find('tbody').html("");
      metrics.forEach(function(metric){

        td_name = '<td>'+ metric.name +'</td>';
        td_10 = '<td>'+ (metric.metrics['10'] || 0) +'</td>';
        td_20 = '<td>'+ (metric.metrics['20'] || 0) +'</td>';
        td_30 = '<td>'+ (metric.metrics['30'] || 0) +'</td>';
        tr = '<tr>'+td_name+td_10+td_20+td_30+'</tr>';        

        $('#stop_stat').find('tbody').append(tr);

      });
      if(metrics.length > 0){
        $('#info-box').removeClass('none');
      }
    }

    // Функция отображения статистики по маршруту
    function displayRouteStat(featureCollection){

      $('#routes_stat tbody').html("");

      featureCollection.features.forEach(function(feature){
        f = new Intl.NumberFormat('ru-RU', {style: 'decimal'});
        row = document.createElement("tr");
        $(row).append('<td>'+feature.route_code+'</td>');
        $(row).append('<td>'+feature.route_interval+' мин</td>');
        $(row).append('<td>'+feature.route_length+' км</td>');
        $(row).append('<td>'+f.format(feature.route_cost)+' руб</td>');
        $(row).append('<td>'+feature.straightness+'</td>');

        $('#routes_stat tbody').append(row);
      });

      if(featureCollection.features.length > 0){
        $('#info-box').removeClass('none');
      }
    }

    // Функция очистки информации
    function hideInfoBox(){
      $('#info-box').addClass('none');  
      $('#info-box').find('info').addClass('none');
      $('.info').find('.time').html("");
    }
  }
});