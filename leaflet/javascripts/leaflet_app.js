(function (window) {
    'use strict';

    function initMap() {
    
    var map = L.map('map').setView([1.352083, 103.819836], 12);

L.tileLayer('https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token={accessToken}', {
    attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://mapbox.com">Mapbox</a>',
    maxZoom: 18,
    id: 'mapbox.streets',
    accessToken: 'pk.eyJ1IjoiaGFzZWVuYSIsImEiOiJjajAzb3A1djUwOXJzMndsamZnZm0zcnBoIn0.pOJe3xpCwhELlrCn5JR6_Q'
}).addTo(map);
    
    
       
        var style = {
            color: 'red',
            opacity: 1.0,
            fillOpacity: 1.0,
            weight: 2,
            clickable: false
        };
        L.Control.FileLayerLoad.LABEL = '<img class="icon" src="folder.svg" alt="file icon"/>';
        L.Control.fileLayerLoad({
            fitBounds: true,
             addToMap: true,
        // File size limit in kb (default: 1024) ?
        fileSizeLimit: 1024,
        // Restrict accepted file formats (default: .geojson, .kml, and .gpx) ?
        formats: [
            '.geojson',
            '.kml'
        ],
            layerOptions: {
                style: style,
                pointToLayer: function (data, latlng) {
                    return L.circleMarker(
                    latlng,
                    { style: style }
                    );
                }
            }
            
        }).addTo(map);
    }

    

    window.addEventListener('load', function () {
        initMap();
    });
}(window));
