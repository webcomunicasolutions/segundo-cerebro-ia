# Changelog - Segundo Cerebro

Todos los cambios notables en este proyecto serán documentados en este archivo.

## [v018] - 2026-01-17 - PREPARACIÓN PARA PRODUCCIÓN 🚀

### ✅ Características Completadas

#### Sistema Core (100% Funcional)
- **Captura**: Envío de mensajes de texto a Telegram
- **Clasificación**: AI Agent con Gemini 2.5 Flash clasifica automáticamente en 4 categorías
- **Almacenamiento**: Base de datos MySQL con 4 tablas (tareas, proyectos, ideas, personas)
- **Memoria contextual**: Postgres Chat Memory preserva conversaciones

#### CRUD Completo
- **Insertar**: 4 herramientas (Insertar en tareas/proyectos/ideas/personas)
- **Consultar**: 4 herramientas con ordenamiento inteligente
- **Actualizar**: 4 herramientas con UPDATE condicional
- **Eliminar**: 4 herramientas con DELETE por ID

#### Funcionalidades Avanzadas
- **Inbox Log**: Registro de todos los mensajes recibidos
- **Formateo de respuestas**: Mensajes con emojis y Markdown
- **Prioridades automáticas**: Sistema infiere urgencia de tareas
- **Fechas naturales**: Interpreta "mañana", "próxima semana"

### 📝 Documentación Nueva
- `MANUAL_DE_USUARIO.md`: Guía completa para usuarios finales
- `GUIA_RAPIDA.md`: Cheatsheet de comandos y ejemplos
- `PRIMEROS_PASOS.md`: Instalación y configuración inicial
- `FAQ.md`: Preguntas frecuentes y troubleshooting

### 🗂️ Reorganización del Proyecto
- Nueva estructura de carpetas: `workflows/`, `docs/`, `reference/`, `bugs-resolved/`, `sessions/`, `scripts/`
- Mejor organización de archivos históricos
- Separación entre documentación técnica y usuario final

### 🛠️ Herramientas de Mantenimiento
- `scripts/limpiar_base_datos.sql`: Script para borrar datos de prueba

### 🚀 Listo para Producción
- Sistema estable y probado
- Documentación completa
- Estructura profesional
- Preparado para compartir

---

## [v017] - 2026-01-17 - EDICIÓN COMPLETA

### Nuevo
- **Actualización (UPDATE)**: 4 herramientas para modificar registros existentes
  - Actualizar tarea
  - Actualizar proyecto
  - Actualizar idea
  - Actualizar persona
- **Eliminación (DELETE)**: 4 herramientas para borrar registros
  - Eliminar tarea
  - Eliminar proyecto
  - Eliminar idea
  - Eliminar persona

### Arreglado
- **Bug ORDER BY restaurado**: Se restauró el ordenamiento en query "Consultar tareas"
- **Loops infinitos en consultas**: System prompt actualizado para prevenir loops

### Mejorado
- System prompt refactorizado con secciones más claras
- Workflow más robusto y confiable
- 16 herramientas totales funcionando correctamente

---

## [v016] - 2026-01-16

### Nuevo
- **Consultas (READ)**: 4 herramientas para ver información guardada
  - Consultar tareas (ordenadas por prioridad)
  - Consultar proyectos (ordenados por estado)
  - Consultar ideas (ordenadas por fecha)
  - Consultar personas (ordenadas alfabéticamente)

### Mejorado
- System prompt con reglas para consultas eficientes
- Formateo de respuestas mejorado

---

## [v015] - 2026-01-15

### Nuevo
- **Inserción (CREATE)**: 4 herramientas para guardar información
  - Insertar en tareas
  - Insertar en proyectos
  - Insertar en ideas
  - Insertar en personas

### Inicial
- Telegram Trigger configurado
- Guardar en inbox_log
- AI Agent con Google Gemini Chat Model
- Postgres Chat Memory
- Responder en Telegram

---

## Roadmap Futuro

### v019 (Planeado)
- **Soporte de Audio**: Procesamiento de mensajes de voz de Telegram
- **Transcripción automática**: Gemini 2.5 Flash con capacidad multimodal
- **Latencia optimizada**: <10 segundos para audio de 1 minuto

### v020+ (Backlog)
- **Comando /fix**: Corrección rápida de clasificación incorrecta
- **The Bouncer**: Confidence scoring para prevenir datos de baja calidad
- **Búsqueda semántica**: Embeddings + búsqueda vectorial
- **Relaciones entre entidades**: Vincular tareas con proyectos
- **Digest diario/semanal**: Resúmenes automáticos vía Telegram
- **Next actions**: Campo obligatorio en proyectos

---

**Convención de versionado**: vXXX (incremento simple por cada hito completo)
**Fecha formato**: YYYY-MM-DD
