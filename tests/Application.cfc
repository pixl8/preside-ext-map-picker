component {
	this.name = "Chart.js for Preside Test Suite";

	this.mappings[ '/tests'   ] = ExpandPath( "/" );
	this.mappings[ '/testbox' ] = ExpandPath( "/testbox" );
	this.mappings[ '/chart-js'  ] = ExpandPath( "../" );

	setting requesttimeout=60000;
}
