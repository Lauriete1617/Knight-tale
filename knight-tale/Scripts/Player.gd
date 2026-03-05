extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D


const gravidade = 300
const velocidade_pulo = -300
const velocidade = 300.0
var direção =0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Imput de pulo
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pulo") and is_on_floor():
		velocity.y = velocidade_pulo

func _physics_process(delta: float) -> void:
	#Sistema de receber input do teclado = input andar pros lados
	var input_teclado = Input.get_axis("esquerda", "direita")
	
	#sistema de anda
	if input_teclado != 0: 
		direção = input_teclado
	#//

	#processo velocidade*gravidade
	if direção:
		velocity.x = direção * velocidade
	
	if not is_on_floor():
		velocity.y += delta*gravidade
	
	move_and_slide()
