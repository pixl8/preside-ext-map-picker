component {

	public void function configure( required struct config ) {
		var conf     = arguments.config;
		var settings = conf.settings ?: {};

		conf.interceptorSettings.customInterceptionPoints.append( "postGetBaseMapData" );

		settings.mapPicker.defaults = {
			  buttonClass       = ""
			, searchButtonClass = ""
			, centreButtonClass = ""
			, resetButtonClass  = ""
			, searchInputClass  = ""
			, resultSelectClass = ""
			, lookupPageSize    = 10
		};
	}

}