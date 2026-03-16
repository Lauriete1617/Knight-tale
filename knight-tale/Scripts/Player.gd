extends CharacterBody2D

@onready var container: Node2D = $Container
@onready var animação: AnimatedSprite2D = $Container/AnimatedSprite2D
@onready var espada: Area2D = $Container/Espada
@onready var ataque: CollisionShape2D = $Container/Espada/Ataque

var espadaItem = true
var andando = false
var pulando = false
var parado = false
var caindo = false

const velocidade = 300.0
const velocidade_pulo = -400.0
const gravidade = 900


func _physics_process(delta: float) -> void:
	# gravidade
	if not is_on_floor():
		velocity.y += gravidade * delta

	#Pulo.
	if Input.is_action_just_pressed("pulo") and is_on_floor():
		velocity.y = velocidade_pulo
	
	# Pega imput
	var direção := Input.get_axis("esquerda", "direita")
	
	if is_on_floor():
		if direção !=0: #caminha
			velocity.x = direção * velocidade
			container.scale.x = direção
			parado = false
			andando = true
			atualizar_animacão()
		else: #parado
			velocity.x = move_toward(velocity.x, 0, velocidade)
			parado = true
			andando = false
			atualizar_animacão()
	elif not is_on_floor():
		if velocity.y > 0:
			pulando = true
			atualizar_animacão()
		elif velocity.y <0:
			caindo = true
			atualizar_animacão()
	move_and_slide()

func atualizar_animacão():
	if andando:
		if espadaItem == true:
			animação.play("Andando com espada")
		elif espadaItem == false:
			animação.play("Andando sem espada")
		return
	
	if parado:
		if espadaItem == true:
			animação.play("Parado com espada")
		elif espadaItem == false:
			animação.play("Parado sem espada")
		return
	
	if pulando:
		if espadaItem == true:
			animação.play("Pulo com espada")
		return
	
	if caindo:
		if espadaItem == true:
			animação.play("Caindo com espada")
		return
