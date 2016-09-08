# data load
{data} = require "data"

# setup main width, height
screenW = 750
screenH = 1334

# main container
main = new Layer
main.width = screenW
main.height = screenH
main.originX = 0 
main.originY = 0 
main.scale = Screen.width / screenW
main.backgroundColor = null

# bg 
bg = new BackgroundLayer()
bg.backgroundColor = "#e3e3e3"

# variable
cnt = 0
lastYPosition = 0
oneItems = []
twoItems = []
threeItems = []
rectItems = []
imgSrc = []
imageItems = []
profileImageItems = []
selectedDim = null
selectedMovie = null
frame = null
startYPosition = null
stageStatus = "default"
cubic = "cubic-bezier(0.645, 0.045, 0.355, 1)"
cubicOut = "cubic-bezier(0.215, 0.61, 0.355, 1)"

# scroll 
scroll = new ScrollComponent()
scroll.width = screenW
scroll.height = screenH
scroll.scrollHorizontal = false
scroll.superLayer = main
scroll.contentInset = 
	right: 100

# progrss bar
progressText = new Layer
progressText.html = cnt + " "+"/" + " "+ 0
progressText.style = 
	"fontSize" : "20px"
	"textAlign" : "center"
	"padding-top" : "30px"
	"font-weight" : "light"
progressText.backgroundColor = null
progressText.opacity = 0 
progressDimed = new Layer
progressDimed.width = 300
progressDimed.height = 300
progressDimed.opacity = 0 
progressDimed.backgroundColor = "black"

# make rect
for i in [0...data.length]
	rect = new Layer
	rect.width = data[i].width
	rect.idx = i 
	rect.height = data[i].height + 28 + data[i].titleH
	rectItems.push( rect )
	# title layer
	title = new Layer
	title.image = "images/imgs/title/" + i + ".png"
	title.name = "title_" + i 
	title.superLayer = rect
	title.width = data[i].titleW
	title.height = data[i].titleH
	title.x = 15
	title.y = data[i].height + 28
	# bg layer
	bgLayer = new Layer
	bgLayer.width = rect.width
	bgLayer.height = data[i].height
	bgLayer.image = data[i].image
	bgLayer.superLayer = rect
	bgLayer.name = "bgLayer_" + i 
	bgLayer.shadowX = bgLayer.shadowY = 6
	bgLayer.shadowBlur = 8
	bgLayer.shadowColor = "rgba(0,0,0,0.1)"
	
	# image mask layer
	frameLayer = new ScrollComponent
	frameLayer.scrollVertical = false
	frameLayer.scrollHorizontal = false
	frameLayer.superLayer = rect
	frameLayer.x = data[i].frameX
	frameLayer.y = data[i].frameY
	frameLayer.width = data[i].frameW
	frameLayer.height = data[i].frameH
	frameLayer.backgroundColor = null
	frameLayer.name = "frameLayer_" + i 
	# image layer
	img = new Layer
	img.superLayer = frameLayer.content
	img.width = 750
	img.height = 600
	img.image = data[i].thumb
	img.x =  data[i].imgX
	img.y =  data[i].imgY
	img.scale =  data[i].imgS
	profileImageItems.push( img )	
		
	rect.x = data[i].xPosition
	rect.y = data[i].yPosition
	rect.superLayer = scroll.content	
	rect.backgroundColor = null
	# separate layer 
	if data[i].menu is "one"
		oneItems.push( rect )
		rect.sendToBack()
	else if data[i].menu is "two"
		twoItems.push( rect )
	else
		threeItems.push( rect )
	# rect click event
	rect.on Events.Click, ->
		if stageStatus is "default" 
			if !scroll.isDragging
				stageStatus = "loading"
				startYPosition = scroll.scrollY
				scroll.scroll = false
				selectedMovie = this
				selectedMovie.xPos = selectedMovie.x
				selectedMovie.yPos = selectedMovie.y
				bar.image = data[selectedMovie.idx].bar
				for i in [0...rectItems.length]
					if i != selectedMovie.idx
						rectItems[i].animate
							properties:
								opacity: 0
							time: 0.1
						curve: cubicOut
				selectedMovie.subLayersByName( "title_" + selectedMovie.idx )[0].animate
					properties: 
						opacity: 0
					time: 0.1
					curve: cubic
				progressDimed.width = selectedMovie.subLayersByName( "bgLayer_" + selectedMovie.idx )[0].width
				progressDimed.height = selectedMovie.subLayersByName( "bgLayer_" + selectedMovie.idx )[0].height
				progressDimed.superLayer = selectedMovie
				progressDimed.animate
					properties: 
						opacity: 0.3
					time: 0.1
				progressText.superLayer = selectedMovie
				progressText.center()
				progressText.y = progressText.y - 28
				progressText.html = cnt + " "+"/" + " "+ data[selectedMovie.idx].imgNum
				progressText.animate
					properties: 
						opacity: 1
					time: 0.1
					curve: cubicOut
				for i in [0...data[this.idx].imgNum]
					l = new Image()
					l.src = "images/imgs/" + this.idx + "/img_" + i + ".png"
					imgSrc.push( l.src )
					l.onload = -> 
						cnt +=1 
						progressText.html = cnt + " "+"/" + " "+ data[selectedMovie.idx].imgNum
						if cnt is ( data[selectedMovie.idx].imgNum - 1 )
							progressText.animate
								properties: 
									opacity: 0
								time: 0.1
								curve: cubicOut	
							progressDimed.animate
								properties: 
									opacity: 0
								time: 0.1
								curve: cubicOut	
							imageItems = []
							frame = selectedMovie.subLayersByName( "frameLayer_" + selectedMovie.idx )[0]
							for i in [0..cnt]
								layer = new Layer
								layer.width = screenW
								layer.height = 600
								layer.y = 620 * ( i + 1 )
								layer.image = imgSrc[i]
								layer.opacity = 0 
								layer.animate
									properties: 
										opacity: 1
									time: 0.6
									delay: 0.6 + 0.2 * i 
									curve: cubic
								imageItems.push( layer )
							scroll.animate
								properties: 
									backgroundColor: "white"
								delay: 0.2
								time: 0.5	
								curve: cubic
							isSel = true
							if Utils.isMobile()
								selectedMovie.bringToFront()
							else
								Utils.delay 0.2, ->
									selectedMovie.bringToFront()
							selectedMovie.width = screenW
							selectedMovie.height = screenH
							selectedMovie.animate
								properties: 
									x: selectedMovie.x - selectedMovie.screenFrame.x
									y: selectedMovie.y - selectedMovie.screenFrame.y
								curve: cubic
								delay: 0.2
								time: 0.5
							selectedMovie.subLayersByName( "bgLayer_" + selectedMovie.idx )[0].animate
								properties: 
									opacity: 0
									shadowX: 0
									shadowY: 0 
									shadowBlur: 0 
								time: 0.2
								curve: cubic
							frame.animate
								properties: 
									width: screenW
									height: screenH
									x: 0
									y: 0
								delay: 0.2
								time: 0.5
								curve: cubic
							frame.once Events.AnimationEnd, ->
								frame.scrollVertical = true
								for i in [0...imageItems.length]
									imageItems[i].superLayer = frame.content
							profileImageItems[ selectedMovie.idx ].animate
								properties: 
									scale:1
									x: 0
									y: 0 
								delay: 0.2
								time: 0.5
								curve: cubic
							bar.animate
								properties: 
									y: 0 
								delay: 0.6
								time: 0.4
								curve: cubic
							bar.once Events.AnimationEnd, ->
								stageStatus = "view"

				
					
# scroll drag start
scroll.on Events.DragStart, ->
	 lastYPosition = scroll.scrollY
	 
	 
# scroll move event	
scroll.on Events.Move, ->
	delta = lastYPosition - scroll.scrollY
	lastYPosition = scroll.scrollY
	for i in [0...twoItems.length ]
		twoItems[i].y += delta * 0.5
	for i in [0...threeItems.length ]
		threeItems[i].y += delta * 0.3

# top-bar click event
bar = new Layer
bar.width = screenW
bar.height = 106
bar.superLayer = main
bar.y = -bar.height
bar.on Events.Click, ->
	if stageStatus is "view" 
		if !frame.isDragging
			scroll.scrollY = startYPosition
			scroll.animate
				properties: 
					backgroundColor: "#e3e3e3"
				time: 0.2	
				curve: cubic
			frame.scroll = false
			frames.scrollY = 0 
			selectedMovie.removeSubLayer( progressText )
			selectedMovie.removeSubLayer( progressDimed )
			for i in [0...imageItems.length]
				imageItems[i].animate
					properties:
						opacity: 0
					time: 0.1
					curve: cubicOut
				imageItems[i].once Events.AnimationEnd, ->
					this.superLayer.removeSubLayer( this )
					this.destroy()
			frame.animate
				properties:
					scrollY: 0
				time: 0.1
				curve: cubicOut
			selectedMovie.animate
				properties: 
					x: selectedMovie.xPos
					y: selectedMovie.yPos
				curve: cubic
				time: 0.5
			selectedMovie.subLayersByName( "bgLayer_" + selectedMovie.idx )[0].animate
				properties: 
					opacity: 1
					shadowX: 6
					shadowY: 6 
					shadowBlur: 8 
				time: 0.5
				curve: cubic
			profileImageItems[selectedMovie.idx].animate
				properties: 
					scale: data[selectedMovie.idx].imgS
					x: data[selectedMovie.idx].imgX
					y: data[selectedMovie.idx].imgY
				time: 0.5
				curve: cubic
			frame.animate
				properties: 
					width: data[selectedMovie.idx].frameW
					height: data[selectedMovie.idx].frameH
					x: data[selectedMovie.idx].frameX
					y: data[selectedMovie.idx].frameY
				time: 0.5
				curve: cubic
			bar.animate
				properties: 
					y: -bar.height
				time: 0.2
				curve: cubic
			for i in [0...rectItems.length]
				if data[i].menu is "one"
					rectItems[i].sendToBack()
				if i != selectedMovie.idx
					rectItems[i].animate
						properties:
							opacity: 1
						delay: 0.5
						time: 0.3
					curve: cubic
			selectedMovie.subLayersByName( "title_" + selectedMovie.idx )[0].animate
					properties: 
						opacity: 1
					time: 0.3
					delay: 0.5
					curve: cubic
			Utils.delay 0.8, ->
				selectedMovie.width = data[selectedMovie.idx].width
				selectedMovie.height = data[selectedMovie.idx].height + 71
				stageStatus = "default"
				scroll.scrollVertical = true
				cnt = 0 
				imgSrc = []
				imageItems = []
				
