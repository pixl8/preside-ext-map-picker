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

		event.includeData( { mapData=mapData } )
			.include( "/js/admin/mapPicker/" );

		return renderView( view="formcontrols/mapPicker/index", args=args );
	}

}
