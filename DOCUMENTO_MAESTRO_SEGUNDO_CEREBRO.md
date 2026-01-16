# Documento Maestro: Sistema de Segundo Cerebro con IA

> **Propósito de este documento**: Documentar todas las decisiones de diseño, arquitectura y razonamiento del sistema. Sirve como referencia para futuras mejoras y para que cualquier persona (o IA) pueda entender por qué se tomó cada decisión.

---

## Tabla de Contenidos

1. [Visión General](#1-visión-general)
2. [Perfil del Usuario](#2-perfil-del-usuario)
3. [Stack Tecnológico](#3-stack-tecnológico)
4. [Arquitectura de Base de Datos](#4-arquitectura-de-base-de-datos)
5. [Flujo de Datos](#5-flujo-de-datos)
6. [Sistema de Clasificación IA](#6-sistema-de-clasificación-ia)
7. [Sistema de Recordatorios](#7-sistema-de-recordatorios)
8. [Comandos de Telegram](#8-comandos-de-telegram)
9. [Decisiones de Diseño](#9-decisiones-de-diseño)
10. [Roadmap de Implementación](#10-roadmap-de-implementación)
11. [Preguntas Pendientes](#11-preguntas-pendientes)
12. [Historial de Cambios](#12-historial-de-cambios)

---

## 1. Visión General

### 1.1 ¿Qué es este sistema?

Un **Segundo Cerebro Agéntico** que:
- **Captura** cualquier pensamiento desde Telegram (texto, audio, imágenes)
- **Clasifica automáticamente** usando IA (Gemini 2.5 Flash)
- **Almacena estructuradamente** en MySQL
- **Recuerda proactivamente** lo que importa en el momento correcto

### 1.2 ¿Por qué lo construimos?

**Problema**: El cerebro humano no está diseñado para almacenar información, está diseñado para pensar. Cada cosa que intentamos recordar es un "impuesto cognitivo" que pagamos constantemente.

**Síntomas del problema**:
- Relaciones que se enfrían porque olvidamos lo que alguien nos dijo
- Proyectos que fallan de la manera que predijimos pero olvidamos documentar
- Ansiedad de fondo constante por "loops abiertos" en la mente
- Compromisos con clientes que se olvidan

**Solución**: Un sistema que trabaja **mientras dormimos**, clasificando, organizando y recordándonos sin esfuerzo de nuestra parte.

### 1.3 Filosofía del Sistema

Basado en el video "Building a Second Brain with AI in 2026" y la metodología BASB de Tiago Forte:

| Principio | Implementación |
|-----------|----------------|
| Fricción cero en captura | Un mensaje a Telegram = capturado |
| IA hace el trabajo cognitivo | Gemini clasifica automáticamente |
| Humano solo captura | No decidir categorías, no organizar |
| Sistema recuerda por ti | Digests, alertas, pre-recordatorios |
| Confianza por visibilidad | Logs de auditoría, confirmaciones |

### 1.4 Los 8 Building Blocks (del video)

| Block | Nombre | Nuestra Implementación |
|-------|--------|------------------------|
| 1 | The Dropbox (Captura) | Bot de Telegram |
| 2 | The Sorter (Clasificador) | Gemini 2.5 Flash |
| 3 | The Form (Esquema) | Tablas MySQL con campos definidos |
| 4 | The Filing Cabinet (Almacén) | MySQL con tipo JSON híbrido |
| 5 | The Receipt (Auditoría) | Tabla `inbox_log` |
| 6 | The Bouncer (Filtro) | Confidence threshold 0.7 |
| 7 | The Tap on Shoulder (Notificación) | Digests + alertas Telegram |
| 8 | The Fix Button (Corrección) | Comandos de corrección |

---

## 2. Perfil del Usuario

### 2.1 Contexto Profesional

| Aspecto | Valor |
|---------|-------|
| Tipo de trabajo | **Mantenimiento informático + Desarrollo software a medida** |
| Modelo de negocio | Clientes contactan cuando necesitan (NO prospección activa) |
| Volumen | 20+ clientes/proyectos activos simultáneos |
| Carga | **MUY ALTA** - requiere sistema robusto |
| Comunicación | Multimodal (texto + audio en igual proporción) |
| Idioma principal | Español (con términos técnicos en inglés) |

### 2.2 Pain Points Identificados

1. **CRÍTICO**: Olvido de tareas y compromisos con clientes
2. Dificultad para mantener contexto entre proyectos
3. Ideas que se pierden por no capturarlas a tiempo
4. Recursos/aprendizajes que no se pueden encontrar después

> **NOTA IMPORTANTE**: El usuario NO necesita "seguimiento de clientes fríos" ni prospección activa. Los clientes le contactan cuando necesitan algo. El sistema se centra en **no olvidar compromisos cuando un cliente pide algo**, no en perseguir clientes.

### 2.3 Necesidades Declaradas

| Categoría | Qué capturar |
|-----------|--------------|
| Clientes | Avisos, solicitudes, compromisos |
| Proyectos | Tareas, estados, próximas acciones |
| Ideas | Innovaciones, mejoras, proyectos futuros |
| Aprendizaje | Videos, artículos, conocimiento |
| Personal | Recados, recordatorios, admin |

### 2.4 Preferencias de Sistema

| Aspecto | Preferencia |
|---------|-------------|
| Recordatorios | Proactivo completo (digest + alertas + revisión semanal) |
| **Horario digest** | **7-8am** (mañana temprano, antes de empezar) |
| **Horario revisión semanal** | Domingos por la tarde |
| Clasificación | Automática con confirmación en casos ambiguos (confidence < 0.7) |
| **Confirmaciones** | **Detalladas + botones** (ver qué entendió + poder corregir) |
| Captura | Omnipresente (cualquier momento/lugar) |
| **Uso de audio** | **Mezcla equilibrada** (texto y audio por igual) |
| Balance | Equitativo entre tareas, ideas y aprendizajes |

---

## 3. Stack Tecnológico

### 3.1 Componentes

```
┌─────────────────────────────────────────────────────────────────┐
│                        ARQUITECTURA                              │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐  │
│  │ TELEGRAM │───▶│   n8n    │───▶│  GEMINI  │───▶│  MySQL   │  │
│  │  (Bot)   │    │(Workflow)│    │2.5 Flash │    │   (DB)   │  │
│  └──────────┘    └──────────┘    └──────────┘    └──────────┘  │
│       │                                               │         │
│       │              ┌──────────┐                     │         │
│       └──────────────│ ALERTAS  │◀────────────────────┘         │
│                      │(Digests) │                               │
│                      └──────────┘                               │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### 3.2 Justificación de Cada Componente

#### Telegram (Interfaz)
| Ventaja | Descripción |
|---------|-------------|
| Ubicuidad | Disponible en móvil, desktop, web |
| Multimodal | Texto, audio, imágenes, documentos |
| Bots robustos | API madura con webhooks |
| Sin fricción | Ya lo usas, no hay app nueva |

**Alternativas descartadas**:
- Slack: Más corporativo, menos ubicuo
- WhatsApp: API de bots limitada
- App propia: Desarrollo innecesario

#### n8n (Orquestación)
| Ventaja | Descripción |
|---------|-------------|
| Auto-hospedable | Privacidad total de datos |
| Visual | Debugging fácil sin código |
| Integraciones | Telegram, MySQL, HTTP nativos |
| Costo | Gratis (self-hosted) |

**Alternativas descartadas**:
- Zapier: $20-100/mes, datos en cloud externo
- Make: Más barato pero menos flexible
- Código custom: Más mantenimiento

#### Gemini 2.5 Flash (IA)
| Ventaja | Descripción |
|---------|-------------|
| JSON Schema Enforcement | Salida estructurada garantizada |
| Latencia | < 1 segundo de respuesta |
| Multimodal | Procesa texto, audio, imágenes |
| Costo | Muy económico para uso intensivo |

**Alternativas descartadas**:
- GPT-4: Más caro, sin JSON Schema nativo
- Claude: Excelente pero más caro para "always-on"
- Modelos locales: Requieren hardware potente

#### MySQL (Almacenamiento)
| Ventaja | Descripción |
|---------|-------------|
| JSON nativo | Flexibilidad + estructura |
| Full-text search | Búsqueda sin dependencias |
| Madurez | Décadas de estabilidad |
| Hosting | Fácil en cualquier servidor |

**Alternativas descartadas**:
- PostgreSQL: Similar, MySQL más familiar
- Notion API: Limitaciones en queries
- MongoDB: Overkill para este caso

---

## 4. Arquitectura de Base de Datos

### 4.1 Filosofía de Diseño

**Principio central**: Routing simple a 4 categorías (alineado al video)

```
Mensaje del usuario
        │
        ▼
   ┌─────────┐
   │ GEMINI  │ (Clasifica)
   └────┬────┘
        │
   ┌────┴────┬─────────┬─────────┐
   ▼         ▼         ▼         ▼
PERSONAS  PROYECTOS  IDEAS    ADMIN
```

**Por qué 4 categorías y no más**:
- Más categorías = más decisiones = más fricción
- El video recomienda "dolorosamente pocas" categorías
- Siempre se puede agregar complejidad después, no al revés

### 4.2 Esquema de Tablas

#### Tabla 1: `personas`

**Propósito**: Almacenar clientes, contactos y personas importantes para:
- Detectar automáticamente cuando un mensaje menciona un cliente
- Vincular proyectos y tareas a personas específicas
- Generar contexto pre-reunión
- Alertar sobre clientes "fríos" (sin contacto reciente)

```sql
CREATE TABLE personas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(255) NOT NULL,
    contexto TEXT,                    -- Quién es, cómo lo conoces
    seguimientos TEXT,                -- Qué recordar para próxima vez
    ultimo_contacto DATETIME DEFAULT CURRENT_TIMESTAMP,
    etiquetas JSON,                   -- ['cliente', 'partner', 'amigo']
    metadata JSON,                    -- {email, telefono, empresa, etc.}
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    actualizado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FULLTEXT(nombre, contexto, seguimientos)
);
```

**Campos clave**:
| Campo | Propósito |
|-------|-----------|
| `nombre` | Identificación para matching de IA |
| `contexto` | Info relevante sobre la persona |
| `seguimientos` | Cosas a recordar en próximo contacto |
| `ultimo_contacto` | Para alertas de clientes fríos |
| `etiquetas` | Categorización flexible (JSON array) |
| `metadata` | Datos de contacto flexibles (JSON object) |

#### Tabla 2: `proyectos`

**Propósito**: Proyectos de clientes y propios, con tracking de estado y próxima acción.

```sql
CREATE TABLE proyectos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(255) NOT NULL,
    estado ENUM('activo', 'esperando', 'pausado', 'completado', 'cancelado') DEFAULT 'activo',
    siguiente_accion TEXT,            -- Acción ejecutable específica
    fecha_limite DATE,
    notas TEXT,
    persona_id INT,                   -- NULL si es proyecto propio
    etiquetas JSON,
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    actualizado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    completado_en TIMESTAMP NULL,
    FOREIGN KEY (persona_id) REFERENCES personas(id) ON DELETE SET NULL,
    FULLTEXT(nombre, siguiente_accion, notas)
);
```

**Campos clave**:
| Campo | Propósito |
|-------|-----------|
| `estado` | Tracking del ciclo de vida |
| `siguiente_accion` | "Next action" ejecutable (principio del video) |
| `fecha_limite` | Para alertas pre-deadline |
| `persona_id` | Vínculo a cliente (NULL = proyecto propio) |
| `completado_en` | Para historial (soft delete) |

**Principio "Next Action"** (del video):
- ❌ "Trabajar en website" (no ejecutable)
- ✅ "Enviar mockups a María por email" (ejecutable)

#### Tabla 3: `ideas`

**Propósito**: Ideas, aprendizajes, recursos, conocimiento reutilizable.

```sql
CREATE TABLE ideas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    titulo VARCHAR(255) NOT NULL,
    resumen TEXT,                     -- Captura la esencia en pocas líneas
    detalle TEXT,                     -- Elaboración completa
    url VARCHAR(500),                 -- Si es recurso externo (video, artículo)
    tipo ENUM('idea', 'aprendizaje', 'recurso', 'referencia') DEFAULT 'idea',
    etiquetas JSON,                   -- ['react', 'optimizacion', 'n8n']
    proyecto_id INT,                  -- NULL si es transversal
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    actualizado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (proyecto_id) REFERENCES proyectos(id) ON DELETE SET NULL,
    FULLTEXT(titulo, resumen, detalle)
);
```

**Campos clave**:
| Campo | Propósito |
|-------|-----------|
| `resumen` | Para digests rápidos |
| `url` | Videos YouTube, artículos, referencias |
| `tipo` | Distinguir ideas de aprendizajes de recursos |
| `proyecto_id` | Vínculo opcional a proyecto específico |

#### Tabla 4: `admin`

**Propósito**: TODOs, tareas, avisos de clientes, recados, recordatorios.

```sql
CREATE TABLE admin (
    id INT PRIMARY KEY AUTO_INCREMENT,
    tarea TEXT NOT NULL,
    tipo ENUM('tarea', 'aviso_cliente', 'recado', 'recordatorio') DEFAULT 'tarea',
    prioridad ENUM('critica', 'alta', 'media', 'baja') DEFAULT 'media',
    estado ENUM('pendiente', 'en_progreso', 'esperando', 'completada', 'cancelada') DEFAULT 'pendiente',
    fecha_limite DATE,
    hora_recordatorio DATETIME,       -- Cuándo alertar
    persona_id INT,                   -- Cliente relacionado
    proyecto_id INT,                  -- Proyecto relacionado
    contexto TEXT,                    -- Info adicional
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    actualizado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    completado_en TIMESTAMP NULL,
    ultimo_recordatorio TIMESTAMP NULL,
    FOREIGN KEY (persona_id) REFERENCES personas(id) ON DELETE SET NULL,
    FOREIGN KEY (proyecto_id) REFERENCES proyectos(id) ON DELETE SET NULL,
    FULLTEXT(tarea, contexto)
);
```

**Campos clave**:
| Campo | Propósito |
|-------|-----------|
| `tipo` | Distinguir avisos de clientes (urgentes) de tareas normales |
| `prioridad` | Para ordenar en digests |
| `estado` | Tracking + soft delete |
| `hora_recordatorio` | Para alertas programadas |
| `completado_en` | Historial (NULL = activo, TIMESTAMP = completado) |

**Regla especial del usuario**:
> "Todos los mensajes que mencionan clientes conocidos son avisos por defecto"

Implementación: `tipo = 'aviso_cliente'` + `prioridad = 'alta'`

#### Tabla 5: `inbox_log`

**Propósito**: Auditoría de clasificaciones de IA (Building Block #5: The Receipt)

```sql
CREATE TABLE inbox_log (
    id INT PRIMARY KEY AUTO_INCREMENT,
    mensaje_original TEXT NOT NULL,
    clasificado_en ENUM('personas', 'proyectos', 'ideas', 'admin') NOT NULL,
    entrada_id INT NOT NULL,          -- ID de la entrada creada
    tipo_entrada VARCHAR(50),         -- Subtipo (aviso_cliente, idea, etc.)
    confianza_ia FLOAT,               -- 0.0 - 1.0
    razonamiento TEXT,                -- Por qué IA clasificó así
    feedback_usuario ENUM('correcto', 'incorrecto', 'ajustado') DEFAULT 'correcto',
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

**Campos clave**:
| Campo | Propósito |
|-------|-----------|
| `mensaje_original` | Qué envió el usuario exactamente |
| `confianza_ia` | Para detectar patrones de error |
| `razonamiento` | Debugging de clasificaciones |
| `feedback_usuario` | Mejorar sistema con el tiempo |

### 4.3 Diagrama de Relaciones

```
┌──────────────┐
│   personas   │
│──────────────│
│ id           │◄─────────────────────────────────┐
│ nombre       │                                   │
│ contexto     │                                   │
│ seguimientos │                                   │
│ ...          │                                   │
└──────────────┘                                   │
       │                                           │
       │ 1:N                                       │
       ▼                                           │
┌──────────────┐                                   │
│  proyectos   │                                   │
│──────────────│                                   │
│ id           │◄──────────────────────┐           │
│ nombre       │                        │           │
│ persona_id   │────────────────────────┼───────────┘
│ ...          │                        │
└──────────────┘                        │
       │                                │
       │ 1:N                            │
       ▼                                │
┌──────────────┐         ┌──────────────┤
│    ideas     │         │    admin     │
│──────────────│         │──────────────│
│ id           │         │ id           │
│ titulo       │         │ tarea        │
│ proyecto_id  │─────────│ persona_id   │─────────────┐
│ ...          │         │ proyecto_id  │─────────────┤
└──────────────┘         │ ...          │             │
                         └──────────────┘             │
                                                      │
                         ┌──────────────┐             │
                         │  inbox_log   │             │
                         │──────────────│             │
                         │ id           │             │
                         │ mensaje_orig │             │
                         │ entrada_id   │─────────────┘
                         │ ...          │   (referencia lógica)
                         └──────────────┘
```

### 4.4 Patrón de Historial (Soft Delete)

**Problema**: Usuario quiere que tareas completadas desaparezcan de lista activa pero mantengan historial.

**Solución**: Soft Delete Pattern

```sql
-- Completar una tarea (NO se borra)
UPDATE admin
SET estado = 'completada',
    completado_en = NOW()
WHERE id = 123;

-- Vista de tareas ACTIVAS
SELECT * FROM admin
WHERE estado IN ('pendiente', 'en_progreso', 'esperando')
ORDER BY prioridad DESC, fecha_limite ASC;

-- Vista de HISTORIAL
SELECT * FROM admin
WHERE completado_en IS NOT NULL
ORDER BY completado_en DESC;

-- Lo que hice HOY
SELECT * FROM admin
WHERE DATE(completado_en) = CURDATE();

-- Lo que hice esta SEMANA
SELECT * FROM admin
WHERE completado_en >= DATE_SUB(NOW(), INTERVAL 7 DAY);
```

**Flujo visual**:
```
CREACIÓN                    COMPLETAR                   RESULTADO
─────────                   ─────────                   ─────────
estado: 'pendiente'    ──▶  estado: 'completada'   ──▶  Lista Activa: ❌
completado_en: NULL         completado_en: NOW()        Historial: ✅
```

---

## 5. Flujo de Datos

### 5.1 Flujo Principal de Captura

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         FLUJO DE CAPTURA                                 │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  1. Usuario envía mensaje a Telegram                                     │
│     "María necesita los mockups para mañana"                            │
│                         │                                                │
│                         ▼                                                │
│  2. n8n recibe webhook de Telegram                                       │
│     {message: "María necesita...", type: "text", user_id: xxx}          │
│                         │                                                │
│                         ▼                                                │
│  3. n8n consulta tabla personas (buscar nombres conocidos)               │
│     SELECT nombre FROM personas → ["María", "Carlos", "Ana"]            │
│                         │                                                │
│                         ▼                                                │
│  4. n8n envía a Gemini 2.5 Flash con prompt + contexto                   │
│     {mensaje, personas_conocidas, proyectos_activos}                    │
│                         │                                                │
│                         ▼                                                │
│  5. Gemini responde con JSON estructurado                                │
│     {                                                                    │
│       "categoria": "admin",                                              │
│       "tipo": "aviso_cliente",                                          │
│       "prioridad": "alta",                                              │
│       "persona_detectada": "María",                                     │
│       "fecha_limite": "2026-01-13",                                     │
│       "confianza": 0.92,                                                │
│       "razonamiento": "Menciona cliente conocido + deadline"            │
│     }                                                                    │
│                         │                                                │
│                         ▼                                                │
│  6. n8n evalúa confianza                                                 │
│     IF confianza >= 0.7 → Insertar directamente                         │
│     IF confianza < 0.7 → Pedir confirmación                             │
│                         │                                                │
│                         ▼                                                │
│  7. n8n inserta en tabla correspondiente (admin)                         │
│     INSERT INTO admin (tarea, tipo, prioridad, persona_id, ...)         │
│                         │                                                │
│                         ▼                                                │
│  8. n8n registra en inbox_log (auditoría)                                │
│     INSERT INTO inbox_log (mensaje_original, clasificado_en, ...)       │
│                         │                                                │
│                         ▼                                                │
│  9. n8n envía confirmación a Telegram                                    │
│     "✅ Aviso de cliente: Mockups para María (mañana)"                  │
│                         │                                                │
│                         ▼                                                │
│  10. Sistema programa recordatorio si hay deadline                       │
│      Cron job verificará mañana a las 9am                               │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### 5.2 Flujo de Confianza Baja

```
Mensaje ambiguo: "Revisar tema de María"
                    │
                    ▼
            Gemini analiza
            confianza: 0.55
                    │
                    ▼
         ┌─────────┴─────────┐
         │ confianza < 0.7   │
         │ NO insertar       │
         └─────────┬─────────┘
                   │
                   ▼
        Telegram al usuario:
        "🤔 No estoy seguro. ¿Es esto:
         1️⃣ Tarea para proyecto de María
         2️⃣ Recordatorio personal
         3️⃣ Otra cosa (escribe)"
                   │
                   ▼
          Usuario responde "1"
                   │
                   ▼
         Insertar con contexto
         Log con feedback
```

---

## 6. Sistema de Clasificación IA

### 6.1 Prompt de Clasificación (BORRADOR)

> **NOTA**: Este prompt se refinará durante implementación

```
Eres un asistente de clasificación para un sistema de Segundo Cerebro.

CONTEXTO DEL USUARIO:
- Consultor/Freelancer con 20+ clientes activos
- Pain point: Olvido de compromisos con clientes

PERSONAS CONOCIDAS (clientes/contactos):
{lista_personas}

PROYECTOS ACTIVOS:
{lista_proyectos}

MENSAJE A CLASIFICAR:
"{mensaje_usuario}"

REGLAS DE CLASIFICACIÓN:
1. Si menciona persona conocida → categoria: "admin", tipo: "aviso_cliente", prioridad: "alta"
2. Si es idea o aprendizaje → categoria: "ideas"
3. Si es nuevo proyecto → categoria: "proyectos"
4. Si es nueva persona → categoria: "personas"
5. Si es tarea sin cliente → categoria: "admin", tipo: "tarea"

RESPONDE SOLO CON JSON (sin markdown, sin explicación):
{
  "categoria": "personas|proyectos|ideas|admin",
  "tipo": "string según categoria",
  "titulo_o_tarea": "string",
  "prioridad": "critica|alta|media|baja",
  "persona_detectada": "nombre o null",
  "proyecto_detectado": "nombre o null",
  "fecha_limite": "YYYY-MM-DD o null",
  "etiquetas": ["array", "de", "etiquetas"],
  "confianza": 0.0-1.0,
  "razonamiento": "Por qué clasificaste así"
}
```

### 6.2 JSON Schema para Gemini

```json
{
  "type": "object",
  "properties": {
    "categoria": {
      "type": "string",
      "enum": ["personas", "proyectos", "ideas", "admin"]
    },
    "tipo": {
      "type": "string"
    },
    "titulo_o_tarea": {
      "type": "string"
    },
    "prioridad": {
      "type": "string",
      "enum": ["critica", "alta", "media", "baja"]
    },
    "persona_detectada": {
      "type": ["string", "null"]
    },
    "proyecto_detectado": {
      "type": ["string", "null"]
    },
    "fecha_limite": {
      "type": ["string", "null"],
      "format": "date"
    },
    "etiquetas": {
      "type": "array",
      "items": {"type": "string"}
    },
    "confianza": {
      "type": "number",
      "minimum": 0,
      "maximum": 1
    },
    "razonamiento": {
      "type": "string"
    }
  },
  "required": ["categoria", "tipo", "titulo_o_tarea", "prioridad", "confianza", "razonamiento"]
}
```

---

## 7. Sistema de Recordatorios

### 7.1 Tipos de Recordatorios

| Tipo | Frecuencia | Contenido |
|------|------------|-----------|
| Digest matutino | **Diario (7-8am)** | Tareas del día, deadlines próximos |
| Alerta pre-deadline | Variable | "Deadline en 2 días: [tarea]" |
| Revisión semanal | **Domingos (tarde)** | Resumen de semana, loops abiertos |

> **NOTA**: NO hay alerta de "cliente frío". El usuario no hace prospección activa - los clientes le contactan cuando necesitan algo.

### 7.2 Contenido del Digest Matutino

```
☀️ Buenos días! Tu día 13/01/2026:

⚠️ URGENTE:
• Enviar mockups a María (HOY)

📋 PENDIENTE:
• Revisar propuesta proyecto Carlos
• Responder email de Ana

📅 PRÓXIMOS DEADLINES:
• 15/01: Entrega website Juan
• 18/01: Presentación Startup X

💡 TIP: Tienes 3 tareas de alta prioridad.
   Enfócate en los mockups de María primero.
```

**Principio del video**: Output pequeño, frecuente, accionable. Máximo 150 palabras.

### 7.3 Contenido de Revisión Semanal

```
📊 Tu semana (06/01 - 12/01):

✅ COMPLETADO: 12 tareas
   • 5 avisos de clientes
   • 4 tareas de proyectos
   • 3 admin personal

⏳ LOOPS ABIERTOS: 4
   • Propuesta para Carlos (5 días)
   • Feedback de Ana (3 días)
   • Investigar React 19
   • Definir scope proyecto X

🎯 SUGERENCIAS PARA PRÓXIMA SEMANA:
   1. Cerrar tema con Carlos (más antiguo)
   2. Agendar call con Ana
   3. 2 deadlines importantes el viernes

📈 PATRÓN DETECTADO:
   Mayoría de tareas completadas son de clientes.
   Ideas/aprendizajes acumulándose sin revisar.
```

**Principio del video**: Máximo 250 palabras. Accionable.

---

## 8. Comandos de Telegram

### 8.1 Comandos Planificados

| Comando | Acción |
|---------|--------|
| `/hoy` | Digest del día actual |
| `/pendiente` | Lista de tareas pendientes |
| `/cliente [nombre]` | Contexto completo del cliente |
| `/proyecto [nombre]` | Estado del proyecto |
| `/buscar [texto]` | Búsqueda en todo el sistema |
| `/completar [id]` | Marcar tarea como completada |
| `/fix` | Corregir última clasificación |

### 8.2 Ejemplos de Uso

```
Usuario: /cliente María

Bot: 👤 María García
     🏢 Startup X (CEO)

     📋 Proyectos activos:
     • Website Redesign (deadline: 15/01)
     • App Mobile (en espera)

     ⚠️ Pendiente:
     • Enviar mockups (HOY - urgente)

     📝 Notas:
     • Interesada en SEO
     • Presupuesto limitado Q1

     📅 Último contacto: 10/01/2026
```

---

## 9. Decisiones de Diseño

### 9.1 Registro de Decisiones

| # | Decisión | Alternativas | Razón |
|---|----------|--------------|-------|
| 1 | 4 tablas principales | 5+ tablas con relaciones complejas | Simplicidad del video, menos fricción |
| 2 | Soft delete para historial | Borrado físico | Usuario quiere historial sin ver tareas completadas |
| 3 | Telegram como interfaz | Slack, App propia | Ubicuidad, multimodal, sin fricción |
| 4 | MySQL sobre PostgreSQL | PostgreSQL, MongoDB | Familiaridad, JSON nativo suficiente |
| 5 | Gemini 2.5 Flash | GPT-4, Claude | JSON Schema nativo, latencia, costo |
| 6 | Confidence threshold 0.7 | 0.5, 0.8, 0.9 | Balance entre autonomía y precisión |
| 7 | Avisos de cliente = prioridad alta | Prioridad manual | Regla del usuario, automatiza lo importante |
| 8 | n8n auto-hospedado | Zapier, Make | Privacidad, costo, flexibilidad |
| 9 | **NO alertas cliente frío** | Alertas cada X días | Usuario no hace prospección activa |
| 10 | **Confirmaciones detalladas + botones** | Minimalistas | Usuario quiere ver qué entendió + corregir |
| 11 | **Audio como ciudadano de primera clase** | Solo texto | Usuario usa texto y audio por igual |
| 12 | **Español como idioma principal** | Inglés/Mixto | Con términos técnicos en inglés cuando aplica |

### 9.2 Principios Guía

1. **Fricción cero en captura**: Si requiere pensar, no se usará
2. **IA hace trabajo cognitivo**: Clasificar, organizar, recordar
3. **Simple primero**: Agregar complejidad solo cuando se necesite
4. **Confianza por visibilidad**: Logs, confirmaciones, transparencia
5. **Diseñar para restart**: Fácil retomar después de días sin usar

---

## 10. Roadmap de Implementación

### Fase 1: MVP (Core Loop)

- [ ] Crear tablas MySQL
- [ ] Configurar bot de Telegram
- [ ] Crear workflow n8n básico (captura → clasificación → almacenamiento)
- [ ] Implementar confirmaciones de Telegram
- [ ] Probar con 10-20 capturas reales

### Fase 2: Recordatorios

- [ ] Implementar digest matutino
- [ ] Implementar alertas pre-deadline
- [ ] Implementar revisión semanal

### Fase 3: Comandos

- [ ] Implementar `/hoy`, `/pendiente`
- [ ] Implementar `/cliente`, `/proyecto`
- [ ] Implementar `/buscar`
- [ ] Implementar `/completar`, `/fix`

### Fase 4: Mejoras

- [ ] Soporte de audio (transcripción)
- [ ] Soporte de imágenes (OCR/análisis)
- [ ] Integración con Google Calendar
- [ ] Búsqueda semántica avanzada

---

## 11. Preguntas Resueltas y Pendientes

### ✅ Resueltas:

| Pregunta | Respuesta | Fecha |
|----------|-----------|-------|
| Idiomas | Principalmente español (términos técnicos en inglés) | 2026-01-12 |
| Horarios de digest | 7-8am (mañana temprano) | 2026-01-12 |
| Formato confirmaciones | Detalladas + botones para corregir | 2026-01-12 |
| Uso de audio | Mezcla equilibrada (texto y audio igual) | 2026-01-12 |
| Clientes fríos | **NO APLICA** - No hace prospección activa | 2026-01-12 |
| Tipo de trabajo | Mantenimiento informático + Software a medida | 2026-01-12 |

### ⏳ Pendientes por definir:

1. ~~**Etiquetas predefinidas**~~: ✅ Definidas: `urgente`, `en-espera`, `investigar` + IA genera más
2. ~~**Prioridad por defecto**~~: ✅ Media
3. ~~**Revisión semanal hora exacta**~~: ✅ Domingo 20-21h
4. **Transcripción de audio**: Whisper local vs API de Google (por decidir en implementación)
5. ~~**Instancia n8n**~~: ✅ Ya en EasyPanel (n8n-n8n.yhnmlz.easypanel.host)

### 📋 Configuración Final Definida

```yaml
Etiquetas Predefinidas:
  - urgente       # Atención inmediata
  - en-espera     # Depende de alguien más
  - investigar    # Requiere búsqueda/estudio
  # + IA puede generar más según contenido

Prioridades:
  - Por defecto: media
  - Aviso de cliente: alta (automático)
  - Con deadline hoy: crítica (automático)

Flujo de Confirmación:
  - SIEMPRE proponer antes de guardar (nunca guardar automático)
  - Mostrar propuesta completa: tipo, cliente, prioridad, deadline
  - Botones: [✅ Guardar] [✏️ Editar] [❌ Cancelar]
  - Solo se guarda en BD después de aprobar
  - Si confianza < 70%: además ofrece opciones alternativas

Horarios:
  - Digest matutino: 7:00-8:00am
  - Revisión semanal: Domingo 20:00-21:00h

Infraestructura:
  - n8n: https://n8n-n8n.yhnmlz.easypanel.host
  - MySQL: Por configurar
  - Telegram Bot: Por crear
  - Gemini API: Por configurar
```

---

## 12. Historial de Cambios

| Fecha | Cambio | Razón |
|-------|--------|-------|
| 2026-01-12 | Creación del documento | Inicio del diseño |
| 2026-01-12 | Simplificación de 5 a 4 tablas | Feedback del usuario: "¿estamos complicando mucho?" |
| 2026-01-12 | Agregado campo `tipo` en tabla ideas | Distinguir ideas de aprendizajes de recursos |
| 2026-01-12 | Documentado patrón soft delete | Usuario requiere historial sin borrar |
| 2026-01-12 | Eliminada alerta "cliente frío" | Usuario no hace prospección - clientes le contactan |
| 2026-01-12 | Definido horario digest: 7-8am | Preferencia del usuario: mañana temprano |
| 2026-01-12 | Confirmaciones: detalladas + botones | Usuario quiere ver qué entendió + poder corregir |
| 2026-01-12 | Agregado soporte de audio prioritario | Usuario usa texto y audio por igual |
| 2026-01-12 | Idioma principal: español | Con términos técnicos en inglés |
| 2026-01-12 | Etiquetas fijas definidas | urgente, en-espera, investigar |
| 2026-01-12 | Revisión semanal: Domingo 20-21h | Preferencia del usuario |
| 2026-01-12 | Umbral confianza IA: 70% | Balance entre autonomía y confirmación |
| 2026-01-12 | n8n confirmado en EasyPanel | Ya tiene instancia funcionando |
| 2026-01-12 | **SIEMPRE aprobar antes de guardar** | Usuario quiere control total, nunca guardar automático |

---

## Anexos

### A. Video de Referencia

- **URL**: https://www.youtube.com/watch?v=0TpON5T-Sw4
- **Título**: "Building a Second Brain with AI in 2026"
- **Conceptos clave**: 8 Building Blocks, 12 Principios de Ingeniería

### B. Metodología BASB

- **Autor**: Tiago Forte
- **Método CODE**: Capturar, Organizar, Destilar, Expresar
- **Método PARA**: Projects, Areas, Resources, Archive

### C. Documentos Relacionados

- `Diseño de Sistema Automatizado con IA.docx` - Documento técnico original
- `Transcripcion_Analizada_Segundo_Cerebro_2026.md` - Análisis del video
- `Concepto_Segundo_Cerebro_AI_2026.md` - Concepto inicial

---

*Última actualización: 2026-01-12*

---

## ESTADO ACTUAL DEL PROYECTO (Para Retomar)

### ✅ COMPLETADO (Fase de Diseño)

| Paso | Estado | Descripción |
|------|--------|-------------|
| 1. Análisis video YouTube | ✅ | Extraídos 8 building blocks + 12 principios |
| 2. Perfil de usuario | ✅ | Mantenimiento informático + software a medida |
| 3. Arquitectura BD | ✅ | 5 tablas: personas, proyectos, ideas, admin, inbox_log |
| 4. Stack tecnológico | ✅ | Telegram + n8n + MySQL + Gemini 2.5 Flash |
| 5. Configuración sistema | ✅ | Horarios, etiquetas, prioridades definidas |
| 6. Flujo de confirmación | ✅ | SIEMPRE aprobar antes de guardar |
| 7. Sistema recordatorios | ✅ | Digest 7am + Revisión Domingo 20h |

### ⏳ PENDIENTE (Fase de Implementación)

| Paso | Prioridad | Descripción |
|------|-----------|-------------|
| 1. Crear tablas MySQL | ALTA | Ejecutar scripts SQL de las 5 tablas |
| 2. Crear bot Telegram | ALTA | BotFather + obtener token |
| 3. Workflow n8n: Captura | ALTA | Telegram → Gemini → MySQL |
| 4. Prompt Gemini | ALTA | Diseñar prompt de clasificación |
| 5. Workflow n8n: Digest | MEDIA | Cron 7am → Resumen → Telegram |
| 6. Comandos Telegram | BAJA | /hoy, /pendiente, /cliente, etc. |
| 7. Soporte audio | BAJA | Transcripción Whisper/Google |

### 📋 RESUMEN DE DECISIONES CLAVE

```yaml
Usuario:
  Profesión: Mantenimiento informático + Software a medida
  Modelo: Clientes contactan cuando necesitan (NO prospección)
  Volumen: 20+ clientes/proyectos activos
  Pain point: Olvido de compromisos con clientes

Sistema:
  Interfaz: Telegram Bot
  Orquestación: n8n (https://n8n-n8n.yhnmlz.easypanel.host)
  IA: Gemini 2.5 Flash
  BD: MySQL (5 tablas)

Configuración:
  Idioma: Español (términos técnicos en inglés)
  Digest: 7-8am diario
  Revisión: Domingo 20-21h
  Confirmación: SIEMPRE aprobar antes de guardar
  Audio: Soportado (texto y audio por igual)

Etiquetas fijas: urgente, en-espera, investigar
Prioridades: media (defecto), alta (cliente), crítica (hoy)
```

### 🗄️ ESQUEMA SQL LISTO PARA EJECUTAR

```sql
-- Tabla 1: personas
CREATE TABLE personas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(255) NOT NULL,
    contexto TEXT,
    seguimientos TEXT,
    ultimo_contacto DATETIME DEFAULT CURRENT_TIMESTAMP,
    etiquetas JSON,
    metadata JSON,
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    actualizado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FULLTEXT(nombre, contexto, seguimientos)
);

-- Tabla 2: proyectos
CREATE TABLE proyectos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(255) NOT NULL,
    estado ENUM('activo', 'esperando', 'pausado', 'completado', 'cancelado') DEFAULT 'activo',
    siguiente_accion TEXT,
    fecha_limite DATE,
    notas TEXT,
    persona_id INT,
    etiquetas JSON,
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    actualizado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    completado_en TIMESTAMP NULL,
    FOREIGN KEY (persona_id) REFERENCES personas(id) ON DELETE SET NULL,
    FULLTEXT(nombre, siguiente_accion, notas)
);

-- Tabla 3: ideas
CREATE TABLE ideas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    titulo VARCHAR(255) NOT NULL,
    resumen TEXT,
    detalle TEXT,
    url VARCHAR(500),
    tipo ENUM('idea', 'aprendizaje', 'recurso', 'referencia') DEFAULT 'idea',
    etiquetas JSON,
    proyecto_id INT,
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    actualizado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (proyecto_id) REFERENCES proyectos(id) ON DELETE SET NULL,
    FULLTEXT(titulo, resumen, detalle)
);

-- Tabla 4: admin
CREATE TABLE admin (
    id INT PRIMARY KEY AUTO_INCREMENT,
    tarea TEXT NOT NULL,
    tipo ENUM('tarea', 'aviso_cliente', 'recado', 'recordatorio') DEFAULT 'tarea',
    prioridad ENUM('critica', 'alta', 'media', 'baja') DEFAULT 'media',
    estado ENUM('pendiente', 'en_progreso', 'esperando', 'completada', 'cancelada') DEFAULT 'pendiente',
    fecha_limite DATE,
    hora_recordatorio DATETIME,
    persona_id INT,
    proyecto_id INT,
    contexto TEXT,
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    actualizado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    completado_en TIMESTAMP NULL,
    ultimo_recordatorio TIMESTAMP NULL,
    FOREIGN KEY (persona_id) REFERENCES personas(id) ON DELETE SET NULL,
    FOREIGN KEY (proyecto_id) REFERENCES proyectos(id) ON DELETE SET NULL,
    FULLTEXT(tarea, contexto)
);

-- Tabla 5: inbox_log
CREATE TABLE inbox_log (
    id INT PRIMARY KEY AUTO_INCREMENT,
    mensaje_original TEXT NOT NULL,
    clasificado_en ENUM('personas', 'proyectos', 'ideas', 'admin') NOT NULL,
    entrada_id INT NOT NULL,
    tipo_entrada VARCHAR(50),
    confianza_ia FLOAT,
    razonamiento TEXT,
    feedback_usuario ENUM('correcto', 'incorrecto', 'ajustado') DEFAULT 'correcto',
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 🔄 FLUJO DE CAPTURA (Diagrama)

```
USUARIO                          SISTEMA
───────                          ───────
Envía mensaje ──────────────────▶ Telegram recibe
                                      │
                                      ▼
                                 n8n webhook
                                      │
                                      ▼
                                 Consulta personas
                                 conocidas en MySQL
                                      │
                                      ▼
                                 Envía a Gemini
                                 con prompt + contexto
                                      │
                                      ▼
                                 Gemini responde JSON
                                      │
                                      ▼
◀────────────────────────────── Propone al usuario:
                                 "📝 Voy a guardar:
                                  📋 Tipo: Aviso cliente
                                  👤 Cliente: María
                                  ⚡ Prioridad: Alta
                                  [✅ Guardar] [✏️ Editar]"
                                      │
Presiona botón ─────────────────▶    │
                                      ▼
                                 SI aprobado:
                                 INSERT en MySQL
                                 INSERT en inbox_log
                                      │
                                      ▼
◀────────────────────────────── Confirma: "✅ Guardado"
```

### 📁 ARCHIVOS DEL PROYECTO

```
notas_ideas/
├── DOCUMENTO_MAESTRO_SEGUNDO_CEREBRO.md  ← ESTE ARCHIVO (diseño completo)
├── CLAUDE.md                             ← Contexto del proyecto
├── Diseño de Sistema Automatizado con IA.docx  ← Documento original
├── Transcripcion_Analizada_Segundo_Cerebro_2026.md  ← Análisis video
└── segundo_cerebro.txt                   ← Notas iniciales
```

### 🚀 PARA RETOMAR

Si se cortó la conversación, decir:

> "Continuemos con el proyecto de Segundo Cerebro. Lee el archivo DOCUMENTO_MAESTRO_SEGUNDO_CEREBRO.md para retomar el contexto. Estábamos en la fase de [implementación/diseño]."

El documento contiene TODO lo necesario para continuar.
