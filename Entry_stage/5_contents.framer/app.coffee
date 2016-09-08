# Project Info
# This info is presented in a widget when you share.
# http://framerjs.com/docs/#info.info

Framer.Info =
	title: ""
	author: "정상혁"
	twitter: ""
	description: ""



layerA = new Layer
	x: 180
	y: 497
	borderRadius: 100
	image: "images/04048_quietsunset_2560x1600.jpg"
	width: 180
	height: 180
	borderWidth: 5
	borderColor: "rgba(255,255,255,0.5)"

layerB = new Layer
	x: 432
	y: 497
	borderRadius: 100
	image: "images/stock-photo-73897943.jpg"
	width: 180
	height: 180
	borderWidth: 5
	borderColor: "rgba(255,255,255,0.5)"

layerC = new Layer
	x: 91
	y: 721
	borderRadius: 100
	image: "images/stock-photo-115449731.jpg"
	width: 180
	height: 180
	borderWidth: 5
	borderColor: "rgba(255,255,255,0.5)"

layerD = new Layer
	x: 302
	y: 721
	borderRadius: 100
	image: "images/stock-photo-158110163.jpg"
	width: 180
	height: 180
	borderWidth: 5
	borderColor: "rgba(255,255,255,0.5)"

layerE = new Layer
	x: 522
	y: 721
	borderRadius: 100
	image: "images/stock-photo-110851015.jpg"
	width: 180
	height: 180
	borderWidth: 5
	borderColor: "rgba(255,255,255,0.5)"

layerF = new Layer
	x: 143
	y: 410
	width: 499
	height: 90
	backgroundColor: "rgba(123,123,123,0)"
layerF.html = "<span style='text-align: center; font-size: 42px;'> 관심있는 이야기를 골라보세요"


content = new Layer
		y: 790
		width: 660
		x: 45
		height: 740
		borderRadius: 10
		backgroundColor: 'white'
		scale: 0


content.states.add
	stateA:
		scale: 1.00


content_pop = new Animation
	
#layerF.on Events.click, ->

	


