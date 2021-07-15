<cffunction name="renderChart" access="public" returntype="any" output="false">
	<cfargument name="chart" required="true">
	<cfscript>
		return renderViewlet( event="charts._renderChart", args=arguments );
	</cfscript>
</cffunction>

<cffunction name="setChartDefaults" access="public" returntype="any" output="false">
	<cfargument name="config" type="string">
	<cfargument name="custom" type="struct">
	<cfscript>
		return renderViewlet( event="charts._setDefaults", args=arguments );
	</cfscript>
</cffunction>