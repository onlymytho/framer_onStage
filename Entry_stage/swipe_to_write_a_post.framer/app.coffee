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
	backgroundColor: '#a39cd6'
	z:2


content_text_to_close = new Layer
	width: 750
	height:30
	backgroundColor: '#a39cd6'
	midY: Screen.height/2+200
	superLayer : content
	scale:0
content_text_to_close.html = "<div style='color: #white; font-size: 52px; text-align:center; vertical-align: middle; line-height:64px'>Touch here to close :) </div>"

content.draggable.enabled = true
content.draggable.vertical = true
content.draggable.horizontal = false
content.draggable.constraints =
	x:0
	y:0


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

writing_form = new Layer
	midX: Screen.width/2
	midY: Screen.height/2 - 200
	width: 680
	height: 600
	borderRadius: 10
	backgroundColor: 'white'
	shadowY: 15
	shadowBlur: 15
	shadowSpread: 5
	scale:0
	z:3

content.on Events.Move, ->
	direction.y = content.y-direction.height





#animations----------------------------------
w_form_hi_animation = new Animation
    layer: writing_form
    properties:
        scale:1
    curve: "spring(400, 30, 0)"

w_form_bye_animation = w_form_hi_animation.reverse()




w_form_close_text_hi_animation = new Animation
	layer: content_text_to_close
	properties:
		scale:1
	curve: "spring(400, 30, 0)"

w_form_close_text_bye_animation  = w_form_close_text_hi_animation.reverse()







#interactions--------------------------------

content.on Events.SwipeDownEnd, ->
	w_form_hi_animation.start()
	w_form_close_text_hi_animation.start()

content.on Events.Click, ->
	w_form_bye_animation.start()
	w_form_close_text_bye_animation.start()

