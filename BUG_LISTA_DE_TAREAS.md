# BUG SEMÁNTICO: "lista de tareas" causa Loop Infinito

**Fecha**: 16 Enero 2026 23:45
**Workflow**: `segundo_cerebro` (ID: `ZI6VUFdg6hEhnCbh`)
**Estado**: 🚨 **PARCIALMENTE RESUELTO** (workaround funciona, pero frase específica falla)

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

## 🔨 Solución Definitiva (Pendiente)

1. **Revisar system prompt** del AI Agent
2. **Buscar instrucciones ambiguas** relacionadas con "lista"
3. **Clarificar comportamiento** cuando usuario dice "lista de [categoría]"
4. **Agregar ejemplos explícitos** en el prompt:
   ```
   Usuario: "lista de tareas"
   Tú: Llamas "Consultar tareas" → Formateas resultados
   ```

---

## 📝 Nota Importante

Este bug es **independiente** del bug DATETIME que resolvimos antes. Ahora hay **DOS** problemas:

1. ✅ **RESUELTO**: Bug DATETIME (fecha_vencimiento necesita DATE())
2. 🚨 **PENDIENTE**: Bug semántico con frase "lista de tareas"

**El sistema funciona** si el usuario pregunta de otra manera. Pero la UX no es perfecta porque "lista de tareas" es una frase muy natural.

---

## 🎯 Prioridad

**MEDIA**: No es bloqueante porque hay workarounds naturales, pero debe resolverse para mejor UX.

---

**Documentado por**: Claude Code (Sonnet 4.5)
**Fecha**: 16 Enero 2026 23:45
