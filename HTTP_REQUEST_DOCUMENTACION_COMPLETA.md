# HTTP Request - Documentación Completa

**Fuentes**:
- ✅ MCP n8n-creator (estructura y opciones completas)
- ℹ️ Análisis de definición oficial v4.3

---

## 📋 Información General

- **Tipo de Nodo**: `nodes-base.httpRequest`
- **Nombre en Workflows**: `n8n-nodes-base.httpRequest`
- **Display Name**: HTTP Request
- **Versión Actual**: 4.3
- **Categoría**: output (salida de datos)
- **Paquete**: n8n-nodes-base
- **Descripción**: Realiza una petición HTTP y retorna los datos de respuesta

### Características Principales

- **Versionado**: Sí (actualmente en v4.3)
- **Es Trigger**: No
- **Es Webhook**: No
- **Es AI Tool**: Puede funcionar como AI Tool (con optimización de respuesta)
- **Tiene Variante Tool**: No (el nodo base puede funcionar como tool)
- **Estilo de Desarrollo**: Programático

### AI Tool Capabilities

Este nodo puede funcionar como AI Tool para agentes de IA:

- **Puede usarse como Tool**: ✅ Sí
- **Casos de uso comunes como AI Tool**:
  - Llamar APIs externas
  - Obtener datos de servicios web
  - Enviar webhooks
  - Integrar con cualquier REST API

---

## 🎯 Propósito del Nodo

El nodo HTTP Request es el nodo más versátil de n8n para interactuar con APIs y servicios web. Permite:

1. **Realizar cualquier tipo de petición HTTP** (GET, POST, PUT, DELETE, PATCH, HEAD, OPTIONS)
2. **Autenticación flexible** con soporte para múltiples métodos
3. **Paginación automática** para APIs que retornan datos en páginas
4. **Optimización para AI Agents** con procesamiento inteligente de respuestas
5. **Importación desde cURL** para facilitar la configuración

---

## 🔧 Propiedades Principales

### 1. Callout de Ejemplo (`preBuiltAgentsCalloutHttpRequest`)
- **Tipo**: callout
- **Default**: ""
- **Descripción**: Banner informativo con enlace a template de ejemplo "Joke agent with HTTP tool"
- **Disponible en**: Siempre visible

**Propósito**: Muestra un mensaje de ayuda con acción para abrir un workflow de ejemplo que usa HTTP Request como tool para agentes.

---

### 2. Importador de cURL (`curlImport`)
- **Tipo**: curlImport
- **Default**: ""
- **Descripción**: Permite importar configuración desde un comando cURL

**Funcionamiento**:
- Pega un comando cURL completo
- El nodo extrae automáticamente: método, URL, headers, body, auth
- Es una importación de un solo uso (no almacena el comando)

**Ejemplo de uso**:
```bash
curl -X POST https://api.example.com/users \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer TOKEN" \
  -d '{"name":"John","email":"john@example.com"}'
```

Al pegar esto en `curlImport`, n8n configura automáticamente:
- Method: POST
- URL: https://api.example.com/users
- Headers: Content-Type y Authorization
- Body: JSON con name y email

---

### 3. Method (`method`) ⭐
- **Tipo**: options (selección única)
- **Default**: "GET"
- **Descripción**: El método HTTP a utilizar
- **Valores posibles**:
  - GET - Obtener recursos
  - POST - Crear recursos
  - PUT - Actualizar recursos (reemplazo completo)
  - PATCH - Actualizar recursos (parcial)
  - DELETE - Eliminar recursos
  - HEAD - Obtener solo headers (sin body)
  - OPTIONS - Obtener métodos permitidos

**Notas**:
- GET y HEAD no permiten body por estándar HTTP
- POST/PUT/PATCH típicamente requieren body
- DELETE puede o no incluir body según API

---

### 4. URL (`url`) ⭐
- **Tipo**: string
- **Default**: ""
- **Required**: ✅ Sí
- **Soporta Expresiones**: ✅ Sí
- **Descripción**: La URL completa a la que hacer la petición

**Ejemplos**:
```javascript
// URL estática
https://api.github.com/users/n8n-io

// URL dinámica con expresiones
{{ $json.api_url }}/users/{{ $json.user_id }}

// URL con variables de entorno
{{ $env.API_BASE_URL }}/v1/data
```

**Validación**:
- Debe ser una URL válida (http:// o https://)
- Soporta query parameters en la URL directamente
- Se pueden agregar query parameters adicionales con "Send Query Parameters"

---

### 5. Authentication (`authentication`) ⭐
- **Tipo**: options
- **Default**: "none"
- **No Data Expression**: true
- **Valores posibles**:
  - **none** - Sin autenticación
  - **predefinedCredentialType** - Tipos predefinidos para servicios populares
  - **genericCredentialType** - Tipos genéricos personalizables

**Descripción de opciones**:

#### a) None
Sin autenticación. Usar para APIs públicas.

#### b) Predefined Credential Type
Autenticación preconfigurada para servicios populares:
- Google API
- AWS
- Slack API
- GitHub API
- Y muchos más

**Ventaja**: n8n maneja automáticamente tokens, refresh, firma de requests.

#### c) Generic Credential Type
Tipos genéricos completamente personalizables:
- Basic Auth
- Header Auth
- OAuth1
- OAuth2
- API Key
- Digest Auth

**Ventaja**: Máxima flexibilidad para cualquier API.

---

### 6. Credential Type (`nodeCredentialType`)
- **Tipo**: credentialsSelect
- **Default**: ""
- **Required**: ✅ Sí (cuando authentication = "predefinedCredentialType")
- **Display Options**: Se muestra solo si authentication = "predefinedCredentialType"
- **Soporta Expresiones**: ✅ Sí

**Descripción**: Selector de credenciales predefinidas para servicios populares.

**Ejemplo**: Si seleccionas "Google API", debes tener configurada una credencial de Google API en n8n.

---

### 7. Notice para Google API (`googleApiWarning`)
- **Tipo**: notice
- **Display Options**: Se muestra solo si nodeCredentialType = "googleApi"
- **Mensaje**: "Make sure you have specified the scope(s) for the Service Account in the credential"

**Propósito**: Recordar configurar los scopes OAuth correctos en la credencial de Google.

---

### 8. Generic Auth Type (`genericAuthType`)
- **Tipo**: credentialsSelect
- **Default**: ""
- **Required**: ✅ Sí (cuando authentication = "genericCredentialType")
- **Display Options**: Se muestra solo si authentication = "genericCredentialType"

**Descripción**: Selector para tipos de autenticación genéricos.

**Tipos disponibles**:
- httpBasicAuth - Usuario y contraseña
- httpHeaderAuth - Header personalizado
- oAuth1Api - OAuth 1.0
- oAuth2Api - OAuth 2.0
- httpDigestAuth - Digest authentication
- httpQueryAuth - Autenticación por query parameter

---

### 9. SSL Certificates (`provideSslCertificates`)
- **Tipo**: boolean
- **Default**: false

**Descripción**: Habilita el uso de certificados SSL personalizados para HTTPS.

**Cuándo usar**:
- APIs internas con certificados autofirmados
- Ambientes corporativos con CA privadas
- Mutual TLS (mTLS)

---

### 10. SSL Certificate Notice (`provideSslCertificatesNotice`)
- **Tipo**: notice
- **Display Options**: Se muestra solo si provideSslCertificates = true
- **Mensaje**: "Provide certificates in node's 'Credential for SSL Certificates' parameter"

---

### 11. SSL Certificate (`sslCertificate`)
- **Tipo**: credentials
- **Default**: ""
- **Display Options**: Se muestra solo si provideSslCertificates = true

**Descripción**: Referencia a credencial de tipo "httpSslAuth" que contiene:
- Certificado cliente (PEM)
- Llave privada (PEM)
- Certificado CA (opcional)

---

## 🔗 Query Parameters

### 12. Send Query Parameters (`sendQuery`)
- **Tipo**: boolean
- **Default**: false
- **No Data Expression**: true

**Descripción**: Habilita el envío de query parameters (ej: `?key=value&foo=bar`)

**Cuándo habilitarlo**:
- Cuando la API requiere parámetros en la URL
- Para filtros, paginación, búsquedas

---

### 13. Specify Query Parameters (`specifyQuery`)
- **Tipo**: options
- **Default**: "keypair"
- **Display Options**: Se muestra solo si sendQuery = true
- **Valores**:
  - **keypair** - Usando campos individuales (UI amigable)
  - **json** - Usando un objeto JSON

**Ejemplo keypair**:
```
Name: search
Value: n8n automation

Name: limit
Value: 10
```
Resultado: `?search=n8n%20automation&limit=10`

**Ejemplo JSON**:
```json
{
  "search": "n8n automation",
  "limit": 10,
  "sort": "date"
}
```

---

### 14. Query Parameters (`queryParameters`)
- **Tipo**: fixedCollection (multipleValues: true)
- **Display Options**: Se muestra si sendQuery=true y specifyQuery="keypair"
- **Estructura**:
  ```json
  {
    "parameters": [
      {
        "name": "nombre_parametro",
        "value": "valor_parametro"
      }
    ]
  }
  ```

**Soporta**:
- Múltiples parámetros
- Expresiones en nombre y valor
- Arrays (ver opción "Array Format in Query Parameters")

---

### 15. JSON Query (`jsonQuery`)
- **Tipo**: json
- **Default**: ""
- **Display Options**: Se muestra si sendQuery=true y specifyQuery="json"
- **Soporta Expresiones**: ✅ Sí

**Ejemplo**:
```json
{
  "api_key": "{{ $env.API_KEY }}",
  "limit": {{ $json.page_size }},
  "offset": {{ $json.page * $json.page_size }}
}
```

**Validación**: Debe ser JSON válido al ejecutarse.

---

## 📤 Headers

### 16. Send Headers (`sendHeaders`)
- **Tipo**: boolean
- **Default**: false
- **No Data Expression**: true

**Descripción**: Habilita el envío de headers HTTP personalizados.

**Casos de uso comunes**:
- Content-Type personalizado
- Authorization custom
- Headers de tracking (X-Request-ID)
- User-Agent personalizado
- CORS headers

---

### 17. Specify Headers (`specifyHeaders`)
- **Tipo**: options
- **Default**: "keypair"
- **Display Options**: Se muestra solo si sendHeaders = true
- **Valores**:
  - **keypair** - Usando campos individuales
  - **json** - Usando objeto JSON

**Ejemplo keypair**:
```
Name: X-API-Key
Value: abc123xyz

Name: User-Agent
Value: n8n-automation/1.0
```

**Ejemplo JSON**:
```json
{
  "X-API-Key": "abc123xyz",
  "User-Agent": "n8n-automation/1.0",
  "Accept": "application/json"
}
```

---

### 18. Header Parameters (`headerParameters`)
- **Tipo**: fixedCollection (multipleValues: true)
- **Display Options**: Se muestra si sendHeaders=true y specifyHeaders="keypair"
- **Estructura**:
  ```json
  {
    "parameters": [
      {
        "name": "nombre_header",
        "value": "valor_header"
      }
    ]
  }
  ```

**Nota**: Los headers de autenticación se agregan automáticamente si usas credentials.

---

### 19. JSON Headers (`jsonHeaders`)
- **Tipo**: json
- **Default**: ""
- **Display Options**: Se muestra si sendHeaders=true y specifyHeaders="json"
- **Soporta Expresiones**: ✅ Sí

**Ejemplo**:
```json
{
  "Authorization": "Bearer {{ $json.access_token }}",
  "Content-Type": "application/json",
  "X-Request-ID": "{{ $runId }}"
}
```

---

## 📦 Body Parameters

### 20. Send Body (`sendBody`)
- **Tipo**: boolean
- **Default**: false
- **No Data Expression**: true

**Descripción**: Habilita el envío de body en la petición.

**Cuándo habilitarlo**:
- POST/PUT/PATCH requests
- Envío de datos al servidor
- Upload de archivos

**Nota**: GET y HEAD típicamente no usan body.

---

### 21. Body Content Type (`contentType`)
- **Tipo**: options
- **Default**: "json"
- **Display Options**: Se muestra solo si sendBody = true
- **Valores**:
  - **json** - JSON (application/json)
  - **form-urlencoded** - Form URL encoded (application/x-www-form-urlencoded)
  - **multipart-form-data** - Multipart form (para archivos)
  - **binaryData** - Archivo binario de n8n
  - **raw** - Raw body con Content-Type personalizado

### Detalles de cada Content Type:

#### a) JSON (`json`)
**Uso**: APIs REST modernas, la mayoría de APIs públicas.

**Opciones adicionales**:
- `specifyBody`: "keypair" o "json"

**Ejemplo keypair**:
```
Name: name
Value: John Doe

Name: email
Value: john@example.com
```
Resultado: `{"name":"John Doe","email":"john@example.com"}`

**Ejemplo JSON** (`jsonBody`):
```json
{
  "name": "{{ $json.name }}",
  "email": "{{ $json.email }}",
  "metadata": {
    "source": "n8n",
    "timestamp": "{{ $now }}"
  }
}
```

---

#### b) Form Urlencoded (`form-urlencoded`)
**Uso**: Formularios HTML tradicionales, algunas APIs OAuth.

**Opciones adicionales**:
- `specifyBody`: "keypair" o "string"

**Ejemplo keypair**:
```
Name: username
Value: johndoe

Name: password
Value: secret123
```
Resultado: `username=johndoe&password=secret123`

**Ejemplo string** (`body`):
```
username={{ $json.user }}&password={{ $json.pass }}&remember=true
```

---

#### c) Multipart Form-Data (`multipart-form-data`)
**Uso**: Upload de archivos, formularios con archivos adjuntos.

**Estructura de parámetros**:
Cada parámetro tiene:
- **parameterType**: "formData" o "formBinaryData"
- **name**: Nombre del campo
- **value** (si formData): Valor del campo
- **inputDataFieldName** (si formBinaryData): Nombre del campo binario en n8n

**Ejemplo**:
```json
{
  "parameters": [
    {
      "parameterType": "formData",
      "name": "description",
      "value": "Profile picture"
    },
    {
      "parameterType": "formBinaryData",
      "name": "file",
      "inputDataFieldName": "image"
    }
  ]
}
```

**Resultado HTTP**:
```
Content-Type: multipart/form-data; boundary=----WebKitFormBoundary...

------WebKitFormBoundary...
Content-Disposition: form-data; name="description"

Profile picture
------WebKitFormBoundary...
Content-Disposition: form-data; name="file"; filename="avatar.jpg"
Content-Type: image/jpeg

[BINARY DATA]
------WebKitFormBoundary...--
```

---

#### d) Binary Data (`binaryData`)
**Uso**: Enviar un archivo binario completo como body.

**Campo requerido**: `inputDataFieldName`

**Ejemplo**:
```
inputDataFieldName: pdf_file
```

Si el item actual tiene un campo binario llamado "pdf_file", ese contenido se envía como body completo.

**Header automático**: n8n infiere el Content-Type del archivo (ej: application/pdf, image/png).

---

#### e) Raw (`raw`)
**Uso**: Cualquier contenido personalizado (XML, SOAP, plain text, custom formats).

**Campos**:
- **rawContentType**: Content-Type header (ej: "application/xml", "text/plain")
- **body**: Contenido raw

**Ejemplo XML**:
```
rawContentType: application/xml
body:
<?xml version="1.0"?>
<request>
  <user>{{ $json.username }}</user>
  <action>create</action>
</request>
```

**Ejemplo SOAP**:
```
rawContentType: text/xml; charset=utf-8
body:
<?xml version="1.0"?>
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <GetUserInfo>
      <UserId>{{ $json.id }}</UserId>
    </GetUserInfo>
  </soap:Body>
</soap:Envelope>
```

---

## ⚙️ Options (Opciones Avanzadas)

### 22. Options Collection (`options`)

El campo `options` es una collection con múltiples opciones avanzadas:

---

### 22.1. Batching (`batching`)
- **Tipo**: fixedCollection
- **Default**: `{ batch: {} }`

**Descripción**: Divide los items de entrada en lotes para throttling de requests.

**Campos**:

#### Items per Batch (`batchSize`)
- **Tipo**: number
- **Default**: 50
- **Min Value**: -1
- **Descripción**: Cantidad de items por lote
  - `-1`: Batching deshabilitado (todos los items en una request)
  - `0`: Se trata como 1
  - `> 0`: Cantidad de items por batch

#### Batch Interval (ms) (`batchInterval`)
- **Tipo**: number
- **Default**: 1000 (1 segundo)
- **Min Value**: 0
- **Descripción**: Tiempo en milisegundos entre cada batch
  - `0`: Sin delay entre batches
  - `> 0`: Delay entre batches

**Ejemplo de uso**:
Si tienes 200 items y configuras:
```json
{
  "batchSize": 50,
  "batchInterval": 1000
}
```

Resultado:
- Batch 1: Items 0-49 (envío inmediato)
- Espera 1 segundo
- Batch 2: Items 50-99
- Espera 1 segundo
- Batch 3: Items 100-149
- Espera 1 segundo
- Batch 4: Items 150-199

**Razón de uso**: APIs con rate limiting (ej: máximo 100 requests/minuto).

---

### 22.2. Ignore SSL Issues (`allowUnauthorizedCerts`)
- **Tipo**: boolean
- **Default**: false
- **No Data Expression**: true

**Descripción**: Permite descargar respuesta aunque la validación del certificado SSL falle.

**⚠️ Seguridad**: Solo usar en desarrollo o con APIs internas. NUNCA en producción con APIs públicas.

**Casos de uso legítimos**:
- Ambientes de desarrollo con certificados autofirmados
- APIs internas corporativas
- Testing local con localhost

---

### 22.3. Array Format in Query Parameters (`queryParameterArrays`)
- **Tipo**: options
- **Default**: "brackets"
- **Display Options**: Se muestra solo si `/sendQuery` = true
- **Valores**:
  - **repeat** - Sin brackets (ej: `foo=bar&foo=qux`)
  - **brackets** - Con brackets (ej: `foo[]=bar&foo[]=qux`)
  - **indices** - Brackets con índices (ej: `foo[0]=bar&foo[1]=qux`)

**Ejemplo**:
Si tienes un query parameter "tags" con valor `["n8n", "automation", "api"]`:

- **repeat**: `?tags=n8n&tags=automation&tags=api`
- **brackets**: `?tags[]=n8n&tags[]=automation&tags[]=api`
- **indices**: `?tags[0]=n8n&tags[1]=automation&tags[2]=api`

**Nota**: Cada API espera un formato específico. Verifica la documentación de la API.

---

### 22.4. Lowercase Headers (`lowercaseHeaders`)
- **Tipo**: boolean
- **Default**: true

**Descripción**: Si convertir nombres de headers a minúsculas.

**Por qué es importante**:
- HTTP/1.1: Headers son case-insensitive (`Content-Type` = `content-type`)
- HTTP/2: Headers DEBEN estar en minúsculas
- Algunas APIs legacy esperan case específico

**Recomendación**: Dejar en `true` salvo que la API específicamente requiera mayúsculas.

---

### 22.5. Redirects (`redirect`)
- **Tipo**: fixedCollection
- **Default**: `{ redirect: {} }`

**Campos**:

#### Follow Redirects (`followRedirects`)
- **Tipo**: boolean
- **Default versión < 4**: false
- **Default versión >= 4**: true
- **No Data Expression**: true
- **Descripción**: Si seguir redirects HTTP (301, 302, 307, 308)

#### Max Redirects (`maxRedirects`)
- **Tipo**: number
- **Default**: 21
- **Display Options**: Solo si followRedirects = true
- **Descripción**: Máximo número de redirects a seguir

**Comportamiento**:
Si `followRedirects` = false:
- Retorna el status code 301/302 y headers (incluyendo `Location`)
- No sigue el redirect

Si `followRedirects` = true:
- Sigue automáticamente hasta `maxRedirects`
- Retorna la respuesta final

**Ejemplo**:
```
URL original: https://bit.ly/n8n-workflow
Redirect 1: https://n8n.io/workflows/123
Redirect 2: https://www.n8n.io/workflows/123

Con followRedirects=true: Retorna contenido de www.n8n.io/workflows/123
Con followRedirects=false: Retorna status 301 y header Location: https://n8n.io/workflows/123
```

---

### 22.6. Response (`response`)
- **Tipo**: fixedCollection
- **Default**: `{ response: {} }`

**Campos**:

#### Include Response Headers and Status (`fullResponse`)
- **Tipo**: boolean
- **Default**: false
- **Descripción**: Si retornar headers y status code además del body

**Con fullResponse = false**:
```json
{
  "userId": 1,
  "name": "John Doe"
}
```

**Con fullResponse = true**:
```json
{
  "statusCode": 200,
  "statusMessage": "OK",
  "headers": {
    "content-type": "application/json",
    "x-rate-limit-remaining": "4999"
  },
  "body": {
    "userId": 1,
    "name": "John Doe"
  }
}
```

---

#### Never Error (`neverError`)
- **Tipo**: boolean
- **Default**: false
- **Descripción**: Si tener éxito incluso cuando status code no es 2xx

**Comportamiento normal** (neverError = false):
- Status 200-299: Éxito
- Status 300-599: Error (workflow se detiene)

**Con neverError = true**:
- Status 200-299: Éxito
- Status 300-599: Éxito (pero puedes inspeccionar el status code)

**Caso de uso**:
Cuando quieres manejar errores manualmente con un nodo Switch:
```javascript
// En nodo Switch después de HTTP Request con neverError=true
{{ $json.statusCode === 404 }} → Ruta "Not Found"
{{ $json.statusCode >= 500 }} → Ruta "Server Error"
{{ $json.statusCode === 200 }} → Ruta "Success"
```

---

#### Response Format (`responseFormat`)
- **Tipo**: options
- **No Data Expression**: true
- **Default**: "autodetect"
- **Valores**:
  - **autodetect** - Detectar automáticamente por Content-Type
  - **json** - Parsear como JSON
  - **text** - Retornar como texto plano
  - **file** - Guardar como archivo binario

**Autodetect logic**:
- Content-Type: `application/json` → JSON
- Content-Type: `text/*` → Text
- Content-Type: `image/*`, `application/pdf`, etc. → File
- Sin Content-Type o desconocido → Text

**Forzar JSON**:
Útil si la API retorna JSON pero con Content-Type incorrecto (ej: `text/plain`).

**Forzar File**:
Para descargar archivos (PDFs, imágenes, Excel, etc.).

---

#### Put Output in Field (`outputPropertyName`)
- **Tipo**: string
- **Default**: "data"
- **Required**: ✅ Sí
- **Display Options**: Solo si responseFormat = "file" o "text"
- **Descripción**: Nombre del campo donde guardar el output

**Para "file"**:
El contenido se guarda como binary data en el campo especificado.

**Ejemplo**:
```
outputPropertyName: document
```
Resultado:
```json
{
  "json": {},
  "binary": {
    "document": {
      "data": "base64EncodedData...",
      "mimeType": "application/pdf",
      "fileName": "report.pdf"
    }
  }
}
```

**Para "text"**:
El texto se guarda en `json[outputPropertyName]`.

**Ejemplo**:
```
outputPropertyName: html_content
```
Resultado:
```json
{
  "html_content": "<html><body>...</body></html>"
}
```

---

### 22.7. Pagination (`pagination`)
- **Tipo**: fixedCollection
- **Default**: `{ pagination: {} }`

**Descripción**: Configuración de paginación automática para APIs que retornan datos en páginas.

**Campos**:

#### Pagination Mode (`paginationMode`)
- **Tipo**: options
- **No Data Expression**: true
- **Default**: "updateAParameterInEachRequest"
- **Valores**:
  - **off** - Sin paginación
  - **updateAParameterInEachRequest** - Actualizar parámetro en cada request
  - **responseContainsNextURL** - La respuesta contiene la URL de la siguiente página

---

#### Notice (`webhookNotice`)
- **Tipo**: notice
- **Display Options**: Se oculta si paginationMode = "off"
- **Mensaje**: "Use the $response variables to access the data of the previous response. Refer to the docs for more info about pagination"

**Variables especiales disponibles en paginación**:
- `$response.body` - Body de la respuesta anterior
- `$response.headers` - Headers de la respuesta anterior
- `$response.statusCode` - Status code de la respuesta anterior
- `$pageCount` - Número de página actual (empieza en 1)

---

#### Next URL (`nextURL`) - Para modo "responseContainsNextURL"
- **Tipo**: string
- **Default**: ""
- **Display Options**: Solo si paginationMode = "responseContainsNextURL"
- **Soporta Expresiones**: ✅ Sí (con `$response`)

**Descripción**: Expresión que evalúa a la URL de la siguiente página.

**Ejemplos**:

**Caso 1: Next URL en campo directo**
```json
// Respuesta de API:
{
  "data": [...],
  "next_page": "https://api.example.com/users?page=2"
}

// Configuración:
nextURL: {{ $response.body.next_page }}
```

**Caso 2: Next URL construida**
```json
// Respuesta:
{
  "pagination": {
    "next_cursor": "abc123"
  }
}

// Configuración:
nextURL: {{ $response.body.pagination.next_cursor ? 'https://api.example.com/data?cursor=' + $response.body.pagination.next_cursor : '' }}
```

**Lógica de detención**:
- Si `nextURL` evalúa a string vacío (""), la paginación se detiene
- Si `nextURL` es `null` o `undefined`, la paginación se detiene

---

#### Parameters (`parameters`) - Para modo "updateAParameterInEachRequest"
- **Tipo**: fixedCollection (multipleValues: true)
- **Display Options**: Solo si paginationMode = "updateAParameterInEachRequest"
- **No Expression**: true (excepto en el campo "value")

**Descripción**: Define qué parámetros actualizar en cada request paginado.

**Estructura**:
```json
{
  "parameters": [
    {
      "type": "qs",  // "qs", "body", "headers"
      "name": "page",
      "value": "{{ $pageCount }}"
    }
  ]
}
```

**Campos de cada parámetro**:

##### Type (`type`)
- **Valores**: "qs" (query), "body", "headers"
- **Descripción**: Dónde se envía el parámetro

##### Name (`name`)
- **Tipo**: string
- **Placeholder**: "e.g page"
- **Descripción**: Nombre del parámetro

##### Value (`value`)
- **Tipo**: string
- **Hint**: "Use expression mode and $response to access response data"
- **Soporta Expresiones**: ✅ Sí
- **Descripción**: Valor del parámetro (típicamente usa `$response` o `$pageCount`)

**Ejemplos comunes**:

**Paginación offset/limit**:
```json
{
  "parameters": [
    {
      "type": "qs",
      "name": "offset",
      "value": "{{ ($pageCount - 1) * 100 }}"
    },
    {
      "type": "qs",
      "name": "limit",
      "value": "100"
    }
  ]
}
```

**Paginación por página**:
```json
{
  "parameters": [
    {
      "type": "qs",
      "name": "page",
      "value": "{{ $pageCount }}"
    }
  ]
}
```

**Paginación con cursor desde respuesta**:
```json
{
  "parameters": [
    {
      "type": "qs",
      "name": "cursor",
      "value": "{{ $response.body.next_cursor }}"
    }
  ]
}
```

---

#### Pagination Complete When (`paginationCompleteWhen`)
- **Tipo**: options
- **No Data Expression**: true
- **Default**: "responseIsEmpty"
- **Display Options**: Se oculta si paginationMode = "off"
- **Valores**:
  - **responseIsEmpty** - Cuando la respuesta está vacía
  - **receiveSpecificStatusCodes** - Al recibir status codes específicos
  - **other** - Expresión personalizada

**Descripción**: Condición para detener la paginación.

---

#### Status Code(s) when Complete (`statusCodesWhenComplete`)
- **Tipo**: string
- **No Data Expression**: true
- **Default**: ""
- **Display Options**: Solo si paginationCompleteWhen = "receiveSpecificStatusCodes"
- **Descripción**: Códigos de status separados por coma (ej: "404,410")

**Ejemplo**:
```
statusCodesWhenComplete: 404,410

Comportamiento:
- Status 200: Continuar paginando
- Status 404 o 410: Detener paginación
```

---

#### Complete Expression (`completeExpression`)
- **Tipo**: string
- **Default**: ""
- **Display Options**: Solo si paginationCompleteWhen = "other"
- **Soporta Expresiones**: ✅ Sí (con `$response`)
- **Descripción**: Expresión que debe evaluar a `true` cuando la paginación está completa

**Ejemplos**:

**Detener si no hay más datos**:
```javascript
{{ !$response.body.data || $response.body.data.length === 0 }}
```

**Detener si campo "hasMore" es false**:
```javascript
{{ $response.body.hasMore === false }}
```

**Detener si llegamos a la última página**:
```javascript
{{ $response.body.currentPage >= $response.body.totalPages }}
```

---

#### Limit Pages Fetched (`limitPagesFetched`)
- **Tipo**: boolean
- **No Data Expression**: true
- **Default**: false
- **Display Options**: Se oculta si paginationMode = "off"

**Descripción**: Si limitar el número de páginas a obtener.

---

#### Max Pages (`maxRequests`)
- **Tipo**: number
- **No Data Expression**: true
- **Default**: 100
- **Display Options**: Solo si limitPagesFetched = true

**Descripción**: Máximo número de requests/páginas a hacer.

**Seguridad**: Evita loops infinitos si la condición de detención falla.

**Ejemplo**:
```
maxRequests: 10

Resultado:
- Se harán máximo 10 requests
- Aunque la API tenga 1000 páginas
- Protección contra errores de lógica
```

---

#### Interval Between Requests (ms) (`requestInterval`)
- **Tipo**: number
- **Default**: 0
- **Min Value**: 0
- **Display Options**: Se oculta si paginationMode = "off"
- **Hint**: "At 0 no delay will be added"

**Descripción**: Tiempo en milisegundos a esperar entre requests paginados.

**Cuándo usar**:
- APIs con rate limiting
- Evitar sobrecargar el servidor
- Cumplir ToS de la API

**Ejemplo**:
```
requestInterval: 1000

Comportamiento:
- Request página 1
- Espera 1 segundo
- Request página 2
- Espera 1 segundo
- Request página 3
- etc.
```

---

### 22.8. Proxy (`proxy`)
- **Tipo**: string
- **Default**: ""
- **Placeholder**: "e.g. http://myproxy:3128"
- **Soporta Expresiones**: ✅ Sí

**Descripción**: HTTP proxy a utilizar para la request.

**Formato**: `http://[user:pass@]host:port`

**Ejemplos**:
```
Sin auth: http://proxy.company.com:8080
Con auth: http://user:password@proxy.company.com:8080
```

**Cuándo usar**:
- Redes corporativas que requieren proxy
- Enmascarar IP de origen
- Debugging con proxies como Charles o Fiddler

---

### 22.9. Timeout (`timeout`)
- **Tipo**: number
- **Default**: 10000 (10 segundos)
- **Min Value**: 1
- **Soporta Expresiones**: ✅ Sí

**Descripción**: Tiempo en milisegundos a esperar por response headers antes de abortar.

**Comportamiento**:
- Si el servidor no envía headers en `timeout` ms → Error de timeout
- Una vez que empiezan a llegar headers, el timeout no aplica al body

**Valores recomendados**:
- APIs rápidas: 5000-10000 ms
- APIs lentas/procesamiento: 30000-60000 ms
- Operaciones muy largas: 120000+ ms

**Nota**: n8n tiene un timeout global de workflow (configurable en settings), este timeout es adicional y específico del nodo.

---

## 🤖 AI Tool Optimization (Optimización para Agentes de IA)

### 23. Optimize Response (`optimizeResponse`)
- **Tipo**: boolean
- **Default**: false
- **No Data Expression**: true
- **Display Options**: Solo si `@tool` = true (modo AI Tool)

**Descripción**: Optimizar la respuesta del tool para reducir la cantidad de datos pasados al LLM, mejorando resultados y reduciendo costos.

**Cuándo habilitarlo**:
- Cuando usas el nodo como tool para un AI Agent
- La respuesta de la API es muy grande
- Solo necesitas campos específicos de la respuesta

---

### 24. Expected Response Type (`responseType`)
- **Tipo**: options
- **Default**: "json"
- **Display Options**: Solo si optimizeResponse=true y @tool=true
- **Valores**:
  - **json** - Respuesta JSON
  - **html** - Respuesta HTML
  - **text** - Respuesta de texto plano

**Descripción**: Tipo de respuesta esperado, determina qué optimizaciones aplicar.

---

### 25. Field Containing Data (`dataField`) - Para JSON
- **Tipo**: string
- **Default**: ""
- **Display Options**: Solo si optimizeResponse=true, responseType="json", @tool=true
- **Soporta Expresiones**: ✅ Sí

**Descripción**: Especifica el campo en la respuesta JSON que contiene los datos relevantes.

**Ejemplo**:
```json
// Respuesta completa de API:
{
  "status": "success",
  "metadata": {
    "timestamp": "2024-01-15T10:30:00Z",
    "requestId": "abc123"
  },
  "data": {
    "users": [
      {"id": 1, "name": "John", "email": "john@example.com"},
      {"id": 2, "name": "Jane", "email": "jane@example.com"}
    ]
  }
}

// Configuración:
dataField: data.users

// LLM recibe solo:
[
  {"id": 1, "name": "John", "email": "john@example.com"},
  {"id": 2, "name": "Jane", "email": "jane@example.com"}
]
```

**Ventaja**: LLM procesa menos datos, respuestas más rápidas, menor costo de tokens.

---

### 26. Include Fields (`fieldsToInclude`)
- **Tipo**: options
- **Default**: "all"
- **Display Options**: Solo si optimizeResponse=true, responseType="json", @tool=true
- **Valores**:
  - **all** - Incluir todos los campos
  - **selected** - Incluir solo campos especificados
  - **except** - Excluir campos especificados

**Descripción**: Qué campos del objeto JSON incluir en la respuesta optimizada.

---

### 27. Fields (`fields`)
- **Tipo**: string
- **Default**: ""
- **Display Options**: Solo si optimizeResponse=true, responseType="json", @tool=true y fieldsToInclude != "all"
- **Soporta Expresiones**: ✅ Sí
- **Hint**: "Comma-separated list of field names. Supports dot notation. You can drag the selected fields from the input panel."

**Descripción**: Lista de campos separados por coma, soporta dot notation.

**Ejemplos**:

**Caso 1: Incluir campos específicos**
```
fieldsToInclude: selected
fields: id,name,email

Respuesta original:
{
  "id": 1,
  "name": "John",
  "email": "john@example.com",
  "address": "123 Main St",
  "phone": "555-0100",
  "createdAt": "2024-01-01"
}

LLM recibe:
{
  "id": 1,
  "name": "John",
  "email": "john@example.com"
}
```

**Caso 2: Excluir campos innecesarios**
```
fieldsToInclude: except
fields: metadata,debug,_internal

Respuesta original:
{
  "userId": 1,
  "name": "John",
  "metadata": {...},
  "debug": {...},
  "_internal": {...}
}

LLM recibe:
{
  "userId": 1,
  "name": "John"
}
```

**Caso 3: Dot notation para campos anidados**
```
fields: user.id,user.name,company.name

Respuesta original:
{
  "user": {
    "id": 1,
    "name": "John",
    "email": "john@example.com",
    "settings": {...}
  },
  "company": {
    "id": 100,
    "name": "Acme Corp",
    "address": "..."
  }
}

LLM recibe:
{
  "user": {
    "id": 1,
    "name": "John"
  },
  "company": {
    "name": "Acme Corp"
  }
}
```

---

### 28. Selector (CSS) (`cssSelector`) - Para HTML
- **Tipo**: string
- **Default**: "body"
- **Display Options**: Solo si optimizeResponse=true, responseType="html", @tool=true
- **Soporta Expresiones**: ✅ Sí

**Descripción**: Selector CSS para extraer elementos específicos del HTML.

**Ejemplos**:

**Extraer solo el contenido principal**:
```
cssSelector: main
```

**Extraer múltiples artículos**:
```
cssSelector: article.blog-post
```

**Extraer tabla de datos**:
```
cssSelector: table#results
```

**Extraer todos los links**:
```
cssSelector: a
```

---

### 29. Return Only Content (`onlyContent`)
- **Tipo**: boolean
- **Default**: false
- **Display Options**: Solo si optimizeResponse=true, responseType="html", @tool=true

**Descripción**: Si retornar solo el contenido de texto de los elementos HTML, eliminando tags y atributos.

**Ejemplo**:

**Con onlyContent = false**:
```html
<div class="article">
  <h1 id="title">Welcome to n8n</h1>
  <p class="intro">This is an <strong>automation</strong> platform.</p>
</div>
```

**Con onlyContent = true**:
```
Welcome to n8n
This is an automation platform.
```

---

### 30. Elements To Omit (`elementsToOmit`)
- **Tipo**: string
- **Default**: ""
- **Display Options**: Solo si optimizeResponse=true, responseType="html", onlyContent=true, @tool=true
- **Soporta Expresiones**: ✅ Sí
- **Descripción**: Lista separada por comas de selectores CSS a excluir al extraer contenido

**Ejemplo**:

**HTML original**:
```html
<article>
  <h1>Article Title</h1>
  <div class="ads">Advertisement</div>
  <p>Main content here.</p>
  <footer>Footer info</footer>
</article>

cssSelector: article
onlyContent: true
elementsToOmit: .ads,footer

LLM recibe:
Article Title
Main content here.
```

**Casos de uso**:
- Remover scripts: `script,style`
- Remover ads: `.ad,.advertisement`
- Remover navegación: `nav,header,footer`
- Remover comentarios: `.comments`

---

### 31. Truncate Response (`truncateResponse`)
- **Tipo**: boolean
- **Default**: false
- **Display Options**: Solo si optimizeResponse=true, responseType="text" o "html", @tool=true

**Descripción**: Si truncar la respuesta a un número máximo de caracteres.

---

### 32. Max Response Characters (`maxLength`)
- **Tipo**: number
- **Default**: 1000
- **Min Value**: 1
- **Display Options**: Solo si optimizeResponse=true, responseType="text" o "html", truncateResponse=true, @tool=true

**Descripción**: Número máximo de caracteres a retornar al LLM.

**Comportamiento**:
- Si la respuesta tiene <= maxLength caracteres: Se retorna completa
- Si la respuesta tiene > maxLength caracteres: Se trunca a maxLength

**Ejemplo**:
```
Respuesta original: 5000 caracteres
maxLength: 1000

LLM recibe: Solo los primeros 1000 caracteres
```

**Cuándo usar**:
- APIs que retornan contenido muy largo
- Reducir costos de tokens del LLM
- Acelerar procesamiento del agente

---

### 33. Info Message (`infoMessage`)
- **Tipo**: notice
- **Mensaje**: "You can view the raw requests this node makes in your browser's developer console"

**Descripción**: Mensaje informativo sobre debugging en browser console.

---

## 📚 Casos de Uso Comunes

### Caso 1: API REST Básica (GET con Query Parameters)

**Escenario**: Obtener lista de usuarios de una API con filtros.

**Configuración**:
```json
{
  "method": "GET",
  "url": "https://api.example.com/users",
  "authentication": "genericCredentialType",
  "genericAuthType": "httpHeaderAuth",
  "sendQuery": true,
  "specifyQuery": "keypair",
  "queryParameters": {
    "parameters": [
      {"name": "role", "value": "admin"},
      {"name": "limit", "value": "50"},
      {"name": "sort", "value": "created_desc"}
    ]
  }
}
```

**Request generado**:
```
GET https://api.example.com/users?role=admin&limit=50&sort=created_desc
Headers:
  Authorization: Bearer [token desde credencial]
```

---

### Caso 2: API REST POST con JSON

**Escenario**: Crear un nuevo usuario.

**Configuración**:
```json
{
  "method": "POST",
  "url": "https://api.example.com/users",
  "authentication": "predefinedCredentialType",
  "nodeCredentialType": "customApiAuth",
  "sendBody": true,
  "contentType": "json",
  "specifyBody": "json",
  "jsonBody": "{\n  \"name\": \"{{ $json.name }}\",\n  \"email\": \"{{ $json.email }}\",\n  \"role\": \"user\"\n}"
}
```

**Request generado**:
```
POST https://api.example.com/users
Headers:
  Content-Type: application/json
  Authorization: [desde credencial]
Body:
{
  "name": "John Doe",
  "email": "john@example.com",
  "role": "user"
}
```

---

### Caso 3: Upload de Archivo (Multipart Form-Data)

**Escenario**: Subir una imagen de perfil.

**Configuración**:
```json
{
  "method": "POST",
  "url": "https://api.example.com/users/{{ $json.userId }}/avatar",
  "sendBody": true,
  "contentType": "multipart-form-data",
  "bodyParameters": {
    "parameters": [
      {
        "parameterType": "formData",
        "name": "description",
        "value": "Profile picture"
      },
      {
        "parameterType": "formBinaryData",
        "name": "file",
        "inputDataFieldName": "avatar"
      }
    ]
  }
}
```

**Prerequisito**: El item debe tener binary data en campo "avatar".

**Request generado**:
```
POST https://api.example.com/users/123/avatar
Headers:
  Content-Type: multipart/form-data; boundary=----WebKitFormBoundary...
Body:
------WebKitFormBoundary...
Content-Disposition: form-data; name="description"

Profile picture
------WebKitFormBoundary...
Content-Disposition: form-data; name="file"; filename="avatar.jpg"
Content-Type: image/jpeg

[BINARY DATA]
```

---

### Caso 4: Paginación Automática (Offset/Limit)

**Escenario**: Obtener todos los registros de una API paginada.

**Configuración**:
```json
{
  "method": "GET",
  "url": "https://api.example.com/records",
  "options": {
    "pagination": {
      "pagination": {
        "paginationMode": "updateAParameterInEachRequest",
        "parameters": {
          "parameters": [
            {
              "type": "qs",
              "name": "offset",
              "value": "{{ ($pageCount - 1) * 100 }}"
            },
            {
              "type": "qs",
              "name": "limit",
              "value": "100"
            }
          ]
        },
        "paginationCompleteWhen": "responseIsEmpty",
        "limitPagesFetched": true,
        "maxRequests": 50,
        "requestInterval": 500
      }
    }
  }
}
```

**Comportamiento**:
```
Request 1: GET /records?offset=0&limit=100
Request 2: GET /records?offset=100&limit=100 (espera 500ms)
Request 3: GET /records?offset=200&limit=100 (espera 500ms)
...
Detiene cuando: respuesta vacía o alcanza 50 requests
```

---

### Caso 5: Paginación con Cursor

**Escenario**: API que usa cursores para paginación (ej: APIs de redes sociales).

**Configuración**:
```json
{
  "method": "GET",
  "url": "https://api.example.com/posts",
  "sendQuery": true,
  "specifyQuery": "keypair",
  "queryParameters": {
    "parameters": [
      {"name": "limit", "value": "50"}
    ]
  },
  "options": {
    "pagination": {
      "pagination": {
        "paginationMode": "updateAParameterInEachRequest",
        "parameters": {
          "parameters": [
            {
              "type": "qs",
              "name": "cursor",
              "value": "{{ $response.body.pagination.next_cursor }}"
            }
          ]
        },
        "paginationCompleteWhen": "other",
        "completeExpression": "{{ !$response.body.pagination.next_cursor }}"
      }
    }
  }
}
```

**Respuesta esperada de API**:
```json
{
  "posts": [...],
  "pagination": {
    "next_cursor": "eyJpZCI6MTIzfQ=="
  }
}
```

---

### Caso 6: Como AI Tool para un Agente

**Escenario**: Agente de IA que busca información en una API de conocimiento.

**Configuración**:
```json
{
  "method": "GET",
  "url": "https://kb.example.com/search",
  "sendQuery": true,
  "specifyQuery": "keypair",
  "queryParameters": {
    "parameters": [
      {"name": "q", "value": "{{ $json.query }}"}
    ]
  },
  "optimizeResponse": true,
  "responseType": "json",
  "dataField": "results",
  "fieldsToInclude": "selected",
  "fields": "title,summary,url"
}
```

**Sin optimización**, el LLM recibiría:
```json
{
  "status": "success",
  "timestamp": "2024-01-15T10:30:00Z",
  "requestId": "abc-123-def",
  "results": [
    {
      "id": 1,
      "title": "How to use n8n",
      "summary": "Guide to n8n automation",
      "url": "https://kb.example.com/1",
      "author": "John Doe",
      "createdAt": "2024-01-01",
      "updatedAt": "2024-01-10",
      "tags": ["n8n", "automation"],
      "views": 1234,
      "_internal": {...}
    }
  ],
  "totalResults": 100,
  "page": 1
}
```

**Con optimización**, el LLM recibe solo:
```json
[
  {
    "title": "How to use n8n",
    "summary": "Guide to n8n automation",
    "url": "https://kb.example.com/1"
  }
]
```

**Ventajas**:
- Reducción de ~80% en tokens
- Respuesta del agente más rápida
- Menor costo
- Menos distracciones para el LLM

---

### Caso 7: SOAP API (Raw XML)

**Escenario**: Integrar con API SOAP legacy.

**Configuración**:
```json
{
  "method": "POST",
  "url": "https://legacy-api.example.com/soap",
  "sendHeaders": true,
  "specifyHeaders": "keypair",
  "headerParameters": {
    "parameters": [
      {"name": "SOAPAction", "value": "GetUserInfo"}
    ]
  },
  "sendBody": true,
  "contentType": "raw",
  "rawContentType": "text/xml; charset=utf-8",
  "body": "<?xml version=\"1.0\"?>\n<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n  <soap:Body>\n    <GetUserInfo>\n      <UserId>{{ $json.userId }}</UserId>\n    </GetUserInfo>\n  </soap:Body>\n</soap:Envelope>"
}
```

---

### Caso 8: Batching para Rate Limiting

**Escenario**: Procesar 1000 items pero la API tiene límite de 100 requests/minuto.

**Configuración**:
```json
{
  "method": "POST",
  "url": "https://api.example.com/process",
  "sendBody": true,
  "contentType": "json",
  "specifyBody": "json",
  "jsonBody": "{{ $json }}",
  "options": {
    "batching": {
      "batch": {
        "batchSize": 10,
        "batchInterval": 6000
      }
    }
  }
}
```

**Comportamiento**:
- 1000 items divididos en batches de 10
- 100 batches totales
- 6 segundos (6000ms) entre batches
- Tiempo total: 100 batches × 6s = 10 minutos
- Rate: 10 requests/minuto (dentro del límite de 100/min)

---

### Caso 9: Full Response con Manejo de Errores

**Escenario**: Necesitas inspeccionar headers de respuesta (ej: rate limit remaining).

**Configuración**:
```json
{
  "method": "GET",
  "url": "https://api.example.com/data",
  "options": {
    "response": {
      "response": {
        "fullResponse": true,
        "neverError": true
      }
    }
  }
}
```

**Output**:
```json
{
  "statusCode": 200,
  "statusMessage": "OK",
  "headers": {
    "content-type": "application/json",
    "x-ratelimit-remaining": "4950",
    "x-ratelimit-reset": "1705320000"
  },
  "body": {
    "data": [...]
  }
}
```

**Siguiente nodo (Switch)**:
```javascript
// Ruta 1: Success
{{ $json.statusCode === 200 }}

// Ruta 2: Rate Limited
{{ $json.statusCode === 429 }}

// Ruta 3: Server Error
{{ $json.statusCode >= 500 }}
```

---

### Caso 10: Optimización HTML para AI Agent

**Escenario**: Agente que extrae información de páginas web.

**Configuración**:
```json
{
  "method": "GET",
  "url": "{{ $json.article_url }}",
  "optimizeResponse": true,
  "responseType": "html",
  "cssSelector": "article.main-content",
  "onlyContent": true,
  "elementsToOmit": ".ads,.comments,nav,footer,script,style",
  "truncateResponse": true,
  "maxLength": 2000
}
```

**HTML original** (5000 caracteres):
```html
<!DOCTYPE html>
<html>
<head>...</head>
<body>
  <nav>...</nav>
  <article class="main-content">
    <h1>How to Use n8n</h1>
    <div class="ads">Ad content</div>
    <p>n8n is a powerful automation platform...</p>
    <p>You can create workflows...</p>
    <div class="comments">100 comments</div>
  </article>
  <footer>...</footer>
  <script>...</script>
</body>
</html>
```

**LLM recibe** (< 2000 caracteres):
```
How to Use n8n
n8n is a powerful automation platform...
You can create workflows...
```

---

## 🎯 Configuración Recomendada por Escenario

### Para APIs REST Simples
```json
{
  "method": "GET",
  "url": "https://api.example.com/endpoint",
  "authentication": "predefinedCredentialType",
  "options": {
    "timeout": 10000
  }
}
```

**Razón**: Configuración mínima, timeout estándar.

---

### Para APIs con Rate Limiting Estricto
```json
{
  "options": {
    "batching": {
      "batch": {
        "batchSize": 10,
        "batchInterval": 1000
      }
    },
    "timeout": 30000
  }
}
```

**Razón**: Batching para respetar límites, timeout mayor por delays.

---

### Para APIs Paginadas con Muchos Datos
```json
{
  "options": {
    "pagination": {
      "pagination": {
        "paginationMode": "updateAParameterInEachRequest",
        "limitPagesFetched": true,
        "maxRequests": 100,
        "requestInterval": 500
      }
    },
    "timeout": 30000
  }
}
```

**Razón**: Paginación automática con límite de seguridad, delay para no saturar.

---

### Para AI Agents (Tool Optimizado)
```json
{
  "optimizeResponse": true,
  "responseType": "json",
  "fieldsToInclude": "selected",
  "fields": "id,name,description",
  "options": {
    "timeout": 15000,
    "response": {
      "response": {
        "neverError": true
      }
    }
  }
}
```

**Razón**: Minimiza tokens al LLM, maneja errores gracefully.

---

### Para Upload de Archivos Grandes
```json
{
  "method": "POST",
  "sendBody": true,
  "contentType": "binaryData",
  "inputDataFieldName": "file",
  "options": {
    "timeout": 120000,
    "redirect": {
      "redirect": {
        "followRedirects": true,
        "maxRedirects": 5
      }
    }
  }
}
```

**Razón**: Timeout largo para uploads, seguir redirects de CDNs.

---

### Para APIs Internas/Debugging
```json
{
  "options": {
    "allowUnauthorizedCerts": true,
    "response": {
      "response": {
        "fullResponse": true,
        "neverError": true
      }
    },
    "timeout": 60000
  }
}
```

**Razón**: Ignora errores SSL en dev, retorna todo para inspección.

---

## ⚠️ Consideraciones Importantes

### Seguridad

1. **NUNCA commits credentials directamente**: Usa el sistema de credentials de n8n.

2. **allowUnauthorizedCerts**: Solo en desarrollo. En producción es un riesgo de seguridad.

3. **Secrets en URLs**: NO pongas API keys en URLs directamente:
   ```javascript
   // ❌ MAL
   url: https://api.example.com/data?api_key=secret123

   // ✅ BIEN
   authentication: "genericCredentialType"
   genericAuthType: "httpHeaderAuth"
   ```

4. **Validación de inputs**: Si la URL viene de datos externos, valídala:
   ```javascript
   // Expresión para validar URL
   {{ $json.url.startsWith('https://trusted-api.com/') ? $json.url : '' }}
   ```

---

### Performance

1. **Batching vs Paginación**:
   - **Batching**: Divide N items de entrada en lotes
   - **Paginación**: Hace múltiples requests a una API hasta obtener todos los datos

2. **Timeout apropiado**:
   - APIs rápidas: 5-10s
   - APIs lentas: 30-60s
   - Uploads/Downloads: 120-300s

3. **Rate Limiting**:
   - Usa `batching` o `requestInterval` en paginación
   - Monitorea headers como `X-RateLimit-Remaining`

---

### Debugging

1. **Browser Developer Console**:
   - Como indica el notice, puedes ver raw requests en la consola del navegador
   - Abre DevTools → Network tab → Ejecuta workflow

2. **Full Response**:
   ```json
   "options": {
     "response": {
       "response": {
         "fullResponse": true
       }
     }
   }
   ```
   Te permite ver status codes, headers completos.

3. **Never Error**:
   ```json
   "neverError": true
   ```
   Evita que el workflow se detenga, permite inspeccionar respuestas de error.

---

### Limitaciones

1. **Tamaño de Response**:
   - n8n tiene límite de ~50MB por item
   - Para archivos muy grandes, considera streaming o descargas parciales

2. **Timeout Global**:
   - n8n tiene un timeout global de workflow (configurable)
   - El timeout del nodo es adicional, no puede exceder el global

3. **Expresiones en ciertos campos**:
   - Algunos campos tienen `noDataExpression: true`
   - No puedes usar expresiones dinámicas en esos campos

---

### Best Practices

1. **Reutiliza Credentials**: Configura una vez, usa en múltiples nodos.

2. **Nomenclatura Clara**: Nombra los nodos descriptivamente:
   ```
   ❌ HTTP Request
   ❌ HTTP Request 1
   ✅ Get User from CRM
   ✅ Create Invoice in Billing API
   ```

3. **Manejo de Errores**:
   - Usa `neverError: true` + nodo Switch para manejo custom
   - O configura "Error Trigger" en el workflow

4. **Documentación**:
   - Usa el campo "Notes" del nodo para documentar:
     - API endpoint documentation URL
     - Qué hace esta request
     - Campos esperados en input

5. **Testing**:
   - Prueba con un solo item primero
   - Luego escala con batching/paginación

---

## 📚 Referencias

### Documentación Oficial
- **n8n HTTP Request Node**: https://docs.n8n.io/integrations/builtin/core-nodes/n8n-nodes-base.httprequest/
- **n8n Pagination**: https://docs.n8n.io/integrations/builtin/core-nodes/n8n-nodes-base.httprequest/#pagination/
- **n8n Expressions**: https://docs.n8n.io/code/expressions/

### Código Fuente
- **GitHub Repository**: https://github.com/n8n-io/n8n
- **Node Source**: `packages/nodes-base/nodes/HttpRequest/V4/`

### Template Relacionado
- **Joke Agent with HTTP Tool**: Template ID `joke_agent_with_http_tool`
  - Ejemplo de uso como AI Tool
  - Accesible desde el callout en el nodo

---

## 🔄 Historial de Versiones

El nodo HTTP Request es versionado. La versión actual es **4.3**.

### Cambios importantes entre versiones:

**v3 → v4**:
- Default de `followRedirects` cambió de `false` a `true`
- Mejoras en paginación
- Soporte para AI Tool optimization

**Nota**: Al importar workflows antiguos, se preserva la versión del nodo para compatibilidad.

---

## 💡 Tips y Trucos

### Tip 1: Importar desde cURL
Si tienes un comando cURL que funciona, pégalo en `curlImport` y n8n configura todo automáticamente.

### Tip 2: Expresiones en Paginación
```javascript
// Offset basado en página
{{ ($pageCount - 1) * $json.pageSize }}

// Cursor desde respuesta anterior
{{ $response.body.pagination?.next }}

// Detener si llegamos a la última página
{{ $pageCount >= $response.body.totalPages }}
```

### Tip 3: Headers Dinámicos
```json
{
  "sendHeaders": true,
  "specifyHeaders": "json",
  "jsonHeaders": "{\n  \"Authorization\": \"Bearer {{ $env.API_TOKEN }}\",\n  \"X-Request-ID\": \"{{ $runId }}\",\n  \"X-User-ID\": \"{{ $json.userId }}\"\n}"
}
```

### Tip 4: Retry con Loop
Si la API falla temporalmente, combina con nodo "Loop Over Items":
1. HTTP Request con `neverError: true`
2. Switch: Si statusCode >= 500 → Loop (máximo 3 veces)
3. Si statusCode 2xx → Continuar

### Tip 5: Variables de Entorno
```javascript
// URL base desde env
{{ $env.API_BASE_URL }}/users

// API key desde env
{{ $env.API_KEY }}

// Toggle features por ambiente
{{ $env.NODE_ENV === 'production' ? 'https://api.prod.com' : 'https://api.dev.com' }}
```

---

## 🎓 Conclusión

El nodo **HTTP Request** es el nodo más versátil de n8n para integraciones con APIs externas. Su flexibilidad permite:

✅ Integrarse con **cualquier API REST**
✅ **Múltiples métodos de autenticación**
✅ **Paginación automática** para APIs con datos grandes
✅ **Optimización para AI Agents** reduciendo tokens
✅ **Batching** para respetar rate limits
✅ **Soporte multimodal**: JSON, XML, Form Data, Binary

**Dominar este nodo es clave** para construir automatizaciones robustas en n8n que se conectan con el vasto ecosistema de APIs modernas.

---

**Documentación generada por**: MCP n8n-creator
**Fecha**: 2026-01-16
**Versión del nodo**: 4.3
**Total de propiedades documentadas**: 33 propiedades principales + múltiples sub-opciones
