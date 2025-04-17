<cfscript>
	inputName      = args.name           ?: "";
	inputId        = args.id             ?: "";
	postcodeField  = args.postcodeField  ?: "";
	latitudeField  = args.latitudeField  ?: "";
	longitudeField = args.longitudeField ?: "";
	zoomField      = args.zoomField      ?: "";
</cfscript>

<cfoutput>
	<div class="admin-map-picker">
		<div class="admin-map-picker-map"
			id="#inputId#"
			<cfif Len( postcodeField )>
				data-postcode-field="#postcodeField#"
			</cfif>
			<cfif Len( latitudeField )>
				data-latitude-field="#latitudeField#"
			</cfif>
			<cfif Len( longitudeField )>
				data-longitude-field="#longitudeField#"
			</cfif>
			<cfif Len( zoomField )>
				data-zoom-field="#zoomField#"
			</cfif>
			style="height:500px;"
		></div>

		<div class="admin-map-picker-buttons" style="text-align:right;margin-top:4px;">
			<cfif len( postcodeField )>
				<button type="button" class="btn btn-info marker-set-at-postcode">
					<i class="fa fa-fw fa-location-arrow"></i>
					#translateResource( "formcontrols.mapPicker:button.marker.at.postcode" )#
				</button>
			</cfif>
			<button type="button" class="btn btn-info marker-set-at-centre">
				<i class="fa fa-fw fa-crosshairs"></i>
				#translateResource( "formcontrols.mapPicker:button.marker.at.centre" )#
			</button>
			<button type="button" class="btn marker-reset">
				<i class="fa fa-fw fa-undo"></i>
				#translateResource( "formcontrols.mapPicker:button.marker.reset" )#
			</button>
		</div>
	</div>
</cfoutput>