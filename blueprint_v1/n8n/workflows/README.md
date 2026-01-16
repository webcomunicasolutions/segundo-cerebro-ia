# Workflows del Segundo Cerebro

Este directorio contiene los workflows de n8n para el sistema de Segundo Cerebro.

## Workflow Principal: `segundo_cerebro`

**ID**: `ZI6VUFdg6hEhnCbh`
**URL**: https://n8n-n8n.yhnmlz.easypanel.host/workflow/ZI6VUFdg6hEhnCbh
**Estado**: Activo
**Última actualización**: 14 de enero de 2026

### Arquitectura (Fase 3)

```
┌──────────────────┐
│ Telegram Trigger │ ← Recibe mensajes del bot @segundo_cerebro_pkm_bot
└────────┬─────────┘
         │
         v
┌──────────────────┐
│ Guardar en       │ ← INSERT en tabla inbox_log (auditoría)
│ inbox_log        │   MySQL: segundo_cerebro
└────────┬─────────┘
         │
         v
┌──────────────────┐
│    AI Agent      │ ← Clasifica mensaje con prompt PARA
│                  │
│  ┌─────────────┐ │
│  │ Gemini 2.0  │←┤ Modelo: gemini-2.0-flash
│  │   Flash     │ │ Temperatura: 0.1
│  └─────────────┘ │
│  ┌─────────────┐ │
│  │  Postgres   │←┤ Memoria de conversación por usuario
│  │   Memory    │ │ Session Key: message.from.id
│  └─────────────┘ │
└────────┬─────────┘
         │
         v
┌──────────────────┐
│ Responder en     │ ← Envía clasificación al usuario
│ Telegram         │   Formato: [CATEGORÍA] Título
└──────────────────┘
```

### Nodos (10 total)

| # | Nodo | Tipo | Función | Credencial |
|---|------|------|---------|------------|
| 1 | Telegram Trigger | telegramTrigger | Recibe mensajes | `segundo_cerebro_pkm_bot` |
| 2 | Guardar en inbox_log | mySql | Auditoría en MySQL | `segundo_cerebro` |
| 3 | AI Agent | agent | Clasificación con IA | - |
| 4 | Google Gemini Chat Model | lmChatGoogleGemini | Motor de IA | `webcomunica api pago` |
| 5 | Postgres Chat Memory | memoryPostgresChat | Memoria conversacional | `Postgres NOCODB` |
| 6 | Responder en Telegram | telegram | Envía respuesta | `segundo_cerebro_pkm_bot` |
| 7 | Insertar en tareas | mySqlTool | Tool para guardar tareas | `segundo_cerebro` |
| 8 | Insertar en proyectos | mySqlTool | Tool para guardar proyectos | `segundo_cerebro` |
| 9 | Insertar en ideas | mySqlTool | Tool para guardar ideas | `segundo_cerebro` |
| 10 | Insertar en personas | mySqlTool | Tool para guardar contactos | `segundo_cerebro` |

### Configuración de Nodos

#### 1. Telegram Trigger
```json
{
  "updates": ["message"]
}
```

#### 2. Guardar en inbox_log (MySQL)
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

#### 3. AI Agent - Configuración Completa

**IMPORTANTE**: Usar `promptType: "define"` y referenciar el nodo origen explícitamente.

```json
{
  "promptType": "define",
  "text": "={{ $('Telegram Trigger').item.json.message.text }}",
  "options": {
    "systemMessage": "..."
  }
}
```

**System Prompt** (actualizado con instrucciones para usar MySQL Tools):
```
Eres un asistente inteligente para un sistema de Segundo Cerebro basado en el método PARA.

## TU TAREA
Analiza el mensaje del usuario, clasifícalo y GUÁRDALO en la base de datos usando las herramientas disponibles.

## CATEGORÍAS
- **TAREA**: Acciones ejecutables (verbo + objeto). Ej: "Comprar leche", "Llamar a Juan"
- **PROYECTO**: Esfuerzos con objetivo/fecha límite. Ej: "Lanzar website para marzo"
- **IDEA**: Notas, recursos, aprendizajes, enlaces. Ej: "Artículo interesante sobre IA"
- **PERSONA**: Información de contactos. Ej: "Juan Pérez, email: juan@example.com"

## HERRAMIENTAS DISPONIBLES
1. **Insertar en tareas**: titulo (requerido), prioridad (baja/media/alta/urgente)
2. **Insertar en proyectos**: nombre (requerido), estado, fecha_limite
3. **Insertar en ideas**: titulo (requerido), contenido, tipo, origen_url
4. **Insertar en personas**: nombre (requerido), relacion, datos_contacto (JSON)

## INSTRUCCIONES
1. Analiza el mensaje
2. Determina la categoría correcta
3. USA LA HERRAMIENTA CORRESPONDIENTE para guardar
4. Confirma al usuario qué guardaste y dónde

## FORMATO DE RESPUESTA
✅ [CATEGORÍA] Título guardado
Prioridad: (solo para TAREA)
💾 Guardado en: nombre_tabla
```

#### 7-10. MySQL Tools (conectadas al AI Agent via `ai_tool`)

```json
// Insertar en tareas
{ "toolDescription": "Para guardar TAREAS (acciones ejecutables)", "table": "tareas" }

// Insertar en proyectos
{ "toolDescription": "Para guardar PROYECTOS (con objetivo/fecha)", "table": "proyectos" }

// Insertar en ideas
{ "toolDescription": "Para guardar IDEAS (notas, recursos, enlaces)", "table": "ideas" }

// Insertar en personas
{ "toolDescription": "Para guardar PERSONAS (contactos)", "table": "personas" }
```

#### 4. Google Gemini Chat Model
```json
{
  "modelName": "models/gemini-2.0-flash",
  "options": {
    "temperature": 0.1
  }
}
```

#### 5. Postgres Chat Memory

**IMPORTANTE**: Usar referencia explícita al nodo Telegram Trigger (no `$json`).

```json
{
  "sessionIdType": "customKey",
  "sessionKey": "={{ $('Telegram Trigger').item.json.message.from.id }}"
}
```
- Mantiene historial de conversación por usuario
- Permite contexto entre mensajes
- La session key usa el ID de usuario de Telegram

#### 6. Responder en Telegram
```json
{
  "chatId": "={{ $('Telegram Trigger').item.json.message.chat.id }}",
  "text": "=🧠 **Segundo Cerebro**\n\n{{ $json.output }}",
  "parse_mode": "Markdown"
}
```

---

## Credenciales Utilizadas

| Credencial | Tipo | ID | Uso |
|------------|------|-----|-----|
| `segundo_cerebro_pkm_bot` | Telegram Bot | `RzgkIinUIV35wSlO` | Bot de Telegram |
| `segundo_cerebro` | MySQL | `yTsefijtH5HVvPzn` | Base de datos |
| `webcomunica api pago` | Google Gemini | `EDGpeO8sJi8YCJQz` | Motor de IA |
| `Postgres NOCODB` | PostgreSQL | `fcCn0Gs1u8rDVAxO` | Memoria del agente |

---

## Casos de Prueba

### Prueba 1: TAREA
**Input**: `Comprar leche`
**Expected**:
```
🧠 **Segundo Cerebro**

[TAREA] Comprar leche
Prioridad: media
Razonamiento: Verbo 'comprar' + objeto 'leche' indica acción ejecutable
```

### Prueba 2: PROYECTO
**Input**: `Lanzar website de la empresa para marzo`
**Expected**:
```
🧠 **Segundo Cerebro**

[PROYECTO] Lanzar website de la empresa
Razonamiento: Objetivo con fecha límite (marzo)
```

### Prueba 3: IDEA
**Input**: `Artículo interesante sobre IA: https://example.com`
**Expected**:
```
🧠 **Segundo Cerebro**

[IDEA] Artículo sobre IA
Razonamiento: Recurso/enlace sin acción inmediata requerida
```

### Prueba 4: PERSONA
**Input**: `Juan Pérez, cliente potencial, juan@example.com, +34 600 123 456`
**Expected**:
```
🧠 **Segundo Cerebro**

[PERSONA] Juan Pérez
Razonamiento: Información de contacto (nombre, email, teléfono)
```

---

## Archivos en este directorio

| Archivo | Descripción |
|---------|-------------|
| `README.md` | Este archivo - documentación del workflow |
| `CHANGELOG.md` | Historial de versiones del workflow |
| `01_telegram_hello_world.json` | Workflow Fase 2 (Hello World) |
| `02_clasificador_inteligente.json` | Diseño original Fase 3 |
| `segundo_cerebro_fase3.json` | Workflow actual (v010) |
| `versions/` | Control de versiones de workflows |

### Versiones (en `versions/`)

| Versión | Archivo | Estado |
|---------|---------|--------|
| v010 | `v010_cuatro_tools.json` | ✅ ESTABLE - 4 tools funcionando |
| v009 | `v009_tareas_ideas.json` | ✅ Tareas + Ideas |
| v008 | `v008_tareas_2_campos.json` | ✅ Primera versión funcional |

---

## Conexiones de Base de Datos

### MySQL - segundo_cerebro
- **Host**: 188.213.5.193
- **Port**: 3306
- **Database**: segundo_cerebro
- **Tablas**: inbox_log, tareas, proyectos, ideas, personas

### PostgreSQL - Memoria del Agente
- Almacena historial de conversaciones
- Session key por usuario de Telegram
- Permite contexto entre mensajes

---

## Próximos Pasos (Fase 4: Robustez)

1. [ ] Implementar "The Bouncer" (confidence scoring)
2. [ ] Herramientas de consulta SELECT ("¿Qué tareas tengo?")
3. [ ] Relacionar entidades ("Añadir tarea al proyecto X")
4. [ ] Añadir comandos de Telegram (/start, /hoy, /fix)
5. [ ] Implementar digest diario/semanal

---

**Última actualización**: 14 de enero de 2026
**Fase actual**: ✅ Fase 3 COMPLETADA - 4 MySQL Tools operativas
