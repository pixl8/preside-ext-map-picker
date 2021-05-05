component {

	property name="leafletMapService" inject="LeafletMapService";

	private function index( event, rc, prc, args={} ) {
		if ( !len( args.latitudeField ?: "" ) || !len( args.latitudeField ?: "" ) ) {
			return "Map control requires both <code>latitudeField</code> and <code>longitudeField</code> to be configured.";
		}

		var mapData = leafletMapService.getBaseMapData();
		mapData.alertPosition = getSetting( "adminNotificationsPosition" );

		if ( len( args.zoomField ?: "" ) && isNumeric( args.savedData[ args.zoomField ] ?: "" ) ) {
			mapData.zoom = args.savedData[ args.zoomField ];
		}

		mapData.errors = {
			  title       = translateResource( "formcontrols.mapPicker:postcode.error.title" )
			, notSupplied = translateResource( "formcontrols.mapPicker:postcode.error.not.supplied" )
			, notFound    = translateResource( "formcontrols.mapPicker:postcode.error.not.found" )
			, unexpected  = translateResource( "formcontrols.mapPicker:postcode.error.unexpected" )
		};

		event.includeData( { mapData=mapData } )
			.include( "/js/admin/mapPicker/" );

		return renderView( view="formcontrols/mapPicker/index", args=args );
	}

}
