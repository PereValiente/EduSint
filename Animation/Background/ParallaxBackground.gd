extends ParallaxBackground

@export var scrolling_speed = 20


#Temporizador inicio escena
func _ready():
	await get_tree().create_timer(2).timeout


#Movimietno fondo, tras empezar el juego
func _process(delta):
	scroll_offset.x -=  scrolling_speed * delta
	
