# Registro de Sesiones - Segundo Cerebro

## Sesion Actual: Fase 3 - Inteligencia con Gemini

**Fecha**: 14 de enero de 2026
**Estado**: ✅ COMPLETADA

---

## Fase 3: Configuracion Completada

### Cambios Realizados

#### 1. Workflow Actualizado via API
- **ID**: `ZI6VUFdg6hEhnCbh`
- **Nombre**: `segundo_cerebro`
- **URL**: https://n8n-n8n.yhnmlz.easypanel.host/workflow/ZI6VUFdg6hEhnCbh

#### 2. Nodos Configurados (6 total)

| Nodo | Configuracion | Estado |
|------|---------------|--------|
| Telegram Trigger | Recibe mensajes | OK |
| Guardar en inbox_log | INSERT SQL configurado | OK |
| AI Agent | System prompt PARA configurado | OK |
| Google Gemini Chat Model | gemini-2.0-flash, temp 0.1 | OK |
| Postgres Chat Memory | Session key por usuario | OK |
| Responder en Telegram | Output del agente | OK |

#### 3. Flujo Implementado

```
Telegram Trigger
      |
      v
Guardar en inbox_log (MySQL)
      |
      v
AI Agent <-- Gemini 2.0 Flash
    ^             |
    |             v
    +-- Postgres Memory
      |
      v
Responder en Telegram
```

#### 4. Credenciales Utilizadas

| Credencial | Tipo | ID |
|------------|------|-----|
| segundo_cerebro_pkm_bot | Telegram | RzgkIinUIV35wSlO |
| segundo_cerebro | MySQL | yTsefijtH5HVvPzn |
| webcomunica api pago | Gemini | EDGpeO8sJi8YCJQz |
| Postgres NOCODB | PostgreSQL | fcCn0Gs1u8rDVAxO |

#### 5. System Prompt del AI Agent

```
Eres un clasificador inteligente para un sistema de Segundo Cerebro.

Categorias:
- TAREA: Acciones ejecutables (verbo + objeto)
- PROYECTO: Esfuerzos con objetivo/fecha limite
- IDEA: Notas, recursos, aprendizajes
- PERSONA: Informacion de contactos

Formato de respuesta:
[CATEGORIA] Titulo sugerido
Prioridad: baja/media/alta/urgente (solo TAREA)
Razonamiento: explicacion breve
```

#### 6. Query SQL para inbox_log

```sql
INSERT INTO inbox_log (
  usuario_id,
  mensaje_crudo,
  payload_json,
  estado,
  canal_origen
) VALUES (
  '{{ $json.message.from.id }}',
  '{{ $json.message.text }}',
  '{{ JSON.stringify($json.message) }}',
  'pendiente',
  'telegram'
)
```

---

## Prueba Completada

### Errores Corregidos por el Usuario

| Nodo | Error Original | Corrección |
|------|----------------|------------|
| AI Agent | Faltaba `promptType: "define"` y campo `text` | Agregado `promptType: "define"` + `text: "={{ $('Telegram Trigger').item.json.message.text }}"` |
| Postgres Memory | `sessionKey: "={{ $json.message.from.id }}"` | Corregido a `"={{ $('Telegram Trigger').item.json.message.from.id }}"` |

### Lección Aprendida

**Cuando hay nodos intermedios** (como MySQL entre Telegram y Agent), hay que usar **referencias explícitas** al nodo origen:
- `$('Telegram Trigger').item.json.message.text`
- NO usar `$json.message.text` (esto referencia el nodo anterior inmediato)

### Resultado de Prueba

**Input**: `Comprar leche`
**Output**: Workflow funcionando correctamente

---

## Archivos Actualizados

- `n8n/workflows/README.md` - Documentacion completa
- `n8n/workflows/segundo_cerebro_fase3.json` - Workflow exportado
- `SESSION_LOG.md` - Este archivo

---

## Actualización: MySQL Tools para el AI Agent

### Fecha: 14 de enero de 2026

Se añadieron 4 MySQL Tools al AI Agent para que pueda insertar directamente en las tablas específicas:

| Tool | Tabla | Descripción |
|------|-------|-------------|
| Insertar en tareas | tareas | Para acciones ejecutables (verbo + objeto) |
| Insertar en proyectos | proyectos | Para esfuerzos con objetivo/fecha límite |
| Insertar en ideas | ideas | Para notas, recursos, aprendizajes, enlaces |
| Insertar en personas | personas | Para información de contactos |

### System Prompt Actualizado

El AI Agent ahora tiene instrucciones para:
1. Analizar el mensaje del usuario
2. Clasificarlo en la categoría correcta
3. **USAR la herramienta MySQL correspondiente** para guardar
4. Confirmar al usuario qué se guardó y dónde

### Arquitectura Actualizada (10 nodos)

```
Telegram Trigger
      |
      v
Guardar en inbox_log (MySQL) ← Auditoría de todo lo que entra
      |
      v
AI Agent <── Gemini 2.0 Flash
    ^  |         |
    |  |         v
    |  +── Postgres Memory (contexto por usuario)
    |
    +── MySQL Tools (4 herramientas):
         ├── Insertar en tareas
         ├── Insertar en proyectos
         ├── Insertar en ideas
         └── Insertar en personas
      |
      v
Responder en Telegram
```

---

## Pruebas Exitosas (14 de enero 2026)

| Mensaje | Categoría | Resultado BD |
|---------|-----------|--------------|
| "Comprar leche" | TAREA | ✅ tareas.id=? prioridad=media |
| "Llamar al dentista urgente" | TAREA | ✅ tareas prioridad=urgente |
| "Artículo sobre IA" | IDEA | ✅ ideas tipo=recurso |
| "Rediseño app para Q2" | PROYECTO | ✅ proyectos.id=3 estado=activo |
| "María García, clienta" | PERSONA | ✅ personas.id=3 relacion=cliente |

## Patrón Técnico Clave Descubierto

**Problema**: MySQL Tool enviaba campos incorrectos (success, toolCallId)

**Solución**: Usar `dataMode: defineBelow` con `$fromAI()`:
```javascript
{
  "dataMode": "defineBelow",
  "valuesToSend": {
    "values": [
      {
        "column": "titulo",
        "value": "={{ $fromAI('titulo', '', 'string') }}"
      }
    ]
  }
}
```

## Control de Versiones de Workflows

Implementado sistema de versionado en `n8n/workflows/versions/`:
- v007: Solo tareas (primera prueba)
- v008: Tareas 2 campos ✅ primera versión funcional
- v009: Tareas + Ideas ✅
- v010: 4 Tools completas ✅ **VERSIÓN ESTABLE**

## Proximos Pasos (Fase 4)

1. [ ] Implementar "The Bouncer" (confidence scoring)
2. [ ] Herramientas de consulta SELECT ("¿Qué tareas tengo?")
3. [ ] Relacionar entidades ("Añadir tarea al proyecto X")
4. [ ] Digest diario automático

---

## Historial de Fases

### Fase 0: Blueprint
- Diseno de arquitectura
- Esquema de base de datos
- Especificacion tecnica

### Fase 1: Cimientos (MySQL)
- Setup de servidor MySQL
- Ejecucion de schema.sql
- Validacion de conexiones
- Inserciones de prueba

### Fase 2: Conexiones (Telegram + n8n)
- Bot de Telegram creado
- Credenciales configuradas
- Workflow Hello World funcionando

### Fase 3: Inteligencia (Gemini) - ✅ COMPLETADA
- AI Agent con Gemini 2.5 Flash
- Memoria con PostgreSQL
- Clasificacion automatica PARA
- Auditoria en inbox_log
- 4 MySQL Tools con patrón $fromAI()
- Control de versiones de workflows

---

---

## Fase 3.5: Corrección de Rumbo - PARA Expandido

**Fecha**: 16 de enero de 2026
**Estado**: ✅ COMPLETADA

### Problema Identificado

El workflow v010/v011 funcionaba pero con campos mínimos:
- Tareas: solo titulo + prioridad
- Proyectos: solo nombre + estado
- Ideas: titulo + contenido + tipo
- Personas: solo nombre + relacion

**Faltaban**: fechas, tags, datos de contacto, contexto adicional.

### Cambios Implementados via n8n-mcp API

#### 1. Tool "Insertar en tareas" Expandida

| Antes | Después |
|-------|---------|
| titulo, prioridad | titulo, prioridad, **fecha_vencimiento**, **contexto_adicional** |

```
toolDescription: "Insertar una TAREA. Campos: titulo (texto de la tarea), prioridad (SOLO: baja, media, alta, urgente), fecha_vencimiento (YYYY-MM-DD o null si no hay fecha), contexto_adicional (JSON con info extra o null)"
```

#### 2. Tool "Insertar en proyectos" Expandida

| Antes | Después |
|-------|---------|
| nombre, estado | nombre, estado, **fecha_limite** |

```
toolDescription: "Insertar un PROYECTO. Campos: nombre (texto), estado (SOLO: activo, en_espera), fecha_limite (YYYY-MM-DD o null)"
```

#### 3. Tool "Insertar en ideas" Expandida

| Antes | Después |
|-------|---------|
| titulo, contenido, tipo | titulo, contenido, tipo, **tags** |

```
toolDescription: "Insertar una IDEA. Campos: titulo (texto), contenido (descripción completa), tipo (SOLO: nota, recurso, aprendizaje), tags (JSON array ej: [\"tech\",\"n8n\"] o null)"
```

#### 4. Tool "Insertar en personas" Expandida

| Antes | Después |
|-------|---------|
| nombre, relacion | nombre, relacion, **datos_contacto** |

```
toolDescription: "Insertar una PERSONA. Campos: nombre (texto), relacion (SOLO: cliente, proveedor, amigo, colega, familia, otro), datos_contacto (JSON con email/telefono o null)"
```

#### 5. System Prompt Actualizado

Nuevo prompt con:
- **Fecha actual**: `{{ $now.format('YYYY-MM-DD') }}` para cálculo de fechas relativas
- **Reglas de fechas**: "mañana" → calcular fecha exacta YYYY-MM-DD
- **Enums estrictos**: valores permitidos explícitos con defaults
- **Formato JSON**: instrucciones para tags, datos_contacto, contexto_adicional
- **Ejemplos concretos**: 4 casos de uso detallados

### Versión del Workflow

- **n8n Version ID**: `f198ca95-afde-4a16-8d7e-e584eff7682e`
- **Version Counter**: 72 (desde 63)
- **Archivo exportado**: `n8n/workflows/versions/v012_full_para_expanded.json`

### Tests Recomendados (via Telegram)

1. **Tarea con fecha**: "Llamar al dentista mañana urgente"
   - Esperado: fecha_vencimiento = 2026-01-17, prioridad = urgente

2. **Idea con tags**: "Artículo sobre n8n https://docs.n8n.io"
   - Esperado: tipo = recurso, tags = '["n8n", "documentacion"]'

3. **Proyecto con deadline**: "Rediseño web para el 15 de febrero"
   - Esperado: fecha_limite = 2026-02-15

4. **Persona con contacto**: "Pedro López, proveedor, pedro@empresa.com"
   - Esperado: datos_contacto = '{"email": "pedro@empresa.com"}'

### Arquitectura Final (10 nodos, campos expandidos)

```
Telegram Trigger
      |
      v
Guardar en inbox_log (MySQL) ← Auditoría completa
      |
      v
AI Agent <── Gemini 2.0 Flash (temp 0.1)
    ^  |         |
    |  |         v
    |  +── Postgres Memory (contexto por usuario)
    |
    +── MySQL Tools (4 herramientas expandidas):
         ├── Insertar en tareas (4 campos)
         ├── Insertar en proyectos (3 campos)
         ├── Insertar en ideas (4 campos)
         └── Insertar en personas (3 campos)
      |
      v
Responder en Telegram
```

---

---

## Fase 4: Funcionalidades Avanzadas

**Fecha**: 16 de enero de 2026
**Estado**: ✅ COMPLETADA

---

### Fase 4.1: Consultas SELECT

#### Nuevas Tools Añadidas (4 tools de lectura)

| Tool | Query | Descripción |
|------|-------|-------------|
| Consultar tareas | `SELECT ... FROM tareas WHERE estado != 'completada' ORDER BY prioridad, fecha_vencimiento` | Lista tareas pendientes ordenadas por urgencia |
| Consultar proyectos | `SELECT ... FROM proyectos WHERE estado IN ('activo', 'en_espera')` | Lista proyectos activos |
| Consultar ideas | `SELECT ... FROM ideas ORDER BY created_at DESC` | Lista ideas recientes |
| Consultar personas | `SELECT ... FROM personas ORDER BY nombre ASC` | Lista contactos alfabéticamente |

#### Arquitectura Actualizada (14 nodos)

```
Telegram Trigger
      |
      v
Guardar en inbox_log (MySQL) ← Auditoría
      |
      v
AI Agent <── Gemini 2.0 Flash (temp 0.1)
    ^  |         |
    |  |         v
    |  +── Postgres Memory (contexto por usuario)
    |
    +── MySQL Tools INSERT (4):
    |    ├── Insertar en tareas
    |    ├── Insertar en proyectos
    |    ├── Insertar en ideas
    |    └── Insertar en personas
    |
    +── MySQL Tools SELECT (4):
         ├── Consultar tareas
         ├── Consultar proyectos
         ├── Consultar ideas
         └── Consultar personas
      |
      v
Responder en Telegram
```

#### Tests Exitosos

| Mensaje | Tool Usada | Resultado |
|---------|------------|-----------|
| "Qué tareas tengo?" | Consultar tareas | ✅ Lista ordenada por prioridad |
| "Mis proyectos" | Consultar proyectos | ✅ Proyectos activos |
| "Qué ideas guardé?" | Consultar ideas | ✅ Ideas recientes |
| "Mis contactos" | Consultar personas | ✅ Lista alfabética |

---

### Fase 4.2: The Bouncer - Detección de Incertidumbre

#### Concepto

"The Bouncer" es un filtro de calidad que previene que inputs ambiguos contaminen la base de datos. En lugar de adivinar, el sistema pide clarificación.

#### Implementación en System Prompt

```
## THE BOUNCER - FILTRO DE CALIDAD

⚠️ ANTES de usar cualquier herramienta, evalúa si el mensaje es CLARO.

### PEDIR CLARIFICACIÓN cuando:
- Mensaje de 1-2 palabras sin contexto: "María", "Reunión", "Web"
- No queda claro si es tarea, proyecto, idea o persona
- Falta información crítica para clasificar
- El mensaje es demasiado vago

### Formato de clarificación:
🤔 No estoy seguro de cómo clasificar esto.

¿Es una **tarea** (algo que hacer)?
¿Una **idea/nota** (algo que recordar)?
¿Un **proyecto** (objetivo grande)?
¿Una **persona** (contacto)?

### NO pedir clarificación cuando:
- Hay verbo de acción claro: "Comprar X", "Llamar a X"
- Hay contexto suficiente: "Artículo sobre IA https://..."
- Es una consulta obvia: "Qué tareas tengo?"
- Tiene formato reconocible: "Juan, cliente, juan@email.com"
```

#### Tests Recomendados para The Bouncer

| Mensaje Ambiguo | Respuesta Esperada |
|-----------------|-------------------|
| "María" | 🤔 Pedir clarificación |
| "Reunión" | 🤔 Pedir clarificación |
| "Web" | 🤔 Pedir clarificación |
| "Comprar pan" | ✅ Insertar tarea (verbo claro) |
| "Qué tareas tengo?" | ✅ Consultar (pregunta clara) |

---

### Versión del Workflow

- **n8n Version ID**: `ac8899b2-553f-4bce-844b-2f61638d1bf1`
- **Version Counter**: 85
- **Nodos**: 14 (6 base + 8 MySQL Tools)
- **Archivo exportado**: `n8n/workflows/versions/v013_consultas_bouncer.json`

---

## Control de Versiones de Workflows

| Versión | Descripción | Estado |
|---------|-------------|--------|
| v007 | Solo tareas (primera prueba) | Obsoleta |
| v008 | Tareas 2 campos | Obsoleta |
| v009 | Tareas + Ideas | Obsoleta |
| v010 | 4 Tools INSERT completas | Funcional |
| v011 | (skipped) | - |
| v012 | Full PARA expanded (fechas, tags, contacto) | Funcional |
| v013 | + Consultas SELECT + The Bouncer | Funcional |
| v014 | + Fechas español DD-MM-YYYY + $now dinámico | Funcional |
| v015 | + /fix + 4 UPDATE + 4 DELETE tools | **ESTABLE** ✅ |

---

### Fase 4.3: Fechas en Formato Español

#### Cambios Implementados

1. **System Prompt con fecha dinámica**:
   - `={{ $now.format('DD-MM-YYYY') }}` - se evalúa en tiempo real
   - Añadido `=` al inicio para que n8n evalúe la expresión

2. **Formato dual de fechas**:
   - **Mostrar al usuario**: DD-MM-YYYY (español)
   - **Guardar en MySQL**: YYYY-MM-DD (requerido por BD)

3. **Consultas SELECT con DATE_FORMAT**:
   - `DATE_FORMAT(fecha_vencimiento, '%d-%m-%Y')` para mostrar fechas en español

#### Lección Técnica Importante

En n8n, para que las expresiones `{{ }}` se evalúen dentro de un string, el valor debe comenzar con `=`:
```
❌ "Hoy es: {{ $now }}"           → NO se evalúa
✅ "=Hoy es: {{ $now }}"          → SÍ se evalúa
```

---

### Fase 4.4: Digest por Email - The Tap on the Shoulder

#### Concepto

"The Tap on the Shoulder" es el sistema de notificaciones proactivas que empuja información útil al usuario en el momento correcto, sin que tenga que pedirla.

#### Nuevo Workflow: `segundo_cerebro_digest`

**ID n8n**: `EwLfBh9xXfajs9Z5`
**Archivo**: `n8n/workflows/segundo_cerebro_digest.json`

#### Funcionalidades

| Tipo | Horario | Contenido |
|------|---------|-----------|
| **Digest Diario** | 7:00 AM (Lun-Vie) | Tareas urgentes y del día, prioridad visual |
| **Digest Semanal** | Domingos 9:00 AM | Estadísticas + lista de tareas + proyectos activos |

#### Arquitectura (evita duplicación de items)

```
                            ┌→ Query Stats     ─┐
Schedule Semanal Dom 9AM ───┼→ Query Tareas    ─┼→ Merge (append) → Aggregate → Code → Gmail
                            └→ Query Proyectos ─┘
```

**Problema resuelto**: Las queries en paralelo evitan multiplicación de items que causaba duplicación en el email.

**Solución técnica**:
1. **Ejecución paralela**: Las 3 queries se disparan simultáneamente
2. **Merge (append)**: Combina todos los resultados
3. **Aggregate**: Consolida en UN solo item
4. **Code node**: Se ejecuta UNA vez con `$('NodeName').all()` para obtener datos

#### Nodos del Workflow (12 total)

| Nodo | Tipo | Función |
|------|------|---------|
| Digest Diario 7AM | Schedule Trigger | Cron: `0 7 * * 1-5` |
| Digest Semanal Dom 9AM | Schedule Trigger | Cron: `0 9 * * 0` |
| Query Tareas Hoy | MySQL | Tareas urgentes y del día |
| Query Resumen Semana | MySQL | Estadísticas (UNION ALL) |
| Query Tareas Detalle | MySQL | Lista de tareas pendientes |
| Query Proyectos Detalle | MySQL | Lista de proyectos activos |
| Esperar Queries | Merge | Combina queries paralelas |
| Consolidar Items | Aggregate | Reduce a 1 item |
| Formatear Digest Diario | Code | HTML del email diario |
| Formatear Digest Semanal | Code | HTML del email semanal |
| Enviar Email Diario | Gmail | Envío automático |
| Enviar Email Semanal | Gmail | Envío automático |

#### Credenciales

- **MySQL**: segundo_cerebro (ID: yTsefijtH5HVvPzn)
- **Gmail**: info@optimizaconia.es (ID: RXx0XE0d0oYDaQvT)

#### Formato del Email

**Diario**:
- Fecha actual en español
- Lista de tareas con colores por prioridad (rojo=urgente, naranja=alta)
- Fecha de vencimiento si existe

**Semanal**:
- Tarjetas de estadísticas (pendientes, urgentes, proyectos, completadas)
- Lista detallada de tareas pendientes
- Lista de proyectos activos con fechas límite

#### Tests Realizados

| Test | Resultado |
|------|-----------|
| Digest semanal sin duplicación | ✅ Funciona correctamente |
| Formato HTML en email | ✅ Se ve correctamente |
| Queries paralelas | ✅ No hay multiplicación de items |

---

---

## Fase 4.5: /fix y Edición Completa - The Fix Button

**Fecha**: 16 de enero de 2026
**Estado**: ✅ COMPLETADA

### Concepto

"The Fix Button" implementa un mecanismo de corrección fácil para:
1. **`/fix`**: Corregir la última entrada (cambiar categoría o campos)
2. **Edición completa**: Modificar/eliminar cualquier registro existente por ID

### Nuevas Tools Añadidas (8 tools)

#### Tools UPDATE (4)

| Tool | Query | Descripción |
|------|-------|-------------|
| Actualizar tarea | `UPDATE tareas SET ... WHERE id=?` | Modifica campos de una tarea existente |
| Actualizar proyecto | `UPDATE proyectos SET ... WHERE id=?` | Modifica campos de un proyecto existente |
| Actualizar idea | `UPDATE ideas SET ... WHERE id=?` | Modifica campos de una idea existente |
| Actualizar persona | `UPDATE personas SET ... WHERE id=?` | Modifica campos de una persona existente |

**Patrón SQL usado**:
```sql
UPDATE tareas SET
  titulo = COALESCE(NULLIF('{{ $fromAI('titulo') }}', ''), titulo),
  prioridad = COALESCE(NULLIF('{{ $fromAI('prioridad') }}', ''), prioridad),
  estado = COALESCE(NULLIF('{{ $fromAI('estado') }}', ''), estado),
  fecha_vencimiento = CASE
    WHEN '{{ $fromAI('fecha_vencimiento') }}' = '' THEN fecha_vencimiento
    WHEN '{{ $fromAI('fecha_vencimiento') }}' = 'null' THEN NULL
    ELSE '{{ $fromAI('fecha_vencimiento') }}'
  END,
  updated_at = NOW()
WHERE id = {{ $fromAI('id') }}
```

**Técnica clave**: `COALESCE(NULLIF(...))` permite actualizar solo los campos que el agente envía, manteniendo los demás intactos.

#### Tools DELETE (4)

| Tool | Query | Descripción |
|------|-------|-------------|
| Eliminar tarea | `DELETE FROM tareas WHERE id=?` | Elimina una tarea por ID |
| Eliminar proyecto | `DELETE FROM proyectos WHERE id=?` | Elimina un proyecto por ID |
| Eliminar idea | `DELETE FROM ideas WHERE id=?` | Elimina una idea por ID |
| Eliminar persona | `DELETE FROM personas WHERE id=?` | Elimina una persona por ID |

### Arquitectura Actualizada (22 nodos)

```
Telegram Trigger
      |
      v
Guardar en inbox_log (MySQL) ← Auditoría
      |
      v
AI Agent <── Gemini 2.0 Flash (temp 0.1)
    ^  |         |
    |  |         v
    |  +── Postgres Memory (contexto por usuario)
    |
    +── MySQL Tools INSERT (4):
    |    ├── Insertar en tareas
    |    ├── Insertar en proyectos
    |    ├── Insertar en ideas
    |    └── Insertar en personas
    |
    +── MySQL Tools SELECT (4):
    |    ├── Consultar tareas
    |    ├── Consultar proyectos
    |    ├── Consultar ideas
    |    └── Consultar personas
    |
    +── MySQL Tools UPDATE (4):   ← NUEVO
    |    ├── Actualizar tarea
    |    ├── Actualizar proyecto
    |    ├── Actualizar idea
    |    └── Actualizar persona
    |
    +── MySQL Tools DELETE (4):   ← NUEVO
         ├── Eliminar tarea
         ├── Eliminar proyecto
         ├── Eliminar idea
         └── Eliminar persona
      |
      v
Responder en Telegram
```

### System Prompt - Nueva Sección de Edición

```
## EDICIÓN DE REGISTROS

### /fix - Corrección rápida (última entrada)
Cuando el usuario dice "/fix" o "corregir":
1. RECUERDA qué acabas de guardar (usa tu memoria de conversación)
2. Pregunta qué quiere corregir si no lo especifica
3. Usa Eliminar + Insertar para cambiar de categoría
4. Usa Actualizar para modificar campos

### Edición por búsqueda
Cuando el usuario quiere editar algo antiguo:
1. PRIMERO consulta para encontrar el registro
2. Muestra los resultados con sus IDs
3. Usa Actualizar/Eliminar con el ID correcto

### IMPORTANTE para DELETE
⚠️ SIEMPRE pedir confirmación antes de eliminar
```

### Flujos de Uso

#### Flujo /fix (corrección inmediata)
```
Usuario: "Comprar leche"
Bot: ✅ [TAREA] Comprar leche (id: 47)

Usuario: "/fix era una nota"
Bot: 🔄 **Corregido**
     ❌ Eliminado de tareas: "Comprar leche"
     ✅ Guardado en ideas: "Comprar leche"
```

#### Flujo Edición por Búsqueda
```
Usuario: "Cambiar el proyecto Web a Rebranding"
Bot: [Consulta proyectos, encuentra id=5 "Web"]
     🔄 **Actualizado**: Proyecto
        Antes: "Web"
        Ahora: "Rebranding"
```

#### Flujo Marcar Completada
```
Usuario: "Marcar tarea Comprar leche como completada"
Bot: [Busca tarea, actualiza estado]
     🔄 **Actualizado**: Tarea "Comprar leche"
        Estado: completada
```

### Tests Recomendados

| Test | Mensaje | Resultado Esperado |
|------|---------|-------------------|
| /fix simple | "Reunión" → "/fix es un proyecto" | Elimina tarea + Inserta proyecto |
| Edición campo | "Cambiar prioridad de Comprar leche a urgente" | UPDATE prioridad |
| Marcar completada | "Completar tarea X" | UPDATE estado='completada' |
| Eliminar | "Borrar la idea sobre IA" | DELETE tras confirmación |
| Renombrar | "Renombrar proyecto Web a Portal" | UPDATE nombre |

### Versión del Workflow

- **n8n Version ID**: `edd9f93b-e079-4a96-9769-8494995a15b5`
- **Version Counter**: 97
- **Nodos**: 22 (6 base + 16 MySQL Tools)
- **Archivo exportado**: `n8n/workflows/versions/v015_fix_y_edicion.json`

---

## Próximos Pasos (Fase 5)

1. [x] ~~Digest diario automático~~ ✅ COMPLETADO
2. [x] ~~Comando `/fix` para corregir última entrada~~ ✅ COMPLETADO
3. [ ] Búsqueda semántica con embeddings
4. [ ] Relacionar entidades ("Añadir tarea al proyecto X")

---

## Historial de Fases

### Fase 0: Blueprint
- Diseño de arquitectura
- Esquema de base de datos
- Especificación técnica

### Fase 1: Cimientos (MySQL)
- Setup de servidor MySQL
- Ejecución de schema.sql
- Validación de conexiones

### Fase 2: Conexiones (Telegram + n8n)
- Bot de Telegram creado
- Credenciales configuradas
- Workflow Hello World funcionando

### Fase 3: Inteligencia (Gemini) - ✅ COMPLETADA
- AI Agent con Gemini 2.0 Flash
- Memoria con PostgreSQL
- Clasificación automática PARA
- 4 MySQL Tools INSERT con patrón $fromAI()

### Fase 3.5: Corrección de Rumbo - ✅ COMPLETADA
- Tools expandidas con campos adicionales
- System Prompt mejorado con cálculo de fechas
- ENUMs estrictos y JSON formatting

### Fase 4: Funcionalidades Avanzadas - ✅ COMPLETADA
- 4.1: Consultas SELECT (leer datos)
- 4.2: The Bouncer (detección de incertidumbre)
- 4.3: Fechas en formato español DD-MM-YYYY
- 4.4: Digest por Email (The Tap on the Shoulder)
- 4.5: /fix y Edición Completa (The Fix Button)
- 22 nodos en workflow principal, 16 MySQL Tools
- 12 nodos en workflow digest

### Workflows Activos

| Workflow | ID | Nodos | Estado |
|----------|-----|-------|--------|
| segundo_cerebro | ZI6VUFdg6hEhnCbh | 22 | ✅ Activo |
| segundo_cerebro_digest | EwLfBh9xXfajs9Z5 | 12 | ✅ Listo para activar |

---

**Ultima actualizacion**: 16 de enero de 2026, 16:05
