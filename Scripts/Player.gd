extends KinematicBody2D

const PARTICLES: PackedScene = preload("res://Scenes/Player/RunParticles.tscn")

#Quando o Obj estiver pronto, guarda a referencia na Variavel
onready var animation: AnimationPlayer = get_node("Animation")
onready var sprite:  Sprite = get_node("Sprite")
onready var colision: CollisionShape2D = get_node("AttackArea/Collision")

#Variavel que carrega a posicao X e Y
var velocity: Vector2
var can_attack: bool = false
var can_die: bool = false

#Exporta a variavel para o Inspetor
export (int) var speed

#Funcao de Update (Verifica o tempo todo)
func _physics_process(_delta: float) -> void:
	move()
	attack()
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

func attack() -> void:
	if Input.is_action_just_pressed("ui_select") and not can_attack:
		can_attack = true

#Funcao feito para chamar as animacao do personagem
func animate() -> void:
	if can_die:
		animation.play("Dead")
		set_physics_process(false)
	elif can_attack: 
		animation.play("Attack")
		set_physics_process(false)
	elif velocity != Vector2.ZERO:
		animation.play("Run")
	else: 
		animation.play("Idle")
	
#Verificando a direcao para a sprite trocar de direcao	
func verify_direction() -> void:
	if velocity.x > 0:
		sprite.flip_h = false
		colision.position = Vector2( 20, 8)
		
	elif velocity.x < 0:
		sprite.flip_h = true
		colision.position = Vector2( -20, 8)

#Adicionando particulas de correr
func instance_particles() -> void:
	var particle = PARTICLES.instance()
	get_tree().root.call_deferred("add_child", particle)
	particle.global_position = global_position + Vector2(0, 16)
	particle.play_particles()
	
func kill() -> void:
	can_die = true
	


func on_animation_finished(anim_name):
	if anim_name == "Dead":
		var reload: bool = get_tree().reload_current_scene()
	elif anim_name == "Attack":
		can_attack = false
		set_physics_process(true)
