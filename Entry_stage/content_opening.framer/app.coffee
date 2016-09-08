# Project Info
# This info is presented in a widget when you share.
# http://framerjs.com/docs/#info.info

Framer.Info =
	title: ""
	author: "정상혁"
	twitter: ""
	description: ""


count = 5
Screen.backgroundColor = "black" #"#2DD7AA"

scroll = new ScrollComponent
	width: Screen.width
	height: Screen.height
	x: Align.center
	y: Align.center
	scrollHorizontal: false

scroll.contentInset = 
	top: 50
	bottom: 50

content_wrapper = new Layer
	parent: scroll.content
	opacity: 1.00
	backgroundColor: "rgba(0,0,0,0.5)"

content = []
image = []

for num in [0...count]
	content[num] = new Layer
		parent: content_wrapper
		name: "content_#{num}"
		y: 790*num
		width: 660
		x: 45
		height: 740
		borderRadius: 10
		backgroundColor: 'white'
	
	content[count] = content_wrapper.height

	image[num] = new Layer
		width: 660
		height: 545
		borderRadius: 10
		image: "images/stock-photo-108182811.jpg"
		parent: content[num]

	image_mask = new Layer
		y: 535
		width: 660
		backgroundColor: "rgba(255,255,255,1)"
		height: 10
		parent: content[num]
		opacity: 1.00

	image[num].states.add
		stateA:
			x: -45
			y: -45	
			width: 750
			height: 622

	image[num].states.animationOptions = curve: "spring(100, 10, 0)"

	content[num].on Events.Click, ->
		image[num].states.switch('stateA')









