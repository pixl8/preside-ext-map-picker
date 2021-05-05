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
			, zoom             = int( leafletConfig.initialZoom ?: 14 )
			, maxZoom          = int( leafletConfig.maxZoom     ?: 18 )
			, defaultLatitude  = leafletConfig.defaultLatitude  ?: 54.003
			, defaultLongitude = leafletConfig.defaultLongitude ?: -2.547
			, defaultZoom      = int( leafletConfig.defaultZoom ?: 5 )
			, zoomToFit        = false
			, markers          = []
		};

		return mapData;
	}

}