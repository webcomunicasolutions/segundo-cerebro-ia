# 🧠 Preparación para FASE 3: Inteligencia con Gemini

**Fecha de inicio prevista**: 14 de enero de 2026
**Estado actual**: Fase 2 completada ✅

---

## 🎯 Objetivo de la Fase 3

Transformar el bot de "Hello World" en un sistema inteligente que:
- Analiza semánticamente cada mensaje
- Clasifica automáticamente en 4 categorías
- Estructura datos para MySQL
- Inserta en la base de datos
- Confirma al usuario qué se guardó

---

## 📋 Pre-requisitos

### ✅ Completado (Ya tienes)

- [x] Bot de Telegram funcional: `@segundo_cerebro_pkm_bot`
- [x] Workflow n8n activo: https://n8n-n8n.yhnmlz.easypanel.host/workflow/ZI6VUFdg6hEhnCbh
- [x] Base de datos MySQL con 5 tablas operativas
- [x] Credenciales de Telegram configuradas en n8n
- [x] Documentación completa de Fases 0-2

### 🔜 Necesitarás (Para Fase 3)

- [ ] **API Key de Gemini** (Google AI Studio)
  - Crear cuenta en: https://aistudio.google.com/
  - Generar API Key
  - Configurar credencial en n8n

- [ ] **Información de conexión MySQL** (ya la tienes en `database/CONNECTION_INFO.md`)
  - Host, Database, User, Password
  - Para configurar credencial MySQL en n8n

---

## 🛠️ Arquitectura Objetivo (Fase 3)

### Flujo Completo

```
┌─────────────────┐
│ Usuario envía   │
│ mensaje         │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Telegram        │ ← Ya funciona ✅
│ Trigger         │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Nodo: Preparar  │ ← NUEVO (Fase 3)
│ para Gemini     │   Extrae texto, fecha, usuario
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Gemini 2.5      │ ← NUEVO (Fase 3)
│ Flash           │   Analiza y clasifica
│                 │   Output: JSON estructurado
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ MySQL: Insertar │ ← NUEVO (Fase 3)
│ en inbox_log    │   Tabla de auditoría
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Switch          │ ← NUEVO (Fase 3)
│ (4 ramas)       │   Routing por categoría
└────┬────────────┘
     │
     ├──→ Persona  ─→ MySQL personas
     │
     ├──→ Proyecto ─→ MySQL proyectos
     │
     ├──→ Idea     ─→ MySQL ideas
     │
     └──→ Tarea    ─→ MySQL tareas
              │
              ▼
     ┌─────────────────┐
     │ Telegram: Enviar│ ← Modificar existente
     │ confirmación    │   "✅ Guardado como Tarea"
     └─────────────────┘
```

---

## 🤖 Configuración de Gemini 2.5 Flash

### 1. Obtener API Key

1. Ve a: https://aistudio.google.com/
2. Inicia sesión con cuenta Google
3. Click en "Get API Key"
4. Copia la API Key (formato: `AIzaSy...`)

### 2. Configurar Credencial en n8n

**Método 1: Manual (Interfaz web)**
1. n8n → Credentials → Add Credential
2. Buscar: "Google Gemini"
3. Credential Name: `Gemini - Segundo Cerebro`
4. API Key: `<tu_api_key>`
5. Save

**Método 2: Vía Claude (API)**
- Claude puede hacerlo automáticamente usando el API de n8n

### 3. Modelo Recomendado

- **Modelo**: `gemini-2.0-flash-exp` (o el más reciente disponible)
- **Razón**:
  - Latencia < 1 segundo
  - JSON Schema Enforcement nativo
  - Soporte multimodal (texto, audio, imágenes)
  - Costo optimizado para uso intensivo

---

## 📝 Prompt Maestro (Borrador Inicial)

Este es el prompt que usará Gemini para clasificar mensajes:

```
Eres un clasificador inteligente para un sistema de Segundo Cerebro basado en el método PARA (Projects, Areas, Resources, Archive).

Tu tarea es analizar el mensaje del usuario y determinar a qué categoría pertenece:

1. **PERSONA**: Información sobre contactos, clientes, relaciones (nombres, datos de contacto, contexto)
2. **PROYECTO**: Esfuerzos con objetivo definido y fecha límite (ej: "Lanzar website para abril")
3. **IDEA**: Notas, recursos, aprendizajes, enlaces (sin fecha límite)
4. **TAREA**: Acciones ejecutables en formato "verbo + objeto" (ej: "Llamar a Juan", "Comprar leche")

**Reglas de clasificación**:
- Si contiene un verbo de acción + objeto específico → TAREA
- Si menciona un objetivo con plazo o entregable → PROYECTO
- Si es información sobre una persona (nombre, teléfono, email) → PERSONA
- Si es conocimiento, recurso, link, nota → IDEA
- En caso de duda, pregunta: "¿Esto requiere acción inmediata?" → SÍ: TAREA, NO: IDEA

**Entrada**:
```json
{
  "mensaje": "{{ $json.message.text }}",
  "fecha": "{{ $now }}",
  "usuario": "{{ $json.message.from.username }}"
}
```

**Salida esperada (JSON Schema)**:
```json
{
  "categoria": "TAREA|PROYECTO|IDEA|PERSONA",
  "confidence": 0.95,
  "titulo_sugerido": "Comprar leche",
  "metadata": {
    "prioridad": "media",
    "tags": ["domestico", "compras"],
    "contexto": "Tarea doméstica simple"
  },
  "razonamiento": "Verbo 'Comprar' + objeto 'leche' indica acción ejecutable"
}
```

**Mensaje del usuario**:
{{ $json.message.text }}

Responde SOLO con el JSON, sin explicación adicional.
```

---

## 🗄️ Esquema de Inserción en Base de Datos

### Tabla: `inbox_log` (Auditoría completa)

Todos los mensajes se guardan primero aquí:

```sql
INSERT INTO inbox_log (
  mensaje_original,
  tipo_mensaje,
  metadata_telegram,
  clasificacion_ia,
  confidence_score,
  razonamiento_ia
) VALUES (
  '{{ $json.message.text }}',
  'texto',
  '{{ $json.message | json }}',  -- JSON completo de Telegram
  '{{ $json.gemini.categoria }}',
  {{ $json.gemini.confidence }},
  '{{ $json.gemini.razonamiento }}'
);
```

### Tablas específicas (según categoría)

**Si categoría = TAREA**:
```sql
INSERT INTO tareas (
  titulo,
  estado,
  prioridad,
  contexto_adicional,
  fuente
) VALUES (
  '{{ $json.gemini.titulo_sugerido }}',
  'pendiente',
  '{{ $json.gemini.metadata.prioridad }}',
  '{{ $json.gemini.metadata | json }}',
  'telegram'
);
```

**Si categoría = PROYECTO**:
```sql
INSERT INTO proyectos (
  nombre,
  estado,
  metadata,
  fuente
) VALUES (
  '{{ $json.gemini.titulo_sugerido }}',
  'activo',
  '{{ $json.gemini.metadata | json }}',
  'telegram'
);
```

**Si categoría = IDEA**:
```sql
INSERT INTO ideas (
  titulo,
  contenido,
  tipo,
  tags,
  fuente
) VALUES (
  '{{ $json.gemini.titulo_sugerido }}',
  '{{ $json.message.text }}',
  'nota',
  '{{ $json.gemini.metadata.tags | json }}',
  'telegram'
);
```

**Si categoría = PERSONA**:
```sql
INSERT INTO personas (
  nombre,
  relacion,
  datos_contacto,
  contexto,
  fuente
) VALUES (
  '{{ $json.gemini.metadata.nombre }}',
  '{{ $json.gemini.metadata.relacion }}',
  '{{ $json.gemini.metadata.datos_contacto | json }}',
  '{{ $json.gemini.metadata.contexto | json }}',
  'telegram'
);
```

---

## 🧪 Casos de Prueba para Fase 3

Una vez implementado, probarás con estos mensajes:

### 1. Prueba de TAREA
**Input**: `Comprar leche`
**Output esperado**:
```json
{
  "categoria": "TAREA",
  "confidence": 0.95,
  "titulo_sugerido": "Comprar leche"
}
```
**Respuesta bot**: `✅ Guardado como Tarea: "Comprar leche"`

### 2. Prueba de PROYECTO
**Input**: `Lanzar website de la empresa para marzo`
**Output esperado**:
```json
{
  "categoria": "PROYECTO",
  "confidence": 0.90,
  "titulo_sugerido": "Lanzar website de la empresa"
}
```
**Respuesta bot**: `📁 Guardado como Proyecto: "Lanzar website de la empresa"`

### 3. Prueba de IDEA
**Input**: `Articulo interesante sobre IA: https://example.com/ai-article`
**Output esperado**:
```json
{
  "categoria": "IDEA",
  "confidence": 0.92,
  "titulo_sugerido": "Artículo sobre IA"
}
```
**Respuesta bot**: `💡 Guardado como Idea: "Artículo sobre IA"`

### 4. Prueba de PERSONA
**Input**: `Juan Pérez, cliente potencial, email: juan@example.com, telefono: +34 600 123 456`
**Output esperado**:
```json
{
  "categoria": "PERSONA",
  "confidence": 0.97,
  "titulo_sugerido": "Juan Pérez"
}
```
**Respuesta bot**: `👥 Guardado como Persona: "Juan Pérez"`

---

## 📊 Métricas de Éxito (Fase 3)

Al completar la Fase 3, el sistema deberá:

- [x] Recibir mensaje de Telegram
- [x] Clasificar automáticamente con Gemini
- [x] Guardar en `inbox_log` (auditoría)
- [x] Insertar en tabla específica según categoría
- [x] Responder al usuario confirmando qué se guardó
- [x] Funcionar con >85% de confianza en clasificación

---

## 🔧 Herramientas Disponibles

### MCPs Configurados (Ya disponibles)

- ✅ **n8n-ejecutor**: Ejecutar workflows
- ✅ **n8n-creator**: Crear/modificar workflows vía API
- ✅ **n8n-mcp-docs**: Documentación de n8n
- ✅ **n8n-workflows-docs**: Ejemplos de workflows

### Skills Disponibles

- ✅ **/n8n**: Skill especializado en workflows de n8n
- ✅ Acceso completo a API de n8n vía curl

---

## 📂 Archivos de Referencia

### Para consultar durante Fase 3

1. **`database/schema.sql`** - Estructura de tablas MySQL
2. **`database/CONNECTION_INFO.md`** - Credenciales de MySQL
3. **`docs/ESPECIFICACION_TECNICA_FINAL_v1.md`** - Arquitectura completa
4. **`n8n/workflows/README.md`** - Documentación del workflow actual
5. **`SESSION_LOG.md`** - Historial de sesiones

---

## 💡 Tips para Mañana

### Orden Recomendado de Implementación

1. **Paso 1**: Configurar credencial de Gemini en n8n
2. **Paso 2**: Agregar nodo Gemini al workflow existente
3. **Paso 3**: Probar clasificación con mensaje simple
4. **Paso 4**: Agregar inserción en `inbox_log`
5. **Paso 5**: Implementar Switch con 4 ramas
6. **Paso 6**: Agregar inserciones en tablas específicas
7. **Paso 7**: Modificar respuesta de Telegram para confirmar
8. **Paso 8**: Probar casos de prueba completos

### Debugging

- n8n tiene "Execute Node" para probar nodos individuales
- Puedes ver JSON de entrada/salida en cada paso
- Claude puede ayudarte a debuggear viendo los logs del workflow

---

## 🎯 Criterio de Finalización (Fase 3)

La Fase 3 estará completa cuando:

1. ✅ Gemini clasifica correctamente 9/10 mensajes de prueba
2. ✅ Todos los mensajes se guardan en `inbox_log`
3. ✅ Cada categoría inserta correctamente en su tabla MySQL
4. ✅ El bot confirma al usuario qué se guardó y dónde
5. ✅ El workflow funciona end-to-end sin errores

---

**Documento creado**: 13 de enero de 2026, 23:55
**Próxima sesión**: 14 de enero de 2026
**Estado**: Listo para comenzar Fase 3 🚀
