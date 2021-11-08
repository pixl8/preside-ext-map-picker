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

	private function website( event, rc, prc, args={} ) {
		var mapData = leafletMapService.getBaseMapData();

		if ( !len( mapData.accessToken ) ) {
			return translateResource( "formcontrols.mapPicker:required.access.token" );
		}
		args.lookupPageSize = args.lookupPageSize ?: 15;
		args.searchType     = len( mapData.geocodeApiKey ) && ( ( args.searchType ?: "address" ) == "address" ) ? "address" : "postcode";
		mapData.errors      = {
			postcode = {
				  title       = translateResource( "formcontrols.mapPicker:postcode.error.title" )
				, notSupplied = translateResource( "formcontrols.mapPicker:postcode.error.not.supplied" )
				, notFound    = translateResource( "formcontrols.mapPicker:postcode.error.not.found" )
				, unexpected  = translateResource( "formcontrols.mapPicker:postcode.error.unexpected" )
			}
			, address = {
				  title       = translateResource( "formcontrols.mapPicker:address.error.title" )
				, notSupplied = translateResource( "formcontrols.mapPicker:address.error.not.supplied" )
				, notFound    = translateResource( "formcontrols.mapPicker:address.error.not.found" )
				, unexpected  = translateResource( "formcontrols.mapPicker:address.error.unexpected" )
			}
		};
		mapData.i18n = {
			multipleAddressesFound = translateResource( "formcontrols.mapPicker:addresses.found" )
		};

		event.includeData( { mapData=mapData } )
			.include( "/js/frontend/mapPicker/" )
			.include( "/css/frontend/mapPicker/" );

		return renderView( view="formcontrols/mapPicker/website", args=args );
	}

}
