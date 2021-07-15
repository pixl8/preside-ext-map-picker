/**
 * @singleton false
 */
component accessors=true {

	property name="id"          type="string" default="#_newId()#";
	property name="width"       type="string";
	property name="height"      type="string";
	property name="aspectRatio" type="numeric";
	property name="type"        type="string";
	property name="datasets"    type="array";
	property name="labels"      type="array";
	property name="theme"       type="any"    default="default";
	property name="colourMode"  type="string"; // 'dataset' or 'datapoint'
	property name="options"     type="struct";
	property name="defaults"    type="struct";

// CONSTRUCTOR
	public Chart function init( required any utils ) {
		_setUtils( arguments.utils );

		setDatasets( [] );
		setLabels( [] );
		setOptions( {} );
		setDefaults( {} );

		return this;
	}

// PUBLIC API METHODS
	public Chart function addDataset(
		  required string label
		, required array  data
		,          struct options = {}
	) {
		getDatasets().append( arguments );

		return this;
	}

	public string function getConfig() {
		return _getUtils().buildConfig( this );
	}

	public struct function applyTypeConfig( required struct config ) {
		return arguments.config;
	}

// PRIVATE HELPERS
	private string function _newId() {
		return "chart" & lcase( replace ( createUUID(), "-", "", "all" ) );
	}


// GETTERS AND SETTERS
	private any function _getUtils() {
	    return _utils;
	}
	private void function _setUtils( required any utils ) {
	    _utils = arguments.utils;
	}


}