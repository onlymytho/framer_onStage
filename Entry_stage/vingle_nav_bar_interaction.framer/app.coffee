# Project Info
# This info is presented in a widget when you share.
# http://framerjs.com/docs/#info.info

Framer.Info =
	title: "vingle_nav_bar_interaction"
	author: "정상혁"
	facebook: "facebook.com/onlymytho"
	description: "Vingle 3.0의 nav_bar 구조에 대한 interaction 프로토타입입니다. 현재 피드 중간에 하얀색 피드가 끼어있는 문제, Scrollable_Tab_Bar를 가운데에 포커싱 하는게 Device.midX = Screen.width/2의 방식이 아니라 대략 가운데로 보이는 위치를 지정한 형식으로 되어있어서 이 부분에 대한 개선이 이루어져야 합니다."


Screen.backgroundColor = 'white'
count = 10

tnav = new Layer
	width: 750
	height: 150
	backgroundColor: '#addbad'

hscbar = new ScrollComponent
	width: Screen.width
	height:110
	y: tnav.height
	scrollVertical: false
	originX: 0
	originY: tnav.height
	backgroundColor: '#ddbbaa'

hscbar_item = []
for number in [0...count]
	hscbar_item[number] = new Layer
		width:180
		height:hscbar.height
		x:180*number
		backgroundColor: 'white'
		superLayer:hscbar.content


#main_nav feed들 부분의 PageComponent
main_nav = new PageComponent
	width: Screen.width
	height: 1500
	y: hscbar.maxY
	scrollVertical: false
	backgroundColor: null

main_nav_items = []
for number in [0...count]
	main_nav_items[number] = new Layer
		width: Screen.width
		height: 1500
		x: Screen.width * number
		y: hscbar.maxY
		superLayer: main_nav.content
		backgroundColor: Utils.randomColor(0.3)
	main_nav_items[number].html = number
	main_nav_items[number].style =
		"color" : "#444444"
		"font-size" : "100px",
		"font-weight" : "100",
		"text-align" : "center",
		"line-height" : "#{main_nav.height}px"
 
for number in [0...(count-1)]
	main_nav.addPage(main_nav_items[number+1], "right")
	main_nav.snapToNextPage()

main_nav.snapToPage main_nav_items[0], false



hscbar_item[main_nav.horizontalPageIndex(main_nav.currentPage)].backgroundColor = Utils.randomColor(0.3)


main_nav.on "change:currentPage", ->
	hscbar_item[main_nav.horizontalPageIndex(main_nav.currentPage)].backgroundColor = Utils.randomColor(0.3)
	hscbar.scrollToLayer(
    hscbar_item[main_nav.horizontalPageIndex(main_nav.previousPage)]
    0.83
    true
    time: 0.2
)
 main_nav.horizontalPageIndex(main_nav.currentPage)

	hscbar_item[main_nav.horizontalPageIndex(main_nav.previousPage)].backgroundColor = 'white'
	

 
