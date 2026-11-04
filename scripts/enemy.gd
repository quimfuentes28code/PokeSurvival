extends Node3D

var target: Node3D
var speed := 2.1
var hp := 2
var contact_cooldown := 0.0
var hit_flash := 0.0
var material: StandardMaterial3D
var arena: Node3D

func _physics_process(delta: float) -> void:
	if not is_instance_valid(target) or not arena.running:
		return
	var offset := target.global_position - global_position
	offset.y = 0.0
	if offset.length() > 1.2:
		position += offset.normalized() * speed * delta
	contact_cooldown -= delta
	if offset.length() < 1.5 and contact_cooldown <= 0.0:
		contact_cooldown = 1.0
		arena.hurt_trainer(10)
	hit_flash = maxf(0.0, hit_flash - delta)
	material.albedo_color = Color.WHITE if hit_flash > 0.0 else Color("d96c87")

func take_hit(damage: int) -> void:
	hp -= damage
	hit_flash = 0.12
	if hp <= 0:
		arena.defeat_enemy(self)
