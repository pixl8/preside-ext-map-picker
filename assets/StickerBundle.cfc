/**
 * Sticker bundle configuration file. See: http://sticker.readthedocs.org/
 */

component output=false {

	public void function configure( bundle ) output=false {
		bundle.addAssets(
			  directory   = "/js/"
			, match       = function( path ){ return ReFindNoCase( "_[0-9a-f]{8}\..*?\.min.js$", arguments.path ); }
			, idGenerator = function( path ) {
				return ListDeleteAt( path, ListLen( path, "/" ), "/" ) & "/";
			}
		);

		bundle.addAsset( id="mappicker-leafletjs" , path="/lib/mappicker-leaflet/leaflet-1.7.1.js" );
		bundle.addAsset( id="mappicker-leafletcss", path="/lib/mappicker-leaflet/leaflet-1.7.1.css" );

		bundle.asset( "/js/admin/mapPicker/" ).dependsOn( "mappicker-leafletjs" );
		bundle.asset( "/js/admin/mapPicker/" ).dependsOn( "mappicker-leafletcss" );
	}
}