# Primeros Pasos - Segundo Cerebro

**Guía de instalación y configuración inicial**

**Versión**: v018 | **Última actualización**: 17 Enero 2026

---

## 📋 Antes de Empezar

### Requisitos Previos

Antes de usar el Sistema de Segundo Cerebro, necesitas:

#### 1. Cuenta de Telegram

- **Si ya tienes Telegram**: ✅ Perfecto, continúa al siguiente paso
- **Si NO tienes Telegram**:
  1. Descarga la app de [telegram.org](https://telegram.org)
  2. Regístrate con tu número de teléfono
  3. Verifica el código SMS que recibes
  4. ¡Listo! Ya tienes cuenta

#### 2. Acceso al Bot

Necesitas que el **administrador del sistema** te proporcione:

- ✅ **Nombre del bot** (ejemplo: `@segundo_cerebro_pkm_bot`)
- ✅ **Autorización** (el bot necesita permitir tu ID de Telegram)

**Importante**: Este sistema es **privado** y requiere autorización. No puedes usarlo solo instalando Telegram.

#### 3. Conexión a Internet

- ✅ Wi-Fi o datos móviles activos
- ✅ Conexión estable (el bot responde en 1-3 segundos)

---

## 🚀 Paso 1: Encontrar el Bot en Telegram

### Opción A: Búsqueda Manual

1. Abre Telegram
2. Ve a la barra de búsqueda (icono de lupa 🔍)
3. Escribe el nombre del bot completo (incluye la `@`)
   - Ejemplo: `@segundo_cerebro_pkm_bot`
4. Selecciona el bot de los resultados
5. Haz clic en **"Iniciar" (Start)**

### Opción B: Enlace Directo

Si el administrador te envió un enlace como:
```
https://t.me/segundo_cerebro_pkm_bot
```

1. Haz clic en el enlace
2. Se abrirá Telegram automáticamente
3. Haz clic en **"Iniciar" (Start)**

---

## 💬 Paso 2: Primera Interacción

### Mensaje de Prueba

Envía tu primer mensaje al bot:

```
Hola
```

**Respuesta esperada del bot**:
```
🧠 Segundo Cerebro

Hola! Estoy aquí para ayudarte a organizar tus tareas, proyectos, ideas y contactos.
¿Qué necesitas hacer hoy?
```

✅ **Si recibes esta respuesta**: ¡Funciona perfectamente! Continúa al siguiente paso.

❌ **Si NO respondes o ves un error**: Contacta al administrador. Posibles causas:
- Tu ID de Telegram no está autorizado
- El bot está desactivado temporalmente
- Problema de conexión a internet

---

## 🧪 Paso 3: Pruebas Básicas

Vamos a probar las 4 categorías principales del sistema:

### Test 1: Crear una Tarea

**Envía**:
```
Nueva tarea: Probar el sistema de segundo cerebro
```

**Respuesta esperada**:
```
🧠 Segundo Cerebro

✅ TAREA: Probar el sistema de segundo cerebro - Guardado
Prioridad: media
```

✅ **Resultado**: La tarea se guardó correctamente.

---

### Test 2: Crear un Proyecto

**Envía**:
```
Nuevo proyecto: Setup inicial del segundo cerebro para febrero 2026
```

**Respuesta esperada**:
```
🧠 Segundo Cerebro

✅ PROYECTO: Setup inicial del segundo cerebro - Guardado
Estado: activo
Fecha límite: 2026-02-28
```

✅ **Resultado**: El proyecto se guardó e interpretó "febrero 2026" correctamente.

---

### Test 3: Guardar una Idea

**Envía**:
```
Idea: El segundo cerebro me ayudará a no olvidar cosas importantes
```

**Respuesta esperada**:
```
🧠 Segundo Cerebro

✅ IDEA: Segundo cerebro para recordar - Guardado
Tipo: nota
```

✅ **Resultado**: La idea se clasificó como "nota" automáticamente.

---

### Test 4: Registrar una Persona

**Envía**:
```
Contacto: Administrador del Sistema, colega, admin@ejemplo.com
```

**Respuesta esperada**:
```
🧠 Segundo Cerebro

✅ PERSONA: Administrador del Sistema - Guardado
Relación: colega
Contacto: {"email": "admin@ejemplo.com"}
```

✅ **Resultado**: La persona se guardó con relación y email estructurado.

---

## 🔍 Paso 4: Verificar que Todo se Guardó

Ahora vamos a consultar cada categoría para verificar:

### Consultar Tareas

**Envía**:
```
qué tareas tengo
```

**Respuesta esperada**:
```
📊 1 resultado:
1. Probar el sistema de segundo cerebro (id: 1) - Prioridad: media
```

✅ **Verificado**: La tarea está en la base de datos.

---

### Consultar Proyectos

**Envía**:
```
lista de proyectos
```

**Respuesta esperada**:
```
📊 1 resultado:
1. Setup inicial del segundo cerebro (id: 1) - Estado: activo, Límite: 2026-02-28
```

✅ **Verificado**: El proyecto está guardado.

---

### Consultar Ideas

**Envía**:
```
ver mis ideas
```

**Respuesta esperada**:
```
📊 1 resultado:
1. Segundo cerebro para recordar (id: 1) - Tipo: nota
```

✅ **Verificado**: La idea está en la base de datos.

---

### Consultar Personas

**Envía**:
```
lista de personas
```

**Respuesta esperada**:
```
📊 1 resultado:
1. Administrador del Sistema (id: 1) - Relación: colega, Email: admin@ejemplo.com
```

✅ **Verificado**: El contacto está registrado.

---

## 🗑️ Paso 5: Limpiar Datos de Prueba

Antes de empezar a usar el sistema con datos reales, debes borrar las pruebas que hiciste.

### Opción 1: Borrar Manualmente (Recomendado para Principiantes)

Borra cada registro uno por uno:

#### Borrar la tarea de prueba

**Envía**:
```
Borrar la tarea de probar el sistema
```

**Respuesta esperada**:
```
🗑️ Eliminado: Probar el sistema de segundo cerebro
```

---

#### Borrar el proyecto de prueba

**Envía**:
```
Eliminar el proyecto de setup inicial
```

**Respuesta esperada**:
```
🗑️ Eliminado: Setup inicial del segundo cerebro
```

---

#### Borrar la idea de prueba

**Envía**:
```
Borrar la idea sobre segundo cerebro
```

**Respuesta esperada**:
```
🗑️ Eliminado: Segundo cerebro para recordar
```

---

#### Borrar el contacto de prueba

**Envía**:
```
Eliminar contacto Administrador del Sistema
```

**Respuesta esperada**:
```
🗑️ Eliminado: Administrador del Sistema
```

---

### Verificar que Todo Está Limpio

Consulta cada categoría para asegurarte de que están vacías:

```
qué tareas tengo
```
**Respuesta esperada**: `No hay tareas registradas`

```
lista de proyectos
```
**Respuesta esperada**: `No hay proyectos registrados`

```
ver mis ideas
```
**Respuesta esperada**: `No hay ideas registradas`

```
lista de personas
```
**Respuesta esperada**: `No hay personas registradas`

✅ **Verificación completa**: El sistema está limpio y listo para uso real.

---

### Opción 2: Limpieza con Script SQL (Avanzado)

Si tienes acceso a la base de datos MySQL o el administrador puede ejecutar scripts SQL:

#### Paso 1: Hacer Backup (IMPORTANTE)

Antes de borrar nada, hacer un backup de seguridad:

```bash
mysqldump -u root -p segundo_cerebro > backup_antes_limpiar_$(date +%Y%m%d_%H%M%S).sql
```

Este comando crea un archivo de backup con fecha y hora.

---

#### Paso 2: Ejecutar Script de Limpieza

El proyecto incluye un script SQL preparado: **`scripts/limpiar_base_datos.sql`**

Este script te permite limpiar la base de datos de forma segura siguiendo estos pasos:

1. **Primero ejecuta el script SIN modificarlo** para ver las estadísticas:
   ```bash
   mysql -u root -p segundo_cerebro < scripts/limpiar_base_datos.sql
   ```
   Verás cuántos registros hay en cada tabla.

2. **Edita el archivo** `scripts/limpiar_base_datos.sql` y descomenta las líneas `TRUNCATE TABLE`

3. **Ejecuta de nuevo** el script:
   ```bash
   mysql -u root -p segundo_cerebro < scripts/limpiar_base_datos.sql
   ```

4. **Verifica desde Telegram**:
   ```
   qué tareas tengo
   ```
   Debería responder: `No hay tareas registradas`

**Nota**: El script incluye instrucciones detalladas, manejo de errores y ejemplos. Consulta el archivo `scripts/limpiar_base_datos.sql` para más información.

---

## ✅ Paso 6: Primer Uso Real

Ahora que el sistema está limpio, empieza a usarlo con datos reales:

### Ejemplo de Sesión de Trabajo Real

```
Tú: "Nueva tarea: Comprar leche mañana"
Bot: ✅ TAREA guardada

Tú: "URGENTE: Llamar al cliente antes de las 3pm"
Bot: ✅ TAREA guardada (prioridad: urgente)

Tú: "Nuevo proyecto: Rediseño del sitio web para marzo"
Bot: ✅ PROYECTO guardado

Tú: "Contacto: Juan García, cliente potencial, juan@empresa.com"
Bot: ✅ PERSONA guardada

Tú: "qué tareas tengo"
Bot: 📊 2 resultados:
     1. Llamar al cliente antes de las 3pm (urgente)
     2. Comprar leche (media)
```

---

## 🎯 Mejores Prácticas para Empezar

### Semana 1: Uso Básico

**Objetivo**: Familiarizarse con captura y consulta.

**Haz esto**:
1. Captura todas las tareas que se te ocurran durante el día
2. Al final del día, revisa: `qué tareas tengo`
3. Marca las completadas: `Marcar tarea [nombre] como completada`

**Evita**:
- No intentes organizar manualmente (la IA lo hace por ti)
- No te preocupes si el bot se equivoca al inicio (aprende de tus patrones)

---

### Semana 2: Proyectos e Ideas

**Objetivo**: Empezar a usar proyectos e ideas.

**Haz esto**:
1. Identifica 2-3 proyectos activos que tienes
2. Crea cada proyecto: `Nuevo proyecto: [nombre] para [fecha]`
3. Guarda ideas que surjan: `Idea: [pensamiento]`

**Revisa semanalmente**:
```
lista de proyectos
ver mis ideas
```

---

### Semana 3: Contactos

**Objetivo**: Registrar personas importantes.

**Haz esto**:
1. Agrega contactos que uses frecuentemente
2. Incluye relación y email/teléfono
3. Revisa periódicamente: `lista de personas`

---

## 🔧 Configuración Avanzada (Opcional)

### Telegram Desktop vs Mobile

**Desktop** (Windows/Mac/Linux):
- ✅ Más rápido para escribir mensajes largos
- ✅ Copiar/pegar fácil
- ✅ Múltiples ventanas

**Mobile** (iOS/Android):
- ✅ Captura rápida en movimiento
- ✅ Notificaciones push del bot
- ✅ Mensajes de voz (v019+)

**Recomendación**: Usa ambos. Telegram sincroniza automáticamente.

---

### Notificaciones

**Habilitar notificaciones del bot**:
1. Abre el chat con el bot
2. Toca el nombre del bot (arriba)
3. Activa "Notificaciones"

**Ventaja**: Recibirás confirmaciones instantáneas cuando guardes algo.

---

### Atajos de Telegram

**Búsqueda rápida del bot**:
1. En Telegram, empieza a escribir `@segundo`
2. Aparecerá el bot en resultados recientes
3. Selecciona y envía mensaje

**Pin del chat**:
1. Mantén presionado el chat del bot
2. Selecciona "Fijar"
3. El chat siempre estará arriba

---

## ❓ FAQ de Primeros Pasos

### ¿Cuánto tiempo toma la configuración inicial?

**Respuesta**: ~5-10 minutos (Paso 1-6 de esta guía).

---

### ¿Necesito crear una cuenta en n8n o Gemini?

**Respuesta**: NO. El sistema ya está configurado por el administrador. Solo necesitas Telegram.

---

### ¿Puedo usar el bot desde mi teléfono y computadora?

**Respuesta**: SÍ. Telegram sincroniza automáticamente entre todos tus dispositivos.

---

### ¿Qué pasa si el bot no responde en mi primer mensaje?

**Posibles causas**:
1. Tu ID de Telegram no está autorizado → Contacta al administrador
2. El bot está desactivado → Contacta al administrador
3. Sin internet → Verifica tu conexión

**Solución**: Si el problema persiste después de 1 minuto, contacta al administrador.

---

### ¿Puedo usar el bot en un grupo de Telegram?

**Respuesta**: Depende de la configuración. Por defecto, el bot está diseñado para **chats privados** (1 a 1).

Si quieres usarlo en un grupo, consulta al administrador.

---

### ¿Los datos de prueba afectan el funcionamiento?

**Respuesta**: NO afectan el funcionamiento, pero sí "ensucian" tus listas. Por eso es importante limpiarlos antes de empezar con datos reales.

---

## 📚 Próximos Pasos

Una vez que hayas completado esta guía, continúa con:

1. **GUIA_RAPIDA.md**: Cheatsheet de comandos esenciales
2. **MANUAL_DE_USUARIO.md**: Guía completa con todos los casos de uso
3. **FAQ.md**: Preguntas frecuentes y troubleshooting

---

## 🎓 Resumen de lo que has Logrado

✅ Encontraste el bot en Telegram
✅ Primera interacción exitosa
✅ Probaste las 4 categorías (tareas, proyectos, ideas, personas)
✅ Verificaste que los datos se guardan
✅ Limpiaste los datos de prueba
✅ Empezaste a usar el sistema con datos reales

**¡Felicidades! Ahora tienes tu Segundo Cerebro funcionando.**

---

## 📞 Soporte

**¿Necesitas ayuda?**
- **Administrador**: [Contacto del administrador]
- **Documentación**: `MANUAL_DE_USUARIO.md`
- **GitHub**: [URL del repositorio]

---

**Última actualización**: 17 Enero 2026 | **Versión**: v018
