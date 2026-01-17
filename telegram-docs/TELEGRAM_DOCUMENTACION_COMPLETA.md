# Telegram Node - Documentación Completa

**Fuentes**:
- ✅ Código fuente GitHub (v1.2)
- ✅ Análisis de `Telegram.node.ts`

## 📋 Información General
- **Nombre**: Telegram
- **Versión**: 1, 1.1, 1.2
- **Categoría**: Output / Communication
- **Descripción**: Envía datos y mensajes a Telegram.
- **Icono**: `file:telegram.svg`

## 🔧 Recursos Disponibles (`resource`)

El nodo divide sus funciones en 4 recursos principales:

1.  **Message** (`message`) [Default]: Para enviar todo tipo de contenido (texto, fotos, audio, ubicación) y gestionar mensajes existentes.
2.  **Chat** (`chat`): Para gestionar grupos y canales (obtener miembros, administradores, salir del grupo).
3.  **Callback** (`callback`): Para responder a consultas de callback (interacciones con botones).
4.  **File** (`file`): Para descargar archivos de Telegram.

## ⚙️ Operaciones por Recurso

### 1. Recurso: Message (`message`)
Es el más utilizado. Permite enviar contenido.

| Operación | Valor (`operation`) | Descripción |
|-----------|-------------------|-------------|
| **Send Message** | `sendMessage` | Envía un mensaje de texto simple. Opciones de parseo (Markdown/HTML). |
| **Send Photo** | `sendPhoto` | Envía una imagen. Puede acompañarse de un caption. |
| **Send Audio** | `sendAudio` | Envía un archivo de audio. |
| **Send Document** | `sendDocument` | Envía un archivo general. |
| **Send Animation** | `sendAnimation` | Envía un GIF o animación. |
| **Send Sticker** | `sendSticker` | Envía un sticker. |
| **Send Location** | `sendLocation` | Envía coordenadas (lat/lon). |
| **Send Media Group** | `sendMediaGroup` | Envía un álbum de fotos/videos. |
| **Send Chat Action** | `sendChatAction` | Muestra "escribiendo...", "enviando foto...", etc. |
| **Edit Message Text** | `editMessageText` | Modifica el texto de un mensaje ya enviado. |
| **Delete Chat Message** | `deleteMessage` | Elimina un mensaje. |
| **Pin Chat Message** | `pinChatMessage` | Fija un mensaje en el chat. |
| **Send and Wait** | `sendAndWait` | (Especial) Envía un mensaje y detiene el workflow hasta recibir respuesta. |

### 2. Recurso: Chat (`chat`)
Gestión administrativa de chats.

| Operación | Valor | Descripción |
|-----------|-------|-------------|
| **Get** | `get` | Obtiene info del chat. |
| **Get Administrators** | `administrators` | Lista admins. |
| **Get Member** | `member` | Obtiene info de un miembro específico. |
| **Leave** | `leave` | El bot abandona el chat. |

### 3. Recurso: Callback (`callback`)
| Operación | Valor | Descripción |
|-----------|-------|-------------|
| **Answer Query** | `answerQuery` | Responde al evento de clic en un botón inline. |

### 4. Recurso: File (`file`)
| Operación | Valor | Descripción |
|-----------|-------|-------------|
| **Get** | `get` | Descarga un archivo desde Telegram (usando `file_id`). |

## 🎯 Configuración Recomendada

### Para Mensajes de Texto con Formato
```json
{
  "resource": "message",
  "operation": "sendMessage",
  "chatId": "@mi_canal",
  "text": "**Hola** mundo",
  "additionalFields": {
    "parse_mode": "Markdown"
  }
}
```
**Nota:** Siempre usa `parse_mode` si quieres negritas o enlaces limpios.

### Para Responder a un Usuario (Reply)
```json
{
  "resource": "message",
  "operation": "sendMessage",
  "chatId": "{{$json.chat.id}}",
  "text": "Recibido",
  "additionalFields": {
    "reply_to_message_id": "{{$json.message_id}}"
  }
}
```

## ⚠️ Consideraciones Importantes

1.  **Chat ID**: Puede ser el ID numérico (ej: `123456789`) o el username del canal (ej: `@mi_canal`). Para usuarios privados, siempre es numérico.
2.  **Archivos**: Para enviar archivos locales, usa el campo `Binary Property`. Para enviar desde URL, n8n suele gestionarlo automáticamente si pasas la URL en el campo correspondiente (dependiendo de la versión del nodo).
3.  **Send and Wait**: Esta operación requiere configurar el `Webhook URL` en n8n correctamente, ya que espera una llamada de vuelta de Telegram.

## 📚 Referencias Internas
- Definición de tipos: `Telegram.node.ts`
- Funciones auxiliares: `GenericFunctions.ts`
