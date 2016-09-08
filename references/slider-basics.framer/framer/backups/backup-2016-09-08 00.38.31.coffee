# Made with Framer
# by Benjamin den Boer
# www.framerjs.com

bg = new BackgroundLayer backgroundColor: "#28affa"

# Create a new Slider
sliderA = new SliderComponent
	knobSize: 50
	min: 0, max: 100
	value: 50
	height: 8

# Center it
sliderA.center()

# Customize the slider
sliderA.fill.backgroundColor = "#fff"
sliderA.backgroundColor = "rgba(255,255,255,0.3)"
sliderA.knob.style.boxShadow = "0 0 0 1px rgba(0,0,0,0.1)"

# We initially downscale the knob
# This way, the knob never gets blurry
sliderA.knob.scale = 0.8

# Scale to 1 on DragStart
sliderA.knob.on Events.DragStart, ->
	this.animate 
		properties: {scale: 1}
		curve: "spring(400, 30, 0)"
	
# Scale back to its original scale on DragEnd	
sliderA.knob.on Events.DragEnd, ->
	this.animate 
		properties: {scale: 0.8}
		curve: "spring(400, 30, 0)"