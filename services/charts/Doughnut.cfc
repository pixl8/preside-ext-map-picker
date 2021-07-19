/**
 * @singleton false
 */
component accessors=true extends="Chart" {

// CONSTRUCTOR
	public any function init( required any utils ) {
		super.init( argumentCollection=arguments );

		setType( "doughnut" );
		setColourMode( "datapoint" );

		return this;
	}


}