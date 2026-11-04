# Investigación de Megabonk

Consulta: **4 de noviembre de 2026**. Alcance: sistemas principales del juego y adaptación a PokeSurvival. Se han leído fuentes oficiales y dos recursos comunitarios; no se ha ejecutado Megabonk ni inspeccionado su código. Las cifras de una guía no equivalen a una verificación experimental de la versión actual.

## Evidencia y versión

La ficha oficial de Steam confirma supervivencia roguelike, hordas y jefes, mapas generados aleatoriamente, experiencia, mejoras de armas, ofertas aleatorias con rareza y desbloqueos de personajes, armas y objetos [S1].

Se consultó el canal oficial de anuncios mediante la API pública de Steam [S2]. La publicación más reciente devuelta fue **H A T S**, fechada el 25 de enero de 2026 y posteriormente editada con los hotfixes **1.0.65** y **1.0.69**, este último del 4 de febrero. Esto identifica la referencia documental encontrada; no demuestra qué ejecutable tiene hoy instalado cada jugador. Las guías comunitarias consultadas también se identifican como 1.0.69.

La política inicialmente restringida impedía abrir Steam. Durante el trabajo el estado efectivo pasó a acceso sin restricción de dominios y las consultas a Steam, megabonk.org y megabonkinfo.org funcionaron. megabonk.wiki devolvió 503 y wiki.gg 403; no se emplean como fuentes de contenido.

## Fuentes consultadas

| ID | Fuente | Utilidad y límites |
| --- | --- | --- |
| S1 | [Ficha oficial en Steam](https://store.steampowered.com/app/3405340/Megabonk/) | Descripción oficial del núcleo; los totales promocionales pueden quedar desactualizados |
| S2 | [Anuncios oficiales, API de Steam](https://api.steampowered.com/ISteamNews/GetNewsForApp/v2/?appid=3405340&count=10&feeds=steam_community_announcements) y [canal de noticias](https://store.steampowered.com/news/app/3405340) | Se leyeron las diez publicaciones devueltas, incluyendo Patch #2, 1.0.12, 1.0.17, Spooky Update, Christmas Patch y H A T S con sus ediciones |
| S3 | [Armas](https://megabonk.org/database/weapons/) | Catálogo comunitario de 30 patrones y desbloqueos; no validar daño por simple copia de la tabla |
| S4 | [Tomos](https://megabonk.org/database/tomes/) | Catálogo comunitario de 23 funciones; contiene valores contradictorios que se describen abajo |
| S5 | [Objetos](https://megabonk.org/database/items/) | Índice comunitario de 85 objetos documentados, categorías y enlaces |
| S6 | [Megabonk Items Explained, IndieSnek](https://www.megabonkinfo.org/) | Segunda fuente comunitaria: efectos, acumulaciones y excepciones por objeto, identificada como 1.0.69 |
| S7 | [Desbloqueos](https://megabonk.org/guides/unlocks/) y [huecos de armas](https://megabonk.org/guides/unlocks/weapon-slots/) | Capacidad, hitos de misiones y compras permanentes |
| S8 | [Toggler](https://megabonk.org/guides/unlocks/toggler/) | Diferencia entre filtrar contenido antes de jugar y excluirlo durante una partida |
| S9 | [Santuarios](https://megabonk.org/guides/mechanics/shrines/) | Charge, Golden Charge, Greed y Boss Curse; catálogo no necesariamente exhaustivo |
| S10 | [Microwave](https://megabonk.org/guides/mechanics/microwave/) | Duplicación, coste, sacrificio y usos |
| S11 | [Temporizador](https://megabonk.org/guides/mechanics/timer/) y [Boss Portal](https://megabonk.org/guides/mechanics/boss-portal/) | Reloj estándar, encuentros y diferencia entre invocación y transición |
| S12 | [Mapas](https://megabonk.org/guides/maps/) y [Graveyard/Crypt](https://megabonk.org/guides/maps/graveyard/) | Rutas normales frente a la ruta especial con criptas y llaves |
| S13 | [Potenciadores](https://megabonk.org/guides/mechanics/powerups/) y [estados](https://megabonk.org/guides/mechanics/status-effects/) | Categorías de recogibles y control/daño persistente; cifras exactas a revisar |
| S14 | [Estadísticas](https://megabonk.org/guides/stats/) | Relaciones entre estadísticas; sus fórmulas se presentan como modelos comunitarios, no ecuaciones publicadas por el desarrollador |
| S15 | [Progresión](https://megabonk.org/guides/progression/), [desafíos](https://megabonk.org/guides/challenges/) y [guía inicial](https://megabonk.org/guides/megabonk-beginners-guide) | Contexto de metaprogresión, objetivos y desafíos; recomendaciones subjetivas e inconsistencias requieren cautela |

Las copias HTML, textos extraídos y anuncios JSON de esta consulta se conservaron fuera del checkout en `/workspace/pokesurvival-environment/research/`. No contienen credenciales y no se necesitan para ejecutar el prototipo.

## Sistemas identificados y decisiones de adaptación

| Sistema de Megabonk | Evidencia documental | Consecuencia para PokeSurvival |
| --- | --- | --- |
| Movimiento 3D y combate | La descripción y guías caracterizan combate de supervivencia; las armas se activan generalmente de forma automática. Las notas oficiales mencionan modos de selección de objetivo, proyectiles aleatorios, saltos y cámara [S1–S3] | Controlar al entrenador y dejar atacar a compañeros; revisar excepciones de apuntado/manual antes de exigir automatismo idéntico a todas las armas |
| Personajes | Capacidades y equipo inicial distintos; los parches cambian pasivas que escalan con nivel [S1, S2] | Entrenador + compañero inicial + pasiva; distinguir aspecto de efecto mecánico |
| Armas | Patrones de barrido, proyectil, retorno, órbita, aura, estela, trampa, vínculo, atracción y ejecución [S3] | Especies con roles diferentes, no solo colores sobre un mismo disparo |
| Huecos | Dos armas al inicio según guía; tercero y cuarto mediante hitos y compra. Las notas oficiales corroboran hitos 25/45 para armas y 35/55 para tomos, y corrigen un error que permitía cinco [S2, S7] | Cuatro activos como capacidad máxima inicial de diseño; progresión de capacidad después de validar el núcleo |
| Subidas | XP recogida, mejora de armas/tomos y ofertas aleatorias cuya rareza modifica el valor [S1, S4] | Reclutar, entrenar y asignar MT; la alternancia de ofertas es diseño nuestro, no regla confirmada del original |
| Tomos | Estadísticas como movimiento, cadencia, daño, crítico, defensa, recogida, suerte y economía [S4] | Las MT ofensivas por sí solas no sustituyen su función; añadir apoyo y entrenamiento |
| Rareza | Calidad aleatoria documentada oficialmente; las guías describen Common, Rare, Epic y Legendary y relación con Luck [S1, S5, S14] | Separar rareza de oferta, rareza de objeto y especie Pokémon; no llamar legendario a todo Pokémon de una oferta de alta calidad |
| Objetos | Efectos pasivos, activaciones al golpear/recibir daño/matar/interactuar, acumulaciones y límites [S2, S5, S6] | Objetos de equipo que alteran la construcción; registro de fuentes y reglas explícitas de acumulación |
| Estadísticas y activaciones | Existen coeficientes y orden de activaciones; las notas 1.0.64 cambiaron el orden a uno estable e introducen/recogen límites [S2, S6] | No encadenar ataques y efectos sin límites; probar que el orden de obtención no produce resultados accidentales |
| Salud y defensa | Vida, regeneración, armadura, escudo, evasión, robo de vida y otras capas [S6, S14] | Una vida de entrenador; compañeros invulnerables inicialmente. Es una simplificación propia para mantener el ritmo |
| Estados | Veneno, quemadura, frío, aturdimiento y Bloodmark en guías; el desarrollador confirma límite de control y endurecimiento tardío [S2, S13] | Estados legibles, límites contra bloqueo infinito de jefes y equivalentes Pokémon definidos |
| Dinero | Gold durante la partida y Silver para compras permanentes según guías; las notas corroboran ambas economías [S2, S7, S15] | Pokédólares temporales y Puntos de Liga persistentes |
| Cofres y tiendas | Compra de cofres, inventario de Shady Guy, rareza, exclusiones y efectos al abrir [S2, S5, S6] | Suministros, comerciante y decisiones económicas separadas del reclutamiento |
| Destructibles | Las notas 1.0.64 añaden suerte a vasijas, escalada por etapa [S2] | Explorar para romper cajas tiene valor además de reunir XP |
| Santuarios | Mantener posición por una elección de estadísticas; variante dorada; más dificultad por economía; duplicar jefe por recompensa [S9] | Zonas de entrenamiento, alijos arriesgados y desafíos dominantes |
| Duplicación | Microwave duplica un objeto elegido, consume otro aleatorio de igual rareza y cobra Gold; las notas oficiales corroboran su interacción con límites de objetos [S2, S10] | Cramobot, con sacrificios y coste explícitos antes de confirmar |
| Recogibles | XP, dinero y potenciadores temporales son categorías distintas de los objetos de inventario [S13] | Orbes, Pokédólares, bayas y objetos X, con iconos y duración diferenciados |
| Mapas | Generación aleatoria en fuente oficial; guías describen Forest, Desert y Graveyard, este último con ruta especial [S1, S2, S12] | Biomas Pokémon que conservan funciones de terreno, visibilidad y recorrido |
| Tiempo | Guía estándar: diez minutos, minibosses 3:00/8:00, oleadas 4:00/7:00; no corresponde a todas las criptas [S11] | Calendario configurable, por validar antes de fijar equilibrio |
| Portales | Guías separan activar al jefe de acceder a una siguiente etapa; no toda ruta tiene otra etapa [S11, S12] | Baliza del dominante y salida entre rutas como objetos distintos |
| Final Swarm | Supervivencia tardía documentada en notas; fantasmas nuevos, presión creciente y ajustes de plata/control [S2] | Estampida final, con objetivos y reglas distintos de la etapa normal |
| Jefe final | Patch #2 incorpora 1.0.4: devuelve un arma por fase, dejando solo la inicial en la primera [S2] | Candidato: Mewtwo sella y devuelve compañeros; comprobar el combate completo antes de implementarlo |
| Criptas | Guía: escape inicial cronometrado, cuatro llaves custodiadas, segunda cripta y Big Bob; enemigo especial al agotar tiempo [S12] | Ruta de fantasmas, guardianes y sellos, sin imponerle el calendario estándar |
| Desbloqueos | Misiones/retos habilitan entradas, luego se compran cuando corresponde; no todos los contadores representan lo mismo [S2, S7] | Pokédex y objetivos de expedición con requisitos visibles; desbloquear no equivale a recibir durante la partida |
| Control de ofertas | Refresh, Skip y Banish aparecen en notas oficiales; Toggler filtra antes de la partida según guía [S2, S8] | Cambiar, pasar, excluir y preparar catálogo como cuatro acciones diferenciadas |
| Cosméticos y retos | H A T S añade 21 gorras/logros; otras notas incluyen skins y retos de criptas [S2, S15] | Trajes y gorras de entrenador; desafíos sin necesidad de ampliar poder permanentemente |
| Calidad de vida | Mapa con niebla, transparencia de efectos, color de ataques enemigos, estadísticas, selección automática a partir de cierto nivel y mejoras del guardado [S2] | Pokégear, legibilidad de hordas, elecciones sin arrastre de entrada y guardado recuperable |

## Detalles que afectan especialmente al diseño

**Los cuatro huecos no son una libertad arbitraria.** La guía separa completar misiones de pagar la mejora de capacidad: conseguir el hito no añade el hueco por sí solo. Nuestro prototipo puede habilitar cuatro para pruebas, pero la metaprogresión final debe conservar una decisión explícita sobre esa capacidad [S7].

**La economía no es solo cofres.** Charge exige tiempo/posición, Greed aumenta dificultad, Boss Curse multiplica amenazas y Microwave exige moneda y sacrificio. Renombrar todos como Poképaradas perdería sus decisiones distintas. La guía describe para Microwave 3 usos en Common, 2 en Rare/Epic y 1 en Legendary; son valores comunitarios a verificar, no parámetros ya comprometidos [S9, S10].

**La fase final evita estrategias de duración indefinida.** Spooky Update documenta un máximo de plata de 8x y, a partir de veinte minutos en Final Swarm, aumento de velocidad de fantasmas y reducción progresiva del límite de aturdimientos/congelaciones desde 15. Debemos conservar la función de presión creciente, no copiar estas cifras sin balancear nuestros ataques [S2].

**El combate admite interacciones complejas.** IndieSnek distingue crecimiento lineal de acumulaciones con curvas, límites y grupos de multiplicación. Por ejemplo, describe excepciones de cadencia y experiencia para Battery y Time Bracelet, y límites de duración/activación en otros objetos. La implementación necesita identificar origen del daño, límites por efecto y orden reproducible [S6].

## Discrepancias detectadas y cómo se resuelven

1. **Luck Tome:** el catálogo comunitario muestra +7%, pero Christmas Patch 1.0.49 dice explícitamente que sube de 7% a 8%. Para esa cifra se prioriza el parche oficial; no se importará el catálogo como datos de balance [S2, S4].
2. **Precision Tome:** una tabla dice +7% y otra sección de la misma página +2%. Valor no resuelto; se conserva la función de crítico y se pospone la cifra [S4].
3. **Número de personajes/objetos:** Steam presenta 20 personajes y 70+ objetos; una guía menciona 21 personajes y su base lista 85 objetos. Son descripciones con distinto mantenimiento, no prueba suficiente de un catálogo oficial actual completo [S1, S5, S15].
4. **Tiers:** el texto introductorio de una guía menciona tiers 4/5+, mientras sus páginas específicas de mapas limitan Forest/Desert a tres y Graveyard a otra ruta. No se adopta aquella frase como regla [S12, S15].
5. **Fórmulas y probabilidades:** el recurso de estadísticas reconoce modelos comunitarios. No se presentan como ecuaciones oficiales ni tasas universales para cofres, tiendas o estatuas [S14].
6. **Control de masas:** una guía usa una referencia temporal ambigua; las notas del desarrollador especifican el contexto de Final Swarm. Se conserva el contexto oficial [S2, S13].

## Cobertura y trabajo pendiente

Quedan cubiertas documentalmente las principales familias de sistemas y sus correspondencias, incluyendo las 30 armas y las funciones de 23 tomos del catálogo comunitario. **No se afirma una auditoría exhaustiva del ejecutable ni que todos sus parámetros estén verificados.** Antes de reproducir reglas exactas hay que observar partidas de la versión objetivo y comprobar:

- Composición, probabilidades, límites y excepciones de las ofertas de nivel; comportamiento con categorías llenas, excluidas o al máximo.
- Todas las variantes de estatuas y santuarios, incluyendo Moai y Shrine of Succ; no basta con que aparezcan nombrados en un desbloqueo.
- Control manual/automático de armas excepcionales, movimiento vertical, selección de objetivos y cámara.
- Costes y reglas de exclusión, límite de nivel por arma/tomo, y cada objeto que modifica esos límites.
- Condiciones exactas de salida, victoria y transición por modo; patrones completos del jefe final y de las criptas.
- Fórmulas de daño, crítico, defensa y activaciones; puntos de saturación y rendimiento con muchas entidades.

No es necesario bloquear el desarrollo del núcleo por esos detalles: [DISENO.md](DISENO.md) distingue decisiones propias, equivalencias documentadas y verificaciones pendientes. El prototipo actual demuestra las herramientas y combate básico; aún no implementa las elecciones de nivel ni MT.
