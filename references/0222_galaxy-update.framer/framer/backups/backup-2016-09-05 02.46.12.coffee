# UP project - Galaxy
# Jungyoung Lee / 2016-02-22

# Defaults
Framer.Defaults.Animation = curve: "spring(400,37,12)"
bg = new BackgroundLayer backgroundColor: "#222933"

# Fit for all screens
wrapper = new Layer
	width: 640, height: 1136
	backgroundColor: ""	
wrapper.originX = 0
wrapper.originY = 0
scaleRatio = wrapper.scale = Screen.width/640

# Vars
navy = "#222933"
skyblue = "#7a8ea7"
red = "#bf3f41"
lv1TextArr = ["Diet", "Adidas", "Animation", "Skate", "Beauty"]
lv2TextArr = ["Startup", "Recipe", "Camp vibe", "Universe"]
lv3TextArr = ["typography", "branding", "appstore", "BMW", "tour", "SNS", "Product", "Palace"]
lvTextArrs = [lv1TextArr, lv2TextArr, lv3TextArr]
lv1Arr = []
lv2Arr = []
lv3Arr = []
lvArrs = [lv1Arr, lv2Arr, lv3Arr]
style1 = {
	"font-size" : "42pt"
	"font-weight" : "900"
	"text-align" : "center"
}
style2 = {
	"font-size" : "26pt"
	"font-weight" : "900"
	"text-align" : "center"
}
style3 = {
	"font-size" : "22pt"
	"font-weight" : "900"
	"text-align" : "center"
}
styleArr = [style1, style2, style3]
ballArr = []
titleArr = ["Keyword", "Friend"]

# Profile
lv1IdArr = ["heejung", "nana", "branden", "vamba", "kinfolk"]
lv2IdArr = ["drake", "satsahc", "tomboy", "vamba", "supreme","vast"]
lv3IdArr = ["hyojoo", "juyon", "brave", "kunani", "karte", "mishu","alex","david"]
lvIdArrs = [lv1IdArr, lv2IdArr, lv3IdArr]
lv1ProfileArr = []
lv2ProfileArr = []
lv3ProfileArr = []
lvProfileArrs = [lv1ProfileArr, lv2ProfileArr, lv3ProfileArr]


# Circle 
galaxy = new Layer	
	width: 640, height: 1136 - 130
	superLayer: wrapper
	backgroundColor: ""

blurBg = new Layer
	width: 960, height: 1280
	x: -100, y: -200
	image: "images/profile_big.jpg"
	opacity: 0.5
	scale: 0.9
	superLayer: galaxy
	
circle1 = new Layer
	width: 780, height: 780
	borderRadius: 390
	backgroundColor: ""
	borderColor: "rgba(255,255,255,0.1)"
	borderWidth: 1
	superLayer: galaxy
circle1.center()

circle2 = new Layer
	width: 540, height: 540
	borderRadius: 270
	backgroundColor: ""
	borderColor: "rgba(255,255,255,0.1)"
	borderWidth: 1
	superLayer: galaxy
circle2.center()
	
circle3 = new Layer
	width: 300, height: 300
	borderRadius: 1150
	backgroundColor: ""
	borderColor: "rgba(255,255,255,0.1)"
	borderWidth: 1
	superLayer: galaxy
circle3.center()
circleArr = [circle3, circle2, circle1]

# Galaxy
for arr, index in lvTextArrs
	for keyword in arr
		myKeyword = new Layer
			width: 1, height: 1
			backgroundColor: ""
			superLayer: galaxy
		myKeywordDot = new Layer
			width: 8, height: 8
			x: -4, y: -4
			borderRadius: 4
			opacity: 0
			backgroundColor:"#fff"		
			superLayer: myKeyword
		myKeywordText = new Layer
			x: -200, y: 0
			width: 400
			opacity: 1 - (index*0.3)
			html: keyword
			backgroundColor: ""
			superLayer: myKeyword
		myKeywordText.style = styleArr[index]
		lvArrs[index].push(myKeyword)

# Planet 
fileNum = 0
for arr, index in lvIdArrs
	for keyword,index2 in arr
		fileNum++
		myProfile = new Layer
			width: 1, height: 1
			backgroundColor: ""
			opacity: 0
			superLayer: galaxy
		myPhoto = new Layer
			width: 90 - index * 20
			height: 90 - index * 20		
			borderRadius: (90 - index*20)/2
			image: "images/profile_#{fileNum}.jpg"
			superLayer: myProfile
		myPhoto.center()
		myId = new Layer
			x: -200, y: (100 -index*20)/2
			width: 400
			opacity: 1 - (index*0.3)
			html: keyword
			backgroundColor: ""
			superLayer: myProfile
		myId.style = {
			"font-size" : "16pt"
			"font-weight" : "700"
			"text-align" : "center"
		}
		myKeywordText.style = styleArr[index]
		lvProfileArrs[index].push(myProfile)

	
# galaxy page
transPage = new PageComponent
	width: 640, height: 1006
	superLayer: wrapper
	scrollVertical: false

pageIndicator = new Layer
	width: 36, height: 12, y: 960
	superLayer: wrapper
	backgroundColor: ""
pageIndicator.centerX()

ball1 = new Layer
	width: 12, height: 12
	borderRadius: 7 
	backgroundColor: "#fff"
	superLayer: pageIndicator
ball2 = new Layer
	width: 12, height: 12, x: 24
	borderRadius: 7 
	opacity: 0.2
	backgroundColor: "#fff"
	superLayer: pageIndicator
ballArr.push(ball1)
ballArr.push(ball2)

	
transPage.on "change:currentPage",->
	nowPage = transPage.horizontalPageIndex(transPage.currentPage)
	pageTitle.html = titleArr[nowPage]
	for ball,index in ballArr
		if 	index is nowPage
			ball.opacity = 1 
		else
			ball.opacity = 0.2
	

for i in [0..1]
	myPage = new Layer
		width: 640,height: 1006
		#html: i
		backgroundColor: ""
		x: i * 640
		superLayer: transPage.content
	
dist = 1
dist2 = 2
transPage.on Events.Move,->
	dist = Utils.modulate(transPage.content.x, [0,-640], [1,0])
	dist2 = dist + 1
	for arr in lvArrs
		for myKeyword,index in arr
			myKeyword.opacity = dist
	for arr in lvProfileArrs
		for myProfile, index in arr
			myProfile.opacity = 1-dist

# Interval 
tempNum = 0
Utils.interval 0.01, ->
	tempNum++
	for arr,index1 in lvArrs
		for myKeyword,index2 in arr
			theta = 2 * Math.PI / arr.length * index2 +  tempNum * (0.001+0.0005*index1)
			myKeyword.x = galaxy.width/2 + circleArr[index1].width/2 * (Math.cos(theta)) * dist
			myKeyword.y = galaxy.height/2 + circleArr[index1].width/2 * (Math.sin(theta)) * dist
	for arr,index1 in lvProfileArrs
		for myKeyword,index2 in arr
			theta = 2 * Math.PI / arr.length * index2 +  tempNum * (0.001+0.0005*index1)
			myKeyword.x = galaxy.width/2 + circleArr[index1].width/2 * (Math.cos(theta)) * dist2
			myKeyword.y = galaxy.height/2 + circleArr[index1].width/2 * (Math.sin(theta)) * dist2

# Show/Hide 
showGalaxy = ->
	for arr in lvArrs	
		for myKeyword,index in arr
			myKeyword.animate
				properties:
					opacity: 1
				delay: 0.1 + index* 0.05
	for circle,index in circleArr
		circle.animate
			properties:
				scale: 1
				opacity: 1

hideGalaxy = ->
	for arr in lvArrs	
		for myKeyword,index in arr
			myKeyword.animate
				properties:
					opacity: 0
				delay: 0.1 + index* 0.05		
	for circle,index in circleArr
		circle.animate
			properties:
				scale: 0
				opacity: 0

showGalaxy()

# Time
myTime = new Layer
	width: 400, height: 60, y: 20
	superLayer: wrapper
	html: "22:38 현재" 
	backgroundColor: ""
	visible: false
myTime.style = {
	"text-align" : "center"
	"font-weight" : "900"
}
myTime.centerX()
pageTitle = new Layer
	width: 180, height: 60, y: 30
	borderRadius: 50
	borderColor: "rgba(255,255,255,0.)"
	borderWidth: 3
	backgroundColor: "rgba(0,0,0,0.4)"
	superLayer: wrapper
	html: titleArr[0]
pageTitle.centerX()
pageTitle.style = {
	"font-size" : "20pt"
	"font-weight" : "900"
	"text-align" : "center"
	"line-height" : "54px"
}

# Screen 
mainPage = new Layer
	width: 640, height: 1136
	y: 1136 - 130
	image: "images/screen.png"
	superLayer: wrapper
			
			
	