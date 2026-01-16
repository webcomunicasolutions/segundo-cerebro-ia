# FIX: Restauración de ORDER BY original en "Consultar tareas"

**Fecha**: 17 Enero 2026
**Workflow**: `segundo_cerebro` (ID: `ZI6VUFdg6hEhnCbh`)
**Estado**: ✅ **CORREGIDO**

---

## 📋 Resumen

Al debuggear el bug DATETIME ayer (16 Enero), hice un cambio **innecesario** simplificando el ORDER BY de la query "Consultar tareas". Hoy se restauró el ORDER BY original que ordena inteligentemente por prioridad y fecha de vencimiento.

---

## ⚠️ Problema Identificado

### Query con cambio innecesario (16 Enero 2026):
```sql
SELECT id, titulo, prioridad, estado, DATE(fecha_vencimiento) as fecha_vencimiento, DATE(created_at) as fecha_creacion
FROM tareas
WHERE estado != 'completada'
ORDER BY id DESC  -- ❌ INNECESARIO - Simplifiqué el ORDER BY original
LIMIT 20
```

**Problema**: Este ORDER BY simplificado ordena por ID descendente, perdiendo la lógica de priorización inteligente que tenía la query original.

**Impacto**:
- Las tareas se presentan en orden de creación (ID), no por importancia
- Una tarea urgente reciente puede aparecer después de tareas de baja prioridad antiguas
- UX degradada para el usuario

---

## ✅ Solución Aplicada

### Query correcta restaurada (17 Enero 2026):
```sql
SELECT id, titulo, prioridad, estado, DATE(fecha_vencimiento) as fecha_vencimiento, DATE(created_at) as fecha_creacion
FROM tareas
WHERE estado != 'completada'
ORDER BY CASE prioridad
  WHEN 'urgente' THEN 1
  WHEN 'alta' THEN 2
  WHEN 'media' THEN 3
  WHEN 'baja' THEN 4
END, fecha_vencimiento ASC  -- ✅ RESTAURADO - Ordena por prioridad y fecha
LIMIT 20
```

**Beneficios del ORDER BY original**:
1. ✅ **Ordena por prioridad**: urgente → alta → media → baja
2. ✅ **Dentro de cada prioridad**: ordena por fecha de vencimiento (más próximas primero)
3. ✅ **UX mejorada**: Usuario ve primero lo más importante y urgente
4. ✅ **Lógica de negocio**: Refleja correctamente la metodología GTD/Second Brain

---

## 🔍 Análisis del Cambio Necesario vs Innecesario

### Cambio NECESARIO (para fix del bug DATETIME):
```sql
-- ❌ ANTES (causaba loop infinito)
SELECT ..., fecha_vencimiento, ...

-- ✅ DESPUÉS (funciona)
SELECT ..., DATE(fecha_vencimiento) as fecha_vencimiento, ...
```

**Razón**: MySQL Tool v2.5 tiene bug al transmitir valores DATETIME a AI Agents.

### Cambio INNECESARIO (simplificación del ORDER BY):
```sql
-- ❌ Cambio innecesario (16 Enero)
ORDER BY id DESC

-- ✅ Original correcto (restaurado 17 Enero)
ORDER BY CASE prioridad WHEN 'urgente' THEN 1 WHEN 'alta' THEN 2 WHEN 'media' THEN 3 WHEN 'baja' THEN 4 END, fecha_vencimiento ASC
```

**Razón por la que se cambió**: Al debuggear, pensé que el ORDER BY complejo podía estar causando el problema, pero NO era la causa.

**Razón por la que se restauró**: El usuario notó correctamente que el cambio era innecesario y degradaba la UX.

---

## 📊 Otras Queries NO Modificadas

Las queries de otros nodos de Consultar **NO fueron modificadas** durante el debugging de ayer:

### ✅ Consultar proyectos (intacta):
```sql
SELECT id, nombre, estado, fecha_limite, DATE(created_at) as fecha_creacion
FROM proyectos
WHERE estado IN ('activo', 'en_espera')
ORDER BY estado ASC, fecha_limite ASC
LIMIT 20
```

### ✅ Consultar ideas (intacta):
```sql
SELECT id, titulo, contenido, tipo, tags, DATE(created_at) as fecha_creacion
FROM ideas
ORDER BY created_at DESC
LIMIT 20
```

### ✅ Consultar personas (intacta):
```sql
SELECT id, nombre, relacion, datos_contacto, DATE(created_at) as fecha_creacion
FROM personas
ORDER BY nombre ASC
LIMIT 20
```

**Razón**: Estas queries NO tenían columnas DATETIME problemáticas y funcionaban correctamente desde el inicio.

---

## 🎯 Resultado

- ✅ Query "Consultar tareas" restaurada con ORDER BY original
- ✅ Fix DATETIME mantenido: `DATE(fecha_vencimiento)`
- ✅ Sistema funciona correctamente
- ✅ Tareas se presentan en orden lógico de prioridad y fecha
- ✅ UX restaurada a su calidad original

---

## 📝 Lección Aprendida

Al debuggear bugs complejos:
1. **Hacer cambios mínimos**: Solo modificar lo estrictamente necesario
2. **Hipótesis aisladas**: Probar una hipótesis a la vez, no múltiples cambios simultáneos
3. **Revertir cambios innecesarios**: Cuando se identifica la causa raíz real, revertir cambios exploratorios
4. **Documentar qué cambió y por qué**: Para facilitar reversión posterior

En este caso, el **ÚNICO** cambio necesario era `fecha_vencimiento` → `DATE(fecha_vencimiento)`.

---

**Documentado por**: Claude Code (Sonnet 4.5)
**Fecha**: 17 Enero 2026
