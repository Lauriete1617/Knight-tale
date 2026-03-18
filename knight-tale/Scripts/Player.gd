extends CharacterBody2D

@onready var container: Node2D = $Container
@onready var animação: AnimatedSprite2D = $Container/AnimatedSprite2D
@onready var espada: Area2D = $Container/Espada
@onready var ataque: CollisionShape2D = $Container/Espada/Ataque

var espadaItem = true
var sinal = null

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
	move_and_slide()
	
	if is_on_floor():
		if direção !=0: #caminha
			velocity.x = direção * velocidade
			container.scale.x = direção
			atualizar_animacão()
		else: #parado
			velocity.x = move_toward(velocity.x, 0, velocidade)
			atualizar_animacão()
	else:
		if direção !=0: #caminha
			velocity.x = direção * velocidade
			container.scale.x = direção
		atualizar_animacão()
	


func atualizar_animacão():
	if is_on_floor():
		if velocity.x != 0:
			sinal = null
			if espadaItem == true:
				animação.play("Andando com espada")
			elif espadaItem == false:
				animação.play("Andando sem espada")
			return
		
		else:
			if sinal == animação.animation_finished:
				await sinal
			if espadaItem == true:
				animação.play("Parado com espada")
			elif espadaItem == false:
				animação.play("Parado sem espada")
			return
	else:
		if velocity.y < 0:
			if espadaItem == true:
				animação.play("Pulo com espada")
			else:
				animação.play("Pulo sem espada")
			return
		
		if velocity.y > 0 :
			if espadaItem == true:
				animação.play("Caindo com espada")
			else:
				animação.play("Caindo sem espada")
			sinal = animação.animation_finished
			return
