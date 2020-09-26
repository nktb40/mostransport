var map;
Paloma.controller('Density',
{
  index: function(){
  	//=========================================
    // Инициализация карты и её слоёв
    //=========================================
    // ключ для Mapbox
    var publicToken = 'pk.eyJ1Ijoibmt0YiIsImEiOiJjazhscjEwanEwZmYyM25xbzVreWMyYTU1In0.dcztuEUgjlhgaalrc_KLMw';

    // Остановки ОТ
    var pointsTileset = $("#city_select").find(':selected').data('tile_stations_url'); //ID tileset объектов
    var pointsSourceLayer = "bus_stops"; //Название SourceLayer

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
      pointsTileset = $(this).find(':selected').data('tile_stations_url');

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
    
    var selected_point;
    var prev_selected_point; 

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

    }

    // Загрузка слоёв данных
    map.on('load', function() {

      // Загружаем слой с остановками
      init_stations_layer();

      // Change the cursor to a pointer when it enters a feature in the 'points' layer.
	    map.on('mouseenter', 'points', function(e) {
	      map.getCanvas().style.cursor = 'pointer';
	      if(e.features[0].source == 'points'){
	        addPointPopup(e);
	      }
	    });

	    // Change it back to a pointer when it leaves.
	    map.on('mouseleave', 'points', function() {
	      map.getCanvas().style.cursor = '';
	      obj_popup.remove();
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

        }

      });
      

    });
    

	}
}); 