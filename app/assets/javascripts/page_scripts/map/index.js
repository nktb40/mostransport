Paloma.controller('Map',
{
  index: function(){
    //=========================================
    // Инициализация карты и её слоёв
    //=========================================
    // ключ для Mapbox
    var publicToken = 'pk.eyJ1Ijoibmt0YiIsImEiOiJjazhscjEwanEwZmYyM25xbzVreWMyYTU1In0.dcztuEUgjlhgaalrc_KLMw';

    // Остановки ОТ
    var pointsTileset = "nktb.bev2q4f8" //ID tileset объектов
    var pointsSourceLayer = "bus_stops"; //Название SourceLayer

    // Изохроны по всем точкам
    var iso_layers = [
      /*{name: 'walking', url: 'nktb.3s2j8c2h'},
      {name: 'cycling', url: 'nktb.3ka2s10w'},
      {name: 'driving', url: 'nktb.14cjlo9r'},
      {name: 'public_transport', url: 'nktb.19y282q8'}*/
    ];

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
    var map = new mapboxgl.Map({
      container: 'map',
      style: 'mapbox://styles/mapbox/streets-v11',
      center: [37.618936,55.754388],
      zoom: 11.5
    });
     
    // create the marker
    var marker = new mapboxgl.Marker();

    // Popup для маркера
    var obj_popup = new mapboxgl.Popup();
    var point_popup = new mapboxgl.Popup();

    // Добавляем строки в таблицу со статистикой изохрона
    data_layers.forEach(function(layer){
      tr1 = '<tr class="info '+layer.name+' none"><td>'+layer.name_quantity+':</td><td class="time time-10"></td><td class="time time-20"></td><td class="time time-30"></td></tr>';
      tr2 = '<tr class="info '+layer.name+'-population none"><td>'+layer.name_population+':</td><td class="time time-10"></td><td class="time time-20"></td><td class="time time-30"></td></tr>'
      
      $('#stop_stat').find('tbody').append(tr1);
      $('#stop_stat').find('tbody').append(tr2);
    });


    // Загрузка Tileset-ов для отображения объектов на карте
    map.on('load', function() {
      console.log("Map");
      console.log(map);

      // Загружаем слои с изохронами
      iso_layers.forEach(function(layer){

        map.addSource(layer.name, {
          'type': 'vector',
          url: "mapbox://"+layer.url
        });

       times.forEach(function(t,i){
          if (i > 0){
            beforeLayer = layer.name+"-"+times[i-1];
          } else{
            beforeLayer = "";
          }
          
          map.addLayer({
            'id': layer.name+"-"+t,
            'type': 'fill',
            'source': layer.name,
            'source-layer': layer.name+"-"+t,
            'filter': ["all",["==",["get","profile"],profile],["match",["get","contour"],minutes, true, false]],
            'layout': {
              'visibility': 'visible'
            },
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
        });
      });
      

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
          'line-width': 4,
          'line-color': '#F7455D'
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

      // Change the cursor to a pointer when it enters a feature in the 'points' layer.
      data_layers.map(function(l){return l.name}).concat('points').forEach(function(l){
        map.on('mouseenter', l, function(e) {
          map.getCanvas().style.cursor = 'pointer';
          if(e.features[0].source == 'points'){
            addPointPopup(e);
          }
          else {
            addObjPopup(e);
          }
        });

        // Change it back to a pointer when it leaves.
        map.on('mouseleave', l, function() {
          map.getCanvas().style.cursor = '';
          obj_popup.remove();
          point_popup.remove();
        });
      });

      // Добавление popup для вспомогательных объектов
      function addObjPopup(e){
        obj_popup.setLngLat(e.lngLat)
          .setHTML(
            "<p>"+e.features[0].properties.name+"</p>"
            +
            "<p>"+e.features[0].properties.address+"</p>"
             +
            "<p>Кол-во жителей: "+e.features[0].properties.population+"</p>"
            +
            "<p>id: "+e.features[0].properties.id+"</p>"
            )
          .addTo(map);
      }

      // Добавление popup для остановок
      function addPointPopup(e){
        point_popup.setLngLat(e.lngLat)
          .setHTML(
            "<div class='loading loading--s none'></div>"
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

        // create the popup
        var popup = new mapboxgl.Popup({ offset: 40 }).setHTML(
          "<div class='loading loading--s none'></div>"
          +
          "<p>Остановка: "+selected_point.properties.StationName+"</p>"
          +
          "<p>Маршруты: "+selected_point.properties.RouteNumbers+"</p>"
        );
           
        if(selected_point != null){
          console.log("selected_point");
          console.log(selected_point);
           
          marker.setLngLat(selected_point.geometry.coordinates);
          marker.setPopup(popup);
          marker.addTo(map);

          marker.togglePopup();

        }

        filterMap();
      });
      

    });

    //=========================================
    // Построение изохрона для выбранной точки
    //=========================================

    var selected_point;
    var prev_selected_point;       
    var profile = 'public_transport';
    var minutes = [0,10,20,30];
    var use_intervals = 0;

    // Target the "params" form in the HTML
    var params = document.getElementById('params');

    // When a user changes the value of profile or duration by clicking a button, change the parameter's value and make the API query again
    params.addEventListener('change', function(e) {
      if (e.target.name === 'profile') {
        profile = e.target.value;
      } 

      if(profile == 'public_transport'){
        use_intervals = (e.target.checked) ? (1) : (0);
      } else {
        use_intervals = null;
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
        $(btn).addClass("btn--stroke");
      } else{
        minutes.push(val);
        $(btn).removeClass("btn--stroke");
      }
      
      prev_selected_point = selected_point;
      filterMap();
    });

    // Функция фильтрации изохронов на карте
    function filterMap(){

      // Очищаем InfoBox
      hideInfoBox();

      // Фильтры
      filter_minutes = ["match",["get", "contour"], minutes, true, false];
	  filter_profile = ["==",["get", "profile"], profile];

      if(selected_point != null){

      	// Устанавливаем фильтры на слой с остановками
		map.setFilter('pointIsoLayer', ["all",filter_profile, filter_minutes]);

        // Скрываем слои с изохронами на все остановки
        iso_layers.forEach(function(layer){
          times.forEach(function(t){
            map.setFilter(layer.name+"-"+t, false);
          });
        });

        if(selected_point != prev_selected_point){
        	// Очищаем слои с маршрутом и с индивидуальными изохронами
	        map.getSource('pointIsochrones').setData({'type': 'FeatureCollection','features': []});
	        map.getSource('routes').setData({'type': 'FeatureCollection','features': []});

	        // Отправляем запрос на получение изохронов для точки
	        pointIsoMessage();

	        // Отправляем запрос на получение линий маршрутов 
	        if (profile == 'public_transport'){
	          routesMessage();
	        }
        }

      } /*else {
        map.setFilter('pointIsoLayer', false);
		
		// Фильтры для слоёв
      	filter_minutes = ["match",["get", "contour"], minutes, true, false];
      	filter_profile = ["==",["get", "profile"], profile];

        iso_layers.forEach(function(layer){
          times.forEach(function(t){
            map.setFilter(layer.name+"-"+t, ["all",filter_profile, filter_minutes]);
          });
        });
      }*/
    }

    // Отправка сообщения на сервер WIX для получения изохронов по выбранной точке
    function pointIsoMessage(){
      //console.log(selected_point);
      $('.loading').removeClass('none');

      params = {
        station_id: [selected_point.properties.global_id]
      }

      $.get("/map/get_isochrones", params)
      .done(function(data) {
	    console.log("get_isochrones");
	    console.log(data);

	    isoFeatures = getPolygonFeatures(data);
        console.log(isoFeatures);
        map.getSource('pointIsochrones').setData(isoFeatures);
        featureWithInfo = addFeatureInfo(isoFeatures);
        displayInfo(featureWithInfo);
        filter_objects(featureWithInfo);
	  })
	  .always(function() {
	    $('.loading').addClass('none');
	  });
    }

    // Отправка сообщения на сервер WIX для получения координат маршрутов
    function routesMessage(){
      params = {
        station_id: selected_point.properties.global_id
      }

      $.get("/map/get_routes", params)
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


    // Обработчик события получения сообщения с сервера WiX
    window.onmessage = function(e){
      $('.loading').addClass('none');

      console.log("Result:");
      console.log(e.data);

      if(e.data.messageType == "POINT_ISO") {
        isoFeatures = getPolygonFeatures(e.data.isochrones);
        console.log(isoFeatures);
        map.getSource('pointIsochrones').setData(isoFeatures);
        featureWithInfo = addFeatureInfo(isoFeatures);
        displayInfo(featureWithInfo);
        filter_objects(featureWithInfo);
      } 
      else if(e.data.messageType == "ROUTES"){
        routeFeatures = getRouteFeatures(e.data.routes);
        map.getSource('routes').setData(routeFeatures);
        displayRouteStat(routeFeatures);

        last_min = minutes.sort(function(a, b){return b - a})[0];
        routes = getRouteStops(routeFeatures);
        route = routes.find(function(r){return r.contour == last_min});

        console.log("Stops:");
        console.log(route);
        //routePointsMessage(route.id);
        pointIsoMessage();
      }
      else if(e.data.messageType == "ROUTE_POINTS_ISO"){
        stopFeatures = getRouteStopsFeatures(e.data.isochrones);
        map.getSource('pointIsochrones').setData(stopFeatures);
        displayInfo(stopFeatures);
        filter_objects(stopFeatures);
        isoCompareMessage("cycling");
      }
      else if(e.data.messageType == "ISO_COMPARE"){
        e.data.isochrones.forEach(function(iso){
          polygon = turf.polygon([iso.polygon]);
          area_1 = Number($('.info.area').find('.time-'+iso.contour).html());
          area_2 = getFeatureArea(polygon);
          share = (area_1/area_2*100).toFixed(2);
          $('.info.velo-share').find('.time-'+iso.contour).html(area_2+" ("+share+"%)");
          $('.info.velo-share').removeClass('none');
        });
      }
    }

    function getRouteStops(routesCollection){

      point = selected_point;
      var stopPoint = turf.point(point.geometry.coordinates);
      routeStops = [];
      
      minutes = minutes.filter(function(m){return m > 0}).sort(function(a, b){return b-a});

      var stops = [];

      routesCollection.features.forEach(function(route){

        var stopsOnRoute = [];

        // Определяем номер маршрута
        var route_num = route.routeNumber;

        if(route.typeOfTransport == "автобус"){
            route_num = "А"+route_num;
        } else if(route.typeOfTransport == "троллейбус"){
            route_num = "Тб"+route_num;
        } else if(route.typeOfTransport == "трамвай"){
            route_num = "Тм"+route_num;
        } 

        // Отбираем из остановок те, которые входят в изохрон маршрута для заданного времени
        route.geometry.coordinates.forEach(function(direction, dirIndex){
          
          // Из маршрута берём названия остановок
          if (dirIndex == 0){
            track = route.trackOfFollowing.replace(/«|»/g, "");
          } else if (dirIndex == 1){
            track = route.reverseTrackOfFollowing.replace(/«|»/g, "");
          }

          if(track.includes(point.properties.StationName)){
            // Строим линию направления
            line = turf.lineString(direction);

            // Определяем близжайшую к остановке точку на маршруте
            pointOnRoute = turf.nearestPointOnLine(line, stopPoint);

            // Находим точки остановок для маршрута
            stopsOnRoute = map.querySourceFeatures('points', {sourceLayer: 'bus_stops', filter: 
              ["all",
                ["in",["get","StationName"],track],
                ["in",route_num,["get","RouteNumbers"]]
              ]});

            // Определяем близжайшую точку на маршруте для всех остановок направления
            stopsOnRoute.forEach(function(s){
              p = turf.point(s.geometry.coordinates);
              s.pointOnRoute = turf.nearestPointOnLine(line, p);
            });

            // Определяем последнюю точку на направлении
            stp = direction[0];
            enp = direction[direction.length-1];

            if(stp[0] == enp[0] && stp[1] == enp[1]){
              lastPoint = turf.point(direction[direction.length-2]);
            } else {
              lastPoint = turf.point(direction[direction.length-1]);
            }
            
            // Обрезаем линию от остановки до конца маршрута
            line = turf.lineSlice(pointOnRoute, lastPoint, line);

            minutes.forEach(function(t){
              // Обрезаем линию от остановки до расстояния, которое можно проехать за заданное время
              start = 0;
              stop = 15 * t/60;
              sliced = turf.lineSliceAlong(line, start, stop, {units: 'kilometers'});
              sliced_buffer = turf.buffer(sliced, 0.02, {units: 'kilometers'});

              // Определяем точки, которые находятся внутри маршрута заданной длины
              stops = stopsOnRoute.filter(function(s){
                return turf.booleanPointInPolygon(s.pointOnRoute, sliced_buffer);
              });

              ids = stops.map(function(r){return r.properties.global_id});

              contour = routeStops.find(function(r){return r.contour == t});

              if (contour){
                contour.id = Array.from(new Set(contour.id.concat(ids)));
              } else {
                routeStops.push({contour: t, id: Array.from(new Set(ids))});
              }
              
            });
          }
        });
      });

      return routeStops;
    }


    function getPolygonFeatures(isochrones){

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

    var geodata;

    function getRouteFeatures(routesArray){
      data = {
         'type': 'FeatureCollection',
         'features': []
      };

      routesArray.forEach(function(route){
        geometry = JSON.parse(route.geo_data.replace(/'/g, '"'));

        feature = {
          'type': 'Feature',
          'trackOfFollowing': route.track_of_following,
          'reverseTrackOfFollowing': route.reverse_track_of_following,
          'routeNumber': route.route_number,
          'typeOfTransport': route.type_of_transport,
          'route_code': route.route_code,
          'route_cost': route.route_cost,
          'route_length': route.route_length,
          'interval': route.route_interval
        };

        feature.geometry = geometry;

        data.features.push(feature);
      });

      return data;
    }

    function getRouteStopsFeatures(stops){
      data = {
         'type': 'FeatureCollection',
         'features': []
      };

      routeStops.forEach(function(r){
        stops = stops.filter(function(s){return r.id.includes(s.global_id);});
        var feature = turf.polygon([stops[0].polygon]);

        for (i = 1; i < stops.length; i++) {
          feature = turf.union(feature, turf.polygon([stops[i].polygon]));
        }

        feature.properties = {
            "id": selected_point.properties.global_id+"-"+"public_transport-"+r.contour,
            "profile": "public_transport", 
            "global_id": selected_point.properties.global_id, 
            "contour": r.contour
          }

        data.features.push(feature);
      });

      data = addFeatureInfo(data);
      console.log(data);
      return data;
    }

    // Функция добавления доп. информации к изохронам
    function addFeatureInfo(featureCollection){
      featureCollection.features.forEach(function(feature){
        feature.properties.area =  getFeatureArea(feature);
        feature.properties.area_unit = "км";
      });

      data_layers.forEach(function(layer){
        featureCollection = getInfoFromObjectsInside(featureCollection, layer.name);
        //feature.properties[layer.name] = data.quantity;
        //feature.properties[layer.name + "-population"] = data.population;
      });

      return featureCollection;
    } 

    // Функция расчёта площади изохрона
    function getFeatureArea(feature){
      var area = 0;

      polygon = feature.geometry.coordinates;

      if (feature.geometry.type == "Polygon"){
        p = turf.polygon(polygon);
        area += turf.area(p);
      } else if (feature.geometry.type == "MultiPolygon"){
        p = turf.multiPolygon(polygon);
        area += turf.area(p);
      }

      return (area/1000000).toFixed(2);
    }

    // Функция расчёта кол-ва объектов и кол-ва людей внутри изохрона
    function getInfoFromObjectsInside(featureCollection, source_name){
      console.log("getInfoFromObjectsInside");
      console.log(source_name);

      minutes_sorted = times.sort(function(a, b){return b - a});
      filtered_arr = [];

      minutes_sorted.forEach(function(m,i){
        feature = featureCollection.features.find(function(f){return f.properties.contour == m});
        filtered = []

        if(i == 0){
          filtered = getObjectsInside(feature, source_name);
        } else {
          filtered = turf.pointsWithinPolygon(filtered_arr[i-1], feature);
        }

        filtered_arr.push(filtered);
        //console.log(filtered);

        quantity = filtered.features.length;

        if(quantity > 0){
          populations = filtered.features.map(function(f){return f.properties.population});
          //console.log(populations);

          population = populations.reduce(function(total, p){return total + p});

          data = {quantity: quantity, population: population};
        } else {
          data = {quantity: 0, population: 0};
        }

        feature.properties[source_name] = data.quantity;
        feature.properties[source_name + "-population"] = data.population;
      });

      return featureCollection;
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

    // Функция отображения доп. информации об изохроне
    function displayInfo(featureCollection){
      featureCollection.features.forEach(function(feature){
        p = feature.properties;
        $('.info.area').find('.time-'+p.contour).html(p.area);
        $('.info.area').removeClass('none');

        data_layers.forEach(function(layer){
          $('.info.'+layer.name).find('.time-'+p.contour).html(p[layer.name]);
          $('.info.'+layer.name).removeClass('none');

          if(p[layer.name+'-population'] > 0){
            $('.info.'+layer.name+'-population').find('.time-'+p.contour).html(p[layer.name+'-population']);
            $('.info.'+layer.name+'-population').removeClass('none');
          }
        });
      });
      $('#info-box').removeClass('none');
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

        $('#routes_stat tbody').append(row);
      });
    }

    // Функция очистки информации
    function hideInfoBox(){
      $('#info-box').addClass('none');  
      $('#info-box').find('info').addClass('none');
      $('.info').find('.time').html("");
    }

    // Функция фильтрации объектов, которые попали в изохрон
    function filter_objects(featureCollection){
      last_min = minutes.sort(function(a, b){return b - a})[0];
      feature = featureCollection.features.find(function(f){return f.properties.contour == last_min});

      data_layers.forEach(function(l){
        filtered = getObjectsInside(feature, l.name);
        filtered_ids = filtered.features.map(function(f){return f.properties.id});
        if(filtered_ids.length > 0){
          map.setFilter(l.name,["match",["get","id"],filtered_ids,true,false])
        }
      });
    }
  }
});