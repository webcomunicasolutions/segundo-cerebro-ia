# Changelog - Segundo Cerebro

Todos los cambios notables en este proyecto serán documentados en este archivo.

## [v019] - 2026-01-17/18 - 🎤 SOPORTE DE AUDIO - ✅ EN PRODUCCIÓN

### ✨ Nueva Funcionalidad: Mensajes de Voz

#### Sistema de Procesamiento de Audio (100% Completado y Validado)
- **Detección automática**: Nodo Switch distingue entre mensajes de texto y audio
- **Descarga de audio**: HTTP Requests obtienen archivo de Telegram API
- **Transcripción con Gemini**: Google Gemini 2.0 Flash transcribe audio a texto
- **Procesamiento unificado**: El texto transcrito se procesa como mensaje normal

#### Arquitectura del Flujo de Audio
```
Telegram Trigger → Es Audio? (Switch)
  ├─→ [Audio] → Obtener File Info → Descargar Audio → Gemini Transcribir → Preparar Mensaje → Guardar inbox_log → AI Agent → Responder
  └─→ [Texto] → Guardar inbox_log → AI Agent → Responder
```

#### Nodos Agregados (5 nuevos)
1. **Es Audio?** (Switch): Detecta `message.voice` o `message.audio`
2. **Obtener File Info** (HTTP Request): Obtiene `file_path` del audio
3. **Descargar Audio** (HTTP Request): Descarga archivo binario
4. **Gemini Transcribir** (Google Gemini): Transcribe audio con `gemini-2.0-flash-exp`
5. **Preparar Mensaje** (Set): Formatea transcripción como `message.text`

### 🔧 Tecnologías Utilizadas
- **Google Gemini 2.0 Flash**: Modelo multimodal con soporte nativo de audio
- **Telegram Bot API**: `getFile` y descarga de archivos binarios
- **n8n HTTP Request**: Manejo de binary data y file downloads
- **n8n Switch**: Routing condicional por tipo de mensaje

### ✅ Ventajas sobre Implementaciones Alternativas
- **Sin OpenAI Whisper**: Eliminada dependencia de OpenAI
- **Modelo unificado**: Mismo Gemini para transcripción y AI Agent
- **Formato nativo**: Soporta OGG Vorbis (formato default de Telegram)
- **Latencia optimizada**: Gemini 2.0 Flash es extremadamente rápido

### 📊 Estado del Sistema
- ✅ Flujo de texto: Funcional (sin cambios)
- ✅ Flujo de audio: Implementado y listo para pruebas
- ✅ CRUD completo: 16 herramientas funcionando
- ✅ Workflow exportado: `workflows/segundo_cerebro_v019.json`

### ✅ Testing Completado
- ✅ **Test 1**: Enviar mensaje de texto (regresión) - Validado en producción
- ✅ **Test 2**: Enviar mensaje de voz real - Validado en producción
- ✅ **Validación completa**: Ambos flujos funcionando correctamente

### 📦 Cambios Técnicos
- **Nodos totales**: 22 → 27 (+5 nodos de audio)
- **Conexiones totales**: 21 → 26 (+5 conexiones)
- **Workflow versionado**: v018 → v019

### 🎉 Estado Final v019
Sistema completamente funcional en producción con soporte multimodal (texto + audio). Validado con mensajes reales de Telegram.

---

## [v018] - 2026-01-17 - ✅ COMPLETADO AL 100% - LISTO PARA PRODUCCIÓN 🚀

### ✅ Características Completadas

#### Sistema Core (100% Funcional)
- **Captura**: Envío de mensajes de texto a Telegram
- **Clasificación**: AI Agent con Gemini 2.5 Flash clasifica automáticamente en 4 categorías
- **Almacenamiento**: Base de datos MySQL con 4 tablas (tareas, proyectos, ideas, personas)
- **Memoria contextual**: Postgres Chat Memory preserva conversaciones

#### CRUD Completo (16 Herramientas Validadas)
- **Insertar**: 4 herramientas (Insertar en tareas/proyectos/ideas/personas)
- **Consultar**: 4 herramientas con ordenamiento inteligente
- **Actualizar**: 4 herramientas con UPDATE condicional ✅ **VALIDADO EN PRODUCCIÓN**
- **Eliminar**: 4 herramientas con DELETE por ID ✅ **VALIDADO EN PRODUCCIÓN**

#### Funcionalidades Avanzadas
- **Inbox Log**: Registro de todos los mensajes recibidos
- **Formateo de respuestas**: Mensajes con emojis y Markdown
- **Prioridades automáticas**: Sistema infiere urgencia de tareas
- **Fechas naturales**: Interpreta "mañana", "próxima semana"
- **Detección de duplicados**: Pide aclaración cuando hay ambigüedad

### 📝 Documentación Nueva (~2150 líneas)
- `MANUAL_DE_USUARIO.md`: Guía completa para usuarios finales (~1000 líneas)
- `GUIA_RAPIDA.md`: Cheatsheet de comandos y ejemplos (~300 líneas)
- `PRIMEROS_PASOS.md`: Instalación y configuración inicial (~500 líneas)
- `FAQ.md`: Preguntas frecuentes y troubleshooting (~400 líneas)

### 🗂️ Reorganización del Proyecto (45 archivos reorganizados)
- Nueva estructura de carpetas: `workflows/`, `docs/`, `reference/`, `bugs-resolved/`, `sessions/`, `scripts/`
- Mejor organización de archivos históricos
- Separación entre documentación técnica y usuario final
- README.md completamente reescrito para producción

### 🛠️ Herramientas de Mantenimiento
- `scripts/limpiar_base_datos.sql`: Script para borrar datos de prueba con safeguards

### 🧪 Tests de Validación (Ejecutados y Pasados)
- ✅ **Test 1 - UPDATE**: "Marcar tarea como completada" (Ejecución 85480)
  - Sistema detectó duplicados y pidió aclaración
  - UPDATE ejecutado correctamente
  - Respuesta clara al usuario
- ✅ **Test 2 - DELETE**: "Eliminar registro" (Ejecución 85480)
  - DELETE ejecutado correctamente
  - Registro desaparecido de consultas posteriores
  - Data safety confirmado

### 🚀 Estado Final
- ✅ Sistema 100% completo y validado
- ✅ Documentación profesional completa
- ✅ Estructura de proyecto compartible
- ✅ Todos los tests pasados
- ✅ Listo para producción inmediata

### 📦 Commits GitHub
- `5afffb7`: v018 preparación para producción completa (45 archivos, +6573 líneas)
- `72ebb08`: Actualizado TAREAS_PENDIENTES.md con estado v018
- `39cf0d4`: Clarificado pendientes (solo 2 tests)
- `[próximo]`: v018 100% completo con tests validados

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
