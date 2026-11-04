extends Node3D

const TrainerScript = preload("res://scripts/trainer.gd")
const EnemyScript = preload("res://scripts/enemy.gd")
const ModelAssets = preload("res://scripts/model_assets.gd")
const TRAINERS := {
	"ash": {"name": "Ash", "partner": "Pikachu", "move": "Impactrueno", "color": Color("f6d651"), "coat": Color("4d86db")},
	"brock": {"name": "Brock", "partner": "Onix", "move": "Lanzarrocas", "color": Color("a8b5bd"), "coat": Color("c68b50")},
	"maya": {"name": "Maya", "partner": "Piplup", "move": "Burbuja", "color": Color("69cce9"), "coat": Color("e778aa")},
}
var trainer: CharacterBody3D
var companion: Node3D
var camera: Camera3D
var enemy_root: Node3D
var hud: Label
var health_bar: ProgressBar
var menu: Control
var end_panel: Control
var end_label: Label
var running := false
var health := 100
var defeated := 0
var elapsed := 0.0
var spawn_clock := 0.0
var attack_clock := 0.0
var orbit_angle := 0.0
var selected := "ash"
var rng := RandomNumberGenerator.new()
var trainer_anim: AnimationPlayer
var partner_anim: AnimationPlayer
var voxel_partner := false
var partner_attack_timer := 0.0

func _ready() -> void:
	_setup_input()
	rng.seed = 28028
	_build_world()
	_build_interface()

func _setup_input() -> void:
	var actions := {"move_left": [KEY_A, KEY_LEFT], "move_right": [KEY_D, KEY_RIGHT], "move_forward": [KEY_W, KEY_UP], "move_back": [KEY_S, KEY_DOWN], "jump": [KEY_SPACE]}
	for action in actions:
		if not InputMap.has_action(action):
			InputMap.add_action(action)
			for key in actions[action]:
				var event := InputEventKey.new()
				event.physical_keycode = key
				InputMap.action_add_event(action, event)

func _material(color: Color) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = 0.85
	return material

func _mesh(parent: Node3D, shape: Mesh, color: Color, offset := Vector3.ZERO) -> MeshInstance3D:
	var mesh := MeshInstance3D.new()
	mesh.mesh = shape
	mesh.material_override = _material(color)
	parent.add_child(mesh)
	mesh.position = offset
	return mesh

func _sphere(radius: float) -> SphereMesh:
	var shape := SphereMesh.new()
	shape.radius = radius
	shape.height = radius * 2.0
	shape.radial_segments = 12
	shape.rings = 6
	return shape

func _box(size: Vector3) -> BoxMesh:
	var shape := BoxMesh.new()
	shape.size = size
	return shape

func _build_world() -> void:
	var world := WorldEnvironment.new()
	var environment := Environment.new()
	environment.background_mode = Environment.BG_COLOR
	environment.background_color = Color("182938")
	environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	environment.ambient_light_color = Color("c0d7ed")
	environment.ambient_light_energy = 0.7
	world.environment = environment
	add_child(world)
	var sun := DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-50, -30, 0)
	sun.light_energy = 1.5
	sun.shadow_enabled = true
	add_child(sun)
	var ground := StaticBody3D.new()
	add_child(ground)
	_mesh(ground, _box(Vector3(80, 1, 80)), Color("497c69"), Vector3(0, -0.5, 0))
	var collision := CollisionShape3D.new()
	var box := BoxShape3D.new()
	box.size = Vector3(80, 1, 80)
	collision.shape = box
	collision.position.y = -0.5
	ground.add_child(collision)
	for x in range(-4, 5):
		_mesh(self, _box(Vector3(0.08, 0.015, 80)), Color("568975"), Vector3(x * 8, 0.01, 0))
		_mesh(self, _box(Vector3(80, 0.015, 0.08)), Color("568975"), Vector3(0, 0.01, x * 8))
	for index in range(24):
		var angle := float(index) / 24.0 * TAU
		var point := Vector3(cos(angle), 0, sin(angle)) * 37.0
		_mesh(self, _box(Vector3(0.9, 3, 0.9)), Color("6e5446"), point + Vector3(0, 1.5, 0))
		_mesh(self, _sphere(2.3), Color("294c4a"), point + Vector3(0, 4.0, 0))
	enemy_root = Node3D.new()
	enemy_root.name = "Enemies"
	add_child(enemy_root)
	camera = Camera3D.new()
	camera.position = Vector3(0, 12, 17)
	add_child(camera)
	camera.look_at(Vector3(0, 1, 0))
	camera.current = true
	camera.fov = 65

func _panel(parent: Control) -> PanelContainer:
	var panel := PanelContainer.new()
	var style := StyleBoxFlat.new()
	style.bg_color = Color("15232bee")
	style.corner_radius_top_left = 14
	style.corner_radius_top_right = 14
	style.corner_radius_bottom_left = 14
	style.corner_radius_bottom_right = 14
	style.content_margin_left = 26
	style.content_margin_right = 26
	style.content_margin_top = 20
	style.content_margin_bottom = 20
	panel.add_theme_stylebox_override("panel", style)
	parent.add_child(panel)
	return panel

func _label(text: String, size: int, color := Color.WHITE) -> Label:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", size)
	label.add_theme_color_override("font_color", color)
	return label

func _build_interface() -> void:
	var canvas := CanvasLayer.new()
	add_child(canvas)
	var screen := Control.new()
	screen.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	screen.mouse_filter = Control.MOUSE_FILTER_IGNORE
	canvas.add_child(screen)
	var top := _panel(screen)
	top.position = Vector2(22, 20)
	var info := VBoxContainer.new()
	top.add_child(info)
	info.add_child(_label("POKESURVIVAL / CAMPO DE PRUEBAS", 20, Color("8fe1c2")))
	hud = _label("Selecciona entrenador para empezar", 17)
	info.add_child(hud)
	health_bar = ProgressBar.new()
	health_bar.custom_minimum_size = Vector2(360, 14)
	health_bar.show_percentage = false
	health_bar.value = 100
	info.add_child(health_bar)
	var controls := _label("WASD / flechas · mover     ESPACIO · saltar     Botón derecho + ratón · cámara     ESC · selección", 16)
	screen.add_child(controls)
	controls.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_LEFT)
	controls.offset_left = 24
	controls.offset_top = -42
	controls.offset_right = 1240
	controls.offset_bottom = -10
	menu = CenterContainer.new()
	screen.add_child(menu)
	menu.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var panel := _panel(menu)
	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation", 14)
	panel.add_child(column)
	column.add_child(_label("Elige tu entrenador", 34))
	column.add_child(_label("Entrenadores voxel V5 · compañeros en desarrollo", 18, Color("8fe1c2")))
	column.add_child(_label("Muévete, esquiva y deja que tu compañero ataque.\nLos objetivos rosados se acercan: evita el contacto.", 18))
	for id in TRAINERS:
		var option: Dictionary = TRAINERS[id]
		var button := Button.new()
		button.text = "%s  +  %s    ·    %s" % [option.name, option.partner, option.move]
		button.custom_minimum_size = Vector2(480, 54)
		button.add_theme_font_size_override("font_size", 21)
		button.pressed.connect(start_run.bind(id))
		column.add_child(button)
	end_panel = CenterContainer.new()
	screen.add_child(end_panel)
	end_panel.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var end_box := _panel(end_panel)
	var end_column := VBoxContainer.new()
	end_box.add_child(end_column)
	end_label = _label("Fin de la práctica", 28)
	end_column.add_child(end_label)
	var restart := Button.new()
	restart.text = "Volver a elegir entrenador"
	restart.custom_minimum_size.y = 50
	restart.pressed.connect(show_menu)
	end_column.add_child(restart)
	end_panel.hide()

func start_run(id: String) -> void:
	if not TRAINERS.has(id):
		return
	_clear_run()
	selected = id
	health = 100
	defeated = 0
	elapsed = 0.0
	spawn_clock = 1.0
	attack_clock = 0.4
	orbit_angle = 0.0
	trainer = CharacterBody3D.new()
	trainer.set_script(TrainerScript)
	trainer.name = "Trainer"
	add_child(trainer)
	trainer.position = Vector3(0, 0.05, 0)
	var collision := CollisionShape3D.new()
	var capsule := CapsuleShape3D.new()
	capsule.radius = 0.4
	capsule.height = 1.8
	collision.shape = capsule
	collision.position.y = 0.9
	trainer.add_child(collision)
	var model := Node3D.new()
	model.name = "Model"
	trainer.add_child(model)
	trainer_anim = null
	if (id == "ash" and ModelAssets.install(model, ModelAssets.ASH_PATH)) or (id == "brock" and ModelAssets.install(model, ModelAssets.BROCK_PATH)):
		trainer_anim = ModelAssets.animator(model)
		ModelAssets.play(trainer_anim, "Idle")
	else:
		_mesh(model, _box(Vector3(0.75, 1, 0.45)), TRAINERS[id].coat, Vector3(0, 0.9, 0))
		_mesh(model, _sphere(0.35), Color("f6c7a1"), Vector3(0, 1.65, 0))
		_mesh(model, _box(Vector3(0.8, 0.15, 0.65)), TRAINERS[id].coat, Vector3(0, 1.95, 0.08))
		_mesh(model, _box(Vector3(0.24, 0.45, 0.28)), Color("233b56"), Vector3(-0.22, 0.23, 0))
		_mesh(model, _box(Vector3(0.24, 0.45, 0.28)), Color("233b56"), Vector3(0.22, 0.23, 0))
	companion = Node3D.new()
	add_child(companion)
	voxel_partner = id == "ash" and ModelAssets.install(companion, ModelAssets.PIKACHU_PATH)
	partner_anim = ModelAssets.animator(companion) if voxel_partner else null
	partner_attack_timer = 0.0
	if voxel_partner:
		ModelAssets.play(partner_anim, "Idle")
	else:
		_mesh(companion, _sphere(0.55), TRAINERS[id].color)
		if id == "ash":
			_mesh(companion, _box(Vector3(0.18, 0.7, 0.18)), TRAINERS[id].color, Vector3(-0.25, 0.6, 0))
			_mesh(companion, _box(Vector3(0.18, 0.7, 0.18)), TRAINERS[id].color, Vector3(0.25, 0.6, 0))
		elif id == "brock":
			_mesh(companion, _sphere(0.4), TRAINERS[id].color, Vector3(0, -0.3, 0.5))
			_mesh(companion, _sphere(0.3), TRAINERS[id].color, Vector3(0, -0.5, 0.9))
		else:
			_mesh(companion, _sphere(0.3), Color("eaf6f2"), Vector3(0, 0.02, 0.35))
	companion.position = trainer.position + Vector3(1.7, 0.0 if voxel_partner else 1.0, 0)
	trainer.active = true
	running = true
	menu.hide()
	end_panel.hide()
	spawn_enemy(Vector3(0, 0, -9))
	_update_hud()

func _clear_run() -> void:
	if is_instance_valid(trainer):
		trainer.free()
	if is_instance_valid(companion):
		companion.free()
	for enemy in enemy_root.get_children():
		enemy.free()
	trainer_anim = null
	partner_anim = null
	voxel_partner = false
	partner_attack_timer = 0.0

func show_menu() -> void:
	running = false
	if is_instance_valid(trainer):
		trainer.active = false
	menu.show()
	end_panel.hide()
	hud.text = "Selecciona entrenador para empezar"

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		show_menu()
	if running and event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		orbit_angle -= event.relative.x * 0.006

func _physics_process(delta: float) -> void:
	if not running:
		return
	elapsed += delta
	trainer.view_yaw = orbit_angle
	var camera_offset := Vector3(0, 9, 13).rotated(Vector3.UP, orbit_angle)
	camera.position = camera.position.lerp(trainer.position + camera_offset, minf(delta * 8.0, 1.0))
	camera.look_at(trainer.position + Vector3(0, 1, 0))
	var altitude := 0.05 + sin(elapsed * 5.0) * 0.025 if voxel_partner else 1.0 + sin(elapsed * 5.0) * 0.12
	var follow := trainer.position + Vector3(1.7, altitude, 0).rotated(Vector3.UP, orbit_angle)
	var follow_distance := companion.position.distance_to(follow)
	companion.position = companion.position.lerp(follow, minf(delta * 9.0, 1.0))
	if is_instance_valid(trainer_anim):
		var moving := Vector2(trainer.velocity.x, trainer.velocity.z).length() > 0.3
		var clip := "Idle"
		if not trainer.is_on_floor():
			clip = "Jump"
		elif moving:
			clip = "Run"
		ModelAssets.play(trainer_anim, clip)
	if is_instance_valid(partner_anim):
		partner_attack_timer = maxf(0.0, partner_attack_timer - delta)
		if partner_attack_timer <= 0.0:
			ModelAssets.play(partner_anim, "Run" if follow_distance > 0.25 else "Idle")
	spawn_clock -= delta
	if spawn_clock <= 0.0:
		spawn_clock = maxf(0.6, 2.4 - elapsed * 0.008)
		if enemy_root.get_child_count() < 80:
			var angle := rng.randf_range(0, TAU)
			var point := trainer.position + Vector3(cos(angle), 0, sin(angle)) * 16.0
			point.x = clampf(point.x, -34, 34)
			point.z = clampf(point.z, -34, 34)
			point.y = 0.0
			spawn_enemy(point)
	attack_clock -= delta
	if attack_clock <= 0.0:
		attack_clock = 0.85
		attack_nearest()
	_update_hud()

func spawn_enemy(point: Vector3) -> Node3D:
	var enemy := Node3D.new()
	enemy.set_script(EnemyScript)
	enemy.target = trainer
	enemy.arena = self
	enemy_root.add_child(enemy)
	enemy.position = point
	var mesh := _mesh(enemy, _sphere(0.65), Color("d96c87"), Vector3(0, 0.65, 0))
	enemy.material = mesh.material_override
	_mesh(enemy, _sphere(0.12), Color("273743"), Vector3(-0.2, 0.85, 0.52))
	_mesh(enemy, _sphere(0.12), Color("273743"), Vector3(0.2, 0.85, 0.52))
	return enemy

func attack_nearest() -> bool:
	var nearest: Node3D = null
	var distance := 12.0
	for enemy in enemy_root.get_children():
		if enemy.is_queued_for_deletion():
			continue
		var candidate := companion.global_position.distance_to(enemy.global_position)
		if candidate < distance:
			distance = candidate
			nearest = enemy
	if nearest == null:
		return false
	var start := companion.global_position
	var end := nearest.global_position + Vector3(0, 0.7, 0)
	var bolt := _mesh(self, _box(Vector3(0.12, 0.12, start.distance_to(end))), TRAINERS[selected].color)
	bolt.position = (start + end) * 0.5
	bolt.look_at(end)
	var fade := create_tween()
	fade.tween_interval(0.12)
	fade.tween_callback(bolt.queue_free)
	if is_instance_valid(partner_anim):
		partner_attack_timer = 0.45
		ModelAssets.play(partner_anim, "Impactrueno")
	nearest.take_hit(1)
	return true

func defeat_enemy(enemy: Node3D) -> void:
	if enemy.is_queued_for_deletion():
		return
	defeated += 1
	enemy.queue_free()

func hurt_trainer(amount: int) -> void:
	if not running:
		return
	health = maxi(0, health - amount)
	_update_hud()
	if health == 0:
		running = false
		trainer.active = false
		ModelAssets.play(trainer_anim, "KO")
		end_label.text = "Fin de la práctica\n%d objetivos · %d s" % [defeated, int(elapsed)]
		end_panel.show()

func _update_hud() -> void:
	hud.text = "%s + %s  |  %d objetivos  |  %02d:%02d" % [TRAINERS[selected].name, TRAINERS[selected].partner, defeated, int(elapsed) / 60, int(elapsed) % 60]
	health_bar.value = health
