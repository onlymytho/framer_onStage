# Project Info
# This info is presented in a widget when you share.
# http://framerjs.com/docs/#info.info

Framer.Info =
	title: "drag_arrow_rotate"
	author: "정상혁"
	facebook: "facebook.com/onlymytho"
	description: "FramerJS Korea 페이스북 그룹에 올라온 이정익님의 결과물을 답습해 본 결과입니다. 화면에 있는 원을 마우스로 움직여보면 어떤 결과물인지 알 수 있습니다."


row = 11
column = 21
arr = []
vx = 7
vy = 8

for i in [0...row * column]
	layer = new Layer
	layer.width = 50
	layer.height = 5
	layer.x = ( i % row ) * ( layer.width + 20 )
	layer.y = Math.floor( i / row ) * ( layer.height + 60 )
	layer.backgroundColor = Utils.randomColor(1)
	arr.push( layer )

circle = new Layer
circle.borderRadius = '50%'
circle.backgroundColor = 'white'
circle.opacity = 0.2
circle.draggable.enabled = true
circle.draggable.constraints =
	x:0
	y:0
	width: Screen.width
	height: Screen.height
circle.on Events.Move, ->
# 선들이 가리키는 지점을 원의 중심으로 하기 위해서 circleX, circleY라는 원의 중심을 가리키는 좌표 변수를 생성. 여기에 원의 중심에 해당하는 값을 원이 움직일 때마다 조정되도록 대입해놓음.
	circleY = circle.y + circle.height / 2
	circleX = circle.x + circle.width / 2
	for i in [0...arr.length]
		mStartAngle = Math.atan2( circleY - ( arr[i].y + arr[i].height / 2 ), circleX - ( arr[i].x + arr[i].width / 2 )) * 180 / Math.PI
		arr[i].rotation = mStartAngle







