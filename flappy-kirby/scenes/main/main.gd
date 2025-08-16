extends Node2D

@onready var bird: CharacterBody2D = $bird
var game_running : bool
var game_over : bool
const scroll_speed : int = 4
var screen_size : Vector2
var ground_height : int
var scroll : int
@onready var ground: Area2D = $ground
@export var pipes_scene : PackedScene
var pipes : Array
const pipe_delay = 100
const pipe_range = 150
@onready var timer: Timer = $Timer
var score = 0
@onready var score_label: Label = $score

func _ready() -> void:
	screen_size = get_window().size
	ground_height = 168
	new_game()
	
func new_game():
		game_running = false
		game_over = false
		timer.start()

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	check_game_state()
	if game_running:
		score_label.text = 'Pontos : ' + str(score)
		scroll += scroll_speed            
		if scroll >= screen_size.x:
			scroll = 0
		ground.position.x = -scroll
		for pipe in pipes:
			pipe.position.x -= scroll_speed 
		
func check_game_state():
	if game_over == false:
		if Input.is_action_just_pressed("flap"):
			if(game_running == false):
				start_game()
				
func start_game():
	game_running = true
	bird.flying = true
	bird.flap()


func _on_timer_timeout() -> void:
	generate_pipes()
	
func generate_pipes():
	var pipes_i = pipes_scene.instantiate()
	pipes_i.position.x = screen_size.x + pipe_delay
	pipes_i.position.y = (screen_size.y - ground_height ) / 2 + randi_range(-pipe_range, pipe_range)
	pipes_i.hit.connect(bird_hit)
	pipes_i.score.connect(count_score)
	add_child(pipes_i)
	pipes.append(pipes_i)

func count_score():
	score += 1

func bird_hit():
	stop_game()
	bird.falling = true
	
func stop_game():
	timer.stop()
	game_over = true
	game_running = false
	bird.flying = false
	

func _on_ground_hit() -> void:
	print ('chama')
	stop_game()
	bird.falling = false
