# Google Gemini Chat Model - Documentación Completa

## 📋 Información General
- **Tipo**: `nodes-langchain.lmChatGoogleGemini`
- **Versión**: 1
- **Categoría**: Transform
- **Package**: `@n8n/n8n-nodes-langchain`
- **Descripción**: Chat Model Google Gemini - Nodo para usar modelos de chat Gemini de Google con agentes conversacionales

## 🎯 Propósito del Nodo

Este nodo proporciona acceso a los modelos de lenguaje de chat de Google Gemini (incluyendo Gemini 2.5 Flash) dentro de workflows de n8n que utilizan la arquitectura LangChain. Es un **nodo de modelo de lenguaje** que debe conectarse a una cadena de IA (AI Chain) o agente de IA (AI Agent).

## 🔌 Tipo de Conexión

- **Debe conectarse a**: AI Chain, AI Agent, o componentes LangChain
- **Output**: Model (se conecta a nodos downstream que consumen el modelo)
- **Uso típico**: Motor de LLM para AI Agents conversacionales

## 🔑 Credenciales Requeridas

- **Credential**: `googlePalmApi` (Google AI API Key)
- **Requerida**: Sí
- **Documentación**: [Credenciales Google AI](https://docs.n8n.io/integrations/builtin/credentials/googleai/)

## 📝 Parámetros Principales

### 1. Model (`modelName`)
- **Tipo**: `options` (desplegable dinámico)
- **Default**: `models/gemini-2.5-flash`
- **Descripción**: El modelo que generará la respuesta
- **Valores posibles**: Se cargan dinámicamente desde la API de Google Gemini
  - `models/gemini-2.5-flash` (recomendado para velocidad y eficiencia)
  - `models/gemini-2.5-pro` (para tareas más complejas)
  - Otros modelos disponibles según tu cuenta de Google AI
- **Documentación**: [Lista de modelos Gemini](https://developers.generativeai.google/api/rest/generativelanguage/models/list)

**💡 Nota**: n8n carga automáticamente solo los modelos disponibles para tu cuenta, excluyendo modelos de embeddings.

## ⚙️ Opciones Disponibles (Campo `options`)

### 1. Maximum Number of Tokens (`maxOutputTokens`)
- **Tipo**: `number`
- **Default**: `2048`
- **Descripción**: El número máximo de tokens que se generarán en la respuesta
- **Rango recomendado**: 256 - 8192 (dependiendo del modelo)
- **Propósito**: Controla la longitud máxima de la respuesta generada

**Cuándo ajustar**:
- **Valores bajos (256-512)**: Respuestas cortas y concisas (confirmaciones, clasificaciones)
- **Valores medios (1024-2048)**: Respuestas estándar (conversación, análisis moderado)
- **Valores altos (4096-8192)**: Respuestas detalladas (documentación extensa, análisis profundo)

### 2. Sampling Temperature (`temperature`)
- **Tipo**: `number`
- **Default**: `0.4`
- **Rango**: 0.0 - 1.0
- **Precisión**: 1 decimal
- **Descripción**: Controla la aleatoriedad en la generación de respuestas

**Comportamiento**:
- **0.0 - 0.2**: Determinístico, repetible, preciso (ideal para tareas que requieren consistencia)
- **0.3 - 0.5**: Balance entre creatividad y consistencia (recomendado para agentes)
- **0.6 - 1.0**: Más creativo, diverso, pero mayor riesgo de alucinaciones

**Cuándo usar**:
- **Temperature baja (0.1-0.2)**: Extracción de datos, clasificación, análisis estructurado
- **Temperature media (0.4-0.5)**: Conversación natural, asistentes virtuales
- **Temperature alta (0.7-1.0)**: Generación creativa, brainstorming

### 3. Top K (`topK`)
- **Tipo**: `number`
- **Default**: `32`
- **Rango**: -1 - 40
- **Descripción**: Número de opciones de tokens que el modelo considera para generar el siguiente token

**Comportamiento**:
- **-1**: Deshabilitado (sin límite de opciones)
- **1-10**: Muy restrictivo (respuestas más predecibles)
- **20-40**: Moderadamente restrictivo (balance entre diversidad y calidad)

**Propósito**: Elimina opciones de baja probabilidad ("long tail") para mejorar calidad de respuestas.

### 4. Top P (`topP`)
- **Tipo**: `number`
- **Default**: `1.0`
- **Rango**: 0.0 - 1.0
- **Precisión**: 1 decimal
- **Descripción**: Controla diversidad mediante nucleus sampling (muestreo de núcleo)

**Comportamiento**:
- **0.5**: Solo se consideran las opciones que suman el 50% de probabilidad
- **0.9**: Se consideran opciones que suman el 90% de probabilidad
- **1.0**: Se consideran todas las opciones

**⚠️ Importante**: Google recomienda ajustar **o bien temperature o bien topP**, no ambos simultáneamente, ya que interactúan entre sí.

### 5. Safety Settings (`safetySettings`)
- **Tipo**: `fixedCollection` (colección de múltiples valores)
- **Múltiples valores**: Sí (puedes definir múltiples categorías de seguridad)
- **Default**:
  ```json
  {
    "category": "HARM_CATEGORY_HARASSMENT",
    "threshold": "HARM_BLOCK_THRESHOLD_UNSPECIFIED"
  }
  ```

#### Categorías de Seguridad (`category`)

| Valor | Descripción |
|-------|-------------|
| `HARM_CATEGORY_HARASSMENT` | Contenido de acoso |
| `HARM_CATEGORY_HATE_SPEECH` | Discurso de odio y contenido ofensivo |
| `HARM_CATEGORY_SEXUALLY_EXPLICIT` | Contenido sexualmente explícito |
| `HARM_CATEGORY_DANGEROUS_CONTENT` | Contenido peligroso (violencia, autolesiones, etc.) |

#### Umbrales de Bloqueo (`threshold`)

| Valor | Descripción |
|-------|-------------|
| `HARM_BLOCK_THRESHOLD_UNSPECIFIED` | Sin especificar (usa configuración por defecto de Google) |
| `BLOCK_LOW_AND_ABOVE` | Bloquea TODO excepto contenido NEGLIGIBLE |
| `BLOCK_MEDIUM_AND_ABOVE` | Permite contenido NEGLIGIBLE y LOW |
| `BLOCK_ONLY_HIGH` | Permite contenido NEGLIGIBLE, LOW y MEDIUM |
| `BLOCK_NONE` | Permite TODO el contenido (sin filtros) |

**Documentación oficial**: [Gemini API Safety Settings](https://ai.google.dev/docs/safety_setting_gemini)

## 🎯 Configuración Recomendada

### Para AI Agent de Segundo Cerebro (Caso Actual)

```json
{
  "modelName": "models/gemini-2.5-flash",
  "options": {
    "temperature": 0.1,
    "maxOutputTokens": 2048,
    "topK": 32,
    "topP": 1.0,
    "safetySettings": {
      "values": [
        {
          "category": "HARM_CATEGORY_HARASSMENT",
          "threshold": "BLOCK_NONE"
        },
        {
          "category": "HARM_CATEGORY_HATE_SPEECH",
          "threshold": "BLOCK_NONE"
        },
        {
          "category": "HARM_CATEGORY_SEXUALLY_EXPLICIT",
          "threshold": "BLOCK_NONE"
        },
        {
          "category": "HARM_CATEGORY_DANGEROUS_CONTENT",
          "threshold": "BLOCK_NONE"
        }
      ]
    }
  }
}
```

**Razón de esta configuración**:

1. **`temperature: 0.1`** (muy baja):
   - El agente debe ser **determinístico y consistente** al clasificar notas
   - Necesitamos que siempre estructure datos de la misma forma (JSON Schema Enforcement)
   - Evita creatividad no deseada en tareas de extracción de datos
   - **Ejemplo**: "Comprar leche" siempre debe identificarse como Tarea, no como Nota o Recurso

2. **`maxOutputTokens: 2048`**:
   - Suficiente para respuestas estructuradas JSON
   - Balance entre capacidad de respuesta y costos
   - Permite respuestas completas sin cortar metadatos importantes

3. **`topK: 32`** (default):
   - Balance adecuado para respuestas estructuradas
   - No es necesario ajustar para este caso de uso

4. **`topP: 1.0`** (sin restricción):
   - Dejamos que temperature controle la aleatoriedad
   - Seguimos la recomendación de Google de no ajustar ambos parámetros

5. **`safetySettings: BLOCK_NONE`** (todos los filtros desactivados):
   - El sistema procesa **notas personales del usuario**
   - No queremos que el filtro de seguridad bloquee contenido legítimo
   - **Ejemplo**: Si el usuario escribe "Recordar revisar documentación sobre cómo manejar contenido peligroso en la app", no queremos que se bloquee por `HARM_CATEGORY_DANGEROUS_CONTENT`
   - Es un contexto privado y personal, no contenido público

### Para Asistente Conversacional Creativo

```json
{
  "modelName": "models/gemini-2.5-flash",
  "options": {
    "temperature": 0.7,
    "maxOutputTokens": 4096,
    "topK": 40,
    "topP": 0.95,
    "safetySettings": {
      "values": [
        {
          "category": "HARM_CATEGORY_HARASSMENT",
          "threshold": "BLOCK_MEDIUM_AND_ABOVE"
        },
        {
          "category": "HARM_CATEGORY_HATE_SPEECH",
          "threshold": "BLOCK_MEDIUM_AND_ABOVE"
        }
      ]
    }
  }
}
```

**Razón**: Mayor creatividad para conversación natural, respuestas más largas, filtros moderados de seguridad.

### Para Análisis de Documentos con Máxima Precisión

```json
{
  "modelName": "models/gemini-2.5-pro",
  "options": {
    "temperature": 0.0,
    "maxOutputTokens": 8192,
    "topK": 10,
    "topP": 1.0
  }
}
```

**Razón**: Temperature 0.0 para máxima determinismo, modelo Pro para razonamiento complejo, tokens altos para análisis exhaustivos.

## 💡 Casos de Uso Comunes

### Caso 1: Clasificación y Extracción de Datos (PKM/Segundo Cerebro)

**Configuración**:
- Model: `gemini-2.5-flash`
- Temperature: `0.1` (muy baja)
- Max Tokens: `2048`
- Safety: `BLOCK_NONE`

**Uso**:
- Conectar a AI Agent con System Prompt que define JSON Schema
- El agente analiza mensajes del usuario y extrae metadatos estructurados
- Respuestas consistentes y predecibles

**Ejemplo de Prompt**:
```
Analiza el mensaje del usuario y clasifícalo según estas categorías:
- Nota: Idea, reflexión, apunte
- Tarea: Acción con verbo ejecutable
- Recurso: Referencia externa (link, libro, video)

Devuelve JSON con:
{
  "tipo": "Nota|Tarea|Recurso",
  "titulo": "...",
  "descripcion": "...",
  "prioridad": 1-5,
  "metadatos": {...}
}
```

### Caso 2: Asistente Virtual Conversacional

**Configuración**:
- Model: `gemini-2.5-flash`
- Temperature: `0.5` (media)
- Max Tokens: `4096`
- Safety: `BLOCK_MEDIUM_AND_ABOVE`

**Uso**:
- Chatbot que responde preguntas de usuarios
- Conversación natural con personalidad
- Respuestas variadas pero controladas

### Caso 3: Generación de Contenido Creativo

**Configuración**:
- Model: `gemini-2.5-pro`
- Temperature: `0.8` (alta)
- Max Tokens: `8192`
- Top K: `40`

**Uso**:
- Generación de copy publicitario
- Escritura creativa (historias, artículos)
- Brainstorming de ideas

## 🔄 Integración con AI Agent

Este nodo **debe conectarse obligatoriamente** a un nodo de tipo:
- **AI Agent** (recomendado para workflows interactivos)
- **AI Chain** (para flujos de procesamiento secuencial)
- Otros nodos LangChain que consumen modelos de chat

**Flujo típico en n8n**:
```
Telegram Trigger → AI Agent → Google Gemini Chat Model → [Tools/Memoria/Output]
                      ↓
                 System Prompt
                      ↓
                 User Message
```

**⚠️ Error común**: Si intentas usar este nodo sin conectarlo a una cadena de IA, verás el mensaje:
> "This node must be connected to an AI chain"

## 🆚 Google Gemini Chat Model vs Google Gemini (nodo estándar)

| Aspecto | Google Gemini Chat Model | Google Gemini |
|---------|-------------------------|---------------|
| **Arquitectura** | LangChain (chat conversacional) | Nodo estándar de n8n |
| **Uso** | AI Agents, AI Chains | Workflows normales de n8n |
| **Contexto** | Mantiene conversación multi-turno | Una llamada, una respuesta |
| **Integración** | Se conecta a componentes LangChain | Se conecta a nodos n8n normales |
| **Recomendado para** | Chatbots, agentes conversacionales | Procesamiento de texto puntual |

## ⚠️ Consideraciones Importantes

### 1. Latencia y Velocidad
- **Gemini 2.5 Flash**: Optimizado para latencia < 1 segundo
- **Gemini 2.5 Pro**: Mayor latencia pero mejor razonamiento complejo
- **Recomendación**: Usa Flash para workflows en tiempo real (Telegram, chat), usa Pro para análisis offline

### 2. Costos
- Los tokens se cobran según el modelo usado
- `maxOutputTokens` limita costos al restringir longitud de respuesta
- Gemini Flash es más económico que Gemini Pro
- **Tip**: Monitorea uso de tokens en workflows intensivos

### 3. JSON Schema Enforcement
- Gemini 2.5 Flash tiene soporte **nativo** para `response_schema` (JSON Schema)
- No necesitas validación post-generación - el modelo garantiza salida estructurada
- **Ventaja competitiva**: Más rápido y confiable que Claude/GPT con JSON parsing manual

### 4. Capacidades Multimodales
- Gemini soporta **texto, audio e imágenes** nativamente
- Puedes enviar screenshots, fotos, grabaciones de voz
- Útil para workflows con Telegram que reciben media

### 5. Safety Settings en Contextos Privados
- Si el agente procesa notas personales, considera usar `BLOCK_NONE`
- Los filtros de seguridad pueden bloquear contenido legítimo del usuario
- **Ejemplo**: Notas sobre temas sensibles pero válidos (salud, finanzas, seguridad informática)

### 6. Temperature vs Top P
- Google recomienda ajustar **solo uno** de estos parámetros
- Generalmente, ajusta `temperature` y deja `topP` en 1.0
- Si necesitas control más fino, usa `topP` con temperature fija en 1.0

### 7. Modelos Disponibles Dinámicamente
- n8n carga modelos desde tu cuenta de Google AI en tiempo real
- Solo verás modelos disponibles para tu API key
- Los modelos de embeddings se filtran automáticamente

## 📚 Referencias

- **Documentación oficial n8n**: [Google Gemini Chat Model](https://docs.n8n.io/integrations/builtin/cluster-nodes/root-nodes/n8n-nodes-langchain.lmchatgooglegemini/)
- **LangChain Documentation**: [Google Gemini Integration](https://js.langchain.com/docs/integrations/chat/google_generativeai)
- **Google AI Documentation**: [Gemini API](https://ai.google.dev/docs)
- **Gemini Safety Settings**: [Safety Configuration](https://ai.google.dev/docs/safety_setting_gemini)
- **Lista de modelos**: [Generative Language API Models](https://developers.generativeai.google/api/rest/generativelanguage/models/list)

## 🎓 Contexto del Proyecto "Segundo Cerebro"

En el workflow "segundo_cerebro" (ID: `ZI6VUFdg6hEhnCbh`), este nodo se usa como:

- **Rol**: Motor cognitivo del AI Agent
- **Modelo**: `gemini-2.5-flash` (velocidad y eficiencia)
- **Temperature**: `0.1` (clasificación determinística)
- **Propósito**: Analizar mensajes de usuario desde Telegram, clasificarlos semánticamente, y estructurar datos para inserción en MySQL
- **Ventajas clave**:
  - Latencia < 1 segundo (experiencia instantánea en Telegram)
  - JSON Schema Enforcement nativo (sin validación manual)
  - Multimodal (soporta texto, audio, imágenes desde Telegram)
  - Razonamiento complejo sin costos excesivos

**Flujo completo**:
1. Usuario envía mensaje a Telegram
2. Webhook activa workflow en n8n
3. AI Agent usa Google Gemini Chat Model para analizar
4. Gemini clasifica y estructura datos (JSON)
5. n8n inserta en MySQL con metadatos
6. Usuario recibe confirmación en Telegram

---

**Última actualización**: 2026-01-16
**Agente**: n8n-node-documenter
**Versión del nodo**: 1
