# Map Picker for Preside

## Overview

### What it does

This extension provides admin and front-end map picker form controls for selecting latitude/longitude values via a drag and drop map panel, and gives two-way interaction between the map and the lat/long fields.

It uses [Leaflet](https://leafletjs.com/) as its mapping API, and requires an access token from [Mapbox](https://www.mapbox.com/).

It also includes UK postcode lookups via [Postcodes.io](https://postcodes.io/), either from a postcode field elsewhere in the form, or by manually entering a postcode to centre the map to.

Full address geolocation is (optionally) provided by the [Google Geocoding API](https://mapsplatform.google.com/). Sign up for an API key (with access to the Maps and Places APIs); note that this is a **paid-for service**.

### What it doesn't do

It is not designed as a front-end map display extension for Preside. Any requirements are usually custom to the application, and so it's nearly impossible to create a one-size-fits-all solution for that.

## Usage

### Configuration

First, you will want to set up the extension via the **Map Picker** panel under Preside's **System > Settings**.

Once you have entered a Mapbox access token, you can set the default centre point and zoom level for new map controls.

### The admin form control

Include the `mapPicker` form control in your form definition using a named form field (the map picker will not itself relate to any object binding):

```
<?xml version="1.0" encoding="UTF-8"?>
<form i18nBaseUri="preside-objects.organisation:">
	<tab id="main">
		<fieldset>
			<field binding="organisation.address" />
			<field binding="organisation.postcode" />
			<field name="locationPicker" control="mapPicker" label="Locate on map"
				latitudeField="latitude" longitudeField="longitude" postcodeField="postcode" />
			<field binding="organisation.latitude" />
			<field binding="organisation.longitude" />
		</fieldset>
	</tab>
</form>
```

The required attributes for the form control are:

- `latitudeField`: the name of the form field that stores the latitude
- `longitudeField`: the name of the form field that stores the longitude

Above, we are also using the optional `postcodeField`. If this is specified, the map picker will show a **Set marker at postcode** button, which will look up the location of the postcode in this field and centre the map at those coordinates.

There is also an optional `zoomField` attribute; this field will be linked to the zoom level of the map, so you can store that alongside the coordinates in your data model.

There is a button on the map picker **Place marker at map centre**, which does what it says: when clicked, it will move the marker to the centre of the current map view.

Finally, **Reset marker** will restore the map and its linked fields to the state they had when the page was loaded - either the original position of the marker, or removing the marker if there wasn't one.

### The front-end form control

Configuring the front-end map picker control is slightly different from the admin control. The control returns a comma-separated `lat,lng` value, and can be implemented with no dependency on other form fields. If persisting to a Preside object, a `varchar( 30 )` property is recommended.

Frontend forms should be rendered in the `website` context.

*Note that the front-end map picker depends on jQuery being available on the page*

```
<?xml version="1.0" encoding="UTF-8"?>
<form i18nBaseUri="preside-objects.organisation:">
	<tab id="main">
		<fieldset>
			<field binding="organisation.location" control="mappicker" />
		</fieldset>
	</tab>
</form>
```

The above code will use the default settings: the map will have a full address lookup field (if a Google API key has been configured), or a simple UK postcode lookup (if no Google API key is provided).

There are a number of attributes that can be used to customise the map picker:

- `searchType`: defaults to `address`, which will use the default logic described above. If set to `postcode`, the lookup will be a simple postcode lookup, whether or not the Google API key is configured.
- `searchEnabled`: defaults to `true`. If set to `false`, neither address nor postcode lookup will be provided.
- `searchFields`: empty by default. If empty, the picker will include its own search input field. But if set to the name (or comma-separated list of names) of another field within the form, then that/those fields will be used to do the location search (so the user does not need to enter data twice).
- `buttonClass`: class to be applied to all buttons on the picker
- `searchButtonClass`, `centreButtonClass`, `resetButtonClass`: class to be applied to specific buttons
- `searchInputClass`, `resultSelectClass`: class to be applied to the picker's search input and multiple result select fields

An example of `searchFields`, which will concatenate the contents of the listed fields and send them to the geocoding service:

```
<?xml version="1.0" encoding="UTF-8"?>
<form i18nBaseUri="preside-objects.organisation:">
	<tab id="main">
		<fieldset>
			<field binding="organisation.location" control="mappicker" searchFields="address_1,address_2,city,county,country,postcode" />
		</fieldset>
	</tab>
</form>
```

#### Global defaults

The following settings may also be defined globally in `Config.cfc` and will be used unless overridden on a specific form field definition:

```
settings.mapPicker.defaults = {
	  buttonClass       = ""
	, searchButtonClass = ""
	, centreButtonClass = ""
	, resetButtonClass  = ""
	, searchInputClass  = ""
	, resultSelectClass = ""
};
```