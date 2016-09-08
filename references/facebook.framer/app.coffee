# Import file "facebook"
psd = Framer.Importer.load("imported/facebook@1x")

Utils.globalLayers( psd )
main.originX = 0 
main.originY = 0 
main.scale = Screen.width / main_stage.width

scroll = new ScrollComponent
scroll.width = Screen.width
scroll.height = Screen.height
scroll.superLayer = main
scroll.scrollHorizontal = false
scroll.placeBehind bottom_bar
scroll.backgroundColor = "#d5d6db"
container.superLayer = scroll.content

tag.yPos = tag.y
gnb.yPos = gnb.y

movie_mc.isSel = false

movie = new VideoLayer
	width: 640 * 1.15
	height: 360 * 1.15
	video: "images/0.mp4"
movie.backgroundColor = null
movie.superLayer = movie_mc
movie_mc.clip = true

scroll.on Events.Move, ->
	if scroll.scrollY > 0 
		tag.y = tag.yPos - scroll.scrollY
		if scroll.scrollY > 128
			gnb.y = gnb.yPos - ( scroll.scrollY ) + 128
			gnb_search.opacity = Utils.modulate( scroll.scrollY, [129,189],[1,0],true)
		else
			gnb.y = gnb.yPos
	else
		tag.y = tag.yPos
	if movie_mc.screenFrame.y < Screen.height - ( movie_mc.height * 1.5)
		if !movie_mc.isSel
			movie_mc.isSel = true
			movie.player.play()
	else
		if movie_mc.isSel
			movie_mc.isSel = false
			movie.player.pause()


Events.wrap(movie.player).on "timeupdate", ->
	if movie.player.currentTime is movie.player.duration
		movie.player.fastSeek(0)
