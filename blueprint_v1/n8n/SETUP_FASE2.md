# 🔌 FASE 2: Configuración de n8n - Primer Latido

**Objetivo**: Conseguir el flujo **Telegram → n8n → Respuesta "Hello World"**

---

## ✅ Pre-requisitos Completados

- [x] Base de datos MySQL `segundo_cerebro` operativa
- [x] Bot de Telegram creado: `@segundo_cerebro_pkm_bot`
- [x] Token del bot obtenido

---

## 📋 PASO 1: Acceder a tu Instancia n8n

### Opción A: n8n Cloud/Self-hosted (Producción)
```
URL: https://n8n-n8n.yhnmlz.easypanel.host
```

### Opción B: n8n Local (Desarrollo)
```bash
# Si usas Docker
docker run -it --rm \
  --name n8n \
  -p 5678:5678 \
  -v ~/.n8n:/home/node/.n8n \
  n8nio/n8n

# Acceder en: http://localhost:5678
```

---

## 🔑 PASO 2: Configurar Credencial de Telegram en n8n

1. **Navegar a Credentials**
   - En el menú lateral de n8n, haz clic en **"Credentials"**
   - Botón **"Add Credential"** (esquina superior derecha)

2. **Buscar "Telegram"**
   - En el buscador, escribe: `Telegram`
   - Selecciona: **"Telegram"** (no "Telegram Trigger")

3. **Configurar la Credencial**
   - **Credential Name**: `Telegram Bot - Segundo Cerebro`
   - **Access Token**: `8524105084:AAH56rJ9ZBu23MV_uvRvE5IwQ52AQD5qMkA`
   - Haz clic en **"Create"**

4. **Validar (Opcional)**
   - n8n puede probar la conexión automáticamente
   - Si aparece un ✅ verde, la credencial es válida

---

## 🤖 PASO 3: Crear Workflow "Hello World"

### 3.1 Crear Nuevo Workflow

1. En n8n, haz clic en **"Workflows"** > **"Add Workflow"**
2. Nombra el workflow: `01 - Telegram Inbox (Hello World)`

### 3.2 Agregar Nodo "Telegram Trigger"

1. Haz clic en **"+"** para agregar un nodo
2. Busca: `Telegram Trigger`
3. Selecciona: **"Telegram Trigger"**
4. Configura:
   - **Credential**: Selecciona `Telegram Bot - Segundo Cerebro`
   - **Updates**: Marca `message` (para recibir mensajes de texto)
   - **Additional Fields**: Deja vacío por ahora

5. **Activar Webhook**:
   - Haz clic en **"Listen for Test Event"** (esto registra el webhook con Telegram)
   - Envía un mensaje de prueba desde Telegram a tu bot: `Hola`
   - Si todo está bien, verás el mensaje aparecer en n8n

### 3.3 Agregar Nodo "Respond to Telegram"

1. Conecta el nodo anterior haciendo clic en el punto de conexión (+)
2. Busca y selecciona: **"Telegram"** (no Trigger, el nodo de acción)
3. Configura:
   - **Credential**: Selecciona `Telegram Bot - Segundo Cerebro`
   - **Resource**: `Message`
   - **Operation**: `Send Text Message`
   - **Chat ID**: `{{ $json.message.chat.id }}`
   - **Text**:
     ```
     🧠 Hello World desde tu Segundo Cerebro!

     He recibido tu mensaje: "{{ $json.message.text }}"
     ```

### 3.4 Guardar y Activar

1. **Guardar**: Haz clic en **"Save"** (esquina superior derecha)
2. **Activar**: Cambia el toggle de "Inactive" a **"Active"**

---

## 🧪 PASO 4: Probar el Flujo

### Prueba 1: Mensaje Simple
1. Abre Telegram
2. Busca tu bot: `@segundo_cerebro_pkm_bot`
3. Envía: `Hola mundo`
4. **Resultado esperado**: El bot responde con "🧠 Hello World desde tu Segundo Cerebro!"

### Prueba 2: Diferentes Mensajes
Envía:
- `Comprar leche`
- `Reunión con Juan mañana`
- `Idea: Crear app de productividad`

El bot debe responder a todos repitiéndote el mensaje recibido.

---

## 🎯 Resultado de la Fase 2

Si todo funciona, ¡acabas de lograr el **PRIMER LATIDO** del sistema! 🫀

### ✅ Validación Exitosa:
- [x] Telegram envía mensajes a n8n vía webhook
- [x] n8n procesa el mensaje
- [x] n8n responde al usuario en Telegram

### 🚀 Próximos Pasos (Fase 3):
- Conectar con Gemini para clasificación inteligente
- Agregar lógica de inserción en `inbox_log`
- Implementar routing a las 4 categorías principales

---

## 🆘 Troubleshooting

### Problema 1: "Telegram Trigger no recibe mensajes"
**Solución**:
- Verifica que el token sea correcto
- Asegúrate de haber hecho clic en "Listen for Test Event"
- El workflow debe estar **Active** (toggle verde)

### Problema 2: "Error de credenciales"
**Solución**:
- Re-crea la credencial desde cero
- Verifica que no haya espacios antes/después del token
- Prueba el token en Telegram enviando una request manual:
  ```bash
  curl https://api.telegram.org/bot8524105084:AAH56rJ9ZBu23MV_uvRvE5IwQ52AQD5qMkA/getMe
  ```

### Problema 3: "n8n dice que el webhook ya está en uso"
**Solución**:
- Solo puede haber un webhook activo por bot
- Desactiva otros workflows que usen el mismo Telegram Trigger
- O usa un bot diferente para testing

---

## 📝 Notas Importantes

⚠️ **Seguridad del Token**:
- El token `8524105084:AAH56rJ9ZBu23MV_uvRvE5IwQ52AQD5qMkA` da control total del bot
- No lo compartas públicamente en repos o foros
- n8n lo almacena cifrado internamente

🔧 **Variables de Entorno** (Opcional para producción):
```bash
export TELEGRAM_BOT_TOKEN="8524105084:AAH56rJ9ZBu23MV_uvRvE5IwQ52AQD5qMkA"
```

---

**Creado**: 13 de enero de 2026
**Estado**: Fase 2 - En progreso
