Class {
	#name : #RSViolinPlotShape,
	#superclass : #RSComposite,
	#instVars : [
		'boxPlotShape',
		'kernelDensity',
		'densityArea',
		'color',
		'bandOffset',
		'bandWidth',
		'dataScale',
		'bandScale'
	],
	#category : #'Roassal3-Chart-Plots'
}

{ #category : #accessing }
RSViolinPlotShape class >> data: collectionOfData1D [
	| violinShape |
	violinShape := self new.
	violinShape data: collectionOfData1D.
	^ violinShape
]

{ #category : #initialization }
RSViolinPlotShape >> addChildrenToComposite [
	| shapes |
	shapes := self shapesToRender.
	shapes do: [ :aShape |
		aShape isCollection ifTrue: [ self addAll: aShape ]
		ifFalse: [ self add: aShape ].
	].
	self adjustToChildren.
	^ self.
]

{ #category : #accessing }
RSViolinPlotShape >> bandOffset: aNumber [
	bandOffset := aNumber.
	boxPlotShape bandOffset: bandOffset.
]

{ #category : #initialization }
RSViolinPlotShape >> bandScale: aNSScale [
	bandScale := aNSScale.
]

{ #category : #accessing }
RSViolinPlotShape >> bandWidth: aNumber [
	bandWidth := aNumber.
	boxPlotShape bandWidth: bandWidth*0.1.
	boxPlotShape outlierSize: bandWidth*0.05.
]

{ #category : #accessing }
RSViolinPlotShape >> border [
	^ densityArea border.
]

{ #category : #styling }
RSViolinPlotShape >> borderColor: aColor [
	^ self border color: aColor.
]

{ #category : #initialization }
RSViolinPlotShape >> color [
	^ color
]

{ #category : #initialization }
RSViolinPlotShape >> color: aColor [
	color := aColor
]

{ #category : #accessing }
RSViolinPlotShape >> data [
	^ kernelDensity data.
]

{ #category : #accessing }
RSViolinPlotShape >> data: dataset [
	| aCollection |
	aCollection := dataset rsValue: model.
	kernelDensity data: aCollection.
	boxPlotShape data: aCollection.
]

{ #category : #initialization }
RSViolinPlotShape >> dataScale: aNSScale [
	dataScale := aNSScale
]

{ #category : #accessing }
RSViolinPlotShape >> dataSorted [
	^ boxPlotShape data.
]

{ #category : #defaults }
RSViolinPlotShape >> defaultBoxPlotShape [
	^ RSBoxPlotShape new.
]

{ #category : #defaults }
RSViolinPlotShape >> defaultDensityArea [
	^ RSPolygon new
		noPaint
		borderColor: Color black.
]

{ #category : #defaults }
RSViolinPlotShape >> defaultKernelDensity [
	"Check the default Kernel function in RSKernelDensity >> defaultKernel (by default a gaussian function)"
	^ RSKernelDensity new.
]

{ #category : #initialization }
RSViolinPlotShape >> densityArea [
	| densityCurve densityAreaPoints maxX minX |
	
	"invert x and y"
	densityCurve := (kernelDensity densityCurve) collect: [:point | 
		(point y @ point x)
	].

	"normalize x"
	maxX := (densityCurve collect: [ :point | point x ]) max.
	minX := (densityCurve collect: [ :point | point x ]) min.
	densityCurve := densityCurve collect: [:point | 
		| normalizedX |
		normalizedX := ((point x)-minX)/(maxX - minX).
		((normalizedX) @ point y)
	].
	
	
	densityAreaPoints := densityCurve copy.
	densityAreaPoints := densityAreaPoints collect: [ :point |
		((bandWidth/2 * point x)+bandOffset)@(dataScale scale: point y)
	 ].
	densityCurve reversed do: [ :point | 
		densityAreaPoints add: (bandOffset-(bandWidth/2 * point x))@(dataScale scale: point y)
		"((point x * -1) @ point y) "
	].
	
	
	densityArea points: densityAreaPoints.
	densityArea color: color.
	^ densityArea
]

{ #category : #initialization }
RSViolinPlotShape >> initialize [
	super initialize.
	kernelDensity := self defaultKernelDensity.
	boxPlotShape := self defaultBoxPlotShape.
	densityArea := self defaultDensityArea.
]

{ #category : #defaults }
RSViolinPlotShape >> kernelBandwidth: aNumber [
	kernelDensity bandwidth: aNumber.
]

{ #category : #initialization }
RSViolinPlotShape >> maxYValue [
	| maxYValueOfCurve |
	maxYValueOfCurve := (kernelDensity densityCurve collect: [ :point | point x ]) max.
	^ boxPlotShape maxYValue max: maxYValueOfCurve.
]

{ #category : #initialization }
RSViolinPlotShape >> minYValue [
	| minYValueOfCurve |
	minYValueOfCurve := (kernelDensity densityCurve collect: [ :point | point x ]) min.
	^ boxPlotShape minYValue min: minYValueOfCurve.
]

{ #category : #'accessing - attributes' }
RSViolinPlotShape >> model: aModel [
	super model: aModel.
	boxPlotShape model: aModel.
]

{ #category : #initialization }
RSViolinPlotShape >> outlierSize: aDimensionInPixels [
	boxPlotShape outlierSize: aDimensionInPixels.
]

{ #category : #initialization }
RSViolinPlotShape >> renderIn: canvas [
	self addChildrenToComposite.
	canvas add: self.
	boxPlotShape color: Color white.
	boxPlotShape addChildrenToComposite.
	canvas add: boxPlotShape.
	^ canvas.
]

{ #category : #initialization }
RSViolinPlotShape >> scalePoint: aPoint [
	^ (bandScale scale: aPoint x) @ (dataScale scale: aPoint y)
]

{ #category : #initialization }
RSViolinPlotShape >> scales: collectionOfNSScales [
	self bandScale: collectionOfNSScales first.
	self dataScale: collectionOfNSScales second.
	boxPlotShape bandScale: collectionOfNSScales first.
	boxPlotShape dataScale: collectionOfNSScales second.
]

{ #category : #initialization }
RSViolinPlotShape >> shapesToRender [
	densityArea := self densityArea.
	^ { densityArea. }.
]