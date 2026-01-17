# Opciones MySQL Tool v2.5 - Documentación Completa

## 📋 Resumen

Este documento detalla **TODAS las opciones disponibles** en el nodo MySQL Tool v2.5 (`n8n-nodes-base.mySql`) según la información extraída directamente del código fuente de n8n.

---

## 🔧 Opciones Disponibles (Campo `options`)

### 1. Connection Timeout (`connectionTimeoutMillis`)
- **Tipo**: `number`
- **Default**: `30`
- **Descripción**: Tiempo en milisegundos reservado para conectarse a la base de datos
- **Min Value**: 1
- **Disponible en**: Todas las operaciones

### 2. Connections Limit (`connectionLimit`)
- **Tipo**: `number`
- **Default**: `10`
- **Descripción**: Cantidad máxima de conexiones a la base de datos. Valores altos pueden causar problemas de rendimiento y posibles caídas de la base de datos
- **Min Value**: 1
- **Disponible en**: Todas las operaciones

### 3. Query Batching (`queryBatching`)
- **Tipo**: `options`
- **Default**: `"single"`
- **Valores posibles**:
  - `"single"` - Una sola query para todos los items entrantes
  - `"independently"` - Ejecutar una query por cada item entrante
  - `"transaction"` - Ejecutar todas las queries en una transacción (si falla una, se hace rollback de todas)
- **Descripción**: La forma en que las queries deben enviarse a la base de datos
- **Disponible en**: Todas las operaciones

### 4. Query Parameters (`queryReplacement`)
- **Tipo**: `string`
- **Default**: `""`
- **Placeholder**: `"e.g. value1,value2,value3"`
- **Descripción**: Lista separada por comas de valores a usar como parámetros de query. Se pueden referenciar en la query como `$1`, `$2`, `$3`, etc.
- **Hint**: "Comma-separated list of values: reference them in your query as $1, $2, $3…"
- **Disponible en**: Solo `executeQuery`
- **Documentación**: https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.mysql/

### 5. Output Columns (`outputColumns`)
- **Tipo**: `multiOptions`
- **Default**: `[]`
- **Descripción**: Columnas a incluir en el output
- **Disponible en**: Solo `select`

### 6. Output Large-Format Numbers As (`largeNumbersOutput`)
- **Tipo**: `options`
- **Default**: `"text"`
- **Valores posibles**:
  - `"numbers"` - Salida como números
  - `"text"` - Salida como texto (usar si se esperan números de más de 16 dígitos)
- **Hint**: "Applies to NUMERIC and BIGINT columns only"
- **Descripción**: Formato de salida para números grandes
- **Disponible en**: `select`, `executeQuery`

### 7. Output Decimals as Numbers (`decimalNumbers`)
- **Tipo**: `boolean`
- **Default**: `false`
- **Descripción**: Si debe mostrar tipos DECIMAL como números en lugar de strings
- **Disponible en**: `select`, `executeQuery`

### 8. Priority (`priority`)
- **Tipo**: `options`
- **Default**: `"LOW_PRIORITY"`
- **Valores posibles**:
  - `"LOW_PRIORITY"` - Retrasa la ejecución del INSERT hasta que no haya otros clientes leyendo de la tabla
  - `"HIGH_PRIORITY"` - Anula el efecto de la opción --low-priority-updates. También causa que los inserts concurrentes no se usen
- **Descripción**: Prioridad de ejecución del INSERT
- **Disponible en**: Solo `insert`

### 9. Replace Empty Strings with NULL (`replaceEmptyStrings`) ⭐
- **Tipo**: `boolean`
- **Default**: `false`
- **Descripción**: Si debe reemplazar strings vacíos con NULL en la entrada. Puede ser útil cuando los datos vienen de una hoja de cálculo
- **Disponible en**: `insert`, `update`, `upsert`, `executeQuery`
- **⚠️ CRÍTICO**: Esta es la opción que mencionaste y que simplifica el manejo de valores NULL

### 10. Select Distinct (`selectDistinct`)
- **Tipo**: `boolean`
- **Default**: `false`
- **Descripción**: Si debe remover filas duplicadas
- **Disponible en**: Solo `select`

### 11. Output Query Execution Details (`detailedOutput`) ⭐
- **Tipo**: `boolean`
- **Default**: `false`
- **Descripción**: Si debe mostrar en el output detalles de la query ejecutada para cada statement, o solo confirmación de éxito
- **Disponible en**: Todas las operaciones
- **⚠️ CRÍTICO**: Esta es la opción que mencionaste para obtener metadata adicional

### 12. Skip on Conflict (`skipOnConflict`)
- **Tipo**: `boolean`
- **Default**: `false`
- **Descripción**: Si debe saltear la fila y no lanzar error si se viola una restricción única o de exclusión
- **Disponible en**: Solo `insert`

---

## 🎯 Configuración Recomendada para Segundo Cerebro

### Para Nodos INSERTAR (4 nodos: tareas, proyectos, ideas, personas)

```json
{
  "options": {
    "replaceEmptyStrings": true,
    "largeNumbersOutput": "text",
    "queryBatching": "single"
  }
}
```

**Razón**:
- `replaceEmptyStrings: true` - Convierte automáticamente strings vacíos en NULL (simplifica el manejo de `fecha_vencimiento`, `contexto_adicional`, etc.)
- `largeNumbersOutput: "text"` - Los IDs se manejan como texto (más seguro para números grandes)
- `queryBatching: "single"` - Una query por todos los items (default, más eficiente)

### Para Nodos CONSULTAR (4 nodos: executeQuery)

```json
{
  "options": {
    "largeNumbersOutput": "text",
    "decimalNumbers": false,
    "queryBatching": "single"
  }
}
```

**Razón**:
- `largeNumbersOutput: "text"` - IDs como texto (consistencia con INSERT)
- `decimalNumbers: false` - DECIMAL como strings (default, más seguro)
- `queryBatching: "single"` - Una query (más eficiente para consultas sin parámetros)

### Para Nodos ACTUALIZAR (4 nodos: executeQuery con UPDATE)

```json
{
  "options": {
    "replaceEmptyStrings": true,
    "largeNumbersOutput": "text",
    "queryBatching": "single"
  }
}
```

**Razón**:
- `replaceEmptyStrings: true` - Simplifica el manejo de NULL en actualizaciones
- `largeNumbersOutput: "text"` - Consistencia con otros nodos
- `queryBatching: "single"` - Eficiencia

### Para Nodos ELIMINAR (4 nodos: executeQuery con DELETE)

```json
{
  "options": {
    "largeNumbersOutput": "text",
    "queryBatching": "single"
  }
}
```

**Razón**:
- `largeNumbersOutput: "text"` - Consistencia
- `queryBatching: "single"` - Eficiencia
- No necesita `replaceEmptyStrings` porque DELETE solo usa ID

---

## 📝 Notas Importantes

### Sobre `replaceEmptyStrings`

Esta opción **ELIMINA** la necesidad de hacer validaciones complejas en las descripciones de tools como:

❌ **ANTES** (sin usar la opción):
```
fecha_vencimiento (YYYY-MM-DD o null si no hay fecha)
```

✅ **DESPUÉS** (con `replaceEmptyStrings: true`):
```
fecha_vencimiento (YYYY-MM-DD)
```

El agente puede enviar:
- `"2026-03-15"` → Se inserta como `'2026-03-15'`
- `""` → Se inserta como `NULL` automáticamente
- `null` → Se inserta como `NULL`

### Sobre `largeNumbersOutput`

Usar `"text"` para IDs garantiza que:
- Números mayores a 16 dígitos no se corrompan
- Consistencia entre INSERT y SELECT
- Compatibilidad con $fromAI() que devuelve strings

### Sobre `detailedOutput`

Esta opción **NO es necesaria para nuestro caso de uso** porque:
- El AI Agent solo necesita saber si la operación fue exitosa
- No necesitamos metadata adicional en el output
- Mantenerlo en `false` reduce el tamaño de las respuestas

### Sobre `queryBatching`

Para nuestro caso de uso:
- `"single"` es ideal porque el AI Agent procesa un mensaje a la vez
- `"independently"` solo es útil si se procesan múltiples items en paralelo
- `"transaction"` es útil si necesitamos rollback automático (no es nuestro caso)

---

## 🔄 Impacto en las Descripciones de Tools

Con las opciones correctas configuradas, las descripciones de tools pueden simplificarse:

### Ejemplo: Insertar en tareas

**❌ ANTES** (sin entender las opciones):
```
Insertar una TAREA. Campos: titulo (texto de la tarea), prioridad (SOLO: baja, media, alta, urgente), fecha_vencimiento (YYYY-MM-DD o null si no hay fecha), contexto_adicional (JSON con info extra o null)
```

**✅ DESPUÉS** (con `replaceEmptyStrings: true`):
```
Insertar una TAREA. Campos: titulo (texto), prioridad (baja/media/alta/urgente), fecha_vencimiento (YYYY-MM-DD, opcional), contexto_adicional (JSON, opcional)
```

El agente no necesita saber sobre NULL explícitamente - si envía string vacío, se convierte automáticamente.

---

## 📊 Resumen de Cambios Necesarios

### Nodos a Actualizar

| Nodo | Opciones a Agregar | Prioridad |
|------|-------------------|-----------|
| Insertar en tareas | `replaceEmptyStrings: true`, `largeNumbersOutput: "text"` | ALTA |
| Insertar en proyectos | `replaceEmptyStrings: true`, `largeNumbersOutput: "text"` | ALTA |
| Insertar en ideas | `replaceEmptyStrings: true`, `largeNumbersOutput: "text"` | ALTA |
| Insertar en personas | `replaceEmptyStrings: true`, `largeNumbersOutput: "text"` | ALTA |
| Consultar tareas | `largeNumbersOutput: "text"` | MEDIA |
| Consultar proyectos | `largeNumbersOutput: "text"` | MEDIA |
| Consultar ideas | `largeNumbersOutput: "text"` | MEDIA |
| Consultar personas | `largeNumbersOutput: "text"` | MEDIA |
| Actualizar tarea | `replaceEmptyStrings: true`, `largeNumbersOutput: "text"` | ALTA |
| Actualizar proyecto | `replaceEmptyStrings: true`, `largeNumbersOutput: "text"` | ALTA |
| Actualizar idea | `replaceEmptyStrings: true`, `largeNumbersOutput: "text"` | ALTA |
| Actualizar persona | `replaceEmptyStrings: true`, `largeNumbersOutput: "text"` | ALTA |
| Eliminar tarea | `largeNumbersOutput: "text"` | BAJA |
| Eliminar proyecto | `largeNumbersOutput: "text"` | BAJA |
| Eliminar idea | `largeNumbersOutput: "text"` | BAJA |
| Eliminar persona | `largeNumbersOutput: "text"` | BAJA |

---

## ✅ Próximos Pasos

1. Aplicar las opciones correctas a los 16 nodos MySQL Tool
2. Simplificar las descripciones de tools (eliminar referencias explícitas a NULL)
3. Actualizar el system prompt con el formato de fecha correcto (`dd/MM/yyyy`)
4. Probar que el agente maneja correctamente los valores opcionales
5. Documentar los cambios en SESSION_LOG.md

---

## 📚 Referencias

- Documentación n8n MySQL: https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.mysql/
- Código fuente n8n MySQL v2.5: https://github.com/n8n-io/n8n/tree/master/packages/nodes-base/nodes/MySql/v2
- MySQL Tool typeVersion: 2.5 (Latest)
