component {

	public void function configure( required struct config ) {
		var conf         = arguments.config;
		var settings     = conf.settings    ?: {};
		settings.chartjs = settings.chartjs ?: {};

		settings.chartjs.themes.default = {
			  backgroundColor = [
				  'rgba( 255, 99, 132, 0.7 )'
				, 'rgba( 54, 162, 235, 0.7 )'
				, 'rgba( 255, 206, 86, 0.7 )'
				, 'rgba( 75, 192, 192, 0.7 )'
				, 'rgba( 153, 102, 255, 0.7 )'
				, 'rgba( 255, 159, 64, 0.7 )'
			  ]
			, borderColor     = [
				  'rgba( 255, 99, 132, 1 )'
				, 'rgba( 54, 162, 235, 1 )'
				, 'rgba( 255, 206, 86, 1 )'
				, 'rgba( 75, 192, 192, 1 )'
				, 'rgba( 153, 102, 255, 1 )'
				, 'rgba( 255, 159, 64, 1 )'
			]
		};
		settings.chartjs.themes.admin = {
			  backgroundColor = [
				  'rgba( 249, 163, 38, 0.8 )'
				, 'rgba( 44, 61, 78, 0.8 )'
				, 'rgba( 243, 88, 69, 0.8 )'
				, 'rgba( 38, 121, 181, 0.8 )'
				, 'rgba( 120, 144, 158, 0.8 )'
				, 'rgba( 251, 190, 104, 0.8 )'
				, 'rgba( 86, 119, 152, 0.8 )'
				, 'rgba( 247, 141, 129, 0.8 )'
				, 'rgba( 110, 177, 225, 0.8 )'
				, 'rgba( 171, 186, 195, 0.8 )'
			  ]
			, borderColor     = [
				  'rgba( 249, 163, 38, 1 )'
				, 'rgba( 44, 61, 78, 1 )'
				, 'rgba( 243, 88, 69, 1 )'
				, 'rgba( 38, 121, 181, 1 )'
				, 'rgba( 120, 144, 158, 1 )'
				, 'rgba( 251, 190, 104, 1 )'
				, 'rgba( 86, 119, 152, 1 )'
				, 'rgba( 247, 141, 129, 1 )'
				, 'rgba( 110, 177, 225, 1 )'
				, 'rgba( 171, 186, 195, 1 )'
			]
		};

		settings.chartjs.themes.grey   = _buildTheme( 0, 0 );
		settings.chartjs.themes.red    = _buildTheme( 0, 100 );
		settings.chartjs.themes.orange = _buildTheme( 30, 100 );
		settings.chartjs.themes.yellow = _buildTheme( 60, 100 );
		settings.chartjs.themes.green  = _buildTheme( 110, 100 );
		settings.chartjs.themes.blue   = _buildTheme( 215, 100 );
		settings.chartjs.themes.purple = _buildTheme( 270, 100 );
		settings.chartjs.themes.pink   = _buildTheme( 320, 100 );

		settings.chartjs.defaults = {
			  admin   = {
				  "font.family" = "'Preside Open Sans','Helvetica Neue',Helvetica,Arial,sans-serif"
				, "font.size"   = 14
				, "color"       = "##393939"
			  }
			, website = {}
		};

	}

	private struct function _buildTheme( required numeric h, required numeric s ) {
		var theme = { backgroundColor=[], borderColor=[] };

		for( var l=30; l<=86; l+=7 ) {
			theme.backgroundColor.append( "hsla( #h#, #s#%, #l#%, 0.75 )" );
			theme.borderColor.append( "hsla( #h#, #s#%, #l#%, 1 )" );
		}

		return theme;
	}
}
