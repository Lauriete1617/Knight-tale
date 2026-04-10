extends CharacterBody2D

#Chamando nós que vamos usar no script
@onready var animação: AnimatedSprite2D = $Container/AnimatedSprite2D
@onready var espada: Area2D = $Container/Espada
@onready var ataqueArea: CollisionShape2D = $Container/Espada/Ataque
@onready var container: Node2D = $Container
@onready var campo_de_visão: CollisionShape2D = $"Campo de visão"
"res://Cenas/"
const player = preload("uid://y5vcv0pimefe")

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
func _physics_process(_delta: float) -> void:
	if body.is_in_Group()
	
	ataque = Input.is_action_pressed("Ataque leve")
	if ataque:
		if sinalAtaque: # Sinal para não interromper animação
			return
		atualizar_animacão()
	move_and_slide()
	
	direção = player.position
	
	if direção !=0: #caminha
		velocity.x = direção * velocidade
		container.scale.x = direção
		atualizar_animacão()
	else: #parado
		velocity.x = move_toward(velocity.x, 0, velocidade)
		atualizar_animacão()

# Gerencia as animações pra evitar que entrem em conflito
func atualizar_animacão():
	if ataque:
		sinalAtaque = true
		
		await animação.animation_finished
		sinalAtaque = false
	
	if is_on_floor() and not sinalAtaque: ## Andando
		if velocity.x != 0:
			animação.play()
		
		else: ## Parado
			animação.play()
			
