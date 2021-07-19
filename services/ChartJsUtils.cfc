/**
 * @presideService true
 * @singleton      true
 */
component {

// CONSTRUCTOR
	/**
	 * @types.inject    coldbox:setting:chartjs.types
	 * @themes.inject   coldbox:setting:chartjs.themes
	 */
	public any function init( required array types, required struct themes ) {
		_setTypes( arguments.types );
		_setThemes( arguments.themes );

		return this;
	}

// PUBLIC API METHODS
	public Chart function newChart(
		  required string type
		,          string theme = $getRequestContext().isAdminRequest() ? "admin" : "default"
		,          string id    = _generateId()
	) {
		var chart = _getChartInstance( arguments.type );

		chart.setTheme( arguments.theme );
		chart.setId( arguments.id );

		return chart;
	}

	public string function buildConfig( required Chart chart ) {
		var theme  = _getTheme( chart.getTheme() );
		var config = {
			  type    = chart.getType()
			, data    = { datasets=[] }
			, options = {}
		};

		var options = chart.getOptions();
		for( var option in options ) {
			"config.options.#option#" = options[ option ];
		}

		// Title and Subtitle
		if ( !isEmpty( chart.getTitle() ) ) {
			config.options.plugins.title.text    = chart.getTitle();
			config.options.plugins.title.display = true;

			if ( len( chart.getTitlePosition() ) ) {
				config.options.plugins.title.position = chart.getTitlePosition();
			}
			if ( len( chart.getTitleAlign() ) ) {
				config.options.plugins.title.align = chart.getTitleAlign();
			}
		}
		if ( !isEmpty( chart.getSubtitle() ) ) {
			config.options.plugins.subtitle.text    = chart.getSubtitle();
			config.options.plugins.subtitle.display = true;

			if ( len( chart.getTitlePosition() ) ) {
				config.options.plugins.subtitle.position = chart.getTitlePosition();
			}
			if ( len( chart.getTitleAlign() ) ) {
				config.options.plugins.subtitle.align = chart.getTitleAlign();
			}
		}

		if ( $helpers.isFalse( chart.getShowLegend() ) ) {
			config.options.plugins.legend.display = false;
		} else {
			if ( len( chart.getLegendPosition() ) ) {
				config.options.plugins.legend.position = chart.getLegendPosition();
			}
			if ( len( chart.getLegendAlign() ) ) {
				config.options.plugins.legend.align = chart.getLegendAlign();
			}
		}

		// Disable animation
		if ( $helpers.isFalse( chart.getAnimation() ) ) {
			config.options.animation = false;
			config.options.animations.colors = false;
			config.options.animations.x = false;
			config.options.transitions.active.animation.duration = 0;
		}

		// Aspect ratio
		if ( !isNull( chart.getHeight() ) ) {
			config.options.maintainAspectRatio = false;
		} else if ( isNumeric( chart.getAspectRatio() ) ) {
			config.options.aspectRatio = chart.getAspectRatio();
		}

		// Labels
		if ( arrayLen( chart.getLabels() ) ) {
			config.data.labels = chart.getLabels();
		}

		// Scales
		chart.getScales().each( function( scale, index ){
			var scaleConfig = {};
			for( var option in scale.options ) {
				"scaleConfig.#option#" = scale.options[ option ];
			}

			if ( !isEmpty( scale.label ) ) {
				scaleConfig.title.text    = scale.label;
				scaleConfig.title.display = true;
			}
			for( var key in [ "min", "max", "suggestedMin", "suggestedMax" ] ) {
				if ( isNumeric( scale[ key ] ?: "" ) ) {
					scaleConfig[ key ] = scale[ key ];
				}
			}
			if ( len( scale.position ?: "" ) ) {
				scaleConfig.position = scale.position;
			}
			scaleConfig.axis         = scale.axis;
			scaleConfig.grid.display = scale.showGrid;

			config.options.scales[ scale.id ] = scaleConfig;
		} );

		// Datasets
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

			if ( len( dataset.scale ?: "" ) ) {
				dataset.yAxisID = dataset.scale;
			}
			if ( !len( dataset.stack ?: "" ) ) {
				dataset.delete( "stack" );
			}

			for( var option in dataset.options ) {
				"dataset.#option#" = dataset.options[ option ];
			}
			dataset.append( dataset.options );
			dataset.delete( "options" );
			dataset.delete( "scale" );

			config.data.datasets.append( dataset );
		} );

		// Apply chart-type-specific options
		config = chart.applyTypeConfig( config );

		return SerializeJson( config );
	}

	public string function render( required Chart chart ) {
		return $renderViewlet( event="charts._renderChart", args={ chart=arguments.chart } );
	}


// PRIVATE HELPERS
	private Chart function _getChartInstance( required string type ) {
		var validTypes = _getTypes();

		if ( !validTypes.findNoCase( arguments.type ) ) {
			throw( type="charts.invalid.type", message="Invalid chart type specified. Chart type must be one of: [ #validTypes.toList( ", " )# ]" );
		}

		return createObject( "charts.#arguments.type#" ).init( utils=this );
	};

	private string function _generateId() {
		return "chart" & lcase( replace ( createUUID(), "-", "", "all" ) );
	}

	private struct function _getTheme( required any theme ) {
		var themes = _getThemes();

		return themes[ arguments.theme ] ?: themes.default;
	}


// GETTERS AND SETTERS
	private array function _getTypes() {
		return _types;
	}
	private void function _setTypes( required array types ) {
		_types = arguments.types;
	}

	private struct function _getThemes() {
		return _themes;
	}
	private void function _setThemes( required struct themes ) {
		_themes = arguments.themes;
	}

}