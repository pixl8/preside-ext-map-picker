/**
 * @singleton false
 */
component accessors=true extends="Chart" {

	property name="horizontal" type="boolean" default=false;
	property name="stacked"    type="boolean" default=false;

// CONSTRUCTOR
	public any function init( required any utils ) {
		super.init( argumentCollection=arguments );

		setType( "bar" );
		setColourMode( "dataset" );

		return this;
	}

	public struct function applyTypeConfig( required struct config ) {
		if ( getHorizontal() ) {
			config.options.indexAxis = "y";
		}
		if ( getStacked() ) {
			var definedAxes = [];
			if ( getScales().len() ) {
				for( var scale in getScales() ) {
					config.options.scales[ scale.id ].stacked = true;
					definedAxes.append( scale.axis );
				}
			}

			for( var axis in [ "x", "y" ] ) {
				if ( !definedAxes.find( axis ) ) {
					config.options.scales[ axis ].stacked = true;
				}
			}
		}

		return config;
	}
}