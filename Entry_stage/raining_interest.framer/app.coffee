# Project Info
# This info is presented in a widget when you share.
# http://framerjs.com/docs/#info.info

Framer.Info =
	title: ""
	author: "정상혁"
	twitter: ""
	description: ""


Screen.backgroundColor='white'
count = 20


#content----------------------------------
content = new Layer
	midX: Screen.width/2
	midY: Screen.height/2 - 100
	width: 680
	height: 800
	borderRadius: 10
	backgroundColor: 'white'
	shadowY: 15
	shadowBlur: 15
	shadowSpread: 5
	scale:0
	z:3


images = new Layer
	width: content.width
	height: content.height-200
	backgroundColor: Utils.randomColor(0.3)
	superLayer: content

images.image = "images/stock-photo-158101369.jpg"



close_btn = new Layer
	width:60
	height:60
	borderRadius: 50
	maxX: content.width-25
	minY: 25
	backgroundColor: 'black'
	opacity:0.25
	superLayer: content

title = new Layer
body = new Layer


content_hi_animation = new Animation
	layer: content
	properties:
	    scale:1
	curve: "spring(400, 30, 0)"

content_bye_animation = content_hi_animation.reverse()


#items----------------------------------


scroll = new ScrollComponent
	width: Screen.width
	height: Screen.height
	scrollY: 0
	scrollHorizontal: false
	#superLayer: item_wrapper

background = new Layer
	width: Screen.width
	height: Screen.height
	z:1
	backgroundColor: 'white'
	superLayer: scroll.content

item = []
for number in [0...count]
	item[number] = new Layer
		width: 150
		height: 150
		midX: Utils.randomChoice([100, 180, 260, 340, 420, 500, 580, 640])
		borderWidth : 1
		borderRadius : 100
		backgroundColor: Utils.randomColor(0.3)
		z:2
		superLayer: scroll.content
	item[number].on Events.Click, ->
		content_hi_animation.start()

item[0].midY = 1200
for number in [0...(count-1)]
	item[number+1].midY = item[0].midY - ( 200 * (number+1) )


background.on Events.Click, ->
	content_bye_animation.start()

close_btn.on Events.Click, ->
	content_bye_animation.start()

scroll_flow = new Animation
	layer: scroll
	properties: 
		scrollY: 3000

scroll_flow.start()

