extends CharacterBody2D

#Chamando nós que vamos usar no script
@onready var corpo: AnimatedSprite2D = $Container/Corpo
@onready var items: AnimatedSprite2D = $Container/Items
@onready var areaAtaque: Area2D = $Container/Espada
@onready var ataqueArea: CollisionShape2D = $Container/Espada/Ataque
@onready var container: Node2D = $Container

# Variável de genero
# False = Cavaleiro, True = Cavaleira
var genero = false

#Variável items
var iventario = ["Vazio", "Espada", "Escudo", "Chá"]

# Variáveis pra sinais
var queda = null
var sinalAtaque = null

# Variáveis pra física
const velocidade = 300.0
const velocidade_pulo = -400.0
const gravidade = 900

# Variáveis de imput
var direção
var ataque

var naMão = iventario[1];

#estados
var andando
var parado
var pulando
var caindo

# Função que roda o tempo todo da cena, focado na parte física
func _physics_process(delta: float) -> void:
	# Sincronização de frames de animações
	items.frame = corpo.frame

	# Pega imput
	direção = Input.get_axis("esquerda", "direita")
	if Input.is_action_just_pressed("pulo") and is_on_floor():
		velocity.y = velocidade_pulo
	ataque = Input.is_action_pressed("Ataque leve")
	
	if ataque:
		if sinalAtaque: # queda para não interromper animação
			return
	move_and_slide()
	
	if is_on_floor():
		pulando = false
		caindo = false
		if direção !=0: #caminha
			parado = false
			andando = true
			velocity.x = direção * velocidade
			container.scale.x = direção
		else: #parado
			andando = false
			parado = true
			velocity.x = move_toward(velocity.x, 0, velocidade)
	else:
		#Gravidade
		velocity.y += gravidade * delta
		
		andando = false
		parado = false
		
		if velocity.y < 0:
			pulando = true
			caindo = false
		elif velocity.y >= 0:
			pulando = false
			caindo = true
		
		if direção !=0: #muda direção no ar
			velocity.x = direção * velocidade
			container.scale.x = direção
	atualizar_animacão()

# Gerencia as animações pra evitar que entrem em conflito
func atualizar_animacão():
	if ataque:
		var probabilidade = randf()
		sinalAtaque = true
		items.play("default");
		
		if probabilidade < 0.5:
			if genero == false:
				corpo.play("Ataque para baixo")
		else:
			if genero == false:
				corpo.play("Ataque para cima")
		
		await corpo.animation_finished
		sinalAtaque = false
	
	if pulando :
		if genero == false:
			corpo.play("Pulo")
		if naMão != "Nada":
			items.play(naMão +" - pulo")
		else:
			items.play("default")
	
	if caindo:
		if genero == false:
			corpo.play("Caindo")
		if naMão != "Nada":
			items.play(naMão +" - caindo")
		else:
			items.play("default")
		queda = true
	
	if andando and not sinalAtaque:
		queda = null
		if genero == false:
			corpo.play("Andando")
		if naMão != "Nada":
			items.play(naMão+" - andando")
		else:
			items.play("default")
	
	if parado and not sinalAtaque: ## Parado
		if queda == true:
			await corpo.animation_finished
		
		if genero == false:
			corpo.play("Parado")
		if naMão != "Nada":
			items.play(naMão +" - parado")
		else: 
			items.play("default")
