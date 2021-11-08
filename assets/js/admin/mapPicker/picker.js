( function( $ ) {

	$.fn.adminMapPicker = function() {
		return this.each( function(){
			var $mapContainer     = $( this )
			  , $map              = $( ".admin-map-picker-map", $mapContainer )
			  , mapId             = $map.attr( "id" )
			  , $postcodeField    = $( "[name="+$map.data( "postcodeField" )+"]" )
			  , $latitudeField    = $( "[name="+$map.data( "latitudeField" )+"]" )
			  , $longitudeField   = $( "[name="+$map.data( "longitudeField" )+"]" )
			  , $zoomField        = $( "[name="+$map.data( "zoomField" )+"]" )
			  , zoom              = cfrequest.mapData.zoom
			  , maxZoom           = cfrequest.mapData.maxZoom
			  , accessToken       = cfrequest.mapData.accessToken
			  , alertPosition     = cfrequest.mapData.alertPosition
			  , defaultLatitude   = cfrequest.mapData.defaultLatitude
			  , defaultLongitude  = cfrequest.mapData.defaultLongitude
			  , defaultZoom       = cfrequest.mapData.defaultZoom
			  , errorMessages     = cfrequest.mapData.errors
			  , latitude          = parseFloat( $latitudeField.val() )
			  , longitude         = parseFloat( $longitudeField.val() )
			  , hasInitLatLng     = $.isNumeric( latitude ) && $.isNumeric( longitude )
			  , tileUrl           = "https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}"
			  , streetLayer       = L.tileLayer( tileUrl, {
					  tileSize    : 512
					, maxZoom     : maxZoom
					, zoomOffset  : -1
					, id          : "mapbox/streets-v11"
					, accessToken : accessToken
				} )
			  , satelliteLayer    = L.tileLayer( tileUrl, {
					  tileSize    : 512
					, maxZoom     : maxZoom
					, zoomOffset  : -1
					, id          : "mapbox/satellite-streets-v11"
					, accessToken : accessToken
				} )
			  , layers            = {
					  "Map"       : streetLayer
					, "Satellite" : satelliteLayer
				}
			  , marker
			  , mapOptions        = {
					  layers          : [ streetLayer ]
					, scrollWheelZoom : false
					, zoom            : hasInitLatLng ? zoom : defaultZoom
					, center          : hasInitLatLng ? [ latitude, longitude ] : [ defaultLatitude, defaultLongitude ]
			    }
			  , markerOptions     = { draggable: true, autoPan: true }
			  , map               = L.map( mapId, mapOptions )
			  , updateFormFields, clearFormFields, lookupPostcode, processLookupPostcode, updateMarkerFromFields, updateZoomFromField;

			updateZoomFromField = function() {
				var zoom = $zoomField.val();
				if ( $.isNumeric( zoom ) ) {
					map.setZoom( zoom );
				}
			};
			updateMarkerFromFields = function() {
				var lat = $latitudeField.val();
				var lng = $longitudeField.val();
				if ( $.isNumeric( lat ) && $.isNumeric( lng ) ) {
					marker.setLatLng( [ lat, lng ] ).addTo( map );
					map.panTo( [ lat, lng ] );
				}
			};
			updateFormFields = function( lat, lng ) {
				$latitudeField.val( lat.toFixed( 6 ) );
				$longitudeField.val( lng.toFixed( 6 ) );
			};
			clearFormFields = function() {
				$latitudeField.val( "" );
				$longitudeField.val( "" );
			};
			processLookupPostcode = function( lookupResult ) {
				if ( lookupResult.success ) {
					marker.setLatLng( lookupResult.latlng ).addTo( map );
					updateFormFields( lookupResult.latlng[ 0 ], lookupResult.latlng[ 1 ] );
					map.flyTo( lookupResult.latlng, zoom );
				} else if ( lookupResult.error ) {
					$.gritter.options.position = alertPosition;
					$.gritter.add( {
						  title      : errorMessages.title
						, text       : lookupResult.error
						, class_name : "gritter-error preside-frontend-msgbox"
						, sticky     : false
					} );
				}
			}
			lookupPostcode = function( postcode ) {
				var lookupResult = { success: false, error: "", latlng: [] };
				if ( !postcode.length ) {
					lookupResult.error = errorMessages.notSupplied;
					processLookupPostcode( lookupResult );
					return;
				}

				$.ajax( {
					method : "GET",
					url    : "https://api.postcodes.io/postcodes",
					data   : { q:postcode }
				} ).done( function( data, textStatus, jqXHR ) {
					if ( data.result ) {
						lookupResult.success = true;
						lookupResult.latlng  = [ data.result[ 0 ].latitude, data.result[ 0 ].longitude ];
					} else {
						lookupResult.error = errorMessages.notFound;
					}
				} ).fail( function( jqXHR, textStatus, errorThrown ) {
					lookupResult.error = errorMessages.unexpected;
				} ).always( function() {
					processLookupPostcode( lookupResult );
				} );
			};

			L.control.layers( layers, null, { "collapsed": false } ).addTo( map );

			if ( hasInitLatLng ) {
				marker = L.marker( [ latitude, longitude ], markerOptions ).addTo( map );
			} else {
				marker = L.marker( [ defaultLatitude, defaultLongitude ], markerOptions );
			}

			marker.on( {
				drag : function( args ){
					updateFormFields( args.latlng.lat, args.latlng.lng );
				}
			} );
			map.on( {
				zoom : function( args ){
					$zoomField.val( map.getZoom() );
				}
			} );


			$mapContainer.on( "click", ".marker-set-at-postcode", function( e ){
				lookupPostcode( $postcodeField.val() );
			} ).on( "click", ".marker-reset", function( e ){
				if ( hasInitLatLng ) {
					marker.setLatLng( [ latitude, longitude ] );
					updateFormFields( latitude, longitude );
				} else {
					marker.remove();
					clearFormFields();
				}
				map.flyTo( mapOptions.center, mapOptions.zoom );
			} ).on( "click", ".marker-set-at-centre", function( e ){
				var pos = map.getCenter();
				marker.setLatLng( pos ).addTo( map );
				updateFormFields( pos.lat, pos.lng );
			} );
			$latitudeField.on( "change", updateMarkerFromFields );
			$longitudeField.on( "change", updateMarkerFromFields );
			$zoomField.on( "change", updateZoomFromField );
		} );

	};

	$( ".admin-map-picker" ).adminMapPicker();

} )( presideJQuery );
