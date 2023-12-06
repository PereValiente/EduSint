extends ParallaxBackground

@export var scrolling_speed = 20

func _ready():
	await get_tree().create_timer(2).timeout

func _process(delta):
	scroll_offset.x -=  scrolling_speed * delta
	
