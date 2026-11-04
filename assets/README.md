# Modelos voxel para PokeSurvival

Los archivos reales proceden de los prototipos de personaje aprobados. Este repositorio **no contiene todavía los GLB binarios**: se distribuyen por separado en el paquete de modelos de esta conversación.

Para activar los modelos, copia exactamente estos archivos en esta carpeta:

- `P01_Ash_V4_ReferenciaVoxel_Animated.glb`
- `PK01_Pikachu_ReferenciaVoxel_Animated.glb`

Abre `project.godot` con Godot 4 y permite que importe los GLB antes de ejecutar. Los nombres distinguen mayúsculas/minúsculas.

**Integración:** Ash tiene Idle, Run, Jump y KO conectados al estado del personaje; Pikachu tiene Idle, Run e Impactrueno conectados a su seguimiento y ataque. Los demás clips (Dodge, Hurt) permanecen para un futuro sistema de esquiva/daño animado.

**Fallback:** Si faltan los GLB, los personajes vuelven a las figuras de colores. Así las pruebas automatizadas y builds básicos siguen funcionando.

**Importante:** Un build de GitHub Actions solo mostrará los modelos si sus archivos GLB forman parte del checkout usado para compilar. El ZIP de modelos se entrega separado, por lo que las versiones automáticas actuales siguen usando figuras provisionales.
