component {

	private string function _renderChart( event, rc, prc, args={} ) {
		var chart = args.chart ?: "";

		if ( !isInstanceOf( chart, "app.extensions.preside-ext-chart-js.services.charts.Chart" )  ) {
			return "";
		}

		var id     = chart.getId();
		var width  = chart.getWidth()  ?: "";
		var height = chart.getHeight() ?: "";
		var styles = "position:relative;";

		if ( isNumeric( width ) ) {
			width &= "px";
		}
		if ( isNumeric( height ) ) {
			height &= "px";
		}
		if ( len( height ) ) {
			styles &= "height:#height#;";
		}
		if ( len( width ) ) {
			styles &= "width:#width#;";
		}

		event.include( "chartjs" );
		event.includeInlineJs( "var #id# = new Chart( document.getElementById( '#id#' ), #chart.getConfig()# );" );

		return renderView( view="charts/_chart", args={ chart=chart, styles=styles, id=id } );
	}

	private void function _setDefaults( event, rc, prc, args={} ) {
		var config   = args.config ?: "";
		var custom   = args.custom ?: {};
		var defaults = [];
		var combined = duplicate( getSetting( name="chartjs.defaults.#config#", defaultValue={} ) );

		structAppend( combined, custom );

		if ( combined.isEmpty() ) {
			return;
		}

		for( var key in combined ) {
			defaults.append( "Chart.defaults.#key# = #serializeJson( combined[ key ] )#;" );
		}

		event.include( "chartjs" );
		event.includeInlineJs( defaults.toList( "#chr(10)#" ) );
	}

}