# 🧠 Segundo Cerebro Digital - Sistema Automatizado con IA

Sistema agéntico de gestión del conocimiento personal (PKM) basado en la metodología "Building a Second Brain", implementado con n8n, Telegram, MySQL y Gemini 2.0 Flash.

## 🎯 ¿Qué es este proyecto?

Un **Segundo Cerebro automatizado** que:
- ✅ Captura pensamientos vía Telegram (texto, audio, imágenes)
- 🤖 Clasifica automáticamente con IA (sin decisiones manuales)
- 📊 Organiza en base de datos estructurada (MySQL)
- 💬 Responde consultas inteligentes en lenguaje natural
- ⚡ Funciona en <5 segundos de latencia

**Diferencia clave**: A diferencia de sistemas pasivos (Notion, Obsidian), este sistema **piensa por ti** usando un motor de razonamiento (Gemini 2.0 Flash).

---

## 🏗️ Arquitectura

```
Telegram Bot → n8n Workflow → AI Agent (Gemini 2.0 Flash) → MySQL Database
                                    ↓
                    16 Herramientas MySQL Tool
                    (4 INSERT, 4 SELECT, 4 UPDATE, 4 DELETE)
```

### Stack Tecnológico

| Componente | Tecnología | Propósito |
|------------|------------|-----------|
| **Interfaz** | Telegram Bot API | Captura omnipresente (móvil, desktop, web) |
| **Orquestación** | n8n (auto-hospedado) | Flujos de trabajo visuales |
| **Motor IA** | Google Gemini 2.0 Flash | Razonamiento y clasificación semántica |
| **Base de Datos** | MySQL 8.0 | Almacenamiento híbrido (relacional + JSON) |
| **Memoria** | PostgreSQL | Historial de conversación del agente |

---

## 📂 Estructura de Archivos

```
notas_ideas/
├── README.md                                    # Este archivo
├── CLAUDE.md                                    # Instrucciones para Claude Code
├── CHANGELOG_v016.md                            # Historial de cambios (última versión)
│
├── Diseño de Sistema Automatizado con IA.docx  # Documento técnico completo (~6MB)
├── DOCUMENTO_MAESTRO_SEGUNDO_CEREBRO.md        # Especificaciones del sistema
├── Concepto_Segundo_Cerebro_AI_2026.md         # Fundamentos conceptuales
│
├── MYSQL_TOOL_V25_CODIGO_FUENTE.md             # Documentación MySQL Tool (MCP + GitHub)
├── HTTP_REQUEST_DOCUMENTACION_COMPLETA.md      # Documentación HTTP Request node
├── OPCIONES_MYSQL_TOOL_V25.md                  # Guía rápida de opciones MySQL
├── OPCIONES_GOOGLE_GEMINI_CHAT_MODEL.md        # Configuración de Gemini
│
├── Transcripcion_Analizada_Segundo_Cerebro_2026.md  # Análisis del video de referencia
├── segundo_cerebro.txt                          # Notas iniciales
│
├── blueprint_v1/                                # Blueprints de n8n workflows
└── n8n-mysql-docs/                             # Código fuente descargado de n8n
```

---

## 🚀 Estado del Proyecto

### Versión Actual: v016 ✅

**Workflow ID**: `ZI6VUFdg6hEhnCbh`
**Nodos**: 22
**Estado**: Producción - Verificado y funcionando
**Última actualización**: 16 Enero 2026

### Mejoras Recientes (v016)

1. ✅ **Configuración MySQL Tool v2.5** (16 nodos)
   - `replaceEmptyStrings: true` en INSERT/UPDATE
   - `largeNumbersOutput: "text"` en todos los nodos

2. ✅ **Fix crítico: AI Agent loop en resultados vacíos**
   - Antes: ~15 segundos (timeout)
   - Ahora: ~4 segundos (respuesta normal)

3. ✅ **Corrección de formato de fecha** (n8n Luxon)
4. ✅ **Autofix de 10 expresiones** n8n

Ver [CHANGELOG_v016.md](CHANGELOG_v016.md) para detalles completos.

---

## 💡 Casos de Uso

### Captura Rápida
```
Usuario → Telegram: "Comprar leche"
Bot: ✅ TAREA guardada: "Comprar leche" (prioridad: media)
```

### Consulta Inteligente
```
Usuario: "Qué personas tengo registradas?"
Bot: 📊 Personas (4 resultados)
     1. Juan García (Cliente)
     2. María López (Proveedor)
     ...
```

### Actualización Natural
```
Usuario: "Cambiar proyecto Web a Rebranding"
Bot: 🔄 Actualizado: Rebranding
```

### Búsqueda Sin Resultados
```
Usuario: "Tengo a Antonio en la lista?"
Bot: No, Antonio no está registrado
```

---

## 🗄️ Esquema de Base de Datos

### Tablas Principales

#### 1. `tareas`
- `id` (INT AUTO_INCREMENT)
- `titulo` (VARCHAR 255)
- `prioridad` (ENUM: baja, media, alta, urgente)
- `estado` (ENUM: pendiente, en_progreso, completada)
- `fecha_vencimiento` (DATE)
- `proyecto_id` (INT FK)
- `metadatos` (JSON)

#### 2. `proyectos`
- `id` (INT AUTO_INCREMENT)
- `nombre` (VARCHAR 255)
- `estado` (ENUM: activo, pausado, completado)
- `fecha_limite` (DATE)
- `metadatos` (JSON)

#### 3. `ideas`
- `id` (INT AUTO_INCREMENT)
- `titulo` (VARCHAR 255)
- `contenido` (TEXT)
- `tipo` (VARCHAR 100)
- `tags` (JSON)
- `metadatos` (JSON)

#### 4. `personas`
- `id` (INT AUTO_INCREMENT)
- `nombre` (VARCHAR 255)
- `relacion` (VARCHAR 100)
- `datos_contacto` (JSON)
- `metadatos` (JSON)

#### 5. `inbox_log` (Auditoría)
- `id` (INT AUTO_INCREMENT)
- `mensaje_original` (TEXT)
- `timestamp` (TIMESTAMP)
- `user_id` (VARCHAR 100)
- `clasificacion` (VARCHAR 50)
- `confianza` (DECIMAL 3,2)

---

## 🛠️ Configuración

### Requisitos

- **n8n**: v1.0+ (auto-hospedado recomendado)
- **MySQL**: 8.0+
- **PostgreSQL**: 14+ (para Postgres Chat Memory)
- **Telegram Bot**: Token de @BotFather
- **Google Gemini API Key**: API de Google AI Studio

### Variables de Entorno (n8n)

```bash
# Telegram
TELEGRAM_BOT_TOKEN=your_bot_token

# Google Gemini
GEMINI_API_KEY=your_api_key

# MySQL
MYSQL_HOST=localhost
MYSQL_PORT=3306
MYSQL_DATABASE=segundo_cerebro
MYSQL_USER=your_user
MYSQL_PASSWORD=your_password

# PostgreSQL (Chat Memory)
POSTGRES_HOST=localhost
POSTGRES_PORT=5432
POSTGRES_DATABASE=n8n_chat_memory
POSTGRES_USER=your_user
POSTGRES_PASSWORD=your_password
```

### Instalación

1. **Clonar repositorio**
```bash
git clone https://github.com/tu-usuario/segundo-cerebro-ia.git
cd segundo-cerebro-ia
```

2. **Configurar base de datos MySQL**
```sql
CREATE DATABASE segundo_cerebro;
-- Ejecutar scripts SQL en blueprint_v1/
```

3. **Importar workflow en n8n**
- Abrir n8n
- Workflows → Import from File
- Seleccionar `blueprint_v1/segundo_cerebro_v016.json`

4. **Configurar credenciales en n8n**
- Telegram Bot API
- Google Gemini API
- MySQL Connection
- PostgreSQL Connection

5. **Activar workflow**
- Abrir workflow importado
- Click en "Active" (switch)

---

## 📊 Métricas de Rendimiento

### Tiempos de Respuesta

| Operación | Latencia | Nodos Ejecutados |
|-----------|----------|------------------|
| Captura simple | ~3-5s | 7 |
| Consulta con datos | ~4-5s | 7 |
| Consulta sin datos | ~4s | 7 |
| Actualización | ~4-5s | 7 |
| Eliminación | ~4-5s | 7 |

### Costos Estimados (Google Gemini 2.0 Flash)

- **Input**: $0.10 / 1M tokens
- **Output**: $0.40 / 1M tokens
- **Costo por interacción**: ~$0.0001-0.0005 USD
- **Uso mensual (100 interacciones/día)**: ~$1-3 USD

---

## 🔒 Privacidad y Seguridad

### ✅ Ventajas de Auto-hospedaje

- Datos personales bajo tu custodia exclusiva
- Sin almacenamiento en clouds de terceros
- Control total sobre logs y auditoría
- Cumplimiento GDPR garantizado

### ⚠️ Consideraciones

- Gemini API envía datos a Google (clasificación semántica)
- Telegram almacena mensajes según políticas propias
- Recomendado: VPS privado para n8n + MySQL

---

## 📚 Documentación Técnica

### Documentos Esenciales

1. **[CHANGELOG_v016.md](CHANGELOG_v016.md)** - Historial de cambios detallado
2. **[MYSQL_TOOL_V25_CODIGO_FUENTE.md](MYSQL_TOOL_V25_CODIGO_FUENTE.md)** - Documentación híbrida (MCP + GitHub)
3. **[DOCUMENTO_MAESTRO_SEGUNDO_CEREBRO.md](DOCUMENTO_MAESTRO_SEGUNDO_CEREBRO.md)** - Especificaciones completas

### Recursos Externos

- [Building a Second Brain - Tiago Forte](https://www.buildingasecondbrain.com/)
- [n8n Documentation](https://docs.n8n.io/)
- [Google Gemini API](https://ai.google.dev/)
- [Telegram Bot API](https://core.telegram.org/bots/api)

---

## 🧪 Testing

### Tests de Verificación

Ejecutar estos tests después de cada cambio:

```bash
# Test 1: Captura básica
Telegram: "Comprar pan"
Esperado: ✅ TAREA guardada

# Test 2: Consulta con datos
Telegram: "Qué proyectos tengo?"
Esperado: Lista de proyectos

# Test 3: Consulta sin datos
Telegram: "Tengo a ZZZ en la lista?"
Esperado: "No, ZZZ no está registrado"

# Test 4: Actualización
Telegram: "Renombrar proyecto X a Y"
Esperado: 🔄 Actualizado: Y

# Test 5: Eliminación
Telegram: "Borrar tarea X"
Esperado: 🗑️ Eliminado: X
```

---

## 🤝 Contribuir

### Metodología de Documentación

Este proyecto utiliza **Documentación Híbrida**:
1. **MCP (n8n-creator)**: Información estructurada en tiempo real
2. **GitHub Source Code**: Implementación TypeScript
3. **Testing en Vivo**: Validación con ejecuciones reales

### Proceso de Contribución

1. Fork del repositorio
2. Crear rama feature: `git checkout -b feature/nueva-funcionalidad`
3. Commit con mensaje descriptivo
4. Push a tu fork
5. Crear Pull Request con documentación actualizada

---

## 🚀 Roadmap

### v017 (Próxima versión)

- [ ] Comando `/fix` para corrección rápida
- [ ] Confidence scores en clasificaciones
- [ ] Digest diario/semanal automático
- [ ] Búsqueda semántica con embeddings
- [ ] Soporte multimodal (audio, imágenes)

### v018 (Futuro)

- [ ] Dashboard de analytics
- [ ] Integración con calendario
- [ ] Export a Notion/Obsidian
- [ ] Voice capture optimizado
- [ ] Mobile app nativa (opcional)

---

## 📄 Licencia

Este proyecto es de código abierto bajo licencia MIT.

---

## 👨‍💻 Autor

**Juan (@webcomunica)**
Proyecto personal de gestión del conocimiento con IA

---

## 🙏 Agradecimientos

- **Tiago Forte**: Metodología "Building a Second Brain"
- **n8n Team**: Plataforma de automatización open-source
- **Google AI**: Gemini 2.0 Flash API
- **Comunidad PKM**: Inspiración y mejores prácticas

---

**Status**: ✅ Producción - Versión v016
**Última actualización**: 16 Enero 2026
