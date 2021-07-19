<cfscript>
	chart  = args.chart  ?: "";
	id     = args.id     ?: "";
	styles = args.styles ?: "";
</cfscript>

<cfoutput>
	<div class="chart-canvas-container" style="#styles#">
		<canvas id="#id#" class="chart-canvas"></canvas>
	</div>
</cfoutput>