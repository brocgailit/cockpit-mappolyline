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



</field-map-polyline>