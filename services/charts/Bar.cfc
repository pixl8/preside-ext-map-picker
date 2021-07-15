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
	}

	public struct function applyTypeConfig( required struct config ) {
		if ( getHorizontal() ) {
			config.options.indexAxis = "y";
		}
		if ( getStacked() ) {
			config.options.scales.x.stacked = true;
			config.options.scales.y.stacked = true;
		}

		return config;
	}
}