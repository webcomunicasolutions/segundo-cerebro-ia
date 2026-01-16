# 🏗️ ESPECIFICACIÓN TÉCNICA FINAL: SISTEMA SEGUNDO CEREBRO (v1.0)

**Rol:** Documento Maestro de Construcción
**Arquitecto:** Gemini Agent
**Ejecutor:** Claude Code CLI
**Fecha:** 13/01/2026

---

## 1. Visión y Filosofía

Construiremos un **Organismo Digital** basado en la biología, no un simple almacén de datos.
*   **Principio Rector:** "Captura sin fricción, Procesamiento asíncrono".
*   **Objetivo:** El usuario solo "tira" información (inputs); el sistema la estructura, guarda y recuerda proactivamente.
*   **Escalabilidad:** El diseño es modular. Empezamos con el "Core Loop" (MVP), pero la estructura de datos permite conectar módulos futuros (Calendar, Drive, Email) sin reescribir la base.

---

## 2. Arquitectura del Sistema

### Flujo de Datos
```mermaid
[TELEGRAM] --(Webhook)--> [n8n] --(JSON)--> [GEMINI 2.5]
                             │
                             ├--(Data Structured)--> [MySQL]
                             │
                             └--(Feedback)---------> [TELEGRAM]
```

### Componentes y Responsabilidades

1.  **Telegram (Interfaz / Sentidos):**
    *   Entrada multimodal (Texto, Audio, Imagen).
    *   Salida de notificaciones y confirmaciones.
    *   **Regla de Oro:** "Fire & Forget". El usuario envía y sigue con su vida.

2.  **n8n (Orquestador / Sistema Nervioso):**
    *   Gestiona el flujo lógico.
    *   Maneja errores y reintentos.
    *   Implementa la lógica del "Portero" (The Bouncer).
    *   Patrón de ejecución: Acknowledge inmediato a Telegram -> Proceso en Background.

3.  **Gemini 2.5 Flash (Inteligencia / Cerebro):**
    *   **Rol:** Clasificador y Extractor de Entidades.
    *   **Input:** Texto crudo o transcripción.
    *   **Output:** JSON estricto (Schema Enforcement).
    *   **Lógica:** Categorización en 4 cubos + Evaluación de confianza.

4.  **MySQL (Memoria / Almacenamiento):**
    *   **Estrategia:** Híbrida (Relacional para estructura + JSON para flexibilidad).
    *   **Persistencia:** Todo se guarda. Nada se borra físicamente (Soft Delete).

---

## 3. Modelo de Datos (MySQL Schema)

Este esquema está diseñado para ser definitivo. Soporta el MVP y futuras expansiones.

### 3.1 Tabla de Auditoría (CRÍTICA)
*El "Recibo". Guarda la verdad cruda antes de cualquier procesamiento.*

```sql
CREATE TABLE inbox_log (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    fecha_recepcion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    canal_origen VARCHAR(50) DEFAULT 'telegram',
    usuario_id VARCHAR(100), -- ID de Telegram
    mensaje_crudo TEXT, -- El texto original o transcripción
    payload_json JSON, -- Todo el objeto técnico que envió Telegram (metadata)
    estado ENUM('pendiente', 'procesado', 'error', 'requiere_revision') DEFAULT 'pendiente',
    categoria_asignada VARCHAR(50), -- Resultado de la IA
    confianza_ia DECIMAL(4,3), -- 0.000 a 1.000
    razonamiento_ia TEXT, -- Por qué la IA decidió esto
    error_log TEXT, -- Si falla, aquí dice por qué
    INDEX idx_estado (estado),
    INDEX idx_fecha (fecha_recepcion)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

### 3.2 Las 4 Categorías Principales

#### A. PERSONAS (`personas`)
*CRM Ligero.*
```sql
CREATE TABLE personas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    relacion VARCHAR(100), -- Cliente, Proveedor, Amigo
    ultimo_contacto DATETIME,
    datos_contacto JSON, -- {email, telefono, telegram_id, linkedin}
    perfil_ia JSON, -- {hijos, cumpleaños, gustos, contexto_resumido}
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FULLTEXT(nombre)
);
```

#### B. PROYECTOS (`proyectos`)
*Contenedores de esfuerzos.*
```sql
CREATE TABLE proyectos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    estado ENUM('activo', 'en_espera', 'completado', 'cancelado') DEFAULT 'activo',
    fecha_limite DATE,
    persona_relacionada_id INT, -- FK opcional a Personas
    metadata JSON, -- {urls_drive, presupuesto, stack_tecnologico}
    resumen_ia TEXT, -- Resumen autogenerado del estado del proyecto
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (persona_relacionada_id) REFERENCES personas(id) ON DELETE SET NULL
);
```

#### C. IDEAS (`ideas`)
*Conocimiento pasivo y recursos.*
```sql
CREATE TABLE ideas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    contenido TEXT, -- El cuerpo de la nota
    tipo ENUM('nota', 'recurso', 'aprendizaje', 'diario') DEFAULT 'nota',
    tags JSON, -- ["tech", "filosofia", "n8n"]
    origen_url VARCHAR(512), -- Si viene de un link compartido
    proyecto_relacionado_id INT, -- FK opcional
    procesado_vectorial BOOLEAN DEFAULT FALSE, -- Para futuro RAG
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (proyecto_relacionado_id) REFERENCES proyectos(id) ON DELETE SET NULL,
    FULLTEXT(titulo, contenido)
);
```

#### D. ADMIN / TAREAS (`tareas`)
*Acciones ejecutables.*
```sql
CREATE TABLE tareas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL, -- Debe ser verbo + objeto (Next Action)
    estado ENUM('pendiente', 'en_progreso', 'completada', 'descartada') DEFAULT 'pendiente',
    prioridad ENUM('baja', 'media', 'alta', 'urgente') DEFAULT 'media',
    fecha_vencimiento DATETIME,
    persona_relacionada_id INT, -- FK opcional
    proyecto_relacionado_id INT, -- FK opcional
    contexto_adicional JSON, -- {checklist, subtareas, herramientas_necesarias}
    completada_en TIMESTAMP NULL, -- Soft Delete lógico
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (persona_relacionada_id) REFERENCES personas(id) ON DELETE SET NULL,
    FOREIGN KEY (proyecto_relacionado_id) REFERENCES proyectos(id) ON DELETE SET NULL,
    FULLTEXT(titulo)
);
```

---

## 4. Lógica del "Cerebro" (n8n + Gemini)

### Estrategia de Prompting
El prompt del sistema debe imponer estas reglas:
1.  **JSON Mode Only:** Prohibido responder texto libre.
2.  **Schema Enforcement:** Validar contra esquema definido.
3.  **Extracción Agresiva:** Si el usuario dice "mañana", convertir a `YYYY-MM-DD` real calculado hoy.

### El Portero (The Bouncer)
Regla lógica en n8n:
*   SI `confianza_ia` >= 0.80 -> **Guardado Automático** (Modo Fluido).
*   SI `confianza_ia` ENTRE 0.50 Y 0.79 -> **Guardado con Aviso** ("⚠️ Guardado como X, ¿es correcto?").
*   SI `confianza_ia` < 0.50 -> **Interrogatorio** ("🤔 No entendí. ¿Es Tarea, Idea o Persona?").

### Manejo de Archivos (MVP)
*   **Imágenes/PDFs:** Se envían a Gemini Vision/Multimodal.
*   **Acción:** Gemini extrae el texto/resumen.
*   **Almacenamiento:** Se guarda el *texto extraído* en `inbox_log` y la tabla destino. No guardamos el binario en disco local en esta fase (evita complejidad de gestión de archivos).

---

## 5. Interfaz de Usuario (Telegram Bot)

### Comandos Esenciales
*   `/start`: Bienvenida y explicación.
*   `/hoy`: Resumen de tareas pendientes para hoy.
*   `/fix [corrección]`: Comando mágico para editar la última entrada procesada.
    *   *Lógica:* Busca el último `id` en `inbox_log` del usuario y re-procesa con la instrucción de corrección.

---

## 6. Plan de Construcción (Roadmap)

### 🧱 FASE 1: Cimientos (INMEDIATA)
*   [ ] Levantar servidor MySQL (o usar existente).
*   [ ] Ejecutar script `schema.sql` para crear tablas.
*   [ ] Verificar conexión y permisos.

### 🔌 FASE 2: Conexiones
*   [ ] Crear Bot en Telegram (BotFather).
*   [ ] Configurar credenciales en n8n.
*   [ ] Crear Webhook "Hello World" (Telegram -> n8n -> Telegram) para confirmar tubería.

### 🧠 FASE 3: Inteligencia
*   [ ] Configurar nodo Gemini en n8n.
*   [ ] Implementar Prompt Maestro y JSON Parser.
*   [ ] Crear lógica de enrutamiento (Switch) a las 4 tablas MySQL.

### 🛡️ FASE 4: Robustez y Feedback
*   [ ] Implementar lógica "The Bouncer".
*   [ ] Crear mensajes de respuesta bonitos en Telegram.
*   [ ] Pruebas de estrés (Audio, Fotos, Texto ambiguo).

---

**Nota Final del Arquitecto:** Este diseño prioriza la **captura de datos crudos** (`inbox_log`). Incluso si nuestra lógica de IA falla hoy, los datos originales del usuario están seguros y podrán ser re-procesados por una IA mejorada en el futuro (versión 2.0).
