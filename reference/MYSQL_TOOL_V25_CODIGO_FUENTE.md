# MySQL Tool v2.5 - Análisis del Código Fuente

**Fecha**: 16 enero 2026
**Fuente**: https://github.com/n8n-io/n8n/tree/master/packages/nodes-base/nodes/MySql
**Archivos analizados**: 13 archivos TypeScript (~84K total)

---

## 📦 Estructura del Código Fuente

```
MySql/
├── MySqlV2.node.ts                    # Nodo principal
├── versionDescription.ts              # Configuración de versiones
├── v2/
│   ├── actions/
│   │   ├── database/
│   │   │   ├── Database.resource.ts   # Resource principal
│   │   │   ├── executeQuery.operation.ts
│   │   │   ├── insert.operation.ts
│   │   │   ├── select.operation.ts
│   │   │   ├── update.operation.ts
│   │   │   ├── upsert.operation.ts
│   │   │   └── deleteTable.operation.ts
│   │   └── common.descriptions.ts     # ⭐ Definición de todas las opciones
│   └── helpers/
│       ├── interfaces.ts              # Tipos TypeScript
│       └── utils.ts                   # ⭐ Funciones utilitarias clave
```

---

## 🔧 Las 12 Opciones Disponibles (Código Completo)

### Definición en `common.descriptions.ts` (líneas 71-260)

```typescript
export const optionsCollection: INodeProperties = {
	displayName: 'Options',
	name: 'options',
	type: 'collection',
	default: {},
	placeholder: 'Add option',
	options: [
		// ... 12 opciones definidas aquí
	]
};
```

---

## ⭐ Opción Crítica: `replaceEmptyStrings`

### Definición (líneas 214-225)

```typescript
{
	displayName: 'Replace Empty Strings with NULL',
	name: 'replaceEmptyStrings',
	type: 'boolean',
	default: false,
	description: 'Whether to replace empty strings with NULL in input, could be useful when data come from spreadsheet',
	displayOptions: {
		show: {
			'/operation': ['insert', 'update', 'upsert', 'executeQuery'],
		},
	},
}
```

**Disponible en**: INSERT, UPDATE, UPSERT, EXECUTE QUERY
**NO disponible en**: SELECT, DELETE (no tiene sentido, no modifican datos)

### Implementación en `utils.ts` (líneas 558-578)

```typescript
export function replaceEmptyStringsByNulls(
	items: INodeExecutionData[],
	replace?: boolean,
): INodeExecutionData[] {
	if (!replace) return [...items];  // Si false, no hace nada

	const returnData: INodeExecutionData[] = items.map((item) => {
		const newItem = { ...item };
		const keys = Object.keys(newItem.json);

		for (const key of keys) {
			if (newItem.json[key] === '') {  // ⭐ Condición exacta
				newItem.json[key] = null;
			}
		}

		return newItem;
	});

	return returnData;
}
```

**Comportamiento exacto**:
- **Input**: `{ titulo: "", prioridad: "alta" }`
- **Output con replaceEmptyStrings: true**: `{ titulo: null, prioridad: "alta" }`
- **Output con replaceEmptyStrings: false**: `{ titulo: "", prioridad: "alta" }`

**Validación**: Solo reemplaza strings vacíos (`""`), NO reemplaza:
- `undefined`
- `null` (ya es null)
- Espacios en blanco (`" "`)
- Strings no vacíos

---

## 🔢 Opción: `largeNumbersOutput`

### Definición (líneas 156-176)

```typescript
{
	displayName: 'Output Large-Format Numbers As',
	name: 'largeNumbersOutput',
	type: 'options',
	options: [
		{
			name: 'Numbers',
			value: 'numbers',
		},
		{
			name: 'Text',
			value: 'text',
			description: 'Use this if you expect numbers longer than 16 digits (otherwise numbers may be incorrect)',
		},
	],
	hint: 'Applies to NUMERIC and BIGINT columns only',
	default: 'text',
	displayOptions: {
		show: { '/operation': ['select', 'executeQuery'] },
	},
}
```

**Disponible en**: SELECT, EXECUTE QUERY
**Propósito**: Evitar pérdida de precisión en números grandes (>16 dígitos)

**Ejemplo de problema sin esta opción**:
```javascript
// JavaScript Number.MAX_SAFE_INTEGER = 9007199254740991 (16 dígitos)
const bigId = 9007199254740992;  // 16+ dígitos
console.log(bigId);              // 9007199254740992 ✅
console.log(bigId + 1);          // 9007199254740992 ❌ (perdió precisión)
```

**Solución**: `largeNumbersOutput: "text"` retorna strings para columnas BIGINT/NUMERIC

---

## 📊 Opción: `detailedOutput`

### Definición (líneas 239-245)

```typescript
{
	displayName: 'Output Query Execution Details',
	name: 'detailedOutput',
	type: 'boolean',
	default: false,
	description: 'Whether to show in output details of the executed query for each statement, or just confirmation of success',
}
```

### Implementación en `utils.ts` (líneas 240-278)

```typescript
export function prepareOutput(
	response: IDataObject[],
	options: IDataObject,
	statements: string[],
	// ...
) {
	let returnData: INodeExecutionData[] = [];

	if (options.detailedOutput) {
		// Modo detallado: incluye SQL ejecutado
		response.forEach((entry, index) => {
			const item = {
				sql: statements[index],  // ⭐ Query ejecutada
				data: entry,             // ⭐ Resultado
			};
			// ...
		});
	} else {
		// Modo normal: solo resultado
		response
			.filter((entry) => Array.isArray(entry))
			.forEach((entry, index) => {
				// Solo retorna data, sin SQL
			});
	}
	// ...
}
```

**Output con `detailedOutput: true`**:
```json
{
  "sql": "INSERT INTO tareas (titulo, prioridad) VALUES ('Comprar', 'media')",
  "data": {
    "affectedRows": 1,
    "insertId": 47
  }
}
```

**Output con `detailedOutput: false`** (default):
```json
{
  "affectedRows": 1,
  "insertId": 47
}
```

---

## 🔀 Opción: `queryBatching`

### Definición (líneas 100-124)

```typescript
{
	displayName: 'Query Batching',
	name: 'queryBatching',
	type: 'options',
	description: 'The way queries should be sent to the database',
	options: [
		{
			name: 'Single Query',
			value: BATCH_MODE.SINGLE,
			description: 'A single query for all incoming items',
		},
		{
			name: 'Independent',
			value: BATCH_MODE.INDEPENDENTLY,
			description: 'Execute one query per incoming item of the run',
		},
		{
			name: 'Transaction',
			value: BATCH_MODE.TRANSACTION,
			description: 'Execute all queries in a transaction, if a failure occurs, all changes are rolled back',
		},
	],
	default: SINGLE,
}
```

### Comportamiento Detallado

#### 1. `SINGLE` (Default) - Una sola query
```typescript
// Ejemplo: 3 items de entrada
// Input: ["Comprar", "Leer", "Correr"]

// Query generada:
INSERT INTO tareas (titulo) VALUES ('Comprar'),('Leer'),('Correr');

// Ventajas: Más rápido (1 round-trip a DB)
// Desventajas: Si falla, falla todo
```

#### 2. `INDEPENDENTLY` - Queries independientes
```typescript
// Ejemplo: 3 items de entrada
// Queries generadas (3 separadas):
INSERT INTO tareas (titulo) VALUES ('Comprar');
INSERT INTO tareas (titulo) VALUES ('Leer');
INSERT INTO tareas (titulo) VALUES ('Correr');

// Ventajas: Si 1 falla, los otros 2 se guardan
// Desventajas: Más lento (3 round-trips a DB)
```

#### 3. `TRANSACTION` - Todo o nada
```typescript
// Ejemplo: 3 items de entrada
BEGIN TRANSACTION;
  INSERT INTO tareas (titulo) VALUES ('Comprar');
  INSERT INTO tareas (titulo) VALUES ('Leer');
  INSERT INTO tareas (titulo) VALUES ('Correr');
COMMIT;  // Si todo OK
-- O --
ROLLBACK;  // Si algo falló

// Ventajas: Atomicidad garantizada (todo o nada)
// Desventajas: Si 1 falla, NINGUNO se guarda
```

### Implementación en `utils.ts` (líneas 310-479)

```typescript
export function configureQueryRunner(
	this: IExecuteFunctions,
	options: IDataObject,
	pool: Mysql2Pool,
) {
	return async (queries: QueryWithValues[]) => {
		const mode = (options.queryBatching as QueryMode) || BATCH_MODE.SINGLE;

		if (mode === BATCH_MODE.SINGLE) {
			// Combina todas las queries en una sola
			const singleQuery = formattedQueries.map(q => q.trim().replace(/;$/, '')).join(';');
			await pool.query(singleQuery);
		}
		else if (mode === BATCH_MODE.INDEPENDENTLY) {
			// Ejecuta cada query por separado
			for (const queryWithValues of queries) {
				try {
					await connection.query(statement);
				} catch (err) {
					// Continúa con las siguientes queries
				}
			}
		}
		else if (mode === BATCH_MODE.TRANSACTION) {
			await connection.beginTransaction();
			try {
				for (const queryWithValues of queries) {
					await connection.query(statement);
				}
				await connection.commit();  // ✅ Todo OK
			} catch (err) {
				await connection.rollback();  // ❌ Revertir todo
			}
		}
	};
}
```

---

## 🔍 Opción: `queryReplacement` (Parámetros)

### Definición (líneas 126-137)

```typescript
{
	displayName: 'Query Parameters',
	name: 'queryReplacement',
	type: 'string',
	default: '',
	placeholder: 'e.g. value1,value2,value3',
	description: 'Comma-separated list of the values you want to use as query parameters. You can drag the values from the input panel on the left.',
	hint: 'Comma-separated list of values: reference them in your query as $1, $2, $3…',
	displayOptions: {
		show: { '/operation': ['executeQuery'] },
	},
}
```

### Implementación en `utils.ts` (líneas 124-147)

```typescript
export const prepareQueryAndReplacements = (
	rawQuery: string,
	nodeVersion: number,
	replacements?: QueryValues,
) => {
	if (nodeVersion >= 2.5) {
		const regex = /\$(\d+)(?::name)?/g;  // Busca $1, $2, $1:name, etc.
		const matches = findParameterMatches(rawQuery, regex);

		// Valida que todos los parámetros tengan valores
		validateReferencedParameters(matches, replacements);

		// Reemplaza $1, $2... con ? (MySQL placeholders)
		const query = processParameterReplacements(rawQuery, matches, replacements);

		// Extrae valores en orden correcto
		const values = extractValuesFromMatches(matches, replacements);

		return { query, values };
	}
	// ...
};
```

### Ejemplo de Uso

**Query con parámetros**:
```sql
SELECT * FROM tareas WHERE prioridad = $1 AND estado = $2 LIMIT $3
```

**Parámetros** (en options.queryReplacement):
```
alta,pendiente,10
```

**Query preparada internamente**:
```sql
SELECT * FROM tareas WHERE prioridad = ? AND estado = ? LIMIT ?
-- values: ['alta', 'pendiente', 10]
```

**Ventaja**: Previene SQL injection automáticamente

### Parámetros especiales: `:name`

```sql
SELECT * FROM $1:name WHERE id = $2
-- $1:name se escapa como identificador de tabla
-- $2 se usa como valor parametrizado
```

**Parámetros**: `tareas,47`

**Query preparada**:
```sql
SELECT * FROM `tareas` WHERE id = ?
-- values: [47]
```

---

## 🛡️ Opción: `skipOnConflict`

### Definición (líneas 247-258)

```typescript
{
	displayName: 'Skip on Conflict',
	name: 'skipOnConflict',
	type: 'boolean',
	default: false,
	description: 'Whether to skip the row and do not throw error if a unique constraint or exclusion constraint is violated',
	displayOptions: {
		show: {
			'/operation': ['insert'],
		},
	},
}
```

### Implementación en `insert.operation.ts` (línea 134)

```typescript
const ignore = (nodeOptions.skipOnConflict as boolean) ? 'IGNORE' : '';

const query = `INSERT ${priority} ${ignore} INTO ${escapeSqlIdentifier(table)} ...`;
```

**Query generada con `skipOnConflict: true`**:
```sql
INSERT IGNORE INTO tareas (titulo, prioridad) VALUES ('Comprar', 'media');
```

**Comportamiento**:
- Sin IGNORE: Error si existe registro con mismo ID único
- Con IGNORE: Salta el registro conflictivo, continúa sin error

---

## 🔗 Opción: `connectionTimeoutMillis` y `connectionLimit`

### Definiciones (líneas 79-98)

```typescript
{
	displayName: 'Connection Timeout',
	name: 'connectionTimeoutMillis',
	type: 'number',
	default: 30,
	description: 'Number of milliseconds reserved for connecting to the database',
	typeOptions: {
		minValue: 1,
	},
},
{
	displayName: 'Connections Limit',
	name: 'connectionLimit',
	type: 'number',
	default: 10,
	typeOptions: {
		minValue: 1,
	},
	description: 'Maximum amount of connections to the database, setting high value can lead to performance issues and potential database crashes',
}
```

**Propósito**: Configuración avanzada de connection pool

**Recomendación para Segundo Cerebro**:
- `connectionTimeoutMillis`: 30 (default, suficiente para Gemini + MySQL)
- `connectionLimit`: 10 (default, un solo usuario activo)

---

## 📋 Resumen de Opciones por Operación

| Opción | INSERT | UPDATE | UPSERT | DELETE | SELECT | EXECUTE QUERY |
|--------|--------|--------|--------|--------|--------|---------------|
| `connectionTimeoutMillis` | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| `connectionLimit` | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| `queryBatching` | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| `queryReplacement` | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ |
| `outputColumns` | ❌ | ❌ | ❌ | ❌ | ✅ | ❌ |
| `largeNumbersOutput` | ❌ | ❌ | ❌ | ❌ | ✅ | ✅ |
| `decimalNumbers` | ❌ | ❌ | ❌ | ❌ | ✅ | ✅ |
| `priority` | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| `replaceEmptyStrings` | ✅ | ✅ | ✅ | ❌ | ❌ | ✅ |
| `selectDistinct` | ❌ | ❌ | ❌ | ❌ | ✅ | ❌ |
| `detailedOutput` | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| `skipOnConflict` | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |

---

## 🎯 Configuración Recomendada para Segundo Cerebro

### Nodos INSERT (4 nodos)
```json
{
  "parameters": {
    "operation": "insert",
    "table": { "mode": "name", "value": "tareas" },
    "dataMode": "autoMapInputData",
    "options": {
      "replaceEmptyStrings": true,        // ⭐ Crítico
      "largeNumbersOutput": "text",       // ⭐ Seguridad
      "queryBatching": "single",          // Default (óptimo)
      "detailedOutput": false             // Default (limpio)
    }
  }
}
```

**Justificación**:
- `replaceEmptyStrings: true` - Gemini puede retornar `""` cuando no hay valor → se convierte automáticamente a `NULL`
- `largeNumbersOutput: "text"` - Previene pérdida de precisión en IDs grandes
- `queryBatching: "single"` - Más rápido, suficiente para un solo insert por ejecución de agente
- `detailedOutput: false` - Output limpio para el agente

### Nodos CONSULTAR (4 nodos SELECT)
```json
{
  "parameters": {
    "operation": "select",
    "table": { "mode": "name", "value": "tareas" },
    "options": {
      "largeNumbersOutput": "text",       // ⭐ Seguridad
      "decimalNumbers": false,            // Default (strings para DECIMAL)
      "selectDistinct": false,            // Default (no hay duplicados esperados)
      "detailedOutput": false             // Default (limpio)
    }
  }
}
```

### Nodos UPDATE (4 nodos)
```json
{
  "parameters": {
    "operation": "update",
    "table": { "mode": "name", "value": "tareas" },
    "options": {
      "replaceEmptyStrings": true,        // ⭐ Crítico
      "largeNumbersOutput": "text",       // ⭐ Seguridad
      "queryBatching": "single",          // Default
      "detailedOutput": false             // Default
    }
  }
}
```

### Nodos DELETE (4 nodos)
```json
{
  "parameters": {
    "operation": "deleteTable",
    "table": { "mode": "name", "value": "tareas" },
    "options": {
      "detailedOutput": false             // Default (limpio)
    }
  }
}
```

**Nota**: DELETE no tiene `replaceEmptyStrings` ni `largeNumbersOutput` (no aplican)

---

## 🚀 Impacto en el Proyecto Segundo Cerebro

### Problema Original (sin configuración correcta)
```javascript
// Gemini responde con:
{
  titulo: "Comprar leche",
  prioridad: "media",
  fecha_vencimiento: "",         // ❌ String vacío
  contexto_adicional: ""         // ❌ String vacío
}

// Sin replaceEmptyStrings: true
// INSERT intenta guardar:
INSERT INTO tareas (titulo, prioridad, fecha_vencimiento, contexto_adicional)
VALUES ('Comprar leche', 'media', '', '');

// Resultado: VARCHAR('') guardado como string vacío en DB
// Problema: No es NULL, es string vacío → consultas fallan
SELECT * FROM tareas WHERE fecha_vencimiento IS NULL;  // ❌ No encuentra nada
```

### Solución (con replaceEmptyStrings: true)
```javascript
// Mismo input de Gemini:
{
  titulo: "Comprar leche",
  prioridad: "media",
  fecha_vencimiento: "",         // String vacío
  contexto_adicional: ""         // String vacío
}

// Con replaceEmptyStrings: true
// ANTES de INSERT, n8n convierte automáticamente:
{
  titulo: "Comprar leche",
  prioridad: "media",
  fecha_vencimiento: null,       // ✅ NULL
  contexto_adicional: null       // ✅ NULL
}

// INSERT guarda correctamente:
INSERT INTO tareas (titulo, prioridad, fecha_vencimiento, contexto_adicional)
VALUES ('Comprar leche', 'media', NULL, NULL);

// Consultas funcionan correctamente:
SELECT * FROM tareas WHERE fecha_vencimiento IS NULL;  // ✅ Encuentra el registro
```

---

## 🔍 Análisis de `replaceEmptyStringsByNulls` en Otras Operaciones

### En `executeQuery.operation.ts` (línea 51)
```typescript
const items = replaceEmptyStringsByNulls(inputItems, nodeOptions.replaceEmptyStrings as boolean);
```

### En `insert.operation.ts` (línea 120)
```typescript
const items = replaceEmptyStringsByNulls(inputItems, nodeOptions.replaceEmptyStrings as boolean);
```

### En `update.operation.ts`
```typescript
const items = replaceEmptyStringsByNulls(inputItems, nodeOptions.replaceEmptyStrings as boolean);
```

### En `upsert.operation.ts`
```typescript
const items = replaceEmptyStringsByNulls(inputItems, nodeOptions.replaceEmptyStrings as boolean);
```

**Patrón consistente**: TODAS las operaciones que modifican datos llaman a `replaceEmptyStringsByNulls` ANTES de construir la query SQL.

---

## 📚 Funciones Utilitarias Clave en `utils.ts`

### 1. `escapeSqlIdentifier` (líneas 24-38)
```typescript
export function escapeSqlIdentifier(identifier: string): string {
	const parts = identifier.match(/(`[^`]*`|[^.`]+)/g) ?? [];

	return parts
		.map((part) => {
			const trimmedPart = part.trim();
			if (trimmedPart.startsWith('`') && trimmedPart.endsWith('`')) {
				return trimmedPart;  // Ya escapado
			}
			return `\`${trimmedPart}\``;  // Escapar
		})
		.join('.');
}
```

**Ejemplo**:
```javascript
escapeSqlIdentifier('tareas')          // `tareas`
escapeSqlIdentifier('db.tareas')       // `db`.`tareas`
escapeSqlIdentifier('`ya_escapado`')   // `ya_escapado` (no duplica)
```

### 2. `addWhereClauses` (líneas 481-537)
```typescript
export function addWhereClauses(
	node: INode,
	itemIndex: number,
	query: string,
	clauses: WhereClause[],
	replacements: QueryValues,
	combineConditions?: string,
): [string, QueryValues] {
	if (clauses.length === 0) return [query, replacements];

	let combineWith = combineConditions === 'OR' ? 'OR' : 'AND';
	let whereQuery = ' WHERE';
	const values: QueryValues = [];

	clauses.forEach((clause, index) => {
		if (clause.condition === 'equal') clause.condition = '=';

		let valueReplacement = ' ';
		if (clause.condition !== 'IS NULL' && clause.condition !== 'IS NOT NULL') {
			valueReplacement = ' ?';
			values.push(clause.value);
		}

		const operator = index === clauses.length - 1 ? '' : ` ${combineWith}`;
		whereQuery += ` ${escapeSqlIdentifier(clause.column)} ${clause.condition}${valueReplacement}${operator}`;
	});

	return [`${query}${whereQuery}`, replacements.concat(...values)];
}
```

**Ejemplo**:
```javascript
// Input:
clauses = [
  { column: 'prioridad', condition: 'equal', value: 'alta' },
  { column: 'estado', condition: '!=', value: 'completada' }
]
combineConditions = 'AND'

// Output:
query = "SELECT * FROM tareas WHERE `prioridad` = ? AND `estado` != ?"
values = ['alta', 'completada']
```

### 3. `parseMySqlError` (líneas 184-229)
```typescript
export function parseMySqlError(
	this: IExecuteFunctions,
	error: any,
	itemIndex = 0,
	queries?: string[],
) {
	let message: string = error.message;
	const description = `sql: ${error.sql}, code: ${error.code}`;

	// Mejora mensajes de error SQL syntax
	if (message.toLowerCase().includes('you have an error in your sql syntax')) {
		const failedStatement = ((message.split("near '")[1] || '').split("' at")[0] || '').split(';')[0];

		if (failedStatement) {
			const lines = queries[queryIndex].split('\n');
			const failedLine = lines.findIndex((line) => line.includes(failedStatement));

			if (failedLine !== -1) {
				message = `You have an error in your SQL syntax on line ${failedLine + 1} near '${failedStatement}'`;
			}
		}
	}

	// Mejora error de conexión
	if (error?.message?.includes('ECONNREFUSED')) {
		message = 'Connection refused';
	}

	return new NodeOperationError(this.getNode(), error as Error, {
		message,
		description,
		itemIndex,
	});
}
```

**Propósito**: Convierte errores crípticos de MySQL en mensajes legibles para debugging.

---

## 🎓 Conclusiones para el Proyecto

### ✅ Lo que aprendimos

1. **`replaceEmptyStrings` es CRÍTICO**: Debe estar en `true` en todos los nodos INSERT/UPDATE/UPSERT/EXECUTE QUERY
2. **`largeNumbersOutput: "text"` es SEGURIDAD**: Evita pérdida de precisión en IDs
3. **`queryBatching: "single"` es ÓPTIMO**: Para el uso de un solo usuario con Gemini
4. **`detailedOutput: false` es LIMPIO**: Output sin ruido para el agente

### ❌ Lo que estaba mal en los análisis anteriores

1. **Error en fecha**: Usé `DD-MM-YYYY` en vez de `dd/MM/yyyy`
2. **No conocía opciones**: Propuse validación manual cuando `replaceEmptyStrings` lo hace automáticamente
3. **Complejidad innecesaria**: Tool descriptions mencionaban "o null" cuando la opción lo maneja

### 🚀 Próximo paso

Aplicar configuración correcta a los **16 nodos MySQL Tool** en el workflow `segundo_cerebro` (ID: `ZI6VUFdg6hEhnCbh`).

---

**Documento creado**: 16 enero 2026
**Fuente definitiva**: Código fuente de n8n v2.5 en GitHub
**Validación**: Completa con 13 archivos TypeScript analizados
