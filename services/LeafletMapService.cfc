/**
 * @presideService
 * @singleton
 */
component {
// CONSTRUCTOR
	/**
	 *
	 */
	public any function init() {
		return this;
	}


	public struct function getBaseMapData() {
		var leafletConfig = $getPresideCategorySettings( "leaflet" );
		var mapData       = {
			  accessToken      = leafletConfig.accessToken   ?: ""
			, geocodeApiKey    = leafletConfig.geocodeApiKey ?: ""
			, defaultLatitude  = isNumeric( leafletConfig.defaultLatitude  ?: "" ) ? leafletConfig.defaultLatitude    : 54.003
			, defaultLongitude = isNumeric( leafletConfig.defaultLongitude ?: "" ) ? leafletConfig.defaultLongitude   : -2.547
			, defaultZoom      = isNumeric( leafletConfig.defaultZoom      ?: "" ) ? int( leafletConfig.defaultZoom ) : 5
			, zoom             = isNumeric( leafletConfig.initialZoom      ?: "" ) ? int( leafletConfig.initialZoom ) : 13
			, maxZoom          = isNumeric( leafletConfig.maxZoom          ?: "" ) ? int( leafletConfig.maxZoom )     : 20
			, addressesFound   = $translateResource( "formcontrols.mapPicker:addresses.found" )
			, zoomToFit        = false
			, markers          = []
		};

		$announceInterception( "postGetBaseMapData", { mapData=mapData, leafletConfig=leafletConfig } );

		return mapData;
	}

}