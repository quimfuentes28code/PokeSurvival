extends SceneTree

var failures := 0

func _initialize() -> void:
	call_deferred("run")

func check(condition: bool, message: String) -> void:
	if condition:
		print("PASS: ", message)
	else:
		push_error("FAIL: " + message)
		failures += 1

func run() -> void:
	var scene = load("res://scenes/arena.tscn").instantiate()
	root.add_child(scene)
	await process_frame
	check(not scene.running and scene.menu.visible, "El menú aparece antes de iniciar")
	scene.start_run("ash")
	await physics_frame
	check(scene.running and scene.health == 100, "La partida inicia con vida completa")
	var initial_position: Vector3 = scene.trainer.position
	Input.action_press("move_forward")
	for frame in range(30):
		await physics_frame
	Input.action_release("move_forward")
	check(scene.trainer.position.z < initial_position.z - 2.0, "W mueve al entrenador en la simulación física")
	for frame in range(15):
		await physics_frame
	check(scene.trainer.is_on_floor(), "El suelo mantiene al entrenador")
	Input.action_press("jump")
	for frame in range(8):
		await physics_frame
	Input.action_release("jump")
	check(scene.trainer.position.y > 0.5, "Espacio produce un salto real")
	for enemy in scene.enemy_root.get_children():
		enemy.free()
	scene.spawn_clock = 1000.0
	scene.attack_clock = 1000.0
	var target = scene.spawn_enemy(scene.companion.position + Vector3(0, 0, -3))
	var defeats_before: int = scene.defeated
	check(scene.attack_nearest(), "El compañero encuentra un objetivo cercano")
	check(target.hp == 1, "El ataque reduce la vida del objetivo")
	scene.attack_nearest()
	await process_frame
	check(scene.defeated == defeats_before + 1, "Dos impactos derrotan y contabilizan un objetivo")
	scene.hurt_trainer(100)
	check(not scene.running and scene.end_panel.visible and scene.health == 0, "La derrota detiene la partida y muestra el resultado")
	scene.start_run("maya")
	check(scene.running and scene.selected == "maya" and scene.health == 100 and scene.defeated == 0, "Reiniciar cambia entrenador y restablece el estado")
	scene.show_menu()
	check(not scene.running and scene.menu.visible, "Volver al menú detiene la simulación")
	scene.free()
	print("Smoke funcional: ", failures, " fallos")
	quit(1 if failures else 0)
