"
<keyClass>
`RSYLabelDecoration` adds a title to the Y-axis in a chart.

*Responsibility*: Add a title and allows for its style to be defined (e.g., color, size, rotation, offset)

*Collaborators*: must be added to an `RSChart`

*Example*:
```Smalltalk
x := -3.14 to: 3.14 by: 0.1.
y := x sin.

p := RSLinePlot new x: x y: y.
p addDecoration: (RSChartTitleDecoration new title: 'hello'; fontSize: 20).
p addDecoration: (RSXLabelDecoration new title: 'My X Axis'; fontSize: 12).
p addDecoration: (RSYLabelDecoration new title: 'My Y Axis'; fontSize: 15; horizontal).
p open
```
"
Class {
	#name : 'RSYLabelDecoration',
	#superclass : 'RSAbstractLabelDecoration',
	#category : 'Roassal-Chart-Decoration',
	#package : 'Roassal-Chart',
	#tag : 'Decoration'
}

{ #category : 'initialization' }
RSYLabelDecoration >> initialize [
	super initialize.
	self vertical.
	self left
]

{ #category : 'accessing' }
RSYLabelDecoration >> left [
	self location
		offset: -5 @ 0;
		left;
		outer;
		middle
]

{ #category : 'accessing' }
RSYLabelDecoration >> right [
	self location
		offset: 5 @ 0;
		right;
		outer;
		middle
]
