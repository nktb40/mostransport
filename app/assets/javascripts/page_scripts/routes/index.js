var map;
Paloma.controller('Routes',
{
  index: function(){

  	// ключ для Mapbox
    var publicToken = 'pk.eyJ1Ijoibmt0YiIsImEiOiJjazhscjEwanEwZmYyM25xbzVreWMyYTU1In0.dcztuEUgjlhgaalrc_KLMw';

    // Остановки
    var pointsTileset = $("#city_select").find(':selected').data('tile_stations_url'); //ID tileset объектов
    // Маршруты
    var routesTileset = $("#city_select").find(':selected').data('tile_routes_url'); //ID tileset объектов

    // Добавялем ключ для Mapbox
    mapboxgl.accessToken = publicToken;

    // Popup для остановки
    var point_popup = new mapboxgl.Popup();

    // Инициализируем карту
    map = new mapboxgl.Map({
      container: 'map',
      style: 'mapbox://styles/mapbox/streets-v11',
      center: [37.618936,55.754388],
      zoom: 11.5
    });

    // Выбранный город
    var selected_city_id = $("#city_select").val();
    
    // Загружаем список маршрутов
    getCityRoutes();

    // Функция обработки события переключения города
    $("#city_select").on('click',function(e){
      selected_city_id = e.target.value;

      // Загружаем список маршрутов
      getCityRoutes();

      // Перемещаем карту в границу, выбранного города
      bbox = $(this).find(':selected').data('bbox');
      map.fitBounds(bbox, {
        padding: {top: 10, bottom:10, left: 10, right: 10}
      });

      // Загружаем источник данных для остановок
      pointsTileset = $(this).find(':selected').data('tile_stations_url');
      routesTileset = $("#city_select").find(':selected').data('tile_routes_url');
      init_stations_layer();

    });

    // Загрузка Tileset-ов для отображения объектов на карте
    function init_stations_layer(){

      if (map.getLayer("points")) {
          map.removeLayer("points");
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
        'source-layer': 'bus_stops',
        //'filter': false,
        'paint': {
          'circle-radius': {
            'stops': [[9, 2], [22, 15]]
          },
          'circle-color': '#3976bc'
        }
      });


      if (map.getLayer("routes")) {
          map.removeLayer("routes");
      }

      if (map.getSource("routes")) {
          map.removeSource("routes");
      }

      // Слой для отображения линий маршрутов
      map.addSource('routes', {
        "type": "vector",
        "url": "mapbox://"+routesTileset,
        "tileSize": 512
      });

      map.addLayer({
        'id': 'routes',
        'type': 'line',
        'source': 'routes',
        'source-layer': 'routes',
        'filter': false,
        'paint': {
          'line-width': 4,
          'line-color': '#F7455D'
        }
      });

    }

    // Loading Points data layer when map is ready
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
          'fill-color': '#f39e3c',
          'fill-opacity': 0.6
        }
      });


      // Загружаем слои с рёбрами графа
      map.addSource('relations', {
        "type": "vector",
        "url": "mapbox://nktb.5q9iwuva",
        "tileSize": 512
      });

      map.addLayer({
        'id': 'relations',
        'type': 'line',
        'source': 'relations',
        'source-layer': 'relations',
        'filter': false,
        'paint': {
          'line-width': 4,
          'line-color': ["case",
                          ["<",["get","total_score"],20],'#63d125',
                          ["all",[">=",["get","total_score"],20],["<",["get","total_score"],50]],'#efd700',
                          [">=",["get","total_score"],50],'#ef8725',
                          '#3976bc'
                        ]
        }
      });

      // Загружаем слой с остановками
      init_stations_layer();

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

    // Обработчик события клика на выбранный маршрут
    $(document).on('click','.route-item',function(e){
      bbox = $(this).data('route-bbox');
      map.fitBounds(bbox, {
        padding: {top: 70, bottom:70, left: 70, right: 70}
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
          "<span><b>Остановка:</b> "+e.features[0].properties.StationName+"</span><br>"
          +
          "<span><b>Маршруты:</b> "+e.features[0].properties.RouteNumbers+"</span>"
          )
        .addTo(map);
    }

    // Обработчик события выбора маршрутов в строке поиска
    $(document).on('changed.bs.select', '#route_search', function (e, clickedIndex, isSelected) {
    	route_codes = $('#route_search').val();
    	showRoutes(route_codes);
      getRoutesInfo(route_codes);
    });

    // Функция отображения линии маршрута на карте
    function showRoutes(route_codes){
    	filter =  ["in",["get","route_code"], ["literal",route_codes]];
    	map.setFilter("routes",filter);
    }

    // Функция получения ифнормации о маршруте
    function getRoutesInfo(route_codes){
      params = {
        route_codes: route_codes,
        city_id: selected_city_id
      };
      $.get('/routes/show', params);
    }

    // Функция подгрузки списка маршрутов для выбранного города
    function getCityRoutes(){
      params = {
        city_id: selected_city_id
      };
      $.get('/routes/get_city_routes',params);
      $('#selected_routes').html("");
    }

  } 

});