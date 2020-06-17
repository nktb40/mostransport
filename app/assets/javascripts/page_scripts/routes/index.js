var map;
Paloma.controller('Routes',
{
  index: function(){
  	// ключ для Mapbox
    var publicToken = 'pk.eyJ1Ijoibmt0YiIsImEiOiJjazhscjEwanEwZmYyM25xbzVreWMyYTU1In0.dcztuEUgjlhgaalrc_KLMw';

    // Выходы метро
    var pointsTileset = "nktb.bev2q4f8" //tileset объекты выходы метро
    var pointsSourceLayer = "bus_stops";

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

      // Слой для отображения линий маршрутов
      map.addSource('routes', {
        "type": "vector",
        "url": "mapbox://nktb.4pzcpmcq",
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

      // Загружаем слой с точками
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
        padding: {top: 20, bottom:20, left: 20, right: 20}
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

    // Обработчик события выбора маршрутов строке поиска
    $('#route_search').on('changed.bs.select', function (e, clickedIndex, isSelected) {
    	route_codes = $('#route_search').val();
    	showRoutes(route_codes);
      getRoutesInfo(route_codes);
    });

    // Функция отображения линии маршрута на карте
    function showRoutes(route_codes){
    	filter =  ["in",["get","route_code"], "["+route_codes+"]"];
    	map.setFilter("routes",filter);
    }

    // Функция получения ифнормации о маршруте
    function getRoutesInfo(route_codes){
      params = {
        route_codes: route_codes
      };
      $.get('/routes/show', params);
    }

  } 

});