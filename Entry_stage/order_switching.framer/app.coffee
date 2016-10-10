# Project Info
# This info is presented in a widget when you share.
# http://framerjs.com/docs/#info.info

Framer.Info =
	title: ""
	author: "정상혁"
	twitter: ""
	description: ""


back = new BackgroundLayer
back.backgroundColor='WHITE' #'#50E3C2'

count = 10
height = 220
gutter = 36

scroll = new ScrollComponent
	width: Screen.width
	height: Screen.height
	scrollHorizontal: false

for num in [0...count]
	items = new Layer
		width: Screen.width - (gutter*2)
		height: height
		x: Align.center
		y: gutter+ num * (height+gutter)
		backgroundColor: Utils.randomChoice(['#C8FFD0'])
		hueRotate: num * 15
		shadowY : 1
		shadowBlur : 2
		shadowSpread: 5
		boxShadow : "0 1px 3px rgba(0,0,0,0.2)"
		borderRadius: 10
		parent : scroll.content
	
	items.html = items.listindex + 1
	items.style.color = "#999"
	items.style.lineHeight = height + 6 + "px"
	items.style.paddingLeft = "32px"
	items.style.fontSize = "24px"
	items.style.fontWeight = "400"
	
	items.draggable.enabled = true
	items.draggable.horizontal = false
	items.draggable.speedX=0
	items.draggable.speedY=1


	items.states.add
		stateB:
			scale:1.05
			shadowY: 16
			shadowBlur: 32
			shadowSpread: 15
			shadowColor: "rgba(0,0,0,0.2)"
			
		stateA:
			scale:1
			shadowBlur: 5
			shadowSpread: 5
		

	big_ani = new Animation
		layer: items
		properties: 
			scale:1.05
	small_ani = big_ani.reverse()


	items.on Events.DragStart, ->
# 		big_ani.start()
		this.states.switch('stateB')
	items.on Events.DragEnd, ->
		this.states.switch('original')





