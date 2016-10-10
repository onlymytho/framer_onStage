# Project Info
# This info is presented in a widget when you share.
# http://framerjs.com/docs/#info.info

Framer.Info =
	title: "Swipe to write a post!"
	author: "정상혁"
	facebook: "facebook.com/onlymytho"
	description: "`Swipe to write a post!`기능을 표현한 프로토타입입니다. 화면을 아래로 Swipe 해보면 결과물을 확인할 수 있습니다."


#Layers---------------------------------
Screen.backgroundColor = 'white'

content = new Layer
	width:750
	height:1337
	backgroundColor: 'white'
	z:2



content_text_to_close = new Layer
	width: 750
	height:30
	backgroundColor: '#a39cd6'
	midY: Screen.height/2+200
	superLayer : content
	scale:0
content_text_to_close.html = "<div style='color: #white; font-size: 52px; text-align:center; vertical-align: middle; line-height:64px'>Touch here to close :) </div>"



direction = new Layer
	width: 750
	height: 200
	backgroundColor: '#white'
	borderWidth: 0
	z:1
direction.y = content.y-direction.height


direction_text = new Layer
	width: 750
	height:30
	backgroundColor: '#white'
	y: 80
	superLayer : direction
direction_text.html = "<div style='color: #444444; font-size: 42px; text-align:center; vertical-align: middle'>Swipe to write a post!</div>"


content.on Events.Move, ->
	direction.y = content.y-direction.height


# Variables
rows = 16
gutter = 10
rowHeight = 200

scroll = new ScrollComponent
	size: Screen.size
	scrollHorizontal: false
	parent: content

# Loop to create row layers
for index in [0...rows]

	cell = new Layer
		width:  Screen.width
		height: rowHeight
		y: index * (rowHeight + gutter)
		parent: scroll.content
		backgroundColor: "#28affa"
		hueRotate: index * 10
content.draggable.enabled = true
content.draggable.vertical = true
content.draggable.horizontal = false
content.draggable.constraints =
	x:0
	y:0


scroll.onScroll ->
	print scroll.scrollY
	if scroll.scrolly<=10
		content.draggable.enabled = true
	else
		content.draggable.enabled = false
	
	
#animations------------------------------







#interactions----------------------------

content.on Events.SwipeDownEnd, ->

content.on Events.Click, ->


