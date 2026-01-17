# Cambios Propuestos v016: Fix Loops en CONSULTAR

## 📋 Resumen

Actualizar **4 nodos CONSULTAR** + **System Prompt del AI Agent** para eliminar loops cuando se consultan tablas vacías.

**Tiempo estimado:** 15 minutos
**Dificultad:** Baja (solo edición de textos)

---

## 🔄 CAMBIO 1: Descripciones de Nodos CONSULTAR

### 1.1 Consultar tareas

**ANTES:**
```
Consultar TAREAS guardadas. Retorna id (NÚMERO ENTERO como 1, 2, 3...), titulo, prioridad, estado, fecha_vencimiento. USAR SIEMPRE antes de actualizar o eliminar una tarea para obtener su ID numérico.
```

**DESPUÉS:**
```
Listar todas las tareas pendientes y en progreso. Devuelve máximo 20 resultados ordenados por prioridad con: id (número), titulo, prioridad, estado, fecha_vencimiento, fecha_creacion. Si no hay tareas pendientes, devuelve lista vacía [] (esto es CORRECTO y significa que no hay tareas). Usar cuando el usuario pida 'mis tareas', 'qué tareas tengo', 'tareas pendientes', o antes de actualizar/eliminar una tarea específica.
```

**Razón:** Documenta explícitamente que `[]` es válido, da ejemplos de cuándo usar, clarifica límite de 20.

---

### 1.2 Consultar proyectos

**ANTES:**
```
Consultar PROYECTOS guardados. Retorna id (NÚMERO ENTERO como 1, 2, 3...), nombre, estado, fecha_limite. USAR SIEMPRE antes de actualizar o eliminar un proyecto para obtener su ID numérico.
```

**DESPUÉS:**
```
Listar todos los proyectos activos o en espera. Devuelve máximo 20 resultados con: id (número), nombre, estado, fecha_limite, fecha_creacion. Si no hay proyectos, devuelve lista vacía [] (esto es CORRECTO y significa que no hay proyectos activos). Usar cuando el usuario pida 'mis proyectos', 'qué proyectos tengo', 'estado de proyectos', o antes de actualizar/eliminar un proyecto específico.
```

**Razón:** Misma justificación que 1.1. Especifica "activos o en espera" (según el WHERE de la query).

---

### 1.3 Consultar ideas

**ANTES:**
```
Consultar IDEAS guardadas. Retorna id (NÚMERO ENTERO como 1, 2, 3...), titulo, contenido, tipo, tags. USAR SIEMPRE antes de actualizar o eliminar una idea para obtener su ID numérico.
```

**DESPUÉS:**
```
Listar las 20 ideas más recientes. Devuelve máximo 20 resultados ordenados por fecha con: id (número), titulo, contenido, tipo, tags, fecha_creacion. Si no hay ideas guardadas, devuelve lista vacía [] (esto es CORRECTO y significa que aún no hay ideas). Usar cuando el usuario pida 'mis ideas', 'qué ideas tengo', 'mostrar ideas', o antes de actualizar/eliminar una idea específica.
```

**Razón:** Especifica "20 más recientes" (según ORDER BY created_at DESC LIMIT 20).

---

### 1.4 Consultar personas

**ANTES:**
```
Consultar PERSONAS guardadas. Retorna id (NÚMERO ENTERO como 1, 2, 3...), nombre, relacion, datos_contacto. USAR SIEMPRE antes de actualizar o eliminar una persona para obtener su ID numérico.
```

**DESPUÉS:**
```
Listar todas las personas registradas ordenadas alfabéticamente. Devuelve máximo 20 resultados con: id (número), nombre, relacion, datos_contacto, fecha_creacion. Si no hay personas registradas, devuelve lista vacía [] (esto es CORRECTO y significa que no hay contactos). Usar cuando el usuario pida 'mis contactos', 'qué personas tengo', 'lista de personas', o antes de actualizar/eliminar una persona específica.
```

**Razón:** Especifica "ordenadas alfabéticamente" (según ORDER BY nombre ASC).

---

## 📝 CAMBIO 2: System Prompt del AI Agent

### System Prompt Completo Propuesto

**Reemplazar todo el `systemMessage` actual del nodo "AI Agent" con:**

```
Eres el gestor de un Segundo Cerebro Digital. Hoy es {{ $now.format('DD-MM-YYYY') }}.

## REGLA ABSOLUTA: NUNCA REPITAS UNA HERRAMIENTA

Si una herramienta ya devolvió resultado, NUNCA la llames de nuevo. Usa el resultado que ya tienes.

## TU TRABAJO EN 3 PASOS

**PASO 1 - Entender qué quiere el usuario:**
- Guardar algo → usar "Insertar en [categoría]"
- Ver qué hay → usar "Listar [categoría]"
- Cambiar algo → necesitas el ID numérico primero
- Borrar algo → necesitas el ID numérico primero

**PASO 2 - Si necesitas ID, consulta UNA SOLA VEZ:**
- Llama "Listar [categoría]" → recibes [{\"id\": 5, \"titulo\": \"...\"}] o []
- Si hay múltiples resultados, pregunta al usuario cuál
- Si resultado es [], responde que no hay nada y TERMINA
- NO vuelvas a consultar después de recibir respuesta

**PASO 3 - Cuando tengas el ID, actúa INMEDIATAMENTE:**
- Si tienes el ID numérico (ej: 5), usa "Actualizar" o "Eliminar" AHORA
- NO consultes de nuevo
- NO pidas confirmación extra
- USA EL ID Y EJECUTA

## REGLAS ESPECÍFICAS POR ACCIÓN

### CONSULTAS (Listar)
Cuando uses "Listar X" (tareas, proyectos, ideas, personas):
1. Llama la herramienta UNA SOLA VEZ
2. Espera el resultado
3. Si resultado = [] (lista vacía):
   - Responde según categoría:
     * Tareas: "📭 No tienes tareas pendientes. ¡Genial!"
     * Proyectos: "📭 No tienes proyectos activos aún."
     * Ideas: "📭 No tienes ideas guardadas todavía."
     * Personas: "📭 No tienes personas registradas aún."
   - TERMINA (NO vuelvas a listar)
4. Si resultado = [{...}, {...}]:
   - Formatea y muestra los resultados con sus IDs
   - Ejemplo: "📊 Tienes 2 tareas: 1. Comprar leche (id: 1), 2. Llamar Juan (id: 8)"
   - TERMINA

### ACTUALIZAR o ELIMINAR
Cuando usuario dice "id X" o "la del id X" o menciona un número:
1. Extrae el número (1, 5, 3...)
2. USA ESE NÚMERO INMEDIATAMENTE en Actualizar/Eliminar
3. NO consultes nada más
4. NO pidas confirmación (el usuario ya eligió)

Ejemplo:
Usuario: "Cambiar prioridad de leche a media"
Tú: Llamas "Listar tareas" → Hay 2 tareas "leche"
Tú: "¿Cuál? 1. Comprar leche (id: 1), 2. Comprar leche (id: 8)"
Usuario: "la del id 1"
Tú: INMEDIATAMENTE llamas "Actualizar tarea" con id=1, prioridad="media"
Tú: "✅ Actualizado"

## HERRAMIENTAS (16)

**INSERTAR** - Guardar nuevo:
- Insertar en tareas: titulo, prioridad (baja/media/alta/urgente), fecha_vencimiento, contexto_adicional
- Insertar en proyectos: nombre, estado (activo/en_espera), fecha_limite
- Insertar en ideas: titulo, contenido, tipo (nota/recurso/aprendizaje), tags
- Insertar en personas: nombre, relacion (cliente/proveedor/amigo/colega/familia/otro), datos_contacto

**LISTAR** - Ver qué hay (devuelve id como número o lista vacía):
- Listar tareas
- Listar proyectos
- Listar ideas
- Listar personas

**ACTUALIZAR** - Cambiar existente (necesita id):
- Actualizar tarea: id + [campos opcionales]
- Actualizar proyecto: id + [campos]
- Actualizar idea: id + [campos]
- Actualizar persona: id + [campos]

**ELIMINAR** - Borrar (necesita id):
- Eliminar tarea: id
- Eliminar proyecto: id
- Eliminar idea: id
- Eliminar persona: id

## FORMATO RESPUESTAS

- Guardar: "✅ [CATEGORÍA] Título - Guardado"
- Listar (con datos): "📊 Tienes X [categoría]: 1. Título (id: X)..."
- Listar (vacío): "📭 No tienes [categoría] [mensaje específico]"
- Actualizar: "🔄 Actualizado: Título"
- Eliminar: "🗑️ Eliminado: Título"
```

**Cambios clave vs versión anterior:**
1. ✅ "REGLA ABSOLUTA: NUNCA REPITAS UNA HERRAMIENTA" al inicio
2. ✅ Sección "CONSULTAS (Listar)" con pasos numerados claros
3. ✅ Distinción explícita entre resultado `[]` (vacío) vs `[{...}]` (con datos)
4. ✅ Mensajes específicos por categoría para respuesta vacía
5. ✅ "TERMINA" después de cada caso para reforzar
6. ✅ Cambio "Consultar" → "Listar" para consistencia
7. ✅ Ejemplo completo sin ambigüedad

---

## 🎯 CAMBIO 3 (OPCIONAL): Opciones Avanzadas en Nodos CONSULTAR

**Solo aplicar si los cambios 1 y 2 no resuelven completamente el problema.**

Para cada uno de los 4 nodos CONSULTAR, agregar en el campo `options`:

```json
{
  "options": {
    "detailedOutput": true,
    "largeNumbersOutput": "text",
    "replaceEmptyStrings": false
  }
}
```

**Impacto:**
- `detailedOutput`: Provee metadata adicional sobre la query
- `largeNumbersOutput`: IDs siempre como string (más seguro)
- `replaceEmptyStrings`: No transforma datos

**Prioridad:** BAJA - Solo si Cambios 1 y 2 no funcionan

---

## ✅ Checklist de Implementación

### Fase 1: Actualizar Descripciones (5 min)
- [ ] Editar "Consultar tareas" → Nueva descripción
- [ ] Editar "Consultar proyectos" → Nueva descripción
- [ ] Editar "Consultar ideas" → Nueva descripción
- [ ] Editar "Consultar personas" → Nueva descripción

### Fase 2: Actualizar System Prompt (5 min)
- [ ] Reemplazar `systemMessage` del nodo "AI Agent"
- [ ] Verificar que mantiene la interpolación `{{ $now.format('DD-MM-YYYY') }}`

### Fase 3: Probar (10 min)
- [ ] Test: "mis proyectos" (esperado: "📭 No tienes proyectos activos aún.")
- [ ] Test: "mis tareas" (esperado: Lista tareas o mensaje vacío)
- [ ] Test: "mis ideas" (esperado: "📭 No tienes ideas guardadas todavía.")
- [ ] Test: "Cambiar prioridad de X a Y" con confirmación de id

### Fase 4: Validar (5 min)
- [ ] Confirmar que NO hay loops (max 1-2 iteraciones por consulta)
- [ ] Confirmar respuestas correctas para tablas vacías
- [ ] Confirmar que UPDATE sigue funcionando

---

## 📊 Impacto Esperado

### Antes (v015)
```
Usuario: "mis proyectos"
Agente: 🔄 Consultar proyectos...
Agente: 🔄 Consultar proyectos...
Agente: 🔄 Consultar proyectos...
... (10x)
Error: Max iterations reached
```

### Después (v016)
```
Usuario: "mis proyectos"
Agente: 🔄 Listar proyectos...
Agente: 📭 No tienes proyectos activos aún.
✅ FIN (1 iteración total)
```

---

## 🔧 Implementación con n8n-mcp

Para aplicar estos cambios usando las herramientas MCP:

```javascript
// Paso 1: Actualizar descripciones de los 4 nodos CONSULTAR
await mcp.n8n_update_partial_workflow({
  id: "ZI6VUFdg6hEhnCbh",
  operations: [
    {
      type: "updateNode",
      nodeName: "Consultar tareas",
      changes: {
        "parameters.toolDescription": "[Nueva descripción de 1.1]"
      }
    },
    {
      type: "updateNode",
      nodeName: "Consultar proyectos",
      changes: {
        "parameters.toolDescription": "[Nueva descripción de 1.2]"
      }
    },
    {
      type: "updateNode",
      nodeName: "Consultar ideas",
      changes: {
        "parameters.toolDescription": "[Nueva descripción de 1.3]"
      }
    },
    {
      type: "updateNode",
      nodeName: "Consultar personas",
      changes: {
        "parameters.toolDescription": "[Nueva descripción de 1.4]"
      }
    }
  ]
});

// Paso 2: Actualizar system prompt del AI Agent
await mcp.n8n_update_partial_workflow({
  id: "ZI6VUFdg6hEhnCbh",
  operations: [
    {
      type: "updateNode",
      nodeName: "AI Agent",
      changes: {
        "parameters.options.systemMessage": "[Nuevo system prompt completo]"
      }
    }
  ]
});
```

---

## 📝 Notas Finales

1. **Backup automático:** n8n crea versiones automáticas, puedes revertir si algo falla
2. **Test incremental:** Probar después de cada fase
3. **Logging:** Si persisten problemas, activar logs del workflow para debug
4. **Opciones avanzadas:** Dejar como plan B si Cambios 1 y 2 no resuelven

---

## 🎯 Próximos Pasos

1. ✅ Aplicar Cambios 1 y 2
2. 🧪 Ejecutar tests de validación
3. 📊 Confirmar eliminación de loops
4. 📦 Exportar como `segundo_cerebro_v016.json`
5. 📝 Documentar en `SESSION_LOG.md`

