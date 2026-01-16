# 🧠 Sistema de Segundo Cerebro Automatizado con IA

[![Estado](https://img.shields.io/badge/Estado-En%20Desarrollo-yellow)](https://github.com/webcomunicasolutions/segundo_cerebro)
[![Versión](https://img.shields.io/badge/Versión-1.0--MVP-blue)](https://github.com/webcomunicasolutions/segundo_cerebro)
[![Licencia](https://img.shields.io/badge/Licencia-Privada-red)](https://github.com/webcomunicasolutions/segundo_cerebro)

**Sistema agéntico activo de Personal Knowledge Management (PKM)** basado en la metodología "Building a Second Brain" de Tiago Forte, potenciado por IA de última generación.

---

## 🎯 Visión del Proyecto

Construir un **Organismo Digital** que funciona como un verdadero segundo cerebro:

- **Captura sin fricción**: El usuario solo "tira" información (texto, audio, imágenes)
- **Procesamiento inteligente**: IA analiza, clasifica y estructura automáticamente
- **Memoria persistente**: Todo se guarda con contexto completo y recuperable
- **Acción proactiva**: El sistema recuerda y sugiere en el momento correcto

> 💡 **Diferenciador clave**: No es un almacén pasivo. El sistema **trabaja mientras duermes**, clasificando, extrayendo metadatos y preparando insights.

---

## 🏗️ Arquitectura del Sistema

### Stack Tecnológico

```
┌─────────────┐
│  TELEGRAM   │ ← Interfaz de captura multimodal (texto, audio, imagen)
└──────┬──────┘
       │ Webhook
       ▼
┌─────────────┐
│     n8n     │ ← Orquestador de flujos + lógica de negocio
└──────┬──────┘
       │ API Call
       ▼
┌─────────────┐
│ GEMINI 2.5  │ ← Motor cognitivo (clasificación + extracción)
│    FLASH    │
└──────┬──────┘
       │ Structured JSON
       ▼
┌─────────────┐
│    MySQL    │ ← Memoria persistente (relacional + JSON híbrido)
└─────────────┘
```

### Componentes

| Componente | Rol | Tecnología |
|------------|-----|------------|
| **Telegram Bot** | Interfaz de usuario (captura y notificaciones) | Telegram Bot API |
| **n8n** | Sistema nervioso central (workflows visuales) | n8n (self-hosted) |
| **Gemini 2.5 Flash** | Cerebro (clasificación semántica + JSON Schema) | Google AI API |
| **MySQL** | Memoria (estructura relacional + flexibilidad JSON) | MySQL 8.0+ |

---

## 📊 Modelo de Datos

El sistema organiza la información en **4 categorías principales** (método PARA):

### 1. 👥 PERSONAS (`personas`)
CRM ligero para gestión de contactos, clientes y relaciones.

**Campos clave**: nombre, relación, datos_contacto (JSON), perfil_ia (JSON)

### 2. 📁 PROYECTOS (`proyectos`)
Contenedores de esfuerzos a corto plazo con objetivos definidos.

**Campos clave**: nombre, estado, fecha_limite, metadata (JSON), resumen_ia

### 3. 💡 IDEAS (`ideas`)
Repositorio de conocimiento, notas, recursos y aprendizajes.

**Campos clave**: titulo, contenido, tipo, tags (JSON), origen_url

### 4. ✅ TAREAS (`tareas`)
Acciones ejecutables con formato "Next Action" (verbo + objeto).

**Campos clave**: titulo, estado, prioridad, fecha_vencimiento, contexto_adicional (JSON)

### 📝 AUDITORÍA (`inbox_log`)
**Tabla crítica** que guarda el rastro crudo de todo lo que entra al sistema.

- Permite re-procesamiento con IAs mejoradas en el futuro
- Confidence scoring para validar calidad
- Razonamiento de la IA documentado

---

## 🧠 Los 8 Building Blocks

Implementación de los principios del video ["Building a Second Brain with AI in 2026"](https://www.youtube.com/watch?v=0TpON5T-Sw4):

| # | Block | Implementación |
|---|-------|----------------|
| 1️⃣ | **The Dropbox** | Bot de Telegram (captura multimodal) |
| 2️⃣ | **The Sorter** | Gemini 2.5 Flash con JSON Schema Enforcement |
| 3️⃣ | **The Form** | Esquema MySQL estricto + validación |
| 4️⃣ | **The Filing Cabinet** | Tablas MySQL con tipo JSON híbrido |
| 5️⃣ | **The Receipt** | Tabla `inbox_log` (auditoría completa) |
| 6️⃣ | **The Bouncer** | Lógica de confianza en n8n (threshold 0.8) |
| 7️⃣ | **The Tap on the Shoulder** | Comandos de Telegram + notificaciones |
| 8️⃣ | **The Fix Button** | Comando `/fix` para corrección rápida |

---

## 🚀 Roadmap de Construcción

### ✅ FASE 0: Blueprint (COMPLETADA)
- [x] Diseño de arquitectura
- [x] Esquema de base de datos
- [x] Especificación técnica completa
- [x] Repositorio Git configurado

### ✅ FASE 1: Cimientos (COMPLETADA)
- [x] Setup de servidor MySQL
- [x] Ejecución de `schema.sql`
- [x] Validación de conexiones
- [x] Inserciones de prueba en todas las tablas
- [x] Documentación de conexión

### ✅ FASE 2: Conexiones (COMPLETADA)
- [x] Crear bot en Telegram (BotFather)
- [x] Configurar credenciales en n8n
- [x] Webhook "Hello World" funcional
- [x] Workflow activo y respondiendo

### ✅ FASE 3: Inteligencia (COMPLETADA)
- [x] Configurar AI Agent con Gemini 2.5 Flash
- [x] Implementar prompt maestro con clasificación PARA
- [x] 4 MySQL Tools operativas:
  - `Insertar en tareas` (titulo, prioridad)
  - `Insertar en ideas` (titulo, contenido, tipo)
  - `Insertar en proyectos` (nombre, estado)
  - `Insertar en personas` (nombre, relacion)
- [x] Postgres Chat Memory para contexto de conversación
- [x] Patrón `$fromAI()` para inserción dinámica
- [x] Control de versiones de workflows (`n8n/workflows/versions/`)

### 🛡️ FASE 4: Robustez
- [ ] Implementar "The Bouncer" (confidence scoring)
- [ ] Mensajes de respuesta elegantes
- [ ] Testing con inputs multimodales

### 🚀 FASE 5: MVP Release
- [ ] Comandos básicos (`/start`, `/hoy`, `/fix`)
- [ ] Documentación de usuario
- [ ] Deploy en producción

---

## 📁 Estructura del Repositorio

```
segundo_cerebro/
├── .gitignore              # Exclusiones (credenciales, logs, backups)
├── README.md               # Este archivo
├── CLAUDE.md               # Instrucciones para Claude Code
│
├── docs/                   # Documentación técnica
│   ├── ESPECIFICACION_TECNICA_FINAL_v1.md
│   └── arquitectura.md
│
├── database/               # Esquemas y migraciones
│   ├── schema.sql          # Creación inicial de tablas
│   ├── migrations/         # Cambios evolutivos
│   └── seeds/              # Datos de prueba
│
├── n8n/                    # Workflows de n8n
│   ├── workflows/          # Exportaciones JSON
│   ├── credentials/        # Plantillas (sin datos reales)
│   └── README.md
│
├── prompts/                # Ingeniería de prompts
│   ├── gemini-classifier.txt
│   ├── json-schemas/
│   └── ejemplos.md
│
└── scripts/                # Automatizaciones
    ├── setup.sh
    ├── backup-db.sh
    └── deploy-n8n-workflow.sh
```

---

## 🔧 Requisitos del Sistema

### Infraestructura
- **MySQL 8.0+** (soporte JSON nativo + FULLTEXT)
- **n8n** (Docker recomendado, self-hosted)
- **Gemini API Key** (Google AI Studio)
- **Telegram Bot Token** (BotFather)

### Conocimientos Recomendados
- SQL básico (CREATE TABLE, SELECT, INSERT)
- n8n workflows (lógica visual)
- JSON Schema (para validación)
- Ingeniería de prompts (básico)

---

## 📖 Referencias y Fuentes

### Metodología
- [Building a Second Brain - Tiago Forte](https://www.buildingasecondbrain.com/)
- [Método CODE - StoryShots](https://www.getstoryshots.com/books/building-a-second-brain-summary/)

### Inspiración Técnica
- [Building a Second Brain with AI in 2026 (YouTube)](https://www.youtube.com/watch?v=0TpON5T-Sw4)
- Video de 30 minutos que propone stack Slack+Notion+Zapier

### Documentación Técnica
- [n8n Documentation](https://docs.n8n.io/)
- [Gemini API Reference](https://ai.google.dev/docs)
- [MySQL JSON Functions](https://dev.mysql.com/doc/refman/8.0/en/json-functions.html)

---

## 🛡️ Seguridad y Privacidad

- ✅ **Self-hosted**: n8n y MySQL bajo tu control total
- ✅ **Sin terceros**: Datos personales no pasan por clouds externos
- ✅ **Cifrado**: Credenciales nunca en el repositorio (ver `.gitignore`)
- ✅ **Auditoría**: Todo input queda registrado en `inbox_log`
- ✅ **Backup**: Scripts automatizados para respaldo de MySQL

---

## 🤝 Contribución

Este es un **proyecto privado** para uso personal. No se aceptan contribuciones externas en esta fase.

---

## 📄 Licencia

**Privado y Propietario** - Todos los derechos reservados.

---

## 📬 Contacto

**Mantenedor**: Juan (webcomunicasolutions)

**Repository**: [webcomunicasolutions/segundo_cerebro](https://github.com/webcomunicasolutions/segundo_cerebro)

---

## 🎯 Principios de Diseño

### Los 12 Principios de Ingeniería Aplicados

1. ✅ **Un solo comportamiento humano**: Capturar (el sistema hace el resto)
2. ✅ **Separación de capas**: Memoria (MySQL) + Compute (n8n+Gemini) + Interfaz (Telegram)
3. ✅ **Prompts como APIs**: JSON Schema Enforcement estricto
4. ✅ **Construir confianza**: Tabla `inbox_log` + confidence scoring
5. ✅ **Fail-safe**: Comportamiento seguro ante baja confianza
6. ✅ **Output pequeño**: Resúmenes diarios <150 palabras
7. ✅ **Next Action**: Tareas con formato ejecutable (verbo + objeto)
8. ✅ **Routing > Organizing**: IA clasifica, usuario no decide taxonomía
9. ✅ **Minimalismo**: 4-5 campos máximo por categoría
10. ✅ **Diseño para restart**: Fácil retomar sin guilt o cleanup
11. ✅ **Core loop primero**: MVP antes de módulos opcionales
12. ✅ **Maintainability**: Workflows visuales, logs claros

---

**Última actualización**: 14 de enero de 2026 - FASE 3 COMPLETADA
