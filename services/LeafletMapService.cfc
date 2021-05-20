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
			  accessToken      = leafletConfig.accessToken ?: ""
			, defaultLatitude  = isNumeric( leafletConfig.defaultLatitude  ?: "" ) ? int( leafletConfig.defaultLatitude  ) : 54.003
			, defaultLongitude = isNumeric( leafletConfig.defaultLongitude ?: "" ) ? int( leafletConfig.defaultLongitude ) : -2.547
			, defaultZoom      = isNumeric( leafletConfig.defaultZoom      ?: "" ) ? int( leafletConfig.defaultZoom      ) : 5
			, zoomToFit        = false
			, markers          = []
		};

		$announceInterception( "postGetBaseMapData", { mapData=mapData, leafletConfig=leafletConfig } );

		return mapData;
	}

}