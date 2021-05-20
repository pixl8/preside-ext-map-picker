component {

	property name="leafletMapService" inject="LeafletMapService";

	private function index( event, rc, prc, args={} ) {
		var mapData = leafletMapService.getBaseMapData();

		if ( !len( mapData.accessToken ) ) {
			return translateResource( "formcontrols.mapPicker:required.access.token" );
		}
		if ( !len( args.latitudeField ?: "" ) || !len( args.latitudeField ?: "" ) ) {
			return translateResource( "formcontrols.mapPicker:required.arguments" );
		}

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
