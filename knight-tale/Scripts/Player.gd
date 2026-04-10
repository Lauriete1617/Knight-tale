extends CharacterBody2D

#Chamando nós que vamos usar no script
@onready var corpo: AnimatedSprite2D = $Container/Corpo
@onready var items: AnimatedSprite2D = $Container/Items
@onready var espada: Area2D = $Container/Espada
@onready var ataqueArea: CollisionShape2D = $Container/Espada/Ataque
@onready var container: Node2D = $Container

# Variável de genero
# False = Cavaleiro, True = Cavaleira
var genero = false

#Variável items
var iventario = ["none", "espada", "escudo", "chá"]

# Variáveis pra sinais
var sinal = null
var sinalAtaque = null

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
	iventario[1]
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
				corpo.play("Ataque para baixo")
		else:
			if genero == false:
				corpo.play("Ataque para cima")
		await corpo.animation_finished
		sinalAtaque = false
	
	if is_on_floor() and not sinalAtaque: ## Andando
		if velocity.x != 0:
			sinal = null
			if genero == false:
				corpo.play("Andando")
				if  iventario == "espada":
					items.play("Espada - andando")
					items.frame = corpo.frame
		
		else: ## Parado
			if sinal == true:
				await corpo.animation_finished
			
			if genero == false:
				corpo.play("Parado")
				if iventario == "espada":
					items.play("Espada - parado")
					items.frame = corpo.frame
	
	else: ## Pulo e queda
		items.play("default")
		if velocity.y < 0:
			if genero == false:
				corpo.play("Pulo com espada")
			if genero == false:
				corpo.play("Pulo sem espada")
			return
		
		if velocity.y > 0 :
			if iventario:
				if genero == false:
					corpo.play("Caindo com espada")
			else:
				if genero == false:
					corpo.play("Caindo sem espada")
			sinal = true
