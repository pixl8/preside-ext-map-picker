# Map Picker for Preside

## Overview

### What it does

This extension provides an admin map picker for selecting latitude/longitude values via a drag and drop map panel, and gives two-way interaction between the map and the lat/long fields.

It uses [Leaflet](https://leafletjs.com/) as its mapping API, and requires an access token from [Mapbox](https://www.mapbox.com/).

It also includes UK postcode lookups via [Postcodes.io](https://postcodes.io/), either from a postcode field elsewhere in the form, or by manually entering a postcode to centre the map to.

### What it doesn't do

It is not designed as a front-end mapping extension for Preside. Any requirements are usually custom to the application, and so it's nearly impossible to create a one-size-fits-all solution for that.

## Usage

### Configuration

First, you will want to set up the extension via the **Leaflet** panel under Preside's **System > Settings**.

Once you have entered a Mapbox access token, you can set the default centre point and zoom level for new map controls.

### The form control

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