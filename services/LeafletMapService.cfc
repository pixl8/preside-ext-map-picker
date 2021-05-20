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
			, defaultLatitude  = leafletConfig.defaultLatitude  ?: 54.003
			, defaultLongitude = leafletConfig.defaultLongitude ?: -2.547
			, defaultZoom      = isNumeric( leafletConfig.defaultZoom ?: "" ) ? int( leafletConfig.defaultZoom ) : 5
			, zoomToFit        = false
			, markers          = []
		};

		$announceInterception( "postGetBaseMapData", { mapData=mapData, leafletConfig=leafletConfig } );

		return mapData;
	}

}