extends CharacterBody2D
@onready var animação: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var espada: CollisionShape2D = $espada

const velocidade = 300.0
const velocidade_pulo = -400.0
const gravidade = 900


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravidade * delta

	# Handle jump.
	if Input.is_action_just_pressed("pulo") and is_on_floor():
		velocity.y = velocidade_pulo

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direção := Input.get_axis("esquerda", "direita")
	if direção !=0:
		velocity.x = direção * velocidade
		animação.play("Caminhando com espada")
		if direção > 0:
			animação.flip_h = false
		elif direção < 0:
			animação.flip_h = true
	else:
		velocity.x = move_toward(velocity.x, 0, velocidade)
		animação.play("Parado com espada")
		

	move_and_slide()
