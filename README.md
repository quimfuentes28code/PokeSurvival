# PokeSurvival

Prototipo 3D con **Godot 4.6.3 estándar y GDScript**: elige entrenador, muévete por la arena y deja que tu compañero ataque automáticamente.

## Jugar en Windows

**[Descargar PokeSurvival para Windows](https://github.com/quimfuentes28code/PokeSurvival/releases/download/v0.1.0/PokeSurvival-Windows.zip)** · [Ver versiones y novedades](https://github.com/quimfuentes28code/PokeSurvival/releases)

1. Descarga el ZIP de la versión.
2. Pulsa **Extraer todo**.
3. Abre **PokeSurvival.exe** y elige entrenador. Mantén `PokeSurvival.pck` en la misma carpeta.

No necesitas instalar Godot para jugar. Es una aplicación de escritorio para Windows de 64 bits.

| Control | Acción |
| --- | --- |
| WASD o flechas | Moverse |
| Espacio | Saltar |
| Botón derecho + ratón | Girar la cámara |
| Escape | Volver a elegir entrenador |

El código, el diseño y las instrucciones se guardan en este repositorio. Los ejecutables se distribuyen en **Releases**. Las partidas del prototipo todavía no tienen guardado persistente.

## Modelos voxel 3D V5 corregidos

El juego admite Ash, Pikachu y Brock en sus versiones V5 (mallas voxel limpias con textura embebida, rigging y animaciones). El clip del ataque eléctrico se llama `Impactrueno`. Maya, Piplup y Onix siguen siendo provisionales.

Para activarlos desde este repositorio, coloca los tres archivos `.glb` corregidos en `assets/` y ábrelo en Godot 4.6.3. Los archivos binarios se entregan en el proyecto completo descargable de la conversación; este repositorio guarda el código. Sin los GLB, aparecen los modelos provisionales.

**Importante:** el ZIP actual de GitHub Releases no incluye los V5. Debes usar el ZIP de Windows V5 preparado por separado o exportar localmente después de copiar los recursos. [Instrucciones](assets/README.md).

## Ejecutar

```sh
git clone https://github.com/quimfuentes28code/PokeSurvival.git
cd PokeSurvival
godot --editor --path .
```

Pulsa **F6** con `scenes/arena.tscn` abierta, o **F5** para el proyecto. También puedes usar `godot --path .` en una sesión con pantalla.

## Validar sin pantalla

```sh
godot --headless --editor --path . --import
godot --headless --path . --script tests/smoke.gd
godot --headless --path . --quit-after 120
```

En el entorno de nube usa el checkout existente en `/workspace/PokeSurvival`. Cada tarea ya está aislada; no hace falta crear un worktree. Si la máquina no permite escribir en el directorio personal, configura `XDG_DATA_HOME`, `XDG_CONFIG_HOME` y `XDG_CACHE_HOME` a directorios escribibles fuera del repositorio. En el entorno preparado se usan los subdirectorios `data`, `config` y `cache` de `/workspace/pokesurvival-environment`.

## Qué incluye esta base

- Escenario 3D de práctica y figuras geométricas provisionales.
- Selección de Ash/Pikachu, Brock/Onix o Maya/Piplup. En este prototipo los ataques comparten comportamiento; el nombre y el color son ilustrativos.
- Movimiento con WASD/flechas, salto con espacio y cámara con botón derecho del ratón.
- El compañero sigue al entrenador y ataca automáticamente al objetivo más cercano dentro de su alcance.
- Objetivos que persiguen y dañan al entrenador, contador de derrotados, vida y reinicio.
- Prueba funcional de menú, movimiento, colisión con el suelo, salto, daño, derrota y reinicio.

Todavía no implementa experiencia, selección de tres recompensas, aprendizaje de movimientos, evolución, jefes, tipos ni progresión persistente. El diseño de esos sistemas se documenta por separado. Este escenario sirve para validar las herramientas y comenzar a iterar; no representa el aspecto final del juego.

No se incluyen recursos extraídos de otros juegos.

## Generar una versión para Windows

Para regenerarlo desde el proyecto, instala las plantillas oficiales de exportación de **Godot 4.6.3** y ejecuta:

```sh
mkdir -p build/windows
godot --headless --path . --export-release Windows
```

La automatización de [GitHub Actions](https://github.com/quimfuentes28code/PokeSurvival/actions) verifica las descargas oficiales, importa el proyecto, ejecuta las pruebas, exporta y empaqueta Windows al subir cambios a `main`, abrir una pull request o iniciar el flujo manualmente. El ZIP de cada ejecución aparece como artefacto de Actions; las versiones publicadas para jugar están en Releases.

Para publicar una nueva versión, abre **Actions → Windows build → Run workflow**, selecciona `main` y escribe una etiqueta nueva como `v0.1.1` en `release_tag`. Tras superar las pruebas, el flujo publica el ZIP en Releases como versión preliminar. Deja ese campo vacío para generar únicamente un artefacto de prueba.

También puedes preparar las herramientas con `python3 tools/setup_godot.py --help` y consultar el empaquetado reproducible con `python3 tools/build_windows.py --help`.

En el entorno de nube las plantillas están verificadas e instaladas bajo `/workspace/pokesurvival-environment/data/godot/export_templates/4.6.3.stable`; usa las variables XDG indicadas arriba. La exportación es Windows x86_64 y excluye las pruebas, documentos de diseño y herramientas de desarrollo. La validación incluye 11 comprobaciones funcionales en Linux y un arranque del ejecutable exportado en Windows sin pantalla. La prueba de Windows comprueba que carga y termina sin errores; no sustituye probar controles y gráficos de forma interactiva.

Consulta [el diseño propuesto](docs/DISENO.md) y [el estado de la investigación](docs/INVESTIGACION.md) para los siguientes pasos y sus fuentes.
