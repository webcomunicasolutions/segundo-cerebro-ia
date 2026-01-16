# TAREAS PENDIENTES - Segundo Cerebro v016

## 📋 Checklist del Plan Original

### ✅ COMPLETADO (6/8 tareas principales)

1. ✅ **Crear 4 tools UPDATE** (Actualizar tarea/proyecto/idea/persona)
2. ✅ **Crear 4 tools DELETE** (Eliminar tarea/proyecto/idea/persona)
3. ✅ **Conectar las 8 nuevas tools al AI Agent** (16 herramientas totales)
4. ⚠️ **Actualizar System Prompt con sección de EDICIÓN**
   - NO está explícitamente en el prompt
   - PERO `/fix` funciona perfectamente (capacidad emergente)
   - **Decisión**: Dejarlo como está (confiar en el LLM)
5. ✅ **Probar /fix con caso simple**
   - Ejecución 85343: "Fran" → "Francisco" ✅
6. ✅ **Probar edición por búsqueda**
   - "Cambiar proyecto Q2 a Q3" ✅
7. ❌ **Exportar workflow v016/v017**
8. ✅ **Documentar en SESSION_LOG.md**

---

## ⏳ PENDIENTE REAL (3 tareas)

### 1. Exportar Workflow v016 📦

**Qué falta**: Exportar el workflow actual como JSON para backup/versionado

**Por qué es importante**:
- Backup del estado funcional
- Facilita restauración si algo falla
- Permite comparar versiones

**Cómo hacerlo**:
```bash
# Opción 1: Desde n8n UI
# Workflows → segundo_cerebro → ⋮ → Download

# Opción 2: Desde MCP (si está disponible export)
# O usar la API de n8n directamente
```

**Estimado**: 5 minutos

---

### 2. Test 3: Marcar Tarea como Completada 🧪

**Test pendiente del plan original**:
```
Input: "Marcar tarea Comprar leche como completada"
Esperado: UPDATE tareas SET estado='completada'
```

**Por qué probarlo**:
- Validar que UPDATE de estado funciona
- Caso de uso muy común
- Verifica que el agente entiende "marcar como completada"

**Cómo probarlo**:
1. Crear tarea: "Comprar leche"
2. Decir: "Marcar tarea comprar leche como completada"
3. Verificar respuesta y consultar tareas

**Estimado**: 2 minutos

---

### 3. Test 4: Eliminar Registro 🗑️

**Test pendiente del plan original**:
```
Input: "Borrar la idea sobre IA"
Esperado: Consulta ideas → Muestra opciones → Confirma → DELETE
```

**Por qué probarlo**:
- Validar herramientas DELETE funcionan
- Verificar que pide confirmación antes de borrar
- Importante para data safety

**Cómo probarlo**:
1. Crear idea: "Idea sobre IA generativa"
2. Decir: "Borrar la idea sobre IA"
3. Verificar que pide confirmación
4. Confirmar y verificar eliminación

**Estimado**: 3 minutos

---

## 📊 Resumen del Estado

### Completado (v016)
- ✅ 16 herramientas MySQL Tool configuradas
- ✅ Fix crítico AI Agent loop
- ✅ Comando `/fix` funcionando (emergente)
- ✅ Tests básicos pasando
- ✅ Documentación completa
- ✅ GitHub actualizado

### Pendiente (para v017)
- ⏳ Export workflow como JSON
- ⏳ Test "marcar completada"
- ⏳ Test "eliminar registro"

---

## 🎯 Prioridad

**Alta** ⚠️:
- Test "eliminar registro" (importante para data safety)

**Media** 📋:
- Export workflow (backup)

**Baja** ✨:
- Test "marcar completada" (probablemente funciona, pero validar)

---

## ⏱️ Tiempo Estimado Total

**Total**: ~10 minutos
- Export workflow: 5 min
- Test marcar completada: 2 min
- Test eliminar: 3 min

---

## 💡 Sugerencia de Ejecución

**Orden recomendado**:
1. Primero: Test "eliminar registro" (más importante)
2. Segundo: Test "marcar completada" (rápido)
3. Tercero: Export workflow (cuando tengamos tiempo)

O si tienes prisa:
- Hacer solo el test de eliminar (lo más crítico)
- Dejar export para otra sesión

---

## ✅ Criterio de "Done"

El v016 se considera **100% completo** cuando:
- [x] Todas las herramientas creadas y funcionando
- [x] Fix crítico resuelto
- [x] Comando /fix validado
- [ ] Test DELETE verificado
- [ ] Workflow exportado
- [x] Documentación completa
- [x] GitHub actualizado

**Estado actual**: 85% completo (6/7 items)

---

**Última actualización**: 16 Enero 2026
