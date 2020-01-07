<field-map-polyline>

    <div class="uk-alert" if="{!apiready}">
        Loading maps api...
    </div>

    <div show="{apiready}">
        <div class="uk-form uk-position-relative uk-margin-small-bottom uk-width-1-1" style="z-index:1001">
            <input ref="autocomplete" class="uk-width-1-1" placeholder="{ latlng.address || [latlng.lat, latlng.lng].join(', ') }">
        </div>
        <div ref="map" style="min-height:300px; z-index:0;">
            Loading map...
        </div>
   </div>


    <script>

        var map, marker, ;

        var locale = document.documentElement.lang.toUpperCase();

        var loadApi = App.assets.require([
            'https://cdn.jsdelivr.net/npm/leaflet@1.3.1/dist/leaflet.min.css',
            'https://cdn.jsdelivr.net/npm/leaflet@1.3.1/dist/leaflet.min.js',
            'https://cdn.jsdelivr.net/npm/places.js@1.7.2/dist/cdn/places.min.js',
            'https://cdnjs.cloudflare.com/ajax/libs/leaflet.draw/1.0.4/leaflet.draw.js',
            'https://cdnjs.cloudflare.com/ajax/libs/leaflet.draw/1.0.4/leaflet.draw.css'
        ]);

        var $this = this, defaultpos = {lat:45.5051, lng:-122.6750};

        this.latlng = defaultpos;

        this.$updateValue = function(value) {

            if (!value) {
                value = defaultpos;
            }

            if (this.latlng != value) {
                this.latlng = value;

                if (marker) {
                    marker.setLatLng([this.latlng.lat, this.latlng.lng]).update();
                    map.panTo(marker.getLatLng());
                }

                this.update();
            }

        }.bind(this);

        this.on('mount', function() {

            loadApi.then(function() {

                $this.apiready = true;

                setTimeout(function(){

                    var map = L.map($this.refs.map).setView([$this.latlng.lat, $this.latlng.lng], opts.zoomlevel || 13);

                    L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png', {
                        attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
                    }).addTo(map);

                    // FeatureGroup is to store editable layers
                    var drawnItems = new L.FeatureGroup();
                    map.addLayer(drawnItems);
                    var drawControl = new L.Control.Draw({
                        position: 'topright',
                        draw: {
                            polyline: true,
                            polygon: false,
                            circle: false,
                            circlemarker: false,
                            rectangle: false,
                            marker: false
                        },
                        edit: {
                            featureGroup: drawnItems
                        }
                    });
                    map.addControl(drawControl);

                    map.on(L.Draw.Event.CREATED, function (event) {
                        var layer = event.layer;
                        drawnItems.clearLayers();
                        drawnItems.addLayer(layer);
                        var polyline = layer.getLatLngs().map(({lat, lng} => [lat, lng]));
                        $this.$setValue(polyline);
                    })

                    var pla = places({
                        container: $this.refs.autocomplete
                    }).on('change', function(e) {
                        e.suggestion.latlng.address = e.suggestion.value;
                        map.panTo(e.suggestion.latlng);
                        pla.close();
                        pla.setVal('');
                    }).on('suggestions', function (e) {
                      var coords = e.query.match(/^(\-?\d+(?:\.\d+)?),\s*(\-?\d+(?:\.\d+)?)$/);

                      if (!coords) {
                        return;
                      }

                      var latlng = {
                        lat: parseFloat(coords[1]),
                        lng: parseFloat(coords[2])
                      };

                      map.panTo(latlng);
                      pla.close();
                      pla.setVal('');
                    });

                }, 50);

                $this.update();
            });

        });


    </script>

</field-map-polyline>