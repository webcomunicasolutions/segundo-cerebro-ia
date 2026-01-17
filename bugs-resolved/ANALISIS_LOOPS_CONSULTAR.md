# Análisis: Loops del AI Agent en Nodos CONSULTAR

## Fecha: 2026-01-16

## 🔍 Problema Identificado

El AI Agent entra en loop (10 iteraciones máximo) cuando usa las herramientas CONSULTAR que devuelven resultados vacíos `[]`.

### Ejemplo Fallido
```
Usuario: "mis proyectos"
Agente: Llama "Consultar proyectos" → []
Agente: Llama "Consultar proyectos" → []
Agente: Llama "Consultar proyectos" → []
... (10 veces)
Error: Max iterations (10) reached
```

---

## 📊 Análisis Técnico

### Estado Actual de Nodos CONSULTAR

Los 4 nodos CONSULTAR tienen:
- **Query FIJA**: Sin parámetros `$fromAI()` dinámicos
- **Tipo**: `operation: "executeQuery"`
- **Sin opciones avanzadas**: No usan `queryReplacement`, `detailedOutput`, etc.

#### Ejemplo: "Consultar proyectos"
```json
{
  "descriptionType": "manual",
  "toolDescription": "Consultar PROYECTOS guardados. Retorna id (NÚMERO ENTERO como 1, 2, 3...), nombre, estado, fecha_limite. USAR SIEMPRE antes de actualizar o eliminar un proyecto para obtener su ID numérico.",
  "operation": "executeQuery",
  "query": "SELECT id, nombre, estado, fecha_limite, DATE(created_at) as fecha_creacion FROM proyectos WHERE estado IN ('activo', 'en_espera') ORDER BY estado ASC, fecha_limite ASC LIMIT 20",
  "options": {}
}
```

### Comparación con Mejores Prácticas n8n

Según documentación oficial de AI Agent workflows:

| Aspecto | Nuestro Workflow | Best Practice | Estado |
|---------|------------------|---------------|--------|
| **Connection Type** | ✅ `ai_tool` | `ai_tool` | CORRECTO |
| **Tool Description** | ⚠️ Funcional pero mejorable | "Specific with context" | MEJORAR |
| **Handle Empty Results** | ❌ No documentado | Debe estar en prompt | FALTA |
| **Output Limiting** | ✅ LIMIT 20 | LIMIT rows | CORRECTO |
| **Parameters** | ⚠️ Sin parámetros | OK para queries fijas | ACEPTABLE |

---

## 🎯 Causa Raíz

### 1. **Descripciones de Tools No Documentan Resultados Vacíos**

**Descripción actual:**
```
"Consultar PROYECTOS guardados. Retorna id (...), nombre, estado. USAR SIEMPRE antes de actualizar..."
```

**Problema:** No menciona qué hacer si no hay proyectos.

**Comparación con ejemplo de documentación:**
```
// ❌ Vague
description: "Get data"

// ✅ Clear and concise
description: "Search GitHub issues by keyword and repository. Returns top 5 matching issues with titles and URLs."
```

### 2. **System Prompt No Maneja Resultados Vacíos Correctamente**

**Prompt actual (simplificado):**
```
REGLAS:
1. Para CONSULTAR: usa la herramienta 1 sola vez, muestra resultados y TERMINA
2. Si consulta devuelve vacío []: di "No hay datos" y TERMINA
3. NUNCA uses la misma herramienta 2 veces seguidas
```

**Problema:** Reglas 1 y 2 entran en conflicto:
- Regla 1 dice "muestra resultados y TERMINA"
- Regla 2 dice "di 'No hay datos' y TERMINA"
- El agente no sabe claramente qué hacer con `[]`

### 3. **Gemini 2.0 Flash No Reconoce `[]` Como "Vacío"**

Posible causa: El agente interpreta `[]` como "sin información" en lugar de "información válida de que no hay registros".

---

## 💡 Soluciones Propuestas

### SOLUCIÓN 1: Mejorar Descripciones de Tools CONSULTAR (PRIORIDAD ALTA)

Hacer las descripciones ultra-específicas según mejores prácticas de n8n.

#### Antes:
```
"Consultar PROYECTOS guardados. Retorna id (NÚMERO ENTERO como 1, 2, 3...), nombre, estado, fecha_limite. USAR SIEMPRE antes de actualizar o eliminar un proyecto para obtener su ID numérico."
```

#### Después (Propuesta):
```
"Listar todos los proyectos activos o en espera. Devuelve máximo 20 resultados con: id (número), nombre, estado, fecha_limite, fecha_creacion. Si no hay proyectos, devuelve lista vacía (esto es CORRECTO, no un error). Usar esta herramienta cuando el usuario pida 'mis proyectos', 'qué proyectos tengo', o antes de actualizar/eliminar un proyecto."
```

**Cambios clave:**
1. ✅ "Listar todos" → Más específico que "Consultar"
2. ✅ "Devuelve máximo 20 resultados" → Expectativa clara
3. ✅ "Si no hay proyectos, devuelve lista vacía (esto es CORRECTO, no un error)" → **CRÍTICO**
4. ✅ Ejemplos de uso: "mis proyectos", "qué proyectos tengo" → Guía al agente
5. ✅ Mantiene "antes de actualizar/eliminar"

### SOLUCIÓN 2: Refinar System Prompt para Claridad Total (PRIORIDAD ALTA)

Reescribir las reglas para eliminar ambigüedad.

#### Prompt Actual (Simplificado):
```
REGLAS:
1. Para CONSULTAR: usa la herramienta 1 sola vez, muestra resultados y TERMINA
2. Si consulta devuelve vacío []: di "No hay datos" y TERMINA
3. NUNCA uses la misma herramienta 2 veces seguidas
```

#### Prompt Mejorado (Propuesta):
```
## REGLA ABSOLUTA: NUNCA REPITAS UNA HERRAMIENTA

Si una herramienta ya devolvió resultado, NUNCA la llames de nuevo. Usa el resultado que ya tienes.

## CONSULTAS (Listar)

Cuando uses una herramienta "Consultar X":
1. Llama la herramienta UNA SOLA VEZ
2. Espera el resultado
3. Si resultado = [] (lista vacía):
   - Responde: "📭 No tienes [categoría] guardados aún."
   - TERMINA (NO vuelvas a consultar)
4. Si resultado = [{...}, {...}]:
   - Formatea y muestra los resultados
   - TERMINA

## FORMATO RESULTADO VACÍO
- Tareas vacías: "📭 No tienes tareas pendientes. ¡Genial!"
- Proyectos vacíos: "📭 No tienes proyectos activos aún."
- Ideas vacías: "📭 No tienes ideas guardadas todavía."
- Personas vacías: "📭 No tienes personas registradas aún."
```

**Cambios clave:**
1. ✅ Regla absoluta al principio: "NUNCA REPITAS UNA HERRAMIENTA"
2. ✅ Pasos numerados claros para CONSULTAR
3. ✅ Distinción explícita entre `[]` (vacío) y `[{...}]` (con datos)
4. ✅ Mensajes específicos por categoría para respuesta al usuario
5. ✅ "TERMINA" repetido en cada caso para reforzar

### SOLUCIÓN 3: Agregar Opciones Avanzadas a Nodos CONSULTAR (PRIORIDAD MEDIA)

Activar opciones que ayudan al agente a entender mejor los resultados.

#### Configuración Propuesta:
```json
{
  "descriptionType": "manual",
  "toolDescription": "[Nueva descripción mejorada]",
  "operation": "executeQuery",
  "query": "[Query actual]",
  "options": {
    "detailedOutput": true,        // Devuelve metadata adicional
    "largeNumbersOutput": "text",  // IDs como texto (más seguro)
    "replaceEmptyStrings": false   // No reemplazar strings vacíos
  }
}
```

**Beneficios:**
- `detailedOutput: true` → El agente recibe información adicional sobre el query ejecutado
- `largeNumbersOutput: "text"` → Los IDs siempre como texto (evita conversión de tipos)
- `replaceEmptyStrings: false` → Mantiene datos originales sin transformación

**Nota:** Esta solución es opcional y de menor prioridad. Las soluciones 1 y 2 deberían resolver el problema.

---

## 🧪 Casos de Prueba Actualizados

### Test 4: Consultar tabla vacía (PROYECTOS)
```
INPUT: "mis proyectos"

FLUJO ESPERADO:
1. Agente llama "Consultar proyectos" → []
2. Agente responde: "📭 No tienes proyectos activos aún."
3. FIN (NO vuelve a consultar)

RESULTADO ACTUAL: Loop 10x ❌
RESULTADO ESPERADO DESPUÉS DE FIX: Respuesta inmediata ✅
```

### Test 5: Consultar tabla con datos (TAREAS)
```
INPUT: "mis tareas"

FLUJO ESPERADO:
1. Agente llama "Consultar tareas" → [{id: 1, titulo: "Comprar leche", ...}]
2. Agente responde:
   📊 **Tienes 1 tarea pendiente**
   1. Comprar leche (id: 1) - Prioridad: media
3. FIN

RESULTADO ESPERADO: ✅ (Ya funciona según conversación histórica)
```

---

## 📝 Implementación Sugerida

### Paso 1: Actualizar Descripciones (5 min)
Editar los 4 nodos CONSULTAR con las nuevas descripciones mejoradas.

### Paso 2: Actualizar System Prompt (10 min)
Reemplazar la sección de REGLAS en el AI Agent con el prompt mejorado.

### Paso 3: Probar (10 min)
- Test 4: "mis proyectos" (tabla vacía)
- Test 5: "mis tareas" (tabla con datos)
- Test 6: "mis ideas" (tabla vacía)

### Paso 4: Validar (5 min)
Confirmar que el agente NO entra en loop y responde correctamente a resultados vacíos.

---

## 📌 Conclusiones

### Problema Principal
El loop ocurre porque:
1. Las descripciones de tools no documentan comportamiento con resultados vacíos
2. El system prompt tiene reglas ambiguas sobre qué hacer con `[]`
3. El agente interpreta `[]` como "necesito más información" → repite la consulta

### Solución
1. **Descripciones explícitas**: Documentar que `[]` es un resultado válido
2. **System prompt sin ambigüedad**: Reglas claras paso a paso
3. **Opciones avanzadas** (opcional): Mejorar metadata de respuestas

### Impacto Esperado
- ✅ Elimina loops en consultas a tablas vacías
- ✅ Respuestas inmediatas al usuario
- ✅ Experiencia más fluida del sistema
- ✅ Reduce costo de tokens (menos iteraciones)

---

## 📚 Referencias

- Documentación n8n AI Agent: [AI Agent Workflow Pattern](/home/juan/.claude/skills/n8n-workflow-patterns/ai_agent_workflow.md)
- Mejores prácticas Tool Descriptions: Línea 662-670
- Ejemplo Database as Tool: Línea 285-308
- Common Gotchas: Línea 650-704

