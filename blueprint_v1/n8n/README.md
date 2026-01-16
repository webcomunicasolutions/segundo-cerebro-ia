# 🔌 Workflows de n8n

Este directorio contiene los workflows exportados de n8n en formato JSON.

## 📂 Estructura

```
n8n/
├── workflows/              # Workflows exportados desde n8n
│   ├── 01-telegram-inbox.json
│   ├── 02-gemini-classifier.json
│   └── 03-mysql-router.json
│
├── credentials/            # Plantillas de credenciales (SIN datos reales)
│   └── credentials.example.json
│
└── README.md              # Este archivo
```

## 🚀 Cómo Importar Workflows

### Opción 1: Interfaz Web de n8n

1. Accede a tu instancia de n8n
2. Ve a **Workflows** > **Import from File**
3. Selecciona el archivo JSON del workflow
4. Configura las credenciales necesarias
5. Activa el workflow

### Opción 2: CLI de n8n (si usas n8n localmente)

```bash
# Importar workflow
n8n import:workflow --input=./workflows/01-telegram-inbox.json

# Listar workflows
n8n list:workflow
```

## 🔑 Configuración de Credenciales

### Credenciales Requeridas

1. **Telegram Bot**
   - Token del bot (obtener de [@BotFather](https://t.me/BotFather))
   - URL del webhook

2. **Gemini API**
   - API Key de Google AI Studio
   - Model: `gemini-2.5-flash`

3. **MySQL Database**
   - Host
   - Port (default: 3306)
   - Database name: `segundo_cerebro`
   - User
   - Password

### Plantilla de Credenciales

Ver `credentials/credentials.example.json` para un ejemplo de estructura.

**⚠️ IMPORTANTE**: NUNCA subas credenciales reales al repositorio. Usa variables de entorno o el sistema de credenciales de n8n.

## 📋 Workflows Principales (Próximamente)

### 1. `01-telegram-inbox.json`
**Propósito**: Captura de mensajes desde Telegram

- Webhook de Telegram
- Acknowledge inmediato al usuario
- Inserción en tabla `inbox_log`

### 2. `02-gemini-classifier.json`
**Propósito**: Clasificación inteligente con Gemini 2.5 Flash

- Lectura de `inbox_log` pendientes
- Prompt maestro de clasificación
- JSON Schema Enforcement
- Confidence scoring

### 3. `03-mysql-router.json`
**Propósito**: Routing a las 4 categorías principales

- Switch node basado en categoría
- Inserción en tablas (`personas`, `proyectos`, `ideas`, `tareas`)
- Actualización de estado en `inbox_log`
- Feedback a Telegram

## 🧪 Testing

### Probar Workflow Localmente

1. **Modo Manual**: Ejecuta el workflow manualmente en n8n
2. **Modo Webhook**: Usa herramientas como `curl` o Postman:

```bash
curl -X POST https://tu-n8n-instance.com/webhook/telegram-inbox \
  -H "Content-Type: application/json" \
  -d '{"message": {"text": "Comprar leche", "from": {"id": 123456}}}'
```

### Validar JSON Schema

```bash
# Si tienes Node.js instalado
npm install -g ajv-cli

ajv validate -s ../prompts/json-schemas/gemini-response.json \
              -d test-output.json
```

## 📝 Notas de Desarrollo

- Usa el nodo **Error Trigger** para manejar fallos gracefully
- Implementa reintentos con **Wait** + **Loop**
- Loguea todo en `inbox_log` para auditoría
- Usa **Switch** node para routing condicional
- Sanitiza inputs para prevenir SQL injection (n8n lo hace automáticamente con parametrización)

## 🔗 Enlaces Útiles

- [Documentación oficial de n8n](https://docs.n8n.io/)
- [n8n Community Forum](https://community.n8n.io/)
- [Telegram Bot API](https://core.telegram.org/bots/api)
- [Gemini API Reference](https://ai.google.dev/docs)

---

**Última actualización**: 13 de enero de 2026
