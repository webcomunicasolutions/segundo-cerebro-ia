# 🧭 FASE 3: CORRECCIÓN DE RUMBO (Arquitectura)

**De:** Arquitecto del Proyecto
**Para:** Claude Code (Constructor)
**Fecha:** 14/01/2026
**Estado:** CRÍTICO - Recuperación de Funcionalidad Completa

---

## 🛑 SITUACIÓN ACTUAL
Has logrado estabilizar el sistema reduciéndolo a la mínima expresión (`v008_tareas_2_campos`). Esto fue una buena maniobra defensiva para detener los errores de SQL, pero **hemos perdido la esencia del Segundo Cerebro**.

Actualmente el sistema:
1. Solo guarda en `tareas`.
2. Ignora `proyectos`, `ideas` y `personas`.
3. Pierde datos críticos como fechas, contextos y relaciones.

## 🎯 OBJETIVO INMEDIATO
**Restaurar la funcionalidad completa del método PARA (Projects, Areas, Resources, Archive) sin sacrificar la estabilidad.**

Necesitamos pasar de "Solo guarda Título y Prioridad" a "Guarda todo el contexto rico que el usuario provee".

---

## 🛠️ INSTRUCCIONES TÉCNICAS (n8n + MySQL)

### 1. Reactivación de las 4 Tools (MySQL)
Debes configurar las 4 herramientas en el AI Agent. No uses `autoMapInputData` si falla; configura los campos explícitamente usando `$fromAI()`.

#### A. Tool: `insertar_tarea` (Tabla: `tareas`)
Recuperar campos perdidos. Configuración robusta:
- **titulo**: `$fromAI('titulo', 'Título de la acción', 'string')` (OBLIGATORIO)
- **prioridad**: `$fromAI('prioridad', 'baja, media, alta, urgente', 'string')` (ENUM estricto) (Default: 'media')
- **fecha_vencimiento**: `$fromAI('fecha_vencimiento', 'YYYY-MM-DD HH:MM:SS', 'string')`
- **contexto_adicional**: `$fromAI('contexto', 'Detalles en JSON', 'string')`

#### B. Tool: `insertar_idea` (Tabla: `ideas`)
- **titulo**: `$fromAI('titulo', 'Título breve', 'string')`
- **contenido**: `$fromAI('contenido', 'Texto completo de la idea', 'string')`
- **tipo**: `$fromAI('tipo', 'nota, recurso, aprendizaje', 'string')` (Default: 'nota')
- **tags**: `$fromAI('tags', 'Array de tags JSON', 'string')`

#### C. Tool: `insertar_proyecto` (Tabla: `proyectos`)
- **nombre**: `$fromAI('nombre', 'Nombre del proyecto', 'string')`
- **estado**: `$fromAI('estado', 'activo, en_espera', 'string')` (Default: 'activo')
- **fecha_limite**: `$fromAI('fecha_limite', 'YYYY-MM-DD', 'string')`

#### D. Tool: `insertar_persona` (Tabla: `personas`)
- **nombre**: `$fromAI('nombre', 'Nombre completo', 'string')`
- **relacion**: `$fromAI('relacion', 'cliente, proveedor, amigo', 'string')` (Default: 'cliente')
- **datos_contacto**: `$fromAI('datos_contacto', 'JSON con email/tel', 'string')`

---

### 2. El Prompt Maestro (System Prompt)
Gemini necesita saber qué valores son válidos para no romper MySQL. Actualiza el System Prompt del nodo "AI Agent" con estas reglas de validación:

```text
Eres el gestor de un Segundo Cerebro Digital. Tu misión es clasificar y guardar información usando las herramientas disponibles.

REGLAS DE ORO PARA HERRAMIENTAS:

1. FECHAS:
   - Si el usuario dice "mañana", CALCULA la fecha exacta (YYYY-MM-DD) basada en hoy: {{ $now }}.
   - Nunca envíes "mañana" o texto relativo a un campo de fecha.

2. ENUMS (Valores estrictos):
   - Prioridad: SOLO usa 'baja', 'media', 'alta', 'urgente'. (Default: 'media')
   - Estado Tarea: 'pendiente', 'en_progreso'. (Default: 'pendiente')
   - Tipo Idea: 'nota', 'recurso', 'aprendizaje'. (Default: 'nota')
   - Relación Persona: 'cliente', 'proveedor', 'amigo'. (Default: 'cliente')

3. JSON:
   - Los campos 'contexto_adicional', 'tags', 'datos_contacto' esperan un STRING con formato JSON válido.
   - Ejemplo tags: "[\"tech\", \"n8n\"]"

4. SELECCIÓN DE TOOL:
   - Acción concreta ("llamar", "comprar", "enviar") -> usar `insertar_tarea`
   - Objetivo a largo plazo ("lanzar web", "aprender python") -> usar `insertar_proyecto`
   - Información pasiva/referencia ("artículo interesante", "nota de reunión") -> usar `insertar_idea`
   - Datos de contacto ("Juan, teléfono 555...") -> usar `insertar_persona`

Si falta información opcional, envía null o string vacío, pero NO inventes datos.
```

---

### 3. Estrategia de Ejecución
1.  **No borres** lo que funciona. Clona el workflow `v008` y trabaja sobre una nueva versión `v009_full_para`.
2.  Añade las tools **una a una**.
    *   Primero: Mejora `insertar_tarea` con fecha y contexto. Prueba.
    *   Segundo: Añade `insertar_idea`. Prueba.
    *   Tercero: Añade el resto.
3.  **Verifica en MySQL**: Después de cada prueba, haz un `SELECT` para confirmar que los datos complejos (fechas, JSON) se guardaron bien.

---

**NOTA FINAL:**
El usuario ya tiene la base de datos lista (`segundo_cerebro`) con todas las columnas necesarias. No tengas miedo de usarlas. El error anterior fue por intentar mapear columnas automáticas (`autoMapInputData`); al definirlas explícitamente (`defineBelow`), tendrás control total.

¡Adelante, recupera la inteligencia del sistema!
