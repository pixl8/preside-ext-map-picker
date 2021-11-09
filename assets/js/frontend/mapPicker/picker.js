( function( $ ) {

	$.fn.frontendMapPicker = function() {
		return this.each( function(){
			var $mapContainer     = $( this )
			  , $map              = $( ".frontend-map-picker-map", $mapContainer )
			  , $searchResults    = $( ".frontend-map-picker-results", $mapContainer )
			  , mapId             = $map.attr( "id" )
			  , searchFields      = $map.data( "searchFields" )
			  , searchType        = $map.data( "searchType" )
			  , resultSelectClass = $map.data( "resultSelectClass" )
			  , $latLngField      = $( "[name="+$map.data( "latLngField" )+"]" )
			  , lookupPageSize    = cfrequest.mapData.lookupPageSize
			  , addressesFound    = cfrequest.mapData.addressesFound
			  , zoom              = cfrequest.mapData.zoom
			  , maxZoom           = cfrequest.mapData.maxZoom
			  , accessToken       = cfrequest.mapData.accessToken
			  , geocodeApiKey     = cfrequest.mapData.geocodeApiKey
			  , defaultLatitude   = cfrequest.mapData.defaultLatitude
			  , defaultLongitude  = cfrequest.mapData.defaultLongitude
			  , defaultZoom       = cfrequest.mapData.defaultZoom
			  , errorMessages     = cfrequest.mapData.errors[ searchType ]
			  , latLng            = $latLngField.val().split( "," )
			  , latitude          = parseFloat( latLng.length ? latLng[ 0 ] : "" )
			  , longitude         = parseFloat( latLng.length ? latLng[ 1 ] : "" )
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
			  , updateFormFields, clearFormFields, placeResultOnMap, doSearch, postcodeSearch, addressSearch, getSearchString, displayMultipleResults;

			getSearchString = function() {
				if ( !searchFields.length ) {
					return $( ".frontend-map-picker-search-input", $mapContainer ).val();
				}

				var values = [];
				var value  = "";
				var fields = searchFields.split( "," );
				for( var i=0; i<fields.length; i++ ) {
					value = $( "[name=" + fields[ i ] + "]" ).val();
					if ( value.length ) {
						values.push( value );
					}
				}
				return values.join( ", " );
			};

			updateFormFields = function( lat, lng ) {
				$latLngField.val( [ lat.toFixed( 6 ), lng.toFixed( 6 ) ].join( "," ) );
			};
			clearFormFields = function() {
				$latLngField.val( "" );
			};

			placeResultOnMap = function( lookupResult ) {
				if ( lookupResult.success ) {
					marker.setLatLng( lookupResult.latlng ).addTo( map );
					updateFormFields( lookupResult.latlng[ 0 ], lookupResult.latlng[ 1 ] );
					map.flyTo( lookupResult.latlng, zoom );
				} else if ( lookupResult.error ) {
					$searchResults.html( '<div class="frontend-map-picker-error"><strong>' + errorMessages.title + '</strong><br>' + lookupResult.error + '</div>' );
				}
			}
			doSearch = function( searchString ) {
				$searchResults.empty();
				if ( searchType == "address" ) {
					addressSearch( searchString );
				} else {
					postcodeSearch( searchString );
				}
			}
			postcodeSearch = function( postcode ) {
				var lookupResult = { success: false, error: "", latlng: [] };
				if ( !postcode.length ) {
					lookupResult.error = errorMessages.notSupplied;
					placeResultOnMap( lookupResult );
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
					placeResultOnMap( lookupResult );
				} );
			};
			addressSearch = function( searchText ) {
				var lookupResult = { success: false, error: "", latlng: [] };
				if ( !searchText.length ) {
					lookupResult.error = errorMessages.notSupplied;
					placeResultOnMap( lookupResult );
					return;
				}

				$.ajax( {
					method : "GET",
					url    : "https://app.geocodeapi.io/api/v1/search",
					data   : { apikey:geocodeApiKey, text:searchText, size:lookupPageSize }
				} ).done( function( data, textStatus, jqXHR ) {
					if ( data.features && data.features.length ) {
						var coordinates       = data.features[ 0 ].geometry.coordinates;
						lookupResult.success  = true;
						lookupResult.multiple = data.features.length > 1;
						lookupResult.features = data.features;
						lookupResult.latlng   = [ coordinates[ 1 ], coordinates[ 0 ] ];
					} else {
						lookupResult.error = errorMessages.notFound;
					}
				} ).fail( function( jqXHR, textStatus, errorThrown ) {
					lookupResult.error = errorMessages.unexpected;
				} ).always( function() {
					if ( lookupResult.multiple ) {
						displayMultipleResults( lookupResult );
					} else {
						placeResultOnMap( lookupResult );
					}
				} );
			};
			displayMultipleResults = function( lookupResult ) {
				var options = lookupResult.features.map( function( feature ) {
					return '<option value="' + feature.geometry.coordinates.reverse().join() + '">' + feature.properties.label + '</option>'
				} );

				var numberFound = lookupResult.features.length;
				numberFound += numberFound >= lookupPageSize ? '+' : '';
				options.unshift( '<option value="">' + numberFound + ' ' + addressesFound + '</option>' );
				$searchResults.html( '<select class="' + resultSelectClass + '">' + options.join( "" ) + '</select>' );
			}

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


			$mapContainer.on( "click", ".marker-set-by-search", function( e ){
				doSearch( getSearchString() );
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
			} ).on( "change", ".frontend-map-picker-results select", function( e ){
				var value = $( this ).val();
				if ( !value.length ) {
					return;
				}

				var latLng       = value.split( "," )
				  , lookupResult = {
					  success : true
					, latlng  : [ parseFloat( latLng[ 0 ] ), parseFloat( latLng[ 1 ] ) ]
				};
				$( this ).remove();
				placeResultOnMap( lookupResult );
			} ).on( "keydown", ".frontend-map-picker-search-input", function( e ){
				if ( e.keyCode == 13 ) {
					e.preventDefault();
					$( this ).blur();
					$( ".marker-set-by-search", $mapContainer ).trigger( "click" );
					return false;
				}
			} );
		} );

	};

	$( ".frontend-map-picker" ).frontendMapPicker();

} )( jQuery );
