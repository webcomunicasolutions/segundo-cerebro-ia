# 🧠 Segundo Cerebro Digital - Sistema Automatizado con IA

**Versión**: v018 (Producción) | **Última actualización**: 17 Enero 2026

Sistema agéntico de gestión del conocimiento personal (PKM) basado en la metodología "Building a Second Brain", implementado con n8n, Telegram, MySQL y Gemini 2.5 Flash.

---

## 🎯 ¿Qué es este proyecto?

Un **Segundo Cerebro automatizado** que:
- ✅ Captura pensamientos vía Telegram (texto)
- 🤖 Clasifica automáticamente con IA (tareas, proyectos, ideas, personas)
- 📊 Organiza en base de datos estructurada (MySQL)
- 💬 Responde consultas inteligentes en lenguaje natural
- ⚡ Funciona en <3 segundos de latencia
- 🧠 Recuerda contexto de conversación (últimas 15 interacciones)

**Diferencia clave**: A diferencia de sistemas pasivos (Notion, Obsidian), este sistema **piensa por ti** usando un motor de razonamiento (Gemini 2.5 Flash).

---

## 🚀 Inicio Rápido

### Para Usuarios Finales

1. **Lee la guía de inicio**: [`PRIMEROS_PASOS.md`](PRIMEROS_PASOS.md)
2. **Consulta la guía rápida**: [`GUIA_RAPIDA.md`](GUIA_RAPIDA.md)
3. **Manual completo**: [`MANUAL_DE_USUARIO.md`](MANUAL_DE_USUARIO.md)
4. **Preguntas frecuentes**: [`FAQ.md`](FAQ.md)

### Para Desarrolladores

1. **Clona el repositorio**:
   ```bash
   git clone [URL_DEL_REPOSITORIO]
   cd notas_ideas
   ```

2. **Importa el workflow en n8n**:
   - Archivo: `workflows/workflow_segundo_cerebro_v018.json`
   - Importa en tu instancia de n8n

3. **Configura las credenciales**:
   - Telegram Bot Token
   - MySQL (base de datos `segundo_cerebro`)
   - Google Gemini API Key
   - PostgreSQL (para memoria conversacional)

4. **Lee la documentación técnica** en [`docs/`](docs/)

---

## 🏗️ Arquitectura

### Diagrama de Flujo

```
Usuario → Telegram Bot
            ↓
          n8n Workflow
            ↓
       Guardar en inbox_log (MySQL)
            ↓
      AI Agent (Gemini 2.5 Flash)
       ↙    ↓    ↘    ↘
    INSERT  SELECT  UPDATE  DELETE
       ↓     ↓      ↓       ↓
    MySQL Database (tareas, proyectos, ideas, personas)
       ↓
    Bot responde confirmación
```

### Stack Tecnológico

| Componente | Tecnología | Propósito |
|------------|------------|-----------|
| **Interfaz** | Telegram Bot API | Captura omnipresente (móvil, desktop, web) |
| **Orquestación** | n8n v6.8+ (auto-hospedado) | Flujos de trabajo visuales |
| **Motor IA** | Google Gemini 2.5 Flash | Razonamiento y clasificación semántica |
| **Base de Datos** | MySQL 8.0 | Almacenamiento híbrido (relacional + JSON) |
| **Memoria** | PostgreSQL | Historial de conversación del agente |

### Herramientas del AI Agent (16 tools)

```
INSERTAR (4):
  - Insertar en tareas
  - Insertar en proyectos
  - Insertar en ideas
  - Insertar en personas

CONSULTAR (4):
  - Consultar tareas (ORDER BY prioridad, fecha)
  - Consultar proyectos (ORDER BY estado, fecha)
  - Consultar ideas (ORDER BY fecha DESC)
  - Consultar personas (ORDER BY nombre)

ACTUALIZAR (4):
  - Actualizar tarea (UPDATE condicional)
  - Actualizar proyecto
  - Actualizar idea
  - Actualizar persona

ELIMINAR (4):
  - Eliminar tarea (DELETE con confirmación)
  - Eliminar proyecto
  - Eliminar idea
  - Eliminar persona
```

---

## 📂 Estructura del Proyecto

```
segundo_cerebro/
├── README.md                    # Este archivo
├── MANUAL_DE_USUARIO.md        # Guía completa para usuarios finales
├── GUIA_RAPIDA.md              # Cheatsheet de comandos
├── PRIMEROS_PASOS.md           # Setup inicial
├── FAQ.md                      # Preguntas frecuentes
├── TAREAS_PENDIENTES.md        # Estado del proyecto
├── CHANGELOG.md                # Historial de versiones
├── CLAUDE.md                   # Instrucciones para Claude Code
│
├── workflows/                   # Workflows de n8n exportados
│   ├── segundo_cerebro_v018.json  # Versión actual (producción)
│   ├── segundo_cerebro_v017.json  # Backup anterior
│   └── segundo_cerebro_v016.json  # Backup histórico
│
├── docs/                        # Documentación técnica maestra
│   ├── DOCUMENTO_MAESTRO_SEGUNDO_CEREBRO.md
│   ├── Diseño de Sistema Automatizado con IA.docx  # ~6MB
│   ├── Concepto_Segundo_Cerebro_AI_2026.md
│   └── Transcripcion_Analizada_Segundo_Cerebro_2026.md
│
├── reference/                   # Referencias técnicas
│   ├── MYSQL_TOOL_V25_CODIGO_FUENTE.md
│   ├── HTTP_REQUEST_DOCUMENTACION_COMPLETA.md
│   ├── OPCIONES_MYSQL_TOOL_V25.md
│   ├── OPCIONES_GOOGLE_GEMINI_CHAT_MODEL.md
│   └── n8n-mysql-docs/         # Código fuente TypeScript
│
├── bugs-resolved/               # Histórico de bugs resueltos
│   ├── BUG_CONSULTAR_TAREAS.md
│   ├── BUG_LISTA_DE_TAREAS.md
│   ├── FIX_ORDER_BY_RESTAURADO.md
│   └── ANALISIS_LOOPS_CONSULTAR.md
│
├── sessions/                    # Logs de sesiones de desarrollo
│   ├── SESSION_LOG.md
│   └── SESSION_17_ENERO_2026.md
│
├── scripts/                     # Scripts de utilidad
│   └── limpiar_base_datos.sql  # Script para borrar datos de prueba
│
└── blueprint_v1/                # Histórico de blueprints n8n
```

---

## 🎯 Estado del Proyecto

### Versión Actual: v018 - Preparación para Producción ✅

**Workflow ID**: `ZI6VUFdg6hEhnCbh`
**Nodos**: 22
**Estado**: **Listo para producción** - Sistema completo, estable y documentado
**Última actualización**: 17 Enero 2026

### Características Completadas (v018)

#### Sistema Core (100% Funcional)
- ✅ **Captura**: Envío de mensajes de texto a Telegram
- ✅ **Clasificación**: AI Agent con Gemini 2.5 Flash clasifica automáticamente
- ✅ **Almacenamiento**: Base de datos MySQL con 4 tablas
- ✅ **Memoria contextual**: Postgres Chat Memory (15 interacciones)

#### CRUD Completo (16 herramientas)
- ✅ **Insertar**: 4 herramientas (CREATE)
- ✅ **Consultar**: 4 herramientas con ordenamiento inteligente (READ)
- ✅ **Actualizar**: 4 herramientas con UPDATE condicional (UPDATE)
- ✅ **Eliminar**: 4 herramientas con confirmación (DELETE)

#### Documentación Completa
- ✅ **MANUAL_DE_USUARIO.md**: Guía completa (~1000 líneas)
- ✅ **GUIA_RAPIDA.md**: Cheatsheet de comandos (~300 líneas)
- ✅ **PRIMEROS_PASOS.md**: Instalación y configuración (~200 líneas)
- ✅ **FAQ.md**: Preguntas frecuentes y troubleshooting (~150 líneas)

#### Herramientas de Mantenimiento
- ✅ **Script SQL de limpieza**: `scripts/limpiar_base_datos.sql`
- ✅ **Estructura organizada**: Carpetas `workflows/`, `docs/`, `reference/`, etc.
- ✅ **Git ready**: `.gitignore` actualizado

### Mejoras Recientes (desde v017)

1. ✅ **Documentación de usuario completa** (4 archivos nuevos)
2. ✅ **Reorganización del proyecto** (estructura profesional)
3. ✅ **Script de limpieza de BD** (para empezar con datos limpios)
4. ✅ **CHANGELOG.md completo** (historial de versiones)
5. ✅ **README.md actualizado** (este archivo)

Ver [`CHANGELOG.md`](CHANGELOG.md) para historial completo de versiones.

---

## 💡 Casos de Uso

### Ejemplo 1: Captura Rápida

```
Usuario → Telegram: "Comprar leche mañana"
Bot: ✅ TAREA: Comprar leche - Guardado
     Prioridad: media
     Fecha: 2026-01-18
```

### Ejemplo 2: Consulta Inteligente

```
Usuario → Telegram: "qué tareas tengo"
Bot: 📊 3 resultados:
     1. Enviar informe (id: 1) - Prioridad: urgente, Vence: 2026-01-17
     2. Comprar leche (id: 2) - Prioridad: media, Vence: 2026-01-18
     3. Llamar dentista (id: 3) - Prioridad: media
```

### Ejemplo 3: Actualización

```
Usuario → Telegram: "Cambiar tarea comprar leche a urgente"
Bot: 🔄 Actualizado: Comprar leche ahora es urgente
```

### Ejemplo 4: Eliminación

```
Usuario → Telegram: "Borrar la tarea de llamar al dentista"
Bot: 🗑️ Eliminado: Llamar dentista
```

---

## 🔧 Instalación y Configuración

### Requisitos Previos

- **n8n v6.8+** (auto-hospedado)
- **MySQL 8.0+**
- **PostgreSQL** (para memoria conversacional)
- **Telegram Bot Token** (obtener de [@BotFather](https://t.me/BotFather))
- **Google Gemini API Key** (obtener de [AI Studio](https://aistudio.google.com/))

### Paso 1: Configurar Base de Datos MySQL

```sql
CREATE DATABASE segundo_cerebro;

USE segundo_cerebro;

-- Tabla de tareas
CREATE TABLE tareas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    prioridad ENUM('baja', 'media', 'alta', 'urgente') DEFAULT 'media',
    estado ENUM('pendiente', 'en_progreso', 'completada') DEFAULT 'pendiente',
    fecha_vencimiento DATE,
    contexto_adicional JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Tabla de proyectos
CREATE TABLE proyectos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    estado ENUM('activo', 'en_espera', 'completado') DEFAULT 'activo',
    fecha_limite DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Tabla de ideas
CREATE TABLE ideas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    contenido TEXT,
    tipo ENUM('nota', 'recurso', 'aprendizaje') DEFAULT 'nota',
    tags JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Tabla de personas
CREATE TABLE personas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    relacion ENUM('cliente', 'proveedor', 'amigo', 'colega', 'familia', 'otro') DEFAULT 'otro',
    datos_contacto JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Tabla de inbox_log (auditoría)
CREATE TABLE inbox_log (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id VARCHAR(50),
    mensaje_crudo TEXT,
    payload_json JSON,
    estado ENUM('pendiente', 'procesado', 'error') DEFAULT 'pendiente',
    canal_origen VARCHAR(50) DEFAULT 'telegram',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Paso 2: Importar Workflow en n8n

1. Abre tu instancia de n8n
2. Ve a **Workflows** → **Import from File**
3. Selecciona `workflows/workflow_segundo_cerebro_v018.json`
4. Configura las credenciales:
   - **Telegram Bot**: Token de [@BotFather](https://t.me/BotFather)
   - **MySQL**: Host, usuario, contraseña, database `segundo_cerebro`
   - **Google Gemini**: API Key de [AI Studio](https://aistudio.google.com/)
   - **PostgreSQL**: Configuración de memoria conversacional
5. **Activa el workflow**

### Paso 3: Probar el Sistema

1. Busca tu bot en Telegram
2. Envía: `Hola`
3. El bot debería responder confirmando que está activo
4. Envía: `Nueva tarea: Probar el segundo cerebro`
5. El bot debería responder: `✅ TAREA guardada`

**¡Listo!** Tu Segundo Cerebro está funcionando.

Para más detalles, consulta [`PRIMEROS_PASOS.md`](PRIMEROS_PASOS.md).

---

## 📖 Documentación

### Para Usuarios Finales

| Documento | Descripción | Líneas |
|-----------|-------------|--------|
| [`PRIMEROS_PASOS.md`](PRIMEROS_PASOS.md) | Instalación y configuración inicial | ~500 |
| [`GUIA_RAPIDA.md`](GUIA_RAPIDA.md) | Cheatsheet de comandos esenciales | ~300 |
| [`MANUAL_DE_USUARIO.md`](MANUAL_DE_USUARIO.md) | Guía completa con todos los casos de uso | ~1000 |
| [`FAQ.md`](FAQ.md) | Preguntas frecuentes y troubleshooting | ~400 |

### Para Desarrolladores

| Documento | Descripción |
|-----------|-------------|
| [`docs/DOCUMENTO_MAESTRO_SEGUNDO_CEREBRO.md`](docs/DOCUMENTO_MAESTRO_SEGUNDO_CEREBRO.md) | Especificaciones técnicas completas |
| [`docs/Diseño de Sistema Automatizado con IA.docx`](docs/Diseño%20de%20Sistema%20Automatizado%20con%20IA.docx) | Documento técnico maestro (~6MB) |
| [`reference/MYSQL_TOOL_V25_CODIGO_FUENTE.md`](reference/MYSQL_TOOL_V25_CODIGO_FUENTE.md) | Código fuente del MySQL Tool |
| [`CHANGELOG.md`](CHANGELOG.md) | Historial de versiones |

---

## 🗺️ Roadmap

### v019 (Próximamente)

- ✨ **Soporte de mensajes de voz** con transcripción automática
- 🎤 Procesamiento de audio con Gemini 2.5 Flash
- ⚡ Latencia esperada: <10 segundos para audio de 1 minuto

### v020+ (Backlog)

- `/fix` → Comando de corrección rápida de clasificación
- **Confidence scoring** → Prevención de datos de baja calidad (The Bouncer)
- **Búsqueda semántica** → Recuperación por significado (embeddings + vector DB)
- **Relaciones entre entidades** → Vincular tareas con proyectos
- **Digest diario/semanal** → Resúmenes automáticos vía Telegram
- **Next actions** → Campo obligatorio en proyectos

### v021+ (Futuro Lejano)

- Procesamiento de **imágenes** (OCR, análisis con Gemini Vision)
- Colaboración **multi-usuario**
- Comando `/export` → Exportar datos a CSV/JSON/PDF
- Integración con **calendarios** (Google Calendar, Outlook)

---

## 🐛 Bugs Conocidos

**Ninguno**. El sistema v018 está estable y probado.

Los bugs anteriores (v015-v017) han sido resueltos:
- ✅ Bug DATETIME en consultas (v016)
- ✅ Bug semántico "lista de tareas" (v017)
- ✅ ORDER BY restaurado (v017)

Ver [`bugs-resolved/`](bugs-resolved/) para análisis completo de bugs históricos.

---

## 🤝 Contribuciones

Este es un proyecto personal, pero si quieres contribuir:

1. Reporta bugs en [GitHub Issues](URL_ISSUES)
2. Sugiere mejoras contactando al administrador
3. Comparte tus ideas en [Discussions](URL_DISCUSSIONS)

**Nota**: El proyecto está diseñado para uso personal. Si planeas usar el código para un proyecto comercial, consulta la licencia.

---

## 📄 Licencia

[Definir licencia: MIT, GPL, propietaria, etc.]

---

## 📞 Soporte

- **Documentación**: Lee [`MANUAL_DE_USUARIO.md`](MANUAL_DE_USUARIO.md) o [`FAQ.md`](FAQ.md)
- **Issues**: [GitHub Issues](URL_ISSUES)
- **Contacto**: [info@ejemplo.com o Telegram del administrador]

---

## 🙏 Agradecimientos

### Inspiración

- **Tiago Forte** - Creador de "Building a Second Brain"
- **Video de referencia**: [Building a Second Brain with AI in 2026](https://www.youtube.com/watch?v=0TpON5T-Sw4)

### Tecnologías

- **n8n** - Orquestación de workflows
- **Google Gemini** - Motor de IA
- **Telegram** - Interfaz de usuario
- **MySQL** - Base de datos

---

## 📊 Estadísticas del Proyecto

- **Líneas de código**: ~50 (SQL schema)
- **Líneas de documentación**: ~3000+ (MD + DOCX)
- **Archivos**: 76 archivos en total
- **Tamaño del proyecto**: ~14 MB
- **Versiones**: v015 → v018 (4 versiones completas)
- **Bugs resueltos**: 3 bugs críticos
- **Tiempo de desarrollo**: ~5 días (13-17 Enero 2026)

---

**¿Listo para empezar?** Lee [`PRIMEROS_PASOS.md`](PRIMEROS_PASOS.md) ahora.

**Última actualización**: 17 Enero 2026 | **Versión**: v018 - Listo para Producción 🚀
