/**
 * @singleton false
 */
component accessors=true extends="Chart" {

	property name="tension"  type="numeric" default=0;
	property name="filled"   type="boolean" default=false;
	property name="stepped"  type="boolean" default=false;
	property name="spanGaps" type="boolean" default=false;

// CONSTRUCTOR
	public any function init( required any utils ) {
		super.init( argumentCollection=arguments );

		setType( "line" );
		setColourMode( "dataset" );

		return this;
	}

	public struct function applyTypeConfig( required struct config ) {
		config.options.datasets.line.tension = getTension();
		if ( getFilled() ) {
			config.options.fill = true;
		}
		if ( getStepped() ) {
			config.options.stepped = true;
		}
		if ( getSpanGaps() ) {
			config.options.spanGaps = true;
		}

		return config;
	}

}