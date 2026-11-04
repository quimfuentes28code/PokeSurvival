# PokeSurvival — propuesta de diseño

Estado: propuesta del 4 de noviembre de 2026, contrastada con la ficha y notas oficiales de Steam hasta el hotfix 1.0.69 allí documentado y con dos fuentes comunitarias. Véase [INVESTIGACION.md](INVESTIGACION.md) para evidencias, fechas y discrepancias. Las reglas de PokeSurvival son propuestas, no funcionalidades ya implementadas; el [README](../README.md) describe lo que funciona.

## Objetivo

Un juego de supervivencia 3D en tercera persona: controlas a un entrenador, esquivas y exploras mientras sus Pokémon combaten automáticamente. Derrotar enemigos permite recoger experiencia, elegir mejoras y construir un equipo capaz de sobrevivir a una dificultad creciente y superar un jefe.

La referencia buscada es el ritmo de Megabonk, con temática Pokémon. Conservaremos el movimiento continuo, los ataques automáticos y las decisiones rápidas. El usuario propone entrenadores como Ash, Brock y Maya; Pokémon en lugar de armas; y ataques asignables en lugar de tomos. Las equivalencias se basan en los sistemas documentados; no se copiarán sin revisión fórmulas, porcentajes ni reglas que hayan cambiado entre versiones.

## Correspondencias propuestas

Las filas describen nuestra adaptación de las familias de sistemas documentadas en las fuentes de investigación. Debajo se concretan los interactuables, el final de partida y los cambios que introduce la propuesta Pokémon.

| Sistema de referencia | PokeSurvival | Función que buscamos conservar |
| --- | --- | --- |
| Personaje y capacidad inicial | Entrenador, pasiva y compañero inicial | Identidad propia desde el comienzo |
| Arma automática | Pokémon compañero que ataca por sí mismo | Concentrar el control manual en movimiento y posicionamiento |
| Nivel y mejoras del arma | Entrenamiento del compañero | Mejorar potencia, alcance, cadencia o patrón |
| Tomos, mencionados por el usuario | MT que enseñan movimientos | Elegir una especialización con huecos limitados |
| Estadísticas globales de los tomos | Entrenamiento y objetos de equipo | Mantener progresión de velocidad, daño, área, experiencia y recogida |
| Objetos pasivos | Objetos inspirados en Restos, Imán, Campana Concha, etc. | Construcciones y sinergias reconocibles |
| Rareza de recompensas | Calidad del hallazgo o entrenamiento | Variación de valor sin convertir una opción en obligatoria |
| Experiencia recogible | Orbes de experiencia | Exponerse y recorrer el mapa para progresar |
| Moneda de la partida | Pokédólares de expedición | Decidir entre gastar y reservar |
| Cofres y suministros | Cápsulas y cajas de suministros | Recompensar exploración, con apertura rápida |
| Tiendas y Shady Guy | Puestos de suministros | Selección deliberada de mejoras con coste |
| Santuarios y eventos | Lugares de entrenamiento, ruinas y desafíos | Dar motivos para desviarse de la ruta segura |
| Eventos de riesgo/recompensa | Desafíos de Pokémon dominantes | Exigir una decisión visible antes de aumentar el peligro |
| Curación y recogibles temporales | Bayas, botiquines y efectos temporales | Resolver necesidades inmediatas durante la acción |
| Enemigos de horda | Pokémon salvajes hostiles en el contexto de la expedición | Siluetas, velocidades y amenazas legibles |
| Élites | Pokémon dominantes con un modificador visible | Aumentar presión y recompensa |
| Jefes | Dominantes especiales o legendarios | Comprobar la construcción del equipo y la habilidad del jugador |
| Mapas y movimiento vertical | Rutas, cuevas, ruinas y montañas | Exploración, salto y rutas de escape |
| Temporizador y escalado | Peligro creciente durante la expedición | Evitar que esperar sea la estrategia dominante |
| Transición entre etapas | Salida hacia otro bioma | Decidir cuándo abandonar un área y sus recompensas |
| Final de partida y posibles fases extra | Jefe, resultado y modo adicional por definir | Condición de victoria y derrota inequívoca |
| Refresh, Skip y Banish | Cambiar encuentro, pasar recompensa y excluir hallazgo | Control acotado sobre el azar |
| Metaprogresión | Pokédex, logros y nuevos entrenadores/objetos | Ampliar las opciones disponibles en futuras partidas |
| Estadísticas de resultado | Daño por compañero, tiempo, elecciones y causa de derrota | Comprender por qué funcionó o falló el equipo |

## Entrenadores

Todos comparten controles. Sus pasivas cambian la construcción del equipo sin exigir aprender otro sistema de movimiento.

| Entrenador | Compañero inicial propuesto | Pasiva propuesta | Estilo |
| --- | --- | --- | --- |
| Ash | Pikachu | Pequeño beneficio de cadencia después de recorrer cierta distancia | Movilidad y ataques encadenados |
| Brock | Onix | Reducción de daño y mejor aprovechamiento de curación | Resistencia y control de proximidad |
| Maya | Piplup | Mayor área para ataques de agua y mejor duración de control | Zonas y grupos de enemigos |

Estas pasivas todavía no están implementadas. Las bonificaciones numéricas se fijarán tras medir el combate básico. Ningún entrenador debe ser requisito para usar un Pokémon o una MT concreta.

## Equipo y control

- Prototipo de progresión: **cuatro Pokémon activos**, siguiendo la capacidad máxima de cuatro armas documentada. Megabonk empieza con dos huecos y permite comprar el tercero y el cuarto mediante metaprogresión. Nuestro prototipo habilitará los cuatro para probar combinaciones; después se añadirá la progresión de capacidad.
- Cada compañero conserva un movimiento básico que define su identidad y puede equipar **una MT adicional**. Máximo inicial: ocho patrones ofensivos.
- Los Pokémon siguen al entrenador, no bloquean su movimiento y no necesitan navegación compleja para que un ataque pueda ejecutarse.
- En esta primera versión solo el entrenador tiene vida. Sus compañeros permanecen activos hasta terminar la partida. Así evitamos gestionar varias curaciones en medio de una horda.
- El objetivo de cada ataque depende de su patrón: enemigo cercano, objetivo en dirección de avance, área o cadena. El jugador no fija objetivos con clics repetidos.
- Seis compañeros activos se evaluarán posteriormente: aumentan el ruido visual y las combinaciones de ataques. No añadiremos suplentes antes de validar el combate.

## Subidas de nivel y tres opciones

El requisito de elegir **entre tres Pokémon** se cumple en las ofertas de reclutamiento. Las MT tendrán sus propias ofertas para que no desaparezca esa elección entre tres compañeros.

1. Recoger suficiente experiencia pausa la simulación y abre una única oferta.
2. Con huecos libres, las primeras ofertas alternan reclutamiento y entrenamiento. Se comprobará en pruebas si el equipo tarda demasiado en completarse.
3. **Reclutamiento:** tres Pokémon distintos; elegir uno lo incorpora. Una especie ya presente se rotula como mejora del compañero, nunca como una incorporación duplicada accidental.
4. **Entrenamiento:** tres opciones entre movimientos compatibles y mejoras útiles para el equipo actual.
5. Cuando el equipo esté lleno, las ofertas se orientan a mejorar los compañeros y ataques presentes. El intercambio de especies queda para una iteración posterior con una comparación explícita de pérdidas.
6. Elegir una MT muestra los destinatarios compatibles; asignarla requiere como máximo una segunda elección. Si solo hay uno y su hueco está libre, se asigna automáticamente. Si sustituye una MT, la tarjeta debe mostrar qué se pierde y exigir esa elección explícita antes de reemplazarla.
7. Si se obtienen varios niveles a la vez, las elecciones se resuelven en cola antes de reanudar la partida; no se pierde experiencia sobrante.

Reglas contra recompensas inútiles: no ofrecer movimientos incompatibles con todo el equipo, mejoras ya al máximo, especies que no caben ni opciones duplicadas. Las ofertas de reclutamiento deben contener tres Pokémon válidos. Si no existen suficientes, se genera una oferta de entrenamiento claramente rotulada; solo dentro de esa categoría se permite completar con mejoras de entrenamiento válidas. Nunca rellenar con botones que no hacen nada.

La alternancia propuesta es una adaptación del calendario de recompensas para respetar la elección literal entre tres Pokémon. No se presenta como una regla de Megabonk: allí la progresión incluye mejoras de armas y tomos. Las probabilidades exactas y composición de las ofertas siguen pendientes de validación directa.

## MT, estadísticas y objetos

Una MT representa un ataque, no una bonificación genérica. Debe indicar tipo, patrón, alcance, enfriamiento, efecto y destinatarios. La compatibilidad se definirá en datos de contenido y tendrá que revisarse si queremos respetar los movimientos que puede aprender cada especie.

Ejemplos de patrones, pendientes de balance y compatibilidad:

| Movimiento | Patrón propuesto | Aporta |
| --- | --- | --- |
| Impactrueno | Descarga dirigida de corto alcance | Ataque frecuente a un objetivo |
| Rayo | Descarga capaz de encadenar objetivos cercanos | Limpieza de grupos |
| Lanzarrocas | Proyectil pesado con impacto | Daño concentrado y empuje |
| Terremoto | Onda periódica sobre el suelo | Defensa de proximidad |
| Burbuja | Abanico de proyectiles lentos | Cobertura y control |
| Surf | Ola amplia en una dirección | Abrir una ruta de escape |
| Ascuas | Proyectiles que aplican quemadura | Daño sostenido |
| Látigo Cepa | Barrido cercano | Mantener distancia con la horda |

Los patrones son adaptaciones al combate en tiempo real; no describen necesariamente el funcionamiento de esos movimientos en los juegos Pokémon.

**Los tomos de Megabonk proporcionan estadísticas: sustituirlos por MT cambia la progresión, no solo su apariencia.** Mantendremos esa función con MT de apoyo, entrenamiento y objetos. Las MT pueden ser ofensivas o de apoyo. Agilidad o Pantalla Luz pueden originar efectos de equipo desde el Pokémon que las usa; ese alcance compartido es una regla propuesta para este fan game. El entrenamiento mejora daño, cadencia, velocidad, área o recogida; los objetos introducen efectos concretos y sinergias. Evitaremos tres sistemas distintos que otorguen exactamente la misma recompensa.

Propuestas de objetos: Restos para recuperación periódica, Imán para potenciar ataques eléctricos y Campana Concha para curación condicionada por daño. Imán no ampliará el radio de recogida solo por su nombre: cada efecto debe explicarse y ser consistente.

El presupuesto de daño debe incluir los dos movimientos de cada compañero. Añadir una MT no puede duplicar sin coste todo su rendimiento. La combinación de cadencia, proyectiles, área, crítico y activaciones secundarias tendrá límites y mediciones para evitar bucles infinitos.

## Tipos, estados y evoluciones

Primera fase: tipos como identidad visual y etiquetas de sinergia. Más adelante se ensayarán ventajas moderadas y resistencias visibles; una oleada aleatoria no debe anular todo un equipo mediante inmunidades absolutas.

Quemadura, ralentización, parálisis y empuje tendrán duración, acumulación y límites explícitos. Los jefes pueden resistir parte del control sin ignorarlo por completo. Las señales de los ataques enemigos siempre deben destacar sobre los efectos aliados.

Las evoluciones son una **ampliación temática propuesta**, no un equivalente verificado del original. Requerirán una condición visible de entrenamiento y, cuando corresponda, un objeto. Cambiarán aspecto y patrón. No usaremos recetas ocultas en el prototipo ni haremos que las especies sin evolución sean elecciones inferiores por definición.

## Expedición, economía y progresión persistente

El recorrido buscado es: elegir entrenador → entrar al bioma → combatir, recoger y explorar → construir el equipo → invocar y vencer al jefe de etapa → pasar a la siguiente etapa cuando exista → elegir el cierre de la ruta o la supervivencia adicional → revisar resultados y desbloqueos. No confundiremos vencer un jefe de etapa con terminar toda la expedición.

Tres recursos separados:

- Experiencia: aumenta el nivel de la expedición actual.
- Pokédólares: se ganan y gastan dentro de la expedición; no se duplican al reintentar.
- Investigación de la Pokédex: progreso persistente obtenido por objetivos definidos, que habilita nuevas opciones para futuras partidas.

Desbloquear un Pokémon lo añade al conjunto de posibles recompensas; no lo regala en cada inicio. Las primeras mejoras persistentes deben ampliar opciones, sin ocultar errores de balance tras bonificaciones permanentes obligatorias.

Las cápsulas de suministros y los eventos deben justificar explorar mientras la presión aumenta. La guía comunitaria describe ventanas estándar de diez minutos, élites en 3:00/8:00 y oleadas en 4:00/7:00; conservaremos ese ritmo como referencia configurable, sin aplicarlo a la ruta especial de criptas. Los costes, cantidades, probabilidades y curvas exactas se verificarán antes de balancear. Las notas oficiales sí corroboran Final Swarm, sus cambios de dificultad y sus límites contra control infinito.

La primera prueba de progresión tendrá una duración corta configurable, con enemigos básicos, una variante peligrosa y un jefe sencillo. Esa duración será una herramienta de prueba, no una afirmación sobre Megabonk.

## Presentación

3D estilizado con cámara que permita leer amenazas, compañeros reconocibles por silueta y color, y efectos breves. El entrenador será el centro de lectura, aunque los ataques salgan visualmente de los compañeros. Los enemigos deben poder distinguirse del equipo aliado incluso cuando sean la misma especie.

El HUD mostrará vida del entrenador, experiencia/nivel, tiempo o peligro, moneda y equipo. Las ofertas mostrarán qué cambia y para quién. Los modelos geométricos actuales permiten validar el manejo antes de sustituirlos por arte definitivo; no son diseños finales de personajes.

## Base técnica y orden de desarrollo

Godot 4.6.3, GDScript y renderizador Compatibility. El primer objetivo es escritorio con teclado y ratón. La base no necesita un servidor, una base de datos, servicios externos ni secretos. Exportación, mando y otras plataformas quedan fuera de la primera validación.

Separar conforme crezca el prototipo: control del jugador/cámara, director de oleadas, equipo y ataques, experiencia/ofertas, datos de contenido y guardado. Los parámetros de especies, movimientos y objetos deben salir de la lógica de combate antes de ampliar mucho el catálogo.

| Entrega | Contenido | Criterio para avanzar |
| --- | --- | --- |
| Base técnica actual | Selección de tres entrenadores representados por geometría, movimiento, cámara, salto, compañero automático y enemigos de prueba | Importación limpia y comprobaciones funcionales de movimiento, combate y reinicio |
| Núcleo de progresión | Experiencia, tres ofertas, segundo compañero y MT asignable | Completar un recorrido combatir → subir nivel → elegir → ver el efecto, sin opciones inválidas |
| Partida completa | Oleadas, suministros, objetos, jefe y resultados | Ganar y perder con reinicio correcto; entender la causa de derrota |
| Identidad Pokémon | Arte, animación, estados, evolución y más especies | Reconocer aliados/amenazas y mantener legibilidad con el equipo lleno |
| Rejugabilidad | Desbloqueos, biomas, guardado y variantes | Guardado recuperable y varias construcciones viables |

## Validaciones siguientes

- Ofertas deterministas con semilla para reproducir fallos, sin duplicados ni destinatarios incompatibles.
- Pausa real durante elecciones; cola de niveles y conservación de experiencia sobrante.
- Cada compañero y MT cambia el combate; mejoras reflejadas correctamente en la interfaz.
- Límites de entidades y limpieza de proyectiles/efectos al reiniciar.
- Enemigos alcanzables, cámara legible y ausencia de bloqueos de movimiento causados por aliados.
- Medir densidad y tiempo de fotograma con el equipo lleno; no afirmar rendimiento por el resultado headless.
- Probar construcciones de movilidad, daño en área y resistencia, con y sin evoluciones.

## Decisiones aún abiertas

La revisión documental ya identifica los límites de huecos, funciones de tomos, categorías de objetos, santuarios, economía, etapas, Final Swarm y metaprogresión. Falta validación directa de la versión objetivo: probabilidades, fórmulas y excepciones de acumulación, todas las variantes de interactuables, controles especiales y comportamiento exacto del jefe final. Las discrepancias encontradas se registran en INVESTIGACION.md. La experiencia con el prototipo resolverá cuatro frente a seis compañeros, cuánto pausan las elecciones, el presupuesto de daño y el grado de fidelidad a tipos/compatibilidades Pokémon.

## Adaptación concreta de exploración y finales

Esta tabla desarrolla los sistemas encontrados durante la investigación. Los nombres y representaciones Pokémon son propuestas nuestras.

| Sistema documentado | Adaptación | Regla jugable |
| --- | --- | --- |
| Charge Shrine | Zona de entrenamiento de un maestro | Permanecer en el círculo bajo presión; elegir una de tres mejoras al completarlo |
| Golden Charge Shrine | Maestro de élite | Mismo desafío espacial, con ofertas de calidad superior |
| Greed Shrine | Alijo del Team Rocket | Obtener recursos aceptando más dificultad para la expedición |
| Boss Curse | Baliza de desafío dominante | Añadir otro dominante al encuentro a cambio de otra recompensa si se vence |
| Microwave | Cramobot de expedición | Elegir un objeto para duplicar, pagar Pokédólares y perder otro de su rareza; usos limitados y costes visibles |
| Shady Guy / tienda | Comerciante itinerante | Comprar objetos concretos; distinguirlo de desbloqueos entre partidas |
| Vasijas y recipientes destructibles | Cajas y depósitos de suministros | Premiar rutas de exploración con recursos y pequeños beneficios; las notas 1.0.64 añadieron suerte a las vasijas |
| Cofres | Cápsulas de suministros | Gasto y recompensa de objetos; las incorporaciones de Pokémon siguen perteneciendo a las ofertas de nivel |
| Potenciadores temporales | Ataque X, Defensa X, Velocidad X y bayas | Efectos de duración limitada o recuperación inmediata, separados de objetos permanentes de la partida |
| Boss Portal | Baliza de una guarida | Encontrar y activar voluntariamente el encuentro de jefe |
| Portal de siguiente etapa | Paso entre rutas | Disponible tras vencer al jefe solo cuando quede otra etapa |
| Final Swarm | Estampida de Pokémon alterados | Supervivencia adicional de presión creciente; no tratarla como otra tienda o una etapa normal |
| Forest | Bosque Verde y rutas boscosas | Terreno con obstáculos, verticalidad y exploración |
| Desert | Desierto de Hoenn | Espacios abiertos, tormentas de arena y dificultades de visibilidad |
| Graveyard / Crypt | Torre Pokémon y ruinas subterráneas | Ruta especial con secciones cronometradas, llaves y guardianes, separada de las etapas normales |
| Jefe final que retira/devuelve armas por fases | Mewtwo que sella temporalmente compañeros | Mantener al inicial y devolver compañeros conforme se superen fases; señales claras y daño viable en todo momento |
| Hats y skins | Gorras, mochilas y trajes de entrenador | Recompensas cosméticas de desafíos, separadas de la fuerza del equipo |
| Quests y desbloqueos | Encargos de investigación de la Pokédex | Objetivos concretos que habilitan especies, MT, objetos, entrenadores y capacidad |
| Silver | Puntos de Liga | Moneda persistente de desbloqueos; distinta de los Pokédólares de una partida |
| Toggler | Preparación de la expedición | Activar/desactivar contenido elegible antes de la partida, sin cambiar la rareza de las ofertas |
| Refresh / Skip / Banish | Cambiar encuentro / pasar / excluir | Tres operaciones distintas sobre ofertas actuales o futuras; conservar costes y límites visibles |
| Desafíos y clasificación | Retos de entrenador y récords locales | Por ejemplo, vencer sin daño o con restricciones; clasificación en línea después de validar guardado y resultados |
| Mapa y niebla de guerra | Pokégear | Mostrar recorrido y puntos descubiertos; evitar buscar siempre en zonas ya visitadas |

La guía describe una cripta inicial, cuatro llaves custodiadas, una segunda cripta y Big Bob; también un enemigo que aparece al agotar el tiempo. La adaptación podría usar cuatro sellos protegidos por fantasmas y un guardián final, sin copiar el recorrido espacial. Las funciones exactas de otras estatuas y variantes de santuario se verificarán antes de implementarlas.

El final debe ofrecer el equivalente de avance, salida o supervivencia que corresponda al modo elegido. En nuestra interfaz nunca se ocultará si seguir significa buscar otro jefe, abandonar con resultados o entrar en una prueba de resistencia. La disponibilidad exacta de salida en cada modo del original requiere observación directa.

## Arquetipos de armas llevados a Pokémon

La fuente comunitaria consultada documenta 30 armas. Aquí se cubren sus patrones como candidatos de contenido; no son una lista de especies ya implementadas ni un compromiso de reproducir sus cifras. Las especies, compatibilidades y movimientos definitivos se revisarán en la fase de contenido.

| Arma / patrón documentado | Compañero candidato | Traducción visual y funcional |
| --- | --- | --- |
| Sword — barrido cercano | Scyther | Corte que alcanza varios objetivos |
| Flamewalker — estela de fuego | Magmar | Dejar terreno ardiente mientras se desplaza |
| Lightning Staff — descargas encadenadas | Pikachu | Rayos que saltan entre objetivos |
| Firestaff — proyectiles explosivos | Charmander | Bolas de fuego con impacto de área |
| Chunkers — rocas orbitales | Geodude | Rocas que giran alrededor del entrenador |
| Bone — proyectil que rebota | Cubone | Hueso que rebota entre enemigos |
| Bow — disparo penetrante | Rowlet | Hojas que atraviesan una fila |
| Revolver — ráfagas y rebotes | Remoraid | Ráfagas acuáticas que rebotan |
| Aegis — bloqueo y contraataque | Mr. Mime | Barrera que libera una onda defensiva |
| Bananarang — ida y vuelta | Marowak | Huesomerang con daño en ambos recorridos |
| Aura — daño de proximidad continuo | Lucario | Campo de aura alrededor del entrenador |
| Axe — proyectiles giratorios persistentes | Kleavor | Hachas de roca que cubren un área |
| Space Noodle — vínculo dañino | Tangela | Liana entre compañero y objetivo que daña al atravesarla |
| Sniper Rifle — precisión a larga distancia | Inteleon | Disparo de agua penetrante |
| Slutty Rocket — proyectiles guiados | Togekiss | Esferas de energía que buscan objetivos |
| Shotgun — abanico cercano | Blastoise | Descarga amplia; revisar control manual del original antes de fijarlo |
| Mines — trampas de proximidad | Forretress | Trampas que estallan al acercarse un enemigo |
| Wireless Dagger — proyectiles guiados con rebote | Staryu | Proyectiles estelares que cambian de objetivo |
| Frostwalker — frío y control cercanos | Glaceon | Estela o zona helada alrededor del recorrido |
| Tornado — remolino y empuje | Pidgeotto | Tornados que desplazan grupos |
| Dexecutioner — penetración y ejecución | Absol | Corte con remate contra enemigos debilitados |
| Blood Magic — crecimiento de vida por bajas | Zubat | Absorción que sostiene al entrenador |
| Black Hole — atracción y área | Gardevoir | Campo psíquico que reúne enemigos |
| Poison Flask — zonas de veneno | Koffing | Nubes persistentes de veneno |
| Katana — cortes rápidos al cercano | Scizor | Ataques rápidos sobre el enemigo próximo |
| Dragon's Breath — llama giratoria orientada | Charizard | Aliento de fuego que sigue amenazas |
| Dice — daño variable y escalado | Clefairy | Metrónomo con resultados visibles y crecimiento controlado |
| Hero Sword — barrido y onda frontal | Gallade | Corte cercano más onda de energía |
| Corrupted Sword — daño con poca vida | Bisharp | Ataques que ganan potencia cuando peligra el entrenador |
| Scythe — giro y carga contra élites | Aegislash | Barrido circular y ataque reforzado al cargar una condición |

El prototipo solo necesitará unas pocas familias bien diferenciadas: proyectil, área cercana, cadena y control. Desarrollar las 30 antes de probar las elecciones aumentaría el coste sin demostrar el núcleo.

## Cómo conservar las funciones de los 23 tomos documentados

Los nombres de la primera columna corresponden al catálogo comunitario. No copiamos sus porcentajes: hay discrepancias entre tablas y parches. Una técnica de apoyo ocupa el hueco de MT y puede beneficiar al entrenador/equipo; un entrenamiento es una mejora del compañero o de la expedición, sin crear otro emisor de daño. Esto preserva las funciones del original dentro de la idea de ataques asignables.

| Tomo | Función a conservar | Sustitución propuesta |
| --- | --- | --- |
| Agility | Movimiento | MT Agilidad como apoyo al entrenador |
| Cooldown | Cadencia | Entrenamiento de cadencia del equipo |
| Damage | Daño | MT Refuerzo |
| Evasion | Evasión | MT Doble Equipo de apoyo |
| Golden | Ingresos de la partida | MT Día de Pago o Moneda Amuleto |
| Health | Vida máxima | Entrenamiento de resistencia |
| Knockback | Empuje | MT Rugido o mejora de impacto |
| Precision | Probabilidad de crítico | MT Foco Energía |
| Projectile Speed | Velocidad de proyectiles | Entrenamiento del ataque a distancia |
| Regen | Recuperación | MT Acua Aro con aura de equipo |
| Shield | Protección regenerable | MT Pantalla Luz |
| Silver | Ganancia persistente | Bonus de investigación/Puntos de Liga |
| Size | Área | Entrenamiento de cobertura |
| Armor | Reducción de daño | MT Defensa Férrea de apoyo |
| Attraction | Recogida | Mejora de la bolsa de exploración |
| Bloody | Robo de vida | MT drenante que cure una parte al entrenador |
| Chaos | Estadística aleatoria | Entrenamiento experimental de la expedición |
| Cursed | Más dificultad | Desafío de encuentro peligroso con recompensa explícita |
| Duration | Duración | Entrenamiento de persistencia de efectos |
| Luck | Calidad de recompensas | Amuleto de fortuna de expedición |
| Quantity | Cantidad de proyectiles | Entrenamiento de disparo múltiple |
| Thorns | Represalia al recibir daño | Casco Dentado o técnica de represalia |
| XP | Ganancia de experiencia | Huevo Suerte o entrenamiento de aprendizaje |

Estas correspondencias preservan roles de juego; no afirman que las MT tengan estos efectos compartidos en el canon. Cuando un entrenamiento y una MT beneficien la misma estadística, la interfaz mostrará su contribución y el límite de acumulación.

## Ejemplo de una construcción de equipo

Ash empieza con Pikachu. Una oferta de reclutamiento presenta Geodude, Bulbasaur y Squirtle: elige Geodude para cubrir proximidad. En una oferta de entrenamiento aparece Rayo compatible con Pikachu y se asigna sin otro menú si su hueco está libre. Más adelante, una MT de apoyo defensivo permite sostener la posición mientras se carga una zona de entrenamiento. El jugador gasta Pokédólares en suministros, encuentra la baliza del dominante y decide si activar un desafío adicional antes del jefe. La pantalla de resultado explica el daño de cada compañero y qué se desbloqueó.

El ejemplo expresa el flujo objetivo; hoy solo funcionan selección, movimiento y combate básico. La siguiente entrega debe demostrar XP → tres opciones → nuevo compañero → MT → efecto observable antes de ampliar el catálogo.
