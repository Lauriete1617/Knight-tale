extends CharacterBody2D

#Chamando nós que vamos usar no script
@onready var animação: AnimatedSprite2D = $Container/AnimatedSprite2D
@onready var espada: Area2D = $Container/Espada
@onready var ataqueArea: CollisionShape2D = $Container/Espada/Ataque
@onready var container: Node2D = $Container

# Variável de genero
# False = Cavaleiro, True = Cavaleira
var genero = false

# Variáveis pra sinais
var espadaItem = true
var sinal = null
var sinalAtaque = null

# Variáveis pra física
const velocidade = 300.0
const velocidade_pulo = -400.0
const gravidade = 900

# Variáveis de imput
var direção
var ataque

#teste 3

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
	
	ataque = Input.is_action_pressed("Ataque leve")
	if ataque:
		if sinalAtaque: # Sinal para não interromper animação
			return
		atualizar_animacão()
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

# Gerencia as animações pra evitar que entrem em conflito
func atualizar_animacão():
	if ataque:
		var probabilidade = randf()
		sinalAtaque = true
		
		if probabilidade < 0.5:
			if genero == false:
				animação.play("Ataque para baixo")
				print("ataque baixo")
		else:
			if genero == false:
				animação.play("Ataque para cima")
				print("ataque cima")
		
		await animação.animation_finished
		sinalAtaque = false
	
	if is_on_floor() and not sinalAtaque: # Andando
		if velocity.x != 0:
			sinal = null
			if espadaItem == true:
				if genero == false:
					animação.play("Andando com espada")
			elif espadaItem == false:
				if genero == false:
					animação.play("Andando sem espada")
		
		else: # Parado
			if sinal == true:
				await animação.animation_finished
			
			if espadaItem == true:
				if genero == false:
					animação.play("Parado com espada")
			elif espadaItem == false:
				if genero == false:
					animação.play("Parado sem espada")
	
	else: # Pulo e queda
		if velocity.y < 0:
			if espadaItem == true:
				if genero == false:
					animação.play("Pulo com espada")
			if espadaItem == false:
				if genero == false:
					animação.play("Pulo sem espada")
			return
		
		if velocity.y > 0 :
			if espadaItem == true:
				if genero == false:
					animação.play("Caindo com espada")
			else:
				if genero == false:
					animação.play("Caindo sem espada")
			sinal = true
