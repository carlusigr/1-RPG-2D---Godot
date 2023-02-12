extends KinematicBody2D

const PARTICLES: PackedScene = preload("res://Scenes/Player/RunParticles.tscn")

#Quando o Obj estiver pronto, guarda a referencia na Variavel
onready var animation: AnimationPlayer = get_node("Animation")
onready var sprite:  Sprite = get_node("Sprite")

#Variavel que carrega a posicao X e Y
var velocity: Vector2

#Exporta a variavel para o Inspetor
export (int) var speed

#Funcao de Update (Verifica o tempo todo)
func _physics_process(_delta: float) -> void:
	move()
	animate()
	verify_direction()
	
#Funcao feita para a movimentacao do personagem	
func move() -> void:
	var direction_vector: Vector2 = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()
	
	velocity = direction_vector * speed
	velocity = move_and_slide(velocity)

#Funcao feito para chamar as animacao do personagem
func animate() -> void:
	if velocity != Vector2.ZERO:
		animation.play("Run")
	else: 
		animation.play("Idle")
	
#Verificando a direcao para a sprite trocar de direcao	
func verify_direction() -> void:
	if velocity.x > 0:
		sprite.flip_h = false
		
	elif velocity.x < 0:
		sprite.flip_h = true

#Adicionando particulas de correr
func instance_particles() -> void:
	var particle = PARTICLES.instance()
	get_tree().root.call_deferred("add_child", particle)
	particle.global_position = global_position + Vector2(0, 16)
	particle.play_particles()
	
	
