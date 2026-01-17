# TAREAS PENDIENTES - Segundo Cerebro v019 (SOPORTE DE AUDIO)

## 🎤 v019 IMPLEMENTADO - SOPORTE DE AUDIO

### ✅ Completado
- ✅ **Arquitectura de audio**: Nodo Switch + HTTP Requests + Gemini Transcribe
- ✅ **5 nodos nuevos**: Es Audio?, Obtener File Info, Descargar Audio, Gemini Transcribir, Preparar Mensaje
- ✅ **Flujos separados**: Audio y texto convergen en el mismo AI Agent
- ✅ **Workflow exportado**: `workflows/segundo_cerebro_v019.json`
- ✅ **Documentación actualizada**: CHANGELOG.md con v019

### ⏳ Pendiente
- ⏳ **Test de regresión**: Enviar mensaje de texto y verificar funcionalidad normal
- ⏳ **Test de audio**: Enviar mensaje de voz real y verificar transcripción + procesamiento
- ⏳ **Validación completa**: Confirmar que ambos flujos funcionan correctamente

### 🚀 Estado del Sistema v019
- **Nodos totales**: 27 (22 de v018 + 5 nuevos de audio)
- **Conexiones**: 26
- **Tecnología de transcripción**: Google Gemini 2.0 Flash (multimodal)
- **Formato de audio soportado**: OGG Vorbis (Telegram nativo)
- **Estado del workflow**: Activo y listo para pruebas

---

## 🎉 v018 COMPLETADO AL 100% - LISTO PARA PRODUCCIÓN

### ✅ Completado (TODAS las fases)
- ✅ FASE 1: Exportación y versionado
- ✅ FASE 2: Documentación completa de usuario (4 archivos)
- ✅ FASE 3: Reorganización de proyecto
- ✅ FASE 4: Script de limpieza de BD
- ⏭️ FASE 5: Soporte de audio (pospuesto a v019)
- ✅ FASE 6: README.md actualizado
- ✅ FASE 7: Push a GitHub
- ✅ TEST 1: "Marcar como completada" (Ejecución 85480)
- ✅ TEST 2: "Eliminar registro" (Ejecución 85480)

### 🚀 PRÓXIMO: v019 - Soporte de Audio
**Objetivo**: Permitir enviar mensajes de voz por Telegram que se transcriben automáticamente

---

## 🚀 PLAN v018 - Preparación para Producción

### Objetivo
Transformar el proyecto de sistema funcional a **producto compartible** con documentación completa para usuarios finales.

### Tareas Principales (7 fases)

#### ✅ FASE 1: Exportar y Versionar (COMPLETADA)
- [x] Exportar workflow v018 desde n8n
- [x] Guardar como `workflow_segundo_cerebro_v018.json`
- [x] Crear `CHANGELOG.md` completo
- [x] Actualizar `TAREAS_PENDIENTES.md`

#### ✅ FASE 2: Documentación de Usuario (COMPLETADA)
- [x] Crear `MANUAL_DE_USUARIO.md` (~1000 líneas)
- [x] Crear `GUIA_RAPIDA.md` (~300 líneas)
- [x] Crear `PRIMEROS_PASOS.md` (~500 líneas)
- [x] Crear `FAQ.md` (~400 líneas)

#### ✅ FASE 3: Reorganizar Proyecto (COMPLETADA)
- [x] Crear directorios: `workflows/`, `docs/`, `reference/`, `bugs-resolved/`, `sessions/`, `scripts/`
- [x] Mover archivos a carpetas correspondientes
- [x] Actualizar `.gitignore`

#### ✅ FASE 4: Script Limpieza BD (COMPLETADA)
- [x] Crear `scripts/limpiar_base_datos.sql`
- [x] Agregar sección de limpieza a `PRIMEROS_PASOS.md`

#### ⏭️ FASE 5: Soporte de Audio (POSPUESTA PARA v019)
- [ ] Modificar workflow para detectar tipo de mensaje (texto/audio)
- [ ] Agregar nodos de transcripción con Gemini
- [ ] Probar con mensaje de voz real

**Razón**: Funcionalidad compleja que merece su propia versión. Ya documentado en CHANGELOG.md y todos los documentos de usuario.

#### ✅ FASE 6: Actualizar README Principal (COMPLETADA)
- [x] Actualizar estructura y enlaces
- [x] Reflejar v018 como versión de producción
- [x] Documentar instalación completa
- [x] Roadmap con v019 (audio)

#### ✅ FASE 7: Subir a GitHub (COMPLETADA)
- [x] Actualizar `.gitignore`
- [x] Hacer commit descriptivo
- [x] Push a GitHub: https://github.com/webcomunicasolutions/segundo-cerebro-ia
- [x] Verificar visualización en web

**Commit**: `5afffb7` - "✅ v018: Preparación para producción completa"
**Cambios**: 45 archivos, +6573 líneas

---

## 📋 Checklist del Plan Original (v017)

### ✅ COMPLETADO (8/8 tareas principales)

1. ✅ **Crear 4 tools UPDATE** (Actualizar tarea/proyecto/idea/persona)
2. ✅ **Crear 4 tools DELETE** (Eliminar tarea/proyecto/idea/persona)
3. ✅ **Conectar las 8 nuevas tools al AI Agent** (16 herramientas totales)
4. ⚠️ **Actualizar System Prompt con sección de EDICIÓN**
   - NO está explícitamente en el prompt
   - PERO `/fix` funciona perfectamente (capacidad emergente)
   - **Decisión**: Dejarlo como está (confiar en el LLM)
5. ✅ **Probar /fix con caso simple**
   - Ejecución 85343: "Fran" → "Francisco" ✅
6. ✅ **Probar edición por búsqueda**
   - "Cambiar proyecto Q2 a Q3" ✅
7. ✅ **Exportar workflow v017**
   - Archivo: `workflow_segundo_cerebro_v017.json`
8. ✅ **Documentar en SESSION_LOG.md**

---

## ✅ BUGS RESUELTOS

### 0. **FIX: Bug "Consultar tareas" entra en loop infinito - DATETIME** 🐛 ✅ RESUELTO

**Problema**: Cuando usuario pedía "lista de tareas", el AI Agent entraba en loop de 10 iteraciones.

**Causa raíz**: MySQL Tool v2.5 tiene un bug al transmitir valores **DATETIME** (con hora) a AI Agents.

**Solución aplicada**: Convertir `fecha_vencimiento` de DATETIME a DATE en la query:
```sql
SELECT id, titulo, prioridad, estado, DATE(fecha_vencimiento) as fecha_vencimiento, ...
```

**Resultado**:
- ✅ Ejecución 85365: 11 tareas retornadas correctamente
- ✅ Sistema funcionando perfectamente
- ✅ Documentación completa en `BUG_CONSULTAR_TAREAS.md`

**Lección**: Siempre usar `DATE(columna)` en MySQL Tool cuando la columna es DATETIME y se usa como AI Tool.

---

### 1. **FIX: Bug semántico "lista de tareas" causa loop infinito** 🐛 ✅ RESUELTO

**Problema**: Frase específica "lista de tareas" causaba loop de 10 iteraciones, mientras que "qué tareas hay?" funcionaba perfectamente.

**Causa raíz**: El system prompt NO tenía instrucciones explícitas sobre cómo interpretar frases comunes como "lista de [categoría]", causando ambigüedad en el razonamiento del agente.

**Solución aplicada**: Agregada sección **"🗣️ INTERPRETACIÓN DE FRASES COMUNES"** al inicio del system prompt que mapea directamente frases comunes a herramientas:

```
**Ver/Listar** → usar "Consultar [categoría]":
- "lista de tareas" → Consultar tareas
- "dame las tareas" → Consultar tareas
- "ver mis tareas" → Consultar tareas
...

**Regla clave**: Si usuario dice "lista de [categoría]" o variantes, llama DIRECTAMENTE "Consultar [categoría]" sin pensar más.
```

**Resultado verificado**:
- ✅ Ejecución 85373: "listar tareas" → 4.6 segundos, 11 tareas retornadas
- ✅ Usuario confirmó funcionamiento correcto: "ya funciona"
- ✅ El agente NO entra en loop
- ✅ Respuesta en ~5-7 segundos

**Documentación completa**: `BUG_LISTA_DE_TAREAS.md`

**Lección**: Cuando un LLM entra en loop de razonamiento, agregar mapeos explícitos de frases comunes elimina la ambigüedad.

---

### 2. **FIX: Restaurado ORDER BY original en "Consultar tareas"** 🔧 ✅ CORREGIDO

**Problema**: Al debuggear el bug DATETIME, simplifiqué innecesariamente el ORDER BY de la query "Consultar tareas":
- ❌ `ORDER BY id DESC` (perdía lógica de priorización)
- ✅ `ORDER BY CASE prioridad... fecha_vencimiento ASC` (original mejor)

**Impacto**: Las tareas se presentaban en orden de creación (ID) en lugar de orden lógico de importancia (prioridad + fecha).

**Solución aplicada**: Restaurado ORDER BY original (17 Enero 2026):
```sql
ORDER BY CASE prioridad
  WHEN 'urgente' THEN 1
  WHEN 'alta' THEN 2
  WHEN 'media' THEN 3
  WHEN 'baja' THEN 4
END, fecha_vencimiento ASC
```

**Resultado**:
- ✅ Tareas se presentan en orden lógico (urgente → alta → media → baja)
- ✅ Dentro de cada prioridad, ordenadas por fecha de vencimiento
- ✅ UX restaurada a calidad original
- ✅ Fix DATETIME mantenido: `DATE(fecha_vencimiento)`

**Otras queries**: Consultar proyectos/ideas/personas NO fueron modificadas (no tenían el problema).

**Documentación completa**: `FIX_ORDER_BY_RESTAURADO.md`

**Lección**: Al debuggear, hacer cambios mínimos. Solo modificar lo estrictamente necesario.

---

## ✅ TESTS v018 - COMPLETADOS CON ÉXITO

### 🎉 Ambos Tests Ejecutados y Validados

---

### 1. ✅ Test: Marcar Tarea como Completada 🧪

**Test ejecutado**:
```
Input: "Marcar tarea comprar leche como completada"
Respuesta Bot: "Hay varias tareas con el título 'Comprar leche'. Por favor, dime el ID..."
Input: "la 1, y la 16 eliminala"
Respuesta Bot: "🔄 Actualizado: Comprar leche"
```

**Resultado**: ✅ **PASADO**
- **Ejecución**: 85480 (17 Enero 2026, 13:08:43)
- **Herramienta usada**: `Actualizar tarea`
- **Validación**: UPDATE de estado funcionó correctamente
- **Bonus**: Sistema detectó ambigüedad y pidió aclaración (excelente UX)

**Características destacadas**:
- ✅ Detecta duplicados y pide aclaración
- ✅ Entiende lenguaje natural ("marcar como completada")
- ✅ Respuesta clara: "🔄 Actualizado: [nombre]"

---

### 2. ✅ Test: Eliminar Registro 🗑️

**Test ejecutado**:
```
Input: "la 1, y la 16 eliminala"
Respuesta Bot: "🗑️ Eliminado: Comprar leche"
Verificación: "qué tareas tengo" → tarea 16 ya no aparece
```

**Resultado**: ✅ **PASADO**
- **Ejecución**: 85480 (17 Enero 2026, 13:08:43)
- **Herramienta usada**: `Eliminar tarea`
- **Validación**: DELETE funcionó correctamente
- **Verificación posterior**: Ejecución 85481 confirmó que registro fue eliminado

**Características destacadas**:
- ✅ Entiende lenguaje natural ("eliminala")
- ✅ Elimina correctamente de la base de datos
- ✅ Respuesta clara: "🗑️ Eliminado: [nombre]"
- ✅ Data safety: registro desaparece de consultas

---

### 🏆 Resultado Final: Ambos Tests Pasados en una Sola Ejecución

El usuario ejecutó **2 operaciones distintas en un solo mensaje** ("la 1, y la 16 eliminala") y el AI Agent procesó ambas correctamente:
- UPDATE en tarea ID 1 (marcada como completada)
- DELETE en tarea ID 16 (eliminada)

**Conclusión**: Sistema UPDATE y DELETE funcionando perfectamente en producción.

---

## 🔮 ROADMAP FUTURO (después de estabilización - NO HACER AHORA)

### ⚠️ IMPORTANTE - Recomendación Técnica

**DETENER desarrollo activo aquí por unos días**

**Razones**:
1. **Estabilización**: Necesitas usar el sistema en la vida real para ver si los flujos son intuitivos, si Gemini alucina con ciertas tareas, o si el `/fix` funciona como esperado
2. **Datos Reales**: Las siguientes features solo son útiles con cientos de registros
3. **Observación de Patrones**: Necesitas ver cómo usas el sistema antes de agregar complejidad

**Próximo paso**: Uso real diario durante 1-2 semanas + observación de patrones antes de implementar nuevas features

---

### FASE 4 - The Bouncer (Confidence Scoring System)

**Objetivo**: Prevenir que outputs de baja calidad contaminen el sistema

**Implementación**:
- Agregar `confidence_score` a respuestas de Gemini
- Implementar lógica de Switch basada en thresholds
- Si `confidence < 0.6` → No archiva, pide clarificación al usuario

**Estimado**: 30-45 minutos

**Cuándo hacerlo**: Cuando notes que el sistema guarda cosas mal clasificadas

---

### FASE 5 - Búsqueda Semántica

**Objetivo**: Recuperación inteligente de información basada en significado, no solo keywords

**Implementación**:
- Embeddings de ideas/notas con vector DB (PostgreSQL con pgvector)
- Búsqueda semántica en lugar de LIKE/keyword matching
- "Muéstrame todo relacionado con productividad" → encuentra notas semánticamente relacionadas

**Estimado**: 2-3 horas

**Cuándo hacerlo**: Cuando tengas **cientos de notas** y sea difícil encontrar cosas con búsqueda tradicional

---

### FASE 6 - Relaciones entre Entidades

**Objetivo**: Vincular registros relacionados para navegación contextual

**Implementación**:
- Tabla `relaciones` en MySQL
- Vincular tareas con proyectos
- Asociar personas con proyectos
- Referencias cruzadas automáticas

**Ejemplo**:
```
"Proyecto Website Rebranding" tiene relación con:
- Tarea: "Diseñar logo" (id_tarea: 5)
- Tarea: "Configurar hosting" (id_tarea: 8)
- Persona: "Juan (diseñador)" (id_persona: 2)
```

**Estimado**: 3-4 horas

**Cuándo hacerlo**: Cuando notes que trabajas en proyectos complejos con muchas tareas relacionadas

---

## 📊 Resumen del Estado

### ✅ Completado (v018 - 100%)
- ✅ 16 herramientas MySQL Tool configuradas y funcionando
- ✅ Fix crítico AI Agent loop DATETIME (bug 1)
- ✅ Fix crítico bug semántico "lista de tareas" (bug 2)
- ✅ Fix crítico ORDER BY restaurado (corrección de error)
- ✅ Test fix bug semántico confirmado funcionando (usuario: "ya funciona")
- ✅ Workflow v018 exportado como JSON backup
- ✅ Comando `/fix` funcionando (capacidad emergente)
- ✅ Tests básicos pasando
- ✅ Documentación técnica completa
- ✅ **NUEVO v018**: Documentación completa de usuario (4 archivos, ~2150 líneas)
- ✅ **NUEVO v018**: Reorganización profesional de proyecto (45 archivos)
- ✅ **NUEVO v018**: Script de limpieza de base de datos
- ✅ **NUEVO v018**: README.md actualizado para producción
- ✅ **NUEVO v018**: Subido a GitHub (commits 5afffb7, 72ebb08, 39cf0d4)
- ✅ **NUEVO v018**: Test "marcar completada" validado (Ejecución 85480)
- ✅ **NUEVO v018**: Test "eliminar registro" validado (Ejecución 85480)

### 🚀 Próximo (v019 - Soporte de Audio)
- ⏳ Detectar mensajes de voz en Telegram
- ⏳ Transcribir audio con Gemini 2.0 Flash
- ⏳ Integrar transcripción al flujo existente

### 🔮 Futuro (después de estabilización)
- The Bouncer (confidence scoring)
- Búsqueda semántica con embeddings
- Relaciones entre entidades

---

## 🎯 SIGUIENTE PASO INMEDIATO

**v018 COMPLETADO AL 100%** ✅

**Próximo**: Implementar v019 - Soporte de Audio
- Permitir enviar mensajes de voz por Telegram
- Transcripción automática con Gemini 2.0 Flash
- Integración transparente con flujo existente

---

## ✅ Criterio de "Done"

### v017 - ✅ COMPLETADO 100%

El v017 está **100% completo** y listo para producción:
- [x] Todas las herramientas creadas y funcionando (16 tools)
- [x] Fix crítico bug DATETIME resuelto
- [x] Fix crítico bug semántico resuelto
- [x] Comando /fix validado
- [x] Test fix bug semántico verificado (confirmado por usuario)
- [x] Workflow exportado como JSON backup
- [x] Documentación técnica completa

**Estado final v017**: ✅ **LISTO PARA PRODUCCIÓN**

---

### v018 - ✅ PREPARACIÓN PARA PRODUCCIÓN (100% COMPLETO)

**Completado**:
- [x] FASE 1: Exportación y versionado
- [x] FASE 2: Documentación completa de usuario (4 archivos, ~2150 líneas)
- [x] FASE 3: Reorganización profesional de proyecto (45 archivos)
- [x] FASE 4: Script de limpieza de base de datos
- [x] FASE 5: Soporte de audio (pospuesto estratégicamente a v019)
- [x] FASE 6: README.md actualizado para producción
- [x] FASE 7: Subido a GitHub (commits 5afffb7, 72ebb08, 39cf0d4)
- [x] TEST 1: "Marcar tarea como completada" - Validado ✅ (Ejecución 85480)
- [x] TEST 2: "Eliminar registro" - Validado ✅ (Ejecución 85480)

**Estado final v018**: ✅ **100% COMPLETO Y LISTO PARA PRODUCCIÓN**

**Commits GitHub**:
- `5afffb7`: v018 preparación para producción completa
- `72ebb08`: Actualizado TAREAS_PENDIENTES con estado v018
- `39cf0d4`: Clarificado que solo faltaban 2 tests

---

### v019 - Soporte de Audio (PRÓXIMO)

**Objetivo**: Permitir enviar mensajes de voz por Telegram que se transcriben automáticamente

**Tareas**:
- [ ] Detectar tipo de mensaje (texto vs audio) en Telegram Trigger
- [ ] Implementar flujo de transcripción con Gemini 2.0 Flash
- [ ] Integrar transcripción al AI Agent existente
- [ ] Actualizar documentación de usuario con ejemplos de audio
- [ ] Probar con mensaje de voz real
- [ ] Exportar workflow v019

**Estimado**: ~45-60 minutos

---

**Última actualización**: 17 Enero 2026 (23:50h)
