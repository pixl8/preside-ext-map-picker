/**
 * @singleton false
 */
component accessors=true {

	property name="id"             type="string";
	property name="type"           type="string";
	property name="width"          type="string";
	property name="height"         type="string";
	property name="aspectRatio"    type="numeric";
	property name="title"          type="any";
	property name="subtitle"       type="any";
	property name="titlePosition"  type="string";
	property name="titleAlign"     type="string";
	property name="showLegend"     type="boolean" default=true;
	property name="legendPosition" type="string";
	property name="legendAlign"    type="string";
	property name="labels"         type="array";
	property name="datasets"       type="array";
	property name="scales"         type="array";
	property name="theme"          type="any"     default="default";
	property name="colourMode"     type="string"; // 'dataset' or 'datapoint'
	property name="animation"      type="boolean" default=true;
	property name="options"        type="struct";

// CONSTRUCTOR
	public Chart function init( required any utils ) {
		_setUtils( arguments.utils );

		setDatasets( [] );
		setLabels( [] );
		setScales( [] );
		setOptions( {} );

		return this;
	}

// PUBLIC API METHODS
	public string function render() {
		return _getUtils().render( this );
	}

	public Chart function addDataset(
		  required string label
		, required array  data
		,          string scale
		,          string stack
		,          struct options = {}
	) {
		getDatasets().append( arguments );
		return this;
	}

	public Chart function fromQuery(
		  required query  query
		, required string labelColumn
		, required array  datasets
	) {
		setLabels( valueArray( arguments.query, arguments.labelColumn ) );

		for( var dataset in arguments.datasets ) {
			addDataset(
				  label   = dataset.label   ?: ""
				, data    = valueArray( arguments.query, dataset.column ) ?: []
				, scale   = dataset.scale   ?: nullValue()
				, stack   = dataset.stack   ?: nullValue()
				, options = dataset.options ?: {}
			);
		}

		return this;
	}

	public Chart function addScale(
		  required string  id
		, required string  axis
		,          any     label    = ""
		,          string  position = ""
		,          boolean showGrid = true
		,          numeric min
		,          numeric max
		,          numeric suggestedMin
		,          numeric suggestedMax
		,          struct  options  = {}
	) {
		getScales().append( arguments );
		return this;
	}

	public string function getConfig() {
		return _getUtils().buildConfig( this );
	}

	public struct function applyTypeConfig( required struct config ) {
		return arguments.config;
	}



// GETTERS AND SETTERS
	private any function _getUtils() {
	    return _utils;
	}
	private void function _setUtils( required any utils ) {
	    _utils = arguments.utils;
	}


}