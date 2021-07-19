# Chart.js for Preside

This extension provides simple integration of charts into Preside, implementing the [Chart.js](https://www.chartjs.org/) library.

Te aim of the extension is to provide simple access to the most commonly-used functionality of the library, while also enabling more complex customisation using configuration options which can be found in the [Chart.js documentation](https://www.chartjs.org/docs/latest/).

## Quick start

Below is the simplest creation of a line chart:

```
#newChart( "line" )
	.setLabels( [ "Item 1", "Item 2", "Item 3", "Item 4", "Item 5", "Item 6" ] )
	.addDataset( "Counts", [ 12, 19, 3, 8, 12, 22 ] )
	.render()#
```

This will include the library JS in the page, write an empty canvas element to the page, and include the JS config required to render the chart.

Let's look in more detail at how we can create more complex charts and customise them to our requirements.

---

## Creating a chart

A new chart object can be created either by using the `newChart()` method in the `ChartJsUtils` service, or via the `newChart()` helper method which proxies to the service.

The method requires a `type` argument, which will be one of the supported chart types (see below).

The `theme` argument is optional and refers to a predefined colour theme set up in `Config.cfc`. If not supplied, frontend requests will use the `default` theme, admin requests will use the `admin` theme.

The `id` argument is optional and allows explicit setting of the ID of the chart and its canvas element. If not supplied, a random ID will be generated.

The `newChart()` method returns a Chart object, which can then be worked on via its exposed methods.

---

## The base Chart object

All chart types extend the base Chart object, which contains the properties and methods common to all charts. The following methods control how a chart is displayed.

### `setWidth( numeric | string )`

By default, the chart's container will fill the available horizontal space, and will resize responsively according to the chart type's intrinsic aspect ratio, or the aspect ratio set explicitly on the chart.

Setting a width will restrict this width, but the chart will still resize if the other sizing settings allow.

The value passed to the method can be any valid CSS size value (`50%`, `500px`, `75vw`). If a simple numeric value is passed, it will be treated as a pixel value.

### `setHeight( numeric | string )`

If no height is specified on a chart, the chart will obtain its height from a combination of its width and aspect ratio, and will retain that aspect ratio when resizing.

If a height is provided, that height will be retained and the aspect ratio will be ignored.

The value passed to the method can be any valid CSS size value (`50%`, `500px`, `75vw`). If a simple numeric value is passed, it will be treated as a pixel value.

### `setAspectRatio( numeric )`

Sets the proportions of the chart. The number provided should be the ratio of width / height - so an aspect ratio of 2 would mean the chart is twice as wide as it is high.

By default, line and bar charts have an aspect ratio of 2, while pie and doughnut charts have an aspect ratio of 1 (i.e. square).

If a height has been set on the chart, the aspect ration will be ignored.

### `setTitle( string | string[] )`

Title for the chart. If an array of strings is provided, each will be displayed on a separate line.

### `setSubtitle( string | string[] )`

Subtitle for the chart. If an array of strings is provided, each will be displayed on a separate line.

### `setTitlePosition()`

`top` | `bottom` | `left` | `right` (top is default)

### `setTitleAlign()`

`start` | `center` | `end` (center is default)

### `setShowLegend( boolean )`

The chart legend is displayed by default, but can be hidden by setting `setShowLegend( false )`.

### `setLegendPosition()`

`top` | `bottom` | `left` | `right` (top is default)

### `setLegendAlign()`

`start` | `center` | `end` (center is default)

### `setAnimation( boolean )`

Charts are animated by default. Animation can be turned off for a chart by setting `setAnimation( false )`.

### `setTheme( string )`

The theme can either be set when creating a new chart, or by using this method on a chart object. See **Themes**

### `setColourMode( string )`

This is set automatically by each chart type, but can be overridden if desired.

`dataset` will use the nth colour in the theme for all points in a dataset, where n is the index of the dataset (the first dataset will use the first colour, etc). Used by default for line and bar charts.

`datapoint` will cycle through the colours in the theme for each point in a dataset. Used by default by pie and doughnut charts.

### `setOptions( struct )`

Set an optional struct containing additional settings that are available in the Chart.js library but are not implemented in this extension. For instance, you might pass in:

```
chart.setOptions( {
	  "animation.duration"     = 500
	, "plugins.legend.reverse" = true
} );
```

Note that, as in the example, the struct keys should be the full dotted path of the setting.


## Line charts

A line chart plots points, joined by a solid line (the theme's `borderColor`). Line charts have a few additional config settings:

### `setTension( numeric )`

A number between 0 and 1. By default, this is set to 0, which means that straight lines join each point. As the value increased towards 1, the line curves more to create a smooth line.

### `setFilled( boolean )`

If set to true, the area below the line will be filled with the `backgroundColor`.

### `setStepped( boolean )`

If set to true, the line will be drawn as a stepped line, with all lines either horizontal or vertical.

### `setSpanGaps( boolean )`

By default, if a point in a dataset is null, there will be a gap in the line. By setting `setSpanGaps( true )`, a continuous line will be drawn joining the points either side of the gap.

## Bar charts

A bar chart plots a solid filled block from zero to the point's value, and have a couple of additional settings:

### `setHorizontal()`

By default, the blocks are plotted vertically, with values increasing up the Y axis. `setHorizontal( true )` rotates the chart so the bars are plotted horizontally.

### `setStacked()`

By default, values from multiple datasets are plotted next to each other, each starting at zero. `setStacked( true )` causes the bars to be stacked on top of each other, so a value of 3 and a value of 4 would have a combined height of 7.

See **Stacking** below for more fine-grained stacking control.

## Pie / Doughnut charts

Pie and doughnut charts are essentially the same, except that doughnut charts have a cutout circle in the center.

They have no additional properties.

---

## Adding data to a chart

A chart is not much use until it has some data, so let's add some.

A chart's data is made up of an array of labels for the x-axis, and one or more datasets, each of which contains an array of values.

Looking again at our simple example above, we can see the labels being added using `addLabels()`:

```
chart.setLabels( [ "Item 1", "Item 2", "Item 3", "Item 4", "Item 5", "Item 6" ] );
```

We can then add an array of datapoints using `addDataSet( label, data, scale, stack, options )`. The required arguments for this are `label` (a name describing the dataset) and `data` (an array of values). Note that you can include null values in the array if a point does not have any data. This will then not be plotted, but is different from a value of 0!

```
chart.addDataset( "Counts", [ 12, 19, 3, 8, 12, 22 ] );
```

`scale` and `stack` are optional string values, and will be addressed in their respective sections below.

`options` is an optional struct containing additional settings that are available in the Chart.js library but are not implemented in this extension. For instance, you might pass in:

```
chart.addDataset( label="Counts", data=[ 12, 19, 3, 8, 12, 22 ], options={ backgroundColor="rgba(0,0,0,0.5)" } );
```

...which would allow you to specify a custom colour for this dataset. For all the available options, see the Chart.js documentation.

You can add multiple datasets to a chart, like this:

```
chart.addDataset( "Counts", [ 12, 19, 3, 8, 12, 22 ] )
     .addDataset( "Average age", [ 30, 23, 19, 35, 13, 27 ] );
```

You should always ensure that you have the same number of datapoints in eact dataset as you have in your array of labels.

## Sourcing data from a query

If you have a query which contains the data for your chart, there is a method which makes it easy to use it in your chart: `fromQuery( query, labelColumn, datasets )`. `query` is a query object; `labelColumn` is a string denoting the column name that contains the labels; and `datasets` is an array of dataset objects.

In the example above, let's say we have a query called `myQuery` with columns `item_label`, `item_counts` and `average_age`. We could achieve the same as above like this:

```
chart.fromQuery( myQuery, "item_label", [
	  { label="Counts", column="item_counts" }
	, { label="Average age", column="average_age" }
] );
```

As with the examples above, each dataset object in the array can also include `scale`, `stack` and `options`.

---

## Scales

If the chart's axes are not otherwise configured, a chart will have an x-axis displaying labels, and a single y-axis showing values, the extent of which will be derived from the data.

Axes can be configured using `chart.addScale()`, which has a number of arguments:

`id` (required) is an ID that can be used when assigning this scale to a dataset.

`axis` (required) will be either `x` or `y`, and denotes which axis the scale applies to.

`label` is the label to be attached to the scale. As with other labels, this may be a string or an array of strings.

`position` specifies where on the chart the scale should be displayed. One of `left`, `right`, `top`, `bottom`, `center`.

`showGrid` is a boolean value which determines if gridlines should be displayed for a scale. Defaults to `true`.

`min` and `max` define the *absolute* minimum and maximum values of the scale.

`suggestedMin` and `suggestedMax` define the *suggested* minimum and maximum values of the scale. If a dataset has values outside the range, the scale will be extended accordingly.

`options` is an optional struct of additional options to apply to the scale, As elsewhere, each option should have as its key the full dotted path of the setting.

Here is an example of scales in use:

```
var barChart = newChart( "bar" )
	.addScale( id="myLabels", axis="x", label="Title for the labels (x) axis" )
	.addScale( id="scale1", axis="y", label="My primary y-axis label" )
	.addScale( id="scale2", axis="y", label="Secondary y-axis label", showGrid=false, position="right", suggestedMin=0, suggestedMax=10 )
	.setLabels( [ ... ] )
	.addDataset( label="Set 1", data=[ ... ], scale="scale1" )
	.addDataset( label="Set 2", data=[ ... ], scale="scale1" )
	.addDataset( label="Set 3", data=[ ... ], scale="scale2", options={ type="line" } );
```

There's a little bit to unpack here.

The first scale defines the x-axis, and all we are doing is setting a label for the axis.

The second scale defines a y-axis, and gives it a title. By default it will display to the left.

The third scale defines an additional y-axis. This scale will display to the right of the chart; will not display gridlines, and will have a *suggested* range of 0 to 10 (but can be extended based on the data).

We are setting the first two datasets to use `scale1`. But the third dataset will use `scale2`, and we are also making use of the `options` to create a mixed chart by setting this dataset to display as a line, even though the chart itself is a bar chart. (The reverse is also possible, plotting a series of data as bars on a line chart.)

## Stacking

Bar charts can be set to display the data as stacked at the chart level, using `chart.setStacked( true )`.

However, you may have more specific stacking requirements. For example, you may have three datasets, two of which should be shown stacked, but the third as standalone.

This can be achieved by adding a `stack` value to each dataset. It doesn't matter what you label the stacks as; but datasets with the same stack ID will be stacked together:

```
var barChart = newChart( "bar" )
	.setStacked( true )
	.setLabels( [ ... ] )
	.addDataset( label="Set 1", data=[ ... ], stack="stack1" )
	.addDataset( label="Set 2", data=[ ... ], stack="stack1" )
	.addDataset( label="Set 3", data=[ ... ], stack="stack2" );
```

## Themes

Colour themes can be defined in `Config.cfc` and used when rendering a chart. A theme is essentially an array of `backgroundColor` values, and a corresponding array of `borderColor` values.

This is the default theme:

```
settings.chartjs.themes.default = {
			  backgroundColor = [
				  "rgba( 255, 99, 132, 0.7 )"
				, "rgba( 54, 162, 235, 0.7 )"
				, "rgba( 255, 206, 86, 0.7 )"
				, "rgba( 75, 192, 192, 0.7 )"
				, "rgba( 153, 102, 255, 0.7 )"
				, "rgba( 255, 159, 64, 0.7 )"
			  ]
			, borderColor     = [
				  "rgba( 255, 99, 132, 1 )"
				, "rgba( 54, 162, 235, 1 )"
				, "rgba( 255, 206, 86, 1 )"
				, "rgba( 75, 192, 192, 1 )"
				, "rgba( 153, 102, 255, 1 )"
				, "rgba( 255, 159, 64, 1 )"
			]
		};
```

The extension comes with a `default` theme, which is used by default by any chart on the frontend of your website. You may either overwrite this with your own defaults, or add another theme of your own.

There is also an `admin` theme, which is used by default by any chart rendered in the admin. Again, you can change this to suit your needs.

There are also some colour themes, each of which contains different lightnesses of the same colour:

`grey`, `red`, `orange`, `yellow`, `green`, `blue`, `purple`, `pink`

You can add as many themes as you like, and choose whichever you want for any individual chart.

## Defaults

Chart.js provides the ability to set defaults for your charts, which will propagate to other settings. These may include font settings which will be picked up by multiple other settings.

The extension provides the ability to set the chart defaults at the start of a page, both by including preset defaults and custom instance-specific settings. This is done by calling the `setChartDefaults()` helper method - this should be done before rendering any charts on a page, and will apply to all charts on the page.

The method takes two arguments (both optional): `config`, which is a string value referring to a predefined set of defaults from `Config.cfc`; and `custom`, a struct containing adhoc settings which can be set within the context of a single page.

```
setChartDefaults(
	  config = "admin"
	, custom = {
		"font.family" = "'Comic Sans'"
	  }
);
```

The example above uses the `admin` defaults provided with the extension, which applies font settings that match those of the Preside admin:

```
settings.chartjs.defaults.admin = {
	  "font.family" = "'Preside Open Sans','Helvetica Neue',Helvetica,Arial,sans-serif"
	, "font.size"   = 14
	, "color"       = "##393939"
}
```

...but also overrides the font family setting for this page (custom defaults passed in take precedence over those contained in predefined sets).

As with chart options, each default should have as its key the full dotted path of the setting.

## Rendering your chart

Once you've configured your chart, there are two ways you can render it to the page.

You can either call the `render()` method on the chart object:

```
renderedChart = myChart.render();
```

or you can use the helper method:

```
#renderChart( myChart )#
```