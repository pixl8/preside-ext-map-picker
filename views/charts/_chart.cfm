<cfscript>
	chart  = args.chart  ?: "";
	id     = args.id     ?: "";
	styles = args.styles ?: "";
</cfscript>

<cfoutput>
	<div class="chart-canvas-container" style="#styles#">
		<canvas id="#id#" class="chart-canvas"></canvas>
	</div>

	<script>
		var #id#
		  , #id#_config = #chart.getConfig()#
		  , #id#_init   = function() {
				#id# = new Chart( document.getElementById( '#id#' ), #id#_config );
		    };
	</script>
</cfoutput>