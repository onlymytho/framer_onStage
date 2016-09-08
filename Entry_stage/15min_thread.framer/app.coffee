# Project Info
# This info is presented in a widget when you share.
# http://framerjs.com/docs/#info.info

Framer.Info =
	title: "15min_thread"
	author: "Sanghyuk Jung"
	facebook: "facebook.com/onlymytho"
	description: ""


# Set background color
Screen.backgroundColor = "blac"

# Create PageComponent
page = new PageComponent 
	x: Align.center
	y: Align.center	
	height: 1337
	width: 750
	borderRadius: 6
	scrollVertical: false
	scrollHorizontal: false

# Add pages

page_wrapper = new Layer
	parent: page.content
	backgroundColor: "rgba(123,123,123,0)"
	width: 750
	height: 1337
#	x: (page.width+10) * i
	
background = new Layer 
	parent: page_wrapper
#	name: "Background #{i}"
	width: page.width
	height: page.height
	backgroundColor: "#fff"
	borderRadius: 6
	opacity: 1.00
	image: "images/stock-photo-110397823.jpg"
	blur: 10
	
black_layer = new Layer
	parent: page_wrapper
	width: page.width
	height: page.height
	borderRadius: 6
	backgroundColor: "rgba(0,0,0,0.2)"

channel_label = new Layer
	parent: page_wrapper
	x: Align.center
	y: 60
	height: 27
	backgroundColor: "rgba(123,123,123,0)"
channel_label.html = "<div style='font-size: 40px; text-align: center; '>Channel</div>"
time_left = new Layer
	parent: page_wrapper
	x: Align.center
	y: 302
	height: 156
	backgroundColor: "rgba(123,123,123,0)"
	width: 321
	
time_left.html = "<div style='font-size: 120px; text-align: center; font-weight: 300;'>14:36</div>"


thumbnail = new Layer
	parent: page_wrapper
	x: Align.center
	midY: Screen.height/2 - 50	
	borderRadius: 150
	width: 240
	height: 240
	image: "images/stock-photo-110397823.jpg"
	borderWidth: 1
	borderColor: "rgba(255,255,255,0.5)"
	
thumbnail_outborder = new Layer
	parent: page_wrapper	
	x: Align.center
	midY: Screen.height/2 - 50	
	width: 280
	height: 280
	backgroundColor: "rgba(255,255,255,0)"
	borderWidth: 1
	borderColor: "rgba(255,255,255,0.5)"
	borderRadius: 150
	opacity: 0.5
	
thumbnail_splash = new Layer
	parent: page_wrapper	
	x: Align.center
	midY: Screen.height/2 - 50	
	width: 220
	height: 220
	backgroundColor: "rgba(255,255,255,0.1)"
	borderWidth: 1
	borderColor: "rgba(255,255,255,0.5)"
	borderRadius: 150
	opacity: 0.5



thumbnail_splash.states.add
	big :
		scale: 1.5
		opacity: 1
	animationOptions:
		curve: "spring(100, 10, 0)"
		

thumbnail_beat_ani = new Animation
	layer : thumbnail
	properties : 
		scale : 1.1
		curve: "bezier-curve(0.1, 0.01, 0.5, 0.5)"
	looping: true

thumbnail_splash_ani = new Animation
	layer : thumbnail_splash
	properties:
		scale: 3
		backgroundColor: "rgba(255,255,255,0)"
		borderColor: "rgba(255,255,255,0.05)"
	curve: "bezier-curve(0.1, 0.01, 0.5, 0.5)"
	looping: true

thumbnail_beat_ani.start()
thumbnail_splash_ani.start()
		


	




	
topic = new Layer
	parent: page_wrapper
	x: Align.center
	y: thumbnail.maxY + 80
	width: 750
	height: 37
	backgroundColor: "rgba(123,123,123,0)"
	
topic.html = "<div style='font-size: 48px; text-align: center; font-weight: 300;'>Salar de Uyuni</div>"

time_slider = new SliderComponent
	parent: page_wrapper
	y: topic.y + 150
	x: Align.center
	width: 450
	height: 4
	knobSize: 20
	backgroundColor: "rgba(255,255,255,0.25)"
	
time_slider.fill.backgroundColor = "rgba(255,255,255,0.5)"
time_slider.fill.height = 5


	

# comments
# comments = []
# comments_count = 3
# 
# for num in [0...comments_count]
# 	comments[num] = new Layer
# 		height: 65
# 		borderRadius: 6
# 		width: 243
# 		backgroundColor: "rgba(0,0,0,0.5)"
# 	comments[num].style = 
# 		"padding": "5px 10px",
# 		"font-size": "14px",
# 		"line-height" : "18px",
# 		"width" : "{#comments.width}"
# 	comments[num].height = comments[num].html.height
# 	
# 	comments[num].width = comments[num].html.width
# 	
# 	
# 	comments[num].x = Utils.randomNumber(0,Screen.width-150)
# 	comments[num].y = Utils.randomNumber(0,Screen.height-100)
# 
# comments[0].html = "Just few away from the official route enjoying the magnificent Salar of Uyuni #Dakar2017"
# comments[1].html = "take away!"
# comments[2].html = "I gotta go someday!"



# Style current page
page.currentPage.opacity = 1

# Fade in the most centered page
page.onChange "currentPage", ->
	page.previousPage.animate 
		properties:
			opacity: 0.25
		time: 0.5
		
	page.currentPage.animate 
		properties:
			opacity: 1
		time: 0.5


time_slider.knob.on Events.DragStart, ->
	page.scroll = false
	this.animate
		properties: {scale : 2}
		curve: "spring(400, 30, 0)"

time_slider.knob.on Events.DragEnd, ->
	page.scroll = true
	this.animate
		properties: {scale : 1}
		curve: "spring(400, 30, 0)"



