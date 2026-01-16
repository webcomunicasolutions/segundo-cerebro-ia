# Changelog - Workflow segundo_cerebro

Control de versiones del workflow `segundo_cerebro` (ID: `ZI6VUFdg6hEhnCbh`)

## Convención de nombres

```
vXXX_descripcion_corta.json
```

- `XXX`: Número de versión (001, 002, etc.)
- `descripcion_corta`: Cambio principal en snake_case

---

## Versiones

### segundo_cerebro_digest - Workflow de Digests (2026-01-16)
**Archivo**: `segundo_cerebro_digest.json`
**ID n8n**: `EwLfBh9xXfajs9Z5`

**Estado**: ✅ ESTABLE - PRODUCCION

**Funcionalidad**:
- **Digest Diario** (7:00 AM Lun-Vie): Tareas urgentes y del día
- **Digest Semanal** (Dom 9:00 AM): Resumen completo con estadísticas

**Arquitectura (evita duplicación)**:
```
Schedule Semanal ─┬→ Query Stats    ─┐
                  ├→ Query Tareas   ─┼→ Merge → Aggregate → Code → Gmail
                  └→ Query Proyectos─┘
```

**Nodos**: 12
- 2 Schedule Triggers (cron)
- 4 MySQL Queries (tareas hoy, stats, tareas detalle, proyectos)
- 1 Merge (append - combinar queries paralelas)
- 1 Aggregate (consolidar en 1 item)
- 2 Code (formateo HTML diario/semanal)
- 2 Gmail (envío de emails)

**Credenciales**:
- MySQL: segundo_cerebro
- Gmail: info@optimizaconia.es

---

### v014 - Fechas en Español DD-MM-YYYY (2026-01-16)
**Archivo**: `versions/v014_fechas_espanol.json`

**Estado**: ✅ ESTABLE

**Cambios**:
- System prompt con `{{ $now.format('DD-MM-YYYY') }}` para fecha actual
- Prefijo `=` en systemMessage para evaluación de expresiones n8n
- Formato español DD-MM-YYYY en respuestas al usuario
- Formato YYYY-MM-DD para almacenamiento MySQL

---

### v013 - Consultas SELECT + Bouncer (2026-01-16)
**Archivo**: `versions/v013_consultas_bouncer.json`

**Estado**: ✅ ESTABLE

**Cambios**:
- 4 nuevas MySQL Tools de consulta (SELECT):
  - Consultar tareas pendientes
  - Consultar proyectos activos
  - Consultar ideas recientes
  - Consultar personas
- The Bouncer: Detección de incertidumbre con preguntas de clarificación
- System prompt mejorado con instrucciones de consulta

---

### v012 - PARA Expandido con Campos Completos (2026-01-16)
**Archivo**: `versions/v012_full_para_expanded.json`

**Estado**: ✅ ESTABLE

**Cambios**:
- Tool Tareas: +fecha_vencimiento, +contexto_adicional
- Tool Proyectos: +fecha_limite
- Tool Ideas: +tags (JSON array)
- Tool Personas: +datos_contacto (JSON object)
- System prompt con reglas de fechas y ENUMs estrictos

---

### v011 - Proyectos y Personas con $fromAI (2026-01-15)
**Archivo**: `versions/v011_proyectos_personas_fromAI.json`

**Estado**: ✅ ESTABLE

**Cambios**:
- Tool Proyectos corregida con patrón $fromAI()
- Tool Personas corregida con patrón $fromAI()
- Todas las 4 tools usan el mismo patrón consistente

---

### v010 - Cuatro Tools Completas (2026-01-14)
**Archivo**: `versions/v010_cuatro_tools.json`

**Estado**: ✅ ESTABLE - FASE 3 COMPLETADA

**Cambios**:
- 4 MySQL Tools configuradas con patrón `$fromAI()`:
  - **Insertar en tareas**: titulo, prioridad
  - **Insertar en ideas**: titulo, contenido, tipo
  - **Insertar en proyectos**: nombre, estado
  - **Insertar en personas**: nombre, relacion
- System prompt con especificaciones de campos para las 4 herramientas
- Ejemplos claros de clasificación para cada tipo

**Resultados probados en BD (2026-01-14)**:
- Tareas: "Llamar al dentista urgente" → prioridad=urgente ✅
- Ideas: "Artículo sobre IA" → tipo=recurso ✅
- Proyectos: "Rediseño app para Q2" → estado=activo ✅
- Personas: "María García, clienta" → relacion=cliente ✅

---

### v009 - Tareas + Ideas ✅ FUNCIONA (2026-01-14)
**Archivo**: `versions/v009_tareas_ideas.json`

**Estado**: ✅ ESTABLE

**Cambios**:
- 2 MySQL Tools funcionando:
  - **Insertar en tareas**: titulo, prioridad
  - **Insertar en ideas**: titulo, contenido, tipo
- System prompt simplificado para 2 tipos

**Resultados probados**:
- Tareas: "Llamar al dentista urgente" → prioridad=urgente ✅
- Ideas: "Artículo sobre IA" → tipo=recurso ✅

---

### v008 - Tareas 2 Campos ✅ FUNCIONA (2026-01-14)
**Archivo**: `versions/v008_tareas_2_campos.json`

**Estado**: ✅ ESTABLE - Primera versión funcional

**Cambios**:
- Tool "Insertar en tareas" simplificada a 2 campos: titulo, prioridad
- Eliminados campos que causaban errores ENUM (estado, etc.)
- Patrón correcto: `$fromAI('campo', '', 'string')`

**Resultado probado**:
```
Input: "Comprar leche"
Output: ✅ TAREA guardada, Prioridad: media, Guardado en: tareas
SQL: INSERT INTO tareas (titulo, prioridad) VALUES ('Comprar leche', 'media')
```

---

### v007 - Solo Tareas (2026-01-14)
**Archivo**: `versions/v007_solo_tareas.json`

**Cambios**:
- Simplificado a UNA sola tool: "Insertar en tareas"
- Eliminadas tools: proyectos, ideas, personas (se añadirán después)
- System prompt específico solo para tareas
- Campos: titulo (obligatorio) + prioridad (obligatorio)
- Instrucciones claras de cómo determinar prioridad

**Nodos**: 7
1. Telegram Trigger
2. Guardar en inbox_log
3. AI Agent
4. Google Gemini Chat Model (2.5 Flash)
5. Postgres Chat Memory
6. Responder en Telegram
7. Insertar en tareas (MySQL Tool)

**Objetivo**: Hacer funcionar perfectamente una tool antes de añadir más.

---

### v006 - System Prompt Detallado (2026-01-14)
**Archivo**: `versions/v006_system_prompt_detallado.json`

**Cambios**:
- System prompt reescrito con instrucciones específicas por herramienta
- Especifica campos OBLIGATORIOS y OPCIONALES para cada tool
- Lista valores válidos para ENUMs (prioridad, estado, tipo)
- Instrucción explícita: "NO envíes campos vacíos"
- Tool "Insertar en tareas" simplificada: solo titulo + prioridad
- Modelo cambiado a Gemini 2.5 Flash (por el usuario)

**Problema solucionado**:
- El agente enviaba campos desordenados y vacíos
- Campos ENUM recibían valores incorrectos (ej: estado='media')

---

### v005 - Ideas con $fromAI (2026-01-14)
**Archivo**: `versions/v005_ideas_fromAI.json`

**Cambios**:
- Tool "Insertar en ideas" actualizada con patrón `$fromAI()`
- Usa `dataMode: defineBelow` + `valuesToSend` con expresiones dinámicas
- Campos configurados: titulo, contenido, tipo, origen_url, tags
- Patrón aprendido de correcciones del usuario en "Insertar en tareas"

**Patrón clave**:
```javascript
"value": "={{ /*n8n-auto-generated-fromAI-override*/ $fromAI('nombreCampo', ``, 'string') }}"
```

---

### v004 - MySQL Tools con typeColumnMapping (2026-01-14)
**Archivo**: `versions/v004_mysql_tools_typeColumnMapping.json`

**Cambios**:
- Añadido `dataMode: autoMapInputData` con `typeColumnMapping`
- Intento de filtrar columnas para evitar error de campos desconocidos
- **Estado**: En prueba - puede no funcionar

**Nodos**: 10
- Telegram Trigger
- Guardar en inbox_log
- AI Agent (con system prompt actualizado)
- Google Gemini Chat Model
- Postgres Chat Memory
- Responder en Telegram
- Insertar en tareas (MySQL Tool)
- Insertar en proyectos (MySQL Tool)
- Insertar en ideas (MySQL Tool)
- Insertar en personas (MySQL Tool)

---

### v003 - MySQL Tools básicas (2026-01-14)
**Archivo**: `versions/v003_mysql_tools_basicas.json` (no guardado)

**Cambios**:
- Primera implementación de 4 MySQL Tools
- Error: campos `success` y `toolCallId` insertados erróneamente

---

### v002 - Fase 3 Clasificador (2026-01-14)
**Archivo**: `segundo_cerebro_fase3.json`

**Cambios**:
- AI Agent con Gemini 2.0 Flash
- Postgres Chat Memory para contexto
- System prompt PARA para clasificación
- Corrección de referencias explícitas a nodos

**Nodos**: 6

---

### v001 - Hello World (2026-01-13)
**Archivo**: `01_telegram_hello_world.json`

**Cambios**:
- Workflow inicial Fase 2
- Telegram Trigger + respuesta simple

**Nodos**: 2

---

## Cómo restaurar una versión

```bash
# 1. Copiar el archivo de versión al workflow principal
cp versions/vXXX_nombre.json segundo_cerebro_fase3.json

# 2. Importar en n8n via API
curl -X PUT "https://n8n-n8n.yhnmlz.easypanel.host/api/v1/workflows/ZI6VUFdg6hEhnCbh" \
  -H "X-N8N-API-KEY: $N8N_API_KEY" \
  -H "Content-Type: application/json" \
  -d @segundo_cerebro_fase3.json
```

---

## Notas

- Siempre guardar versión ANTES de hacer cambios importantes
- El archivo `segundo_cerebro_fase3.json` es la versión "activa" documentada
- Las versiones en `versions/` son snapshots históricos
