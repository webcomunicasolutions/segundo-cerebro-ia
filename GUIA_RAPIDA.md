# Guía Rápida - Segundo Cerebro

**Versión**: v018 | **Última actualización**: 17 Enero 2026

---

## 🚀 Inicio Rápido

1. Abre Telegram
2. Busca `@segundo_cerebro_pkm_bot` (o el nombre que te dieron)
3. Envía un mensaje: `Hola`
4. ¡Listo! Ya puedes empezar

---

## 📝 Capturar Información

### Tareas

| Acción | Ejemplo de Entrada | Resultado |
|--------|-------------------|-----------|
| **Crear tarea simple** | `Nueva tarea: Llamar al dentista` | ✅ TAREA guardada con prioridad media |
| **Tarea con fecha** | `Comprar regalo para María el viernes` | ✅ TAREA con fecha: viernes |
| **Tarea urgente** | `URGENTE: Enviar informe antes de las 5pm` | ✅ TAREA con prioridad urgente |
| **Con fecha específica** | `Reunión con cliente el 25 de enero` | ✅ TAREA con fecha: 2026-01-25 |

**Fechas que entiende el sistema**:
- `mañana` → día siguiente
- `pasado mañana` → +2 días
- `el viernes` → próximo viernes
- `en 3 días` → fecha calculada
- `2026-01-20` → fecha específica

---

### Proyectos

| Acción | Ejemplo | Resultado |
|--------|---------|-----------|
| **Crear proyecto** | `Nuevo proyecto: Rediseño del sitio web para Q2` | ✅ PROYECTO activo |
| **Con fecha límite** | `Proyecto migración servidor para marzo 2026` | ✅ PROYECTO con límite: 2026-03-31 |

**Estados de proyecto**:
- `activo` (por defecto)
- `en_espera`
- `completado`

---

### Ideas

| Acción | Ejemplo | Resultado |
|--------|---------|-----------|
| **Nota simple** | `Idea: Artículo sobre IA y productividad` | ✅ IDEA tipo nota |
| **Recurso** | `Recurso: Tutorial n8n https://youtube.com/...` | ✅ IDEA tipo recurso |
| **Aprendizaje** | `Aprendizaje: React hooks usan estado sin clases` | ✅ IDEA tipo aprendizaje |

**Tipos de idea**:
- `nota` → pensamientos generales
- `recurso` → enlaces, videos, documentos
- `aprendizaje` → conceptos que aprendiste

---

### Personas

| Acción | Ejemplo | Resultado |
|--------|---------|-----------|
| **Cliente** | `Contacto: Juan García, cliente, juan@empresa.com` | ✅ PERSONA tipo cliente |
| **Proveedor** | `Proveedor: María López, diseñadora, maria@diseño.com` | ✅ PERSONA tipo proveedor |
| **Con teléfono** | `Amigo: Carlos Ruiz, +34 600 123 456` | ✅ PERSONA tipo amigo |

**Relaciones posibles**:
- `cliente`, `proveedor`, `amigo`, `colega`, `familia`, `otro`

---

## 🔍 Consultar Información

### Ver Listas

| Comando | Variantes Aceptadas | Resultado |
|---------|---------------------|-----------|
| **Ver tareas** | `lista de tareas`<br>`dame las tareas`<br>`qué tareas tengo`<br>`ver mis tareas` | 📊 Lista de tareas activas ordenadas por prioridad |
| **Ver proyectos** | `lista de proyectos`<br>`dame los proyectos`<br>`mis proyectos` | 📊 Lista de proyectos activos |
| **Ver ideas** | `qué ideas tengo`<br>`lista de ideas`<br>`ver mis ideas` | 📊 Lista de ideas guardadas |
| **Ver personas** | `lista de personas`<br>`mis contactos`<br>`ver contactos` | 📊 Lista de personas registradas |

**Ejemplo de respuesta**:
```
📊 3 resultados:
1. Enviar informe (id: 1) - Prioridad: urgente, Vence: 2026-01-17
2. Comprar regalo (id: 2) - Prioridad: media, Vence: 2026-01-23
3. Llamar dentista (id: 3) - Prioridad: media
```

---

## 🔄 Actualizar Información

### Cambiar Campos

| Acción | Ejemplo | Resultado |
|--------|---------|-----------|
| **Cambiar prioridad** | `Cambiar tarea llamar dentista a urgente` | 🔄 Prioridad actualizada |
| **Cambiar nombre** | `Renombrar proyecto Web a Portal Cliente` | 🔄 Nombre actualizado |
| **Cambiar fecha** | `Cambiar fecha de comprar regalo al 20 de enero` | 🔄 Fecha actualizada |
| **Marcar completada** | `Marcar tarea enviar informe como completada` | 🔄 Estado: completada |
| **Cambiar estado proyecto** | `Marcar proyecto migración como en_espera` | 🔄 Estado actualizado |

**Flujo típico**:
1. El bot busca el registro por nombre
2. Si encuentra múltiples, te pregunta cuál
3. Tú respondes con el ID o número
4. El bot actualiza y confirma

---

## 🗑️ Eliminar Información

| Acción | Ejemplo | Resultado |
|--------|---------|-----------|
| **Borrar tarea** | `Borrar la tarea de llamar al dentista` | 🗑️ Tarea eliminada |
| **Borrar proyecto** | `Eliminar el proyecto de migración` | 🗑️ Proyecto eliminado |
| **Borrar idea** | `Borrar la idea sobre IA` | 🗑️ Idea eliminada |
| **Borrar persona** | `Eliminar contacto Juan García` | 🗑️ Persona eliminada |

⚠️ **Precaución**: La eliminación es **permanente**. No hay deshacer.

**Flujo con confirmación** (si hay ambigüedad):
```
Tú: "Borrar la tarea de leche"
Bot: "Encontré 2 tareas:
      1. Comprar leche (id: 5)
      2. Leche para el gato (id: 12)
      ¿Cuál quieres eliminar?"
Tú: "5"
Bot: "🗑️ Eliminado: Comprar leche"
```

---

## 💡 Tips Rápidos

### ✅ HACER

| Situación | Comando Correcto |
|-----------|-----------------|
| Crear tarea | ✅ `Nueva tarea: Comprar leche mañana` |
| Urgencia | ✅ `URGENTE: Revisar contrato hoy` |
| Fecha explícita | ✅ `Reunión con cliente el 25 de enero` |
| Ver lista | ✅ `lista de tareas` |
| Ser específico | ✅ `Cambiar prioridad de tarea comprar leche a alta` |

### ❌ EVITAR

| Situación | Comando Incorrecto | Por qué no funciona |
|-----------|-------------------|---------------------|
| Demasiado vago | ❌ `leche` | Sin verbo ni contexto |
| Sin categoría | ❌ `Comprar leche` (ambiguo) | ¿Es tarea, proyecto o idea? |
| Múltiples acciones | ❌ `Nueva tarea leche y proyecto web` | Procesa solo una acción a la vez |
| Fecha ambigua | ❌ `la próxima semana` | Mejor usar fecha específica |

---

## 🎯 Comandos por Frecuencia de Uso

### Uso Diario

```
✅ Nueva tarea: [descripción]
✅ qué tareas tengo
✅ Marcar tarea [nombre] como completada
✅ Borrar la tarea [nombre]
```

### Uso Semanal

```
📊 lista de proyectos
🔄 Cambiar estado proyecto [nombre] a [activo/en_espera]
💡 Idea: [pensamiento o recurso]
```

### Uso Mensual

```
👥 Contacto: [nombre, relación, email/teléfono]
📋 lista de ideas
🗑️ Eliminar tareas/proyectos obsoletos
```

---

## 🔧 Troubleshooting Rápido

| Problema | Solución Rápida |
|----------|----------------|
| **Bot no responde** | Espera 30s → Verifica internet → Reinicia Telegram |
| **Categoría incorrecta** | Borra el registro → Reenvía con palabras clave claras (`Nueva tarea:`, `Nuevo proyecto:`) |
| **Fecha mal interpretada** | Actualiza: `Cambiar fecha de [tarea] al [DD de MMM]` |
| **No recuerdo el ID** | Lista primero: `lista de [categoría]` → Usa nombre o ID |
| **Mensaje confuso** | Reformula con más contexto y un verbo claro |

---

## 📊 Formato de Respuestas del Bot

| Emoji | Significado |
|-------|------------|
| ✅ | Guardado exitoso |
| 🔄 | Actualizado |
| 🗑️ | Eliminado |
| 📊 | Consulta con resultados |
| ℹ️ | Sin resultados (respuesta válida, no error) |
| ⚠️ | Necesita aclaración |
| ❌ | Error (reformula tu mensaje) |

---

## 🧠 Arquitectura Rápida

```
Tú (Telegram)
    → n8n (registra mensaje)
    → Gemini 2.5 Flash (analiza y clasifica)
    → MySQL (guarda estructurado)
    → Bot te confirma (1-3 segundos)
```

**Latencia esperada**:
- Mensaje simple: 1-3 segundos
- Consulta compleja: 5-7 segundos

**Privacidad**: Datos en servidor privado auto-hospedado, NO en clouds de terceros.

---

## 📚 Aprende Más

- **Manual completo**: `MANUAL_DE_USUARIO.md` (~100 páginas)
- **Primeros pasos**: `PRIMEROS_PASOS.md` (setup inicial)
- **Preguntas frecuentes**: `FAQ.md` (problemas comunes)
- **Changelog**: `CHANGELOG.md` (historial de versiones)

---

## 🎓 Ejemplo Completo de Sesión

```
Tú: "Nueva tarea: Comprar leche mañana"
Bot: ✅ TAREA: Comprar leche - Guardado
     Prioridad: media, Fecha: 2026-01-18

Tú: "URGENTE: Enviar informe hoy"
Bot: ✅ TAREA: Enviar informe - Guardado
     Prioridad: urgente, Fecha: 2026-01-17

Tú: "qué tareas tengo"
Bot: 📊 2 resultados:
     1. Enviar informe (id: 1) - Prioridad: urgente, Vence: 2026-01-17
     2. Comprar leche (id: 2) - Prioridad: media, Vence: 2026-01-18

Tú: "Marcar tarea enviar informe como completada"
Bot: 🔄 Actualizado: Enviar informe - Estado: completada

Tú: "lista de tareas"
Bot: 📊 1 resultado:
     1. Comprar leche (id: 2) - Prioridad: media, Vence: 2026-01-18
```

**Observación**: La tarea completada desapareció de la lista automáticamente.

---

## 🔮 Próximas Versiones

### v019 (Próximamente)
- ✨ Soporte de **mensajes de voz** con transcripción automática
- 🎤 Latencia <10 segundos para audio de 1 minuto

### v020+ (Backlog)
- `/fix` → Comando de corrección rápida
- Confidence scoring → Prevención de datos de baja calidad
- Búsqueda semántica → Encuentra por significado, no solo keywords
- Relaciones entre entidades → Vincular tareas con proyectos

---

**¿Necesitas ayuda?** Consulta el `MANUAL_DE_USUARIO.md` completo o contacta al administrador.

**Última actualización**: 17 Enero 2026 | **Versión**: v018
