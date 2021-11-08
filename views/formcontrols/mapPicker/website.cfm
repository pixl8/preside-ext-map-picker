<cfscript>
	inputName         = args.name         ?: "";
	inputId           = args.id           ?: "";
	defaultValue      = args.defaultValue ?: "";
	searchEnabled     = isTrue( args.searchEnabled ?: true );
	searchFields      = args.searchFields ?: "";
	searchType        = args.searchType   ?: "address";
	searchStandalone  = !Len( searchFields );
	searchInputClass  = args.searchInputClass  ?: "";
	buttonClass       = args.buttonClass       ?: "";
	searchButtonClass = args.searchButtonClass ?: "";
	centreButtonClass = args.centreButtonClass ?: "";
	resetButtonClass  = args.resetButtonClass  ?: "";

	value  = event.getValue( name=inputName, defaultValue=defaultValue );
	if ( not IsSimpleValue( value ) ) {
		value = "";
	}
</cfscript>

<cfoutput>
	<div class="frontend-map-picker">
		<div class="frontend-map-picker-map"
			id="#inputId#-map"
			data-lat-lng-field="#inputName#"
			data-search-fields="#searchFields#"
			data-search-type="#searchType#"
		></div>

		<div class="frontend-map-picker-controls">
			<cfif searchEnabled>
				<div class="frontend-map-picker-search">
					<cfif searchStandalone>
						<input type="text" class="#searchInputClass# frontend-map-picker-search-input" placeholder="#translateResource( "formcontrols.mapPicker:frontend.search.placeholder.#searchType#" )#">
					</cfif>
					<button type="button" class="#buttonClass# #searchButtonClass# marker-set-by-search">
						#translateResource( "formcontrols.mapPicker:frontend.button.marker.from.#searchType#" )#
					</button>
				</div>
			</cfif>
			<div class="frontend-map-picker-results"></div>

			<input type="hidden" size="100" name="#inputName#" id="#inputId#" value="#HtmlEditFormat( value )#">

			<button type="button" class="#buttonClass# #centreButtonClass# marker-set-at-centre">
				#translateResource( "formcontrols.mapPicker:frontend.button.marker.at.centre" )#
			</button>
			<button type="button" class="#buttonClass# #resetButtonClass# marker-reset">
				#translateResource( "formcontrols.mapPicker:frontend.button.marker.reset" )#
			</button>
		</div>

	</div>
</cfoutput>