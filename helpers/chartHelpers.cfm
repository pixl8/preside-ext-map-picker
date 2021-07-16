<cffunction name="newChart" access="public" returntype="Chart" output="false">
	<cfargument name="type"  type="string" required="true">
	<cfargument name="theme" type="string">
	<cfargument name="id"    type="string">

	<cfreturn getSingleton( "ChartJsUtils" ).newChart( argumentCollection=arguments )>
</cffunction>

<cffunction name="renderChart" access="public" returntype="string" output="false">
	<cfargument name="chart" type="Chart" required="true">

	<cfreturn renderViewlet( event="charts._renderChart", args=arguments )>
</cffunction>

<cffunction name="setChartDefaults" access="public" returntype="any" output="false">
	<cfargument name="config" type="string">
	<cfargument name="custom" type="struct">

	<cfreturn renderViewlet( event="charts._setDefaults", args=arguments )>
</cffunction>