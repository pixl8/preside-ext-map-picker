/**
 * @presideService true
 * @singleton      true
 */
component {

// CONSTRUCTOR
	public any function init() {
		return this;
	}

// CONSTRUCTOR
	/**
	 * @themes.inject    coldbox:setting:chartjs.themes
	 */
	public any function init( required struct themes ) {
		_setThemes( arguments.themes );

		return this;
	}

// PUBLIC API METHODS

	public Chart function newChart( required string type, string id="" ) {
		var chart = new "charts.#arguments.type#"( utils=this );

		if ( $getRequestContext().isAdminRequest() ) {
			chart.setTheme( "admin" );
		}

		return chart;
	}

	public string function buildConfig( required Chart chart ) {
		var theme  = _getTheme( chart.getTheme() );
		var config = {
			  type    = chart.getType()
			, data    = { datasets=[] }
			, options = chart.getOptions()
		};

		// config.options.responsive = !isNumeric( chart.getWidth() ) || !isNumeric( chart.getHeight() );

		if ( isNumeric( chart.getAspectRatio() ) ) {
			config.options.aspectRatio = chart.getAspectRatio();
		} else if ( !isNull( chart.getHeight() ) ) {
			config.options.maintainAspectRatio = false;
		}
		if ( arrayLen( chart.getLabels() ) ) {
			config.data.labels = chart.getLabels();
		}

		chart.getDatasets().each( function( dataset, index ){
			var colourIndex = index mod theme.backgroundColor.len();
			if ( colourIndex == 0 ) {
				colourIndex = theme.backgroundColor.len();
			}

			if ( chart.getColourMode() == "dataset" ) {
				dataset.backgroundColor = theme.backgroundColor[ colourIndex ];
				dataset.borderColor     = theme.borderColor[ colourIndex ];
			} else {
				dataset.backgroundColor = theme.backgroundColor;
				dataset.borderColor     = theme.borderColor;
			}

			dataset.append( dataset.options );
			dataset.delete( "options" );

			config.data.datasets.append( dataset );
		} );

		config = chart.applyTypeConfig( config );

		return SerializeJson( config );
	}

	private struct function _getTheme( required any theme ) {
		var themes = _getThemes();

		return themes[ arguments.theme ] ?: themes.default;
	}

	private any function _getThemes() {
		return _themes;
	}
	private void function _setThemes( required any themes ) {
		_themes = arguments.themes;
	}


}