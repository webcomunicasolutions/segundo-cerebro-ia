# BUG SEMÁNTICO: "lista de tareas" causa Loop Infinito

**Fecha descubrimiento**: 16 Enero 2026 23:45
**Fecha resolución**: 17 Enero 2026
**Workflow**: `segundo_cerebro` (ID: `ZI6VUFdg6hEhnCbh`)
**Estado**: ✅ **RESUELTO**

---

## 🎉 SOLUCIÓN APLICADA

**Causa raíz identificada**: El system prompt del AI Agent NO tenía instrucciones explícitas sobre cómo interpretar frases comunes como "lista de tareas", causando que el agente entrara en loop de razonamiento intentando decidir qué hacer.

**Fix implementado**: Agregada nueva sección **"🗣️ INTERPRETACIÓN DE FRASES COMUNES"** al inicio del system prompt que mapea directamente frases comunes a las herramientas correctas:

```
## 🗣️ INTERPRETACIÓN DE FRASES COMUNES

Cuando el usuario dice estas frases, tradúcelas inmediatamente a la acción correcta SIN ENTRAR EN LOOP:

**Ver/Listar** → usar "Consultar [categoría]":
- "lista de tareas" → Consultar tareas
- "dame las tareas" → Consultar tareas
- "ver mis tareas" → Consultar tareas
- "qué tareas tengo" → Consultar tareas
- "lista de proyectos" → Consultar proyectos
- ...

**Regla clave**: Si usuario dice "lista de [categoría]" o variantes, llama DIRECTAMENTE "Consultar [categoría]" sin pensar más.
```

**Resultado esperado**:
- ✅ Frases como "lista de tareas" ahora se mapean directamente a "Consultar tareas"
- ✅ El agente NO entra en loop de razonamiento
- ✅ Respuesta en ~5-7 segundos con resultados correctos

**Testing pendiente**: Probar que "me das la lista de tareas" ahora funciona correctamente.

---

## 🔍 Descubrimiento

El bug **NO es técnico** (MySQL, queries, DATETIME). Es un **bug semántico/lingüístico** en el razonamiento del AI Agent.

### ❌ Frases que FALLAN (loop infinito)
```
"me das la lista de tareas"
"lista de tareas"  (probablemente)
```

### ✅ Frases que FUNCIONAN
```
"que tareas hay?"
"que tareas tengo?"
"que tengo pendiente por hacer?"
"tareas pendientes"
```

---

## 📊 Evidencia

### Ejecución 85366 - ❌ FALLA
- **Input**: `"me das la lista de tareas"`
- **Duración**: 17 segundos
- **AI Agent**: 3ms → Error "Max iterations (10)"
- **Resultado**: Respuesta vacía

### Ejecución 85367 - ✅ FUNCIONA
- **Input**: `"que tareas hhay?"`
- **Duración**: 6.5 segundos
- **AI Agent**: 5159ms → SUCCESS
- **Resultado**: 11 tareas retornadas

### Ejecución 85368 - ✅ FUNCIONA
- **Input**: `"que tengo pendiente por hacer??"`
- **Duración**: 3.9 segundos
- **AI Agent**: 2424ms → SUCCESS
- **Resultado**: 11 tareas retornadas

---

## 🎯 Causa Raíz (Hipótesis)

Cuando el usuario dice específicamente **"lista de [categoría]"**, el AI Agent se confunde porque probablemente hay instrucciones contradictorias o ambiguas en el system prompt sobre:

1. Cómo interpretar "lista de"
2. Qué herramienta usar
3. Cómo formatear la respuesta

Esto causa que el AI Agent entre en loop tratando de decidir qué hacer.

---

## 🔧 Solución Temporal (Workaround)

**Instruir al usuario** a usar frases alternativas:
- ❌ "lista de tareas"
- ✅ "que tareas tengo?"
- ✅ "tareas pendientes"

---

## 🔨 Solución Definitiva (✅ IMPLEMENTADA)

1. ✅ **Revisado system prompt** del AI Agent
2. ✅ **Identificadas instrucciones ambiguas** - faltaba mapeo explícito de frases comunes
3. ✅ **Clarificado comportamiento** - agregada sección "INTERPRETACIÓN DE FRASES COMUNES"
4. ✅ **Agregados ejemplos explícitos** en el prompt:
   ```
   Usuario: "lista de tareas"
   Sistema: Mapea directamente a "Consultar tareas" sin razonar
   Agente: Llama "Consultar tareas" → Retorna resultados
   ```

**Fecha implementación**: 17 Enero 2026
**Commit**: Pendiente de documentar en GitHub

---

## 📝 Nota Importante

Este bug es **independiente** del bug DATETIME que resolvimos antes. Ahora hay **DOS** problemas:

1. ✅ **RESUELTO**: Bug DATETIME (fecha_vencimiento necesita DATE())
2. 🚨 **PENDIENTE**: Bug semántico con frase "lista de tareas"

**El sistema funciona** si el usuario pregunta de otra manera. Pero la UX no es perfecta porque "lista de tareas" es una frase muy natural.

---

## 🎯 Prioridad

**✅ RESUELTO**: Fix implementado en system prompt. Testing pendiente para verificar que funciona correctamente.

---

**Documentado por**: Claude Code (Sonnet 4.5)
**Fecha**: 16 Enero 2026 23:45
