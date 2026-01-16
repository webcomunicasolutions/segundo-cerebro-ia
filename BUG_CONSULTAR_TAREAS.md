# BUG CRÍTICO: Consultar Tareas entra en Loop Infinito

**Fecha**: 16 Enero 2026
**Workflow**: `segundo_cerebro` (ID: `ZI6VUFdg6hEhnCbh`)
**Estado**: 🚨 **SIN RESOLVER**

---

## 📋 Resumen Ejecutivo

El nodo "Consultar tareas" causa que el AI Agent entre en un loop infinito de 10 iteraciones cuando el usuario pide "lista de tareas", resultando en error "Max iterations (10) reached" y respuesta vacía en Telegram.

**Lo extraño**: La query SQL **SÍ ejecuta correctamente** y **SÍ retorna 4 registros**, pero el AI Agent no los procesa.

---

## 🔍 Síntomas Observados

### ✅ Nodos que FUNCIONAN
- **Consultar proyectos** → Retorna 4 proyectos, AI Agent procesa en ~1.5s ✅
- **Consultar ideas** → Retorna 6 ideas, AI Agent procesa en ~2s ✅
- **Consultar personas** → Retorna 4 personas, AI Agent procesa en ~4.7s ✅

### ❌ Nodo que FALLA
- **Consultar tareas** → Retorna 4 tareas (confirmado en logs), pero AI Agent:
  - Alcanza "Max iterations (10)"
  - Duración: ~13-15 segundos
  - Respuesta vacía en Telegram
  - Error: "Max iterations (10) reached. The agent could not complete the task within the allowed number of iterations."

---

## 📊 Evidencia Recopilada

### Ejecución Fallida: 85355 (última)
```json
{
  "duration": 13709,
  "nodes": {
    "Consultar tareas": {
      "executionTime": 3,
      "itemsOutput": 0,  // ⚠️ Muestra 0 pero datos SÍ existen
      "status": "success"
    },
    "AI Agent": {
      "executionTime": 4,
      "output": {
        "error": "Max iterations (10) reached..."
      }
    }
  }
}
```

### Datos Reales en Base de Datos (confirmado por usuario)
```json
[
  {
    "id": 15,
    "titulo": "Ir en bici con Francisco",
    "prioridad": "media",
    "estado": "pendiente",
    "fecha_vencimiento": "2026-01-17 12:00:00",
    "fecha_creacion": "2026-01-16"
  },
  {
    "id": 4,
    "titulo": "DiseÃ±ar interfaz de usuario para el bot",
    "prioridad": "media",
    "estado": "pendiente",
    "fecha_vencimiento": "2026-01-18 17:00:00",
    "fecha_creacion": "2026-01-13"
  },
  {
    "id": 1,
    "titulo": "Comprar leche",
    "prioridad": "baja",
    "estado": "pendiente",
    "fecha_vencimiento": "2026-01-14 10:00:00",
    "fecha_creacion": "2026-01-13"
  },
  {
    "id": 6,
    "titulo": "Escribir documentaciÃ³n de usuario final",
    "prioridad": "baja",
    "estado": "pendiente",
    "fecha_vencimiento": "2026-02-10 17:00:00",
    "fecha_creacion": "2026-01-13"
  }
]
```

**Nota**: Los caracteres mal codificados (`DiseÃ±ar`, `documentaciÃ³n`) también aparecen en proyectos/ideas/personas, **NO ES EL PROBLEMA**.

### Comparación de Queries

**❌ FALLA - Consultar tareas** (última versión probada):
```sql
SELECT id, titulo, prioridad, estado, DATE(fecha_vencimiento) as fecha_vencimiento, DATE(created_at) as fecha_creacion
FROM tareas
WHERE estado != 'completada'
ORDER BY id DESC
LIMIT 20
```

**✅ FUNCIONA - Consultar proyectos**:
```sql
SELECT id, nombre, estado, fecha_limite, DATE(created_at) as fecha_creacion
FROM proyectos
WHERE estado IN ('activo', 'en_espera')
ORDER BY estado ASC, fecha_limite ASC
LIMIT 20
```

**✅ FUNCIONA - Consultar ideas**:
```sql
SELECT id, titulo, contenido, tipo, tags, DATE(created_at) as fecha_creacion
FROM ideas
ORDER BY created_at DESC
LIMIT 20
```

---

## 🧪 Hipótesis Probadas y DESCARTADAS

### ❌ Hipótesis 1: Query compleja con CASE en ORDER BY
**Probado**: Simplificar ORDER BY de `CASE prioridad...` a `ORDER BY id DESC`
**Resultado**: Sigue fallando
**Conclusión**: NO es el ORDER BY

### ❌ Hipótesis 2: Valores NULL en ORDER BY
**Probado**: `fecha_vencimiento` puede ser NULL, pero `fecha_limite` en proyectos también
**Resultado**: Proyectos funciona con NULLs, tareas no
**Conclusión**: NO son los NULLs

### ❌ Hipótesis 3: Encoding UTF-8 de caracteres especiales
**Probado**: Agregar `CAST(titulo AS CHAR CHARACTER SET utf8mb4)`
**Resultado**: Sigue fallando
**Conclusión**: NO es el encoding (además, otras tablas tienen los mismos caracteres mal codificados y funcionan)

### ❌ Hipótesis 4: Formato DATETIME vs DATE
**Probado**: Convertir `fecha_vencimiento` a `DATE(fecha_vencimiento)`
**Resultado**: Sigue fallando
**Conclusión**: NO es el tipo de dato de fecha

---

## 🤔 Observaciones Críticas

1. **La query ejecuta correctamente**: MySQL retorna 4 registros (confirmado por usuario viendo los datos crudos)

2. **itemsOutput muestra 0**: Los logs de n8n muestran `itemsOutput: 0` para "Consultar tareas", pero los datos SÍ existen

3. **Patrón intermitente**:
   - Ejecución 85349: "lista de tareas" → FALLA (14.3s, max iterations)
   - Ejecución 85350: "lista de proyectos" → FUNCIONA (5.1s, 4 resultados)
   - Ejecución 85353: "lista de tareas" → FALLA (14.5s, max iterations)
   - Ejecución 85355: "lista de tareas" → FALLA (13.7s, max iterations)

4. **El AI Agent no recibe los datos**: A pesar de que MySQL retorna datos, el AI Agent actúa como si recibiera `[]` (array vacío)

5. **Sin errores de MySQL**: El nodo "Consultar tareas" muestra `status: "success"`, no hay errores SQL

---

## 🎯 Hipótesis Actuales (SIN PROBAR)

### Hipótesis 5: Bug en MySQL Tool v2.5 con columna `estado`
**Razón**:
- Tareas: tiene columna `estado` con valores 'pendiente', 'en_progreso', 'completada'
- Proyectos: tiene columna `estado` con valores 'activo', 'en_espera', 'completado'
- Ideas: NO tiene columna `estado`
- Personas: NO tiene columna `estado`

**Posible conflicto**: MySQL Tool puede tener un bug interno con columnas llamadas `estado` cuando se usan como AI Tools.

**Cómo probar**:
```sql
-- Renombrar columna temporalmente
SELECT id, titulo, prioridad, estado as estado_tarea, DATE(fecha_vencimiento) as fecha_vencimiento, DATE(created_at) as fecha_creacion
FROM tareas
WHERE estado != 'completada'
ORDER BY id DESC
LIMIT 20
```

### Hipótesis 6: Conflicto con WHERE comparando con string
**Razón**:
- Tareas usa: `WHERE estado != 'completada'`
- Proyectos usa: `WHERE estado IN ('activo', 'en_espera')`
- Ideas: sin WHERE
- Personas: sin WHERE

**Posible bug**: MySQL Tool puede tener problema con `!=` en WHERE

**Cómo probar**:
```sql
-- Cambiar != por IN
SELECT id, titulo, prioridad, estado, DATE(fecha_vencimiento) as fecha_vencimiento, DATE(created_at) as fecha_creacion
FROM tareas
WHERE estado IN ('pendiente', 'en_progreso')
ORDER BY id DESC
LIMIT 20
```

### Hipótesis 7: Bug específico de MySQL Tool al retornar datos a AI Agent
**Razón**:
- La query ejecuta (3ms de execution time)
- Los datos existen en MySQL
- Pero `itemsOutput: 0` en logs
- Y AI Agent actúa como si recibiera `[]`

**Problema**: Hay una desconexión entre la ejecución SQL y la transmisión de datos al AI Agent.

**Cómo probar**:
- Crear un nodo MySQL **normal** (no Tool) que ejecute la misma query
- Ver si retorna datos correctamente
- Si funciona → el bug está en MySQL **Tool** específicamente

### Hipótesis 8: Límite de tokens/caracteres en respuesta
**Razón**:
- Tareas tiene títulos con caracteres especiales mal codificados
- Puede que el total de caracteres exceda algún límite interno

**Cómo probar**:
```sql
-- Limitar a 1 registro
SELECT id, titulo, prioridad, estado, DATE(fecha_vencimiento) as fecha_vencimiento, DATE(created_at) as fecha_creacion
FROM tareas
WHERE estado != 'completada'
ORDER BY id DESC
LIMIT 1
```

---

## 📝 Configuración Actual del Nodo

```javascript
{
  "parameters": {
    "descriptionType": "manual",
    "toolDescription": "Consultar TAREAS guardadas. Retorna id (NÚMERO ENTERO como 1, 2, 3...), titulo, prioridad, estado, fecha_vencimiento. USAR SIEMPRE antes de actualizar o eliminar una tarea para obtener su ID numérico.",
    "operation": "executeQuery",
    "query": "SELECT id, titulo, prioridad, estado, DATE(fecha_vencimiento) as fecha_vencimiento, DATE(created_at) as fecha_creacion FROM tareas WHERE estado != 'completada' ORDER BY id DESC LIMIT 20",
    "options": {
      "largeNumbersOutput": "text"
    }
  },
  "id": "mysql-tool-consultar-tareas",
  "name": "Consultar tareas",
  "type": "n8n-nodes-base.mySqlTool",
  "typeVersion": 2.5,
  "credentials": {
    "mySql": {
      "id": "yTsefijtH5HVvPzn",
      "name": "segundo_cerebro"
    }
  }
}
```

---

## 🔬 Próximos Pasos para Debugging

### Prioridad ALTA ⚠️

1. **Probar Hipótesis 6** (cambiar `WHERE estado != 'completada'` por `WHERE estado IN (...)`)
   - Es diferente a lo que usan proyectos/ideas/personas
   - Fácil de probar
   - Alta probabilidad de ser el culpable

2. **Probar Hipótesis 7** (crear nodo MySQL normal, no Tool)
   - Confirmar si el bug está en MySQL Tool vs MySQL normal
   - Crítico para identificar dónde está el problema

3. **Probar Hipótesis 8** (LIMIT 1 en vez de LIMIT 20)
   - Descartar problema de tamaño de respuesta
   - Rápido de probar

### Prioridad MEDIA 📋

4. **Probar Hipótesis 5** (renombrar columna `estado`)
   - Menos probable, pero posible conflicto interno

5. **Comparar configuraciones de credenciales MySQL**
   - Ver si hay diferencias en charset/encoding entre nodos

### Si todo falla: Solución Temporal 🔧

**Workaround**: Usar un nodo MySQL **normal** (no Tool) + un nodo Code que convierta el resultado a formato que el AI Agent espera, conectado manualmente.

---

## 📊 Comparativa Completa de Nodos

| Característica | Tareas ❌ | Proyectos ✅ | Ideas ✅ | Personas ✅ |
|----------------|-----------|--------------|----------|-------------|
| **Tipo nodo** | mySqlTool | mySqlTool | mySqlTool | mySqlTool |
| **Operation** | executeQuery | executeQuery | executeQuery | executeQuery |
| **Columna estado** | Sí (pendiente/en_progreso/completada) | Sí (activo/en_espera/completado) | No | No |
| **WHERE clause** | `!= 'completada'` | `IN ('activo', 'en_espera')` | Ninguno | Ninguno |
| **ORDER BY** | `id DESC` | `estado ASC, fecha_limite ASC` | `created_at DESC` | `nombre ASC` |
| **Campos fecha** | `fecha_vencimiento` (DATETIME), `created_at` | `fecha_limite` (DATE?), `created_at` | `created_at` | `created_at` |
| **Caracteres especiales** | Sí (ñ, ó mal codificados) | Sí | Sí | Sí |
| **itemsOutput en logs** | 0 | 4 | 6 | 4 |
| **AI Agent duration** | 4ms (error) | 1522ms (success) | 2057ms (success) | ~4700ms (success) |
| **Total duration** | ~14s | ~5s | ~6s | ~5s |

---

## 🎬 Historial de Cambios en Query

### Versión 1 (original con CASE)
```sql
SELECT id, titulo, prioridad, estado, fecha_vencimiento, DATE(created_at) as fecha_creacion
FROM tareas
WHERE estado != 'completada'
ORDER BY CASE prioridad WHEN 'urgente' THEN 1 WHEN 'alta' THEN 2 WHEN 'media' THEN 3 WHEN 'baja' THEN 4 END, fecha_vencimiento ASC
LIMIT 20
```
**Resultado**: ❌ FALLA

### Versión 2 (ORDER BY simplificado)
```sql
SELECT id, titulo, prioridad, estado, fecha_vencimiento, DATE(created_at) as fecha_creacion
FROM tareas
WHERE estado != 'completada'
ORDER BY id DESC
LIMIT 20
```
**Resultado**: ❌ FALLA

### Versión 3 (con CAST para UTF-8)
```sql
SELECT id, CAST(titulo AS CHAR CHARACTER SET utf8mb4) as titulo, prioridad, estado, fecha_vencimiento, DATE(created_at) as fecha_creacion
FROM tareas
WHERE estado != 'completada'
ORDER BY id DESC
LIMIT 20
```
**Resultado**: ❌ FALLA

### Versión 4 (actual - con DATE en fecha_vencimiento)
```sql
SELECT id, titulo, prioridad, estado, DATE(fecha_vencimiento) as fecha_vencimiento, DATE(created_at) as fecha_creacion
FROM tareas
WHERE estado != 'completada'
ORDER BY id DESC
LIMIT 20
```
**Resultado**: ❌ FALLA

---

## 🔗 Ejecuciones Relevantes

- **85346**: Primera detección del bug - "lista de proyectos" → Max iterations
- **85349**: "lista de tareas" → Max iterations (14.3s)
- **85350**: "lista de proyectos" → SUCCESS (5.1s) - confirmó que proyectos funciona
- **85353**: "lista de tareas" → Max iterations (14.5s) - después de simplificar ORDER BY
- **85355**: "lista de tareas" → Max iterations (13.7s) - versión actual

---

## 💡 Notas Importantes

1. **La query NO está mal**: MySQL la ejecuta correctamente y retorna datos
2. **No es problema de datos**: Los 4 registros existen y son válidos
3. **No es problema de encoding**: Otras tablas tienen los mismos caracteres mal codificados
4. **Es específico del nodo**: Solo "Consultar tareas" falla, los otros 3 consultar funcionan
5. **El bug es consistente**: 100% reproducible, no es aleatorio

---

## 🎯 Acción Recomendada para Mañana

**PRIORIDAD 1**: Probar cambiar `WHERE estado != 'completada'` por `WHERE estado IN ('pendiente', 'en_progreso')`

Esta es la diferencia más obvia entre tareas (que falla) y proyectos (que funciona). Ambos tienen columna `estado`, pero:
- Tareas usa: `estado != 'completada'` (operador de desigualdad)
- Proyectos usa: `estado IN ('activo', 'en_espera')` (operador IN)

Si esto lo resuelve, sabemos que MySQL Tool v2.5 tiene un bug con el operador `!=` en WHERE cuando se usa como AI Tool.

---

**Documentado por**: Claude Code (Sonnet 4.5)
**Fecha**: 16 Enero 2026 23:30
**Estado**: Pendiente de resolución
