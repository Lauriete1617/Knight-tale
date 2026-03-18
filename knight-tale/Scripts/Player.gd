extends CharacterBody2D

#Chamando nós que vamos usar no script
@onready var animação: AnimatedSprite2D = $Container/AnimatedSprite2D
@onready var espada: Area2D = $Container/Espada
@onready var ataqueArea: CollisionShape2D = $Container/Espada/Ataque
@onready var container: Node2D = $Container

# Variáveis pra sinais
var espadaItem = true
var sinal = null

# Variáveis pra física
const velocidade = 300.0
const velocidade_pulo = -400.0
const gravidade = 900

# Variáveis de imput
var direção
var ataque
# Função que roda o tempo todo da cena, focado na parte física
func _physics_process(delta: float) -> void:
	# gravidade
	if not is_on_floor():
		velocity.y += gravidade * delta

	#Pulo.
	if Input.is_action_just_pressed("pulo") and is_on_floor():
		velocity.y = velocidade_pulo
	
	# Pega imput
	direção = Input.get_axis("esquerda", "direita")
	ataque = Input.is_action_just_pressed("Ataque leve")
	move_and_slide()
	
	if is_on_floor():
		if direção !=0: #caminha
			velocity.x = direção * velocidade
			container.scale.x = direção
			atualizar_animacão()
		else: #parado
			velocity.x = move_toward(velocity.x, 0, velocidade)
			atualizar_animacão()
		if ataque:
			atualizar_animacão()
	else:
		if direção !=0: #caminha
			velocity.x = direção * velocidade
			container.scale.x = direção
		atualizar_animacão()

# Gerencia as animações pra evitar que entrem em conflito
func atualizar_animacão():
	if is_on_floor():
		if velocity.x != 0:
			sinal = null
			if espadaItem == true:
				animação.play("Andando com espada")
			elif espadaItem == false:
				animação.play("Andando sem espada")
			
		
		else:
			if sinal == animação.animation_finished:
				await sinal
			if espadaItem == true:
				animação.play("Parado com espada")
			elif espadaItem == false:
				animação.play("Parado sem espada")
			
		
		if ataque == Input.is_action_just_pressed("Ataque leve"):
			sinal = null
			if randf() > 0.5:
				animação.play("Ataque para baixo")
			else:
				animação.play("Ataque para cima")
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
