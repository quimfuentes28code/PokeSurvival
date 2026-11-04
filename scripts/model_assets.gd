extends RefCounted
## Carga opcional de modelos GLB (se mantiene el fallback técnico).
const ASH_PATH := "res://assets/P01_Ash_V5_Limpio_Animado.glb"
const BROCK_PATH := "res://assets/P02_Brock_V5_Limpio_Animado.glb"
const PIKACHU_PATH := "res://assets/PK01_Pikachu_V5_Limpio_Animado.glb"

static func install(parent: Node3D, path: String) -> bool:
	if not ResourceLoader.exists(path):
		return false
	var resource := ResourceLoader.load(path)
	if not resource is PackedScene:
		push_warning("Modelo 3D no importado: " + path)
		return false
	parent.add_child((resource as PackedScene).instantiate())
	return true

static func animator(parent: Node) -> AnimationPlayer:
	var found := parent.find_children("*", "AnimationPlayer", true, false)
	return found[0] as AnimationPlayer if not found.is_empty() else null

static func play(player: AnimationPlayer, name: String) -> void:
	if not is_instance_valid(player):
		return
	var found := ""
	if player.has_animation(name):
		found = name
	else:
		for entry in player.get_animation_list():
			var clip := String(entry)
			if clip.ends_with("/" + name) or clip.ends_with("|" + name):
				found = clip
				break
	if found.is_empty() or player.current_animation == found:
		return
	if name == "Idle" or name == "Run":
		player.get_animation(found).loop_mode = Animation.LOOP_LINEAR
	player.play(found, 0.1)
