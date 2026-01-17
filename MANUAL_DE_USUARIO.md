# Manual de Usuario - Segundo Cerebro con IA

**Versión**: v018
**Última actualización**: 17 de Enero de 2026
**Nivel**: Usuarios finales (no requiere conocimientos técnicos)

---

## 📖 Tabla de Contenidos

1. [Introducción](#introducción)
2. [¿Qué es el Segundo Cerebro?](#qué-es-el-segundo-cerebro)
3. [Primeros Pasos](#primeros-pasos)
4. [Casos de Uso Detallados](#casos-de-uso-detallados)
5. [Tipos de Respuestas del Bot](#tipos-de-respuestas-del-bot)
6. [Mejores Prácticas](#mejores-prácticas)
7. [Arquitectura del Sistema](#arquitectura-del-sistema)
8. [Troubleshooting](#troubleshooting)
9. [Preguntas Frecuentes](#preguntas-frecuentes)

---

## Introducción

### Bienvenido a tu Segundo Cerebro

Este manual te guiará paso a paso para usar el **Sistema de Segundo Cerebro Automatizado con IA**, una herramienta que te permitirá:

- 🧠 **Capturar ideas** sin interrumpir tu flujo de trabajo
- 📝 **Organizar tareas** automáticamente por prioridad
- 🎯 **Gestionar proyectos** con fechas y estados
- 👥 **Registrar contactos** importantes
- 🔍 **Recuperar información** cuando la necesites

**Lo mejor**: Todo esto funciona mediante conversación natural con un bot de Telegram. No necesitas aprender comandos complejos ni menús confusos.

### ¿Por qué un "Segundo Cerebro"?

Tu cerebro es excelente para pensar y crear, pero terrible para recordar detalles. Un Segundo Cerebro es un sistema externo que almacena información por ti, liberándote para enfocarte en lo que realmente importa.

Este sistema va más allá de una simple nota: **usa Inteligencia Artificial para organizar automáticamente** lo que le envías, clasificándolo en la categoría correcta y extrayendo información relevante.

---

## ¿Qué es el Segundo Cerebro?

### Concepto Base: Building a Second Brain (BASB)

El método "Building a Second Brain" (Construir un Segundo Cerebro), desarrollado por Tiago Forte, es un sistema revolucionario de gestión del conocimiento personal. Tradicionalmente requiere disciplina manual para organizar información en 4 categorías:

- **Projects (Proyectos)**: Esfuerzos a corto plazo con objetivo definido
- **Areas (Áreas)**: Responsabilidades a largo plazo
- **Resources (Recursos)**: Temas de interés continuo
- **Archive (Archivo)**: Elementos inactivos

### Nuestra Versión Automatizada

**Diferencia clave**: En lugar de organizar manualmente, este sistema **usa IA para clasificar y estructurar automáticamente** lo que le envías.

**Stack tecnológico** (no necesitas entenderlo técnicamente):
- **Telegram**: Tu interfaz de captura (donde hablas con el bot)
- **n8n**: El cerebro que orquesta todo
- **MySQL**: La base de datos que guarda tu información
- **Gemini 2.5 Flash**: El motor de IA que entiende lo que le dices

**Resultado**: Envías un mensaje como "Comprar leche mañana" y el sistema:
1. Identifica que es una **tarea**
2. Detecta que la prioridad es **media**
3. Extrae que la fecha es **mañana**
4. Lo guarda estructurado en la base de datos
5. Te confirma que se guardó correctamente

---

## Primeros Pasos

### Requisitos Previos

Para usar el sistema necesitas:

1. ✅ **Una cuenta de Telegram** (iOS, Android, Desktop o Web)
2. ✅ **Acceso al bot** (el administrador te dará el nombre del bot)
3. ✅ **Internet** (el bot necesita conexión para funcionar)

Eso es todo. No necesitas instalar nada más.

### Primera Interacción

#### Paso 1: Buscar el Bot

1. Abre Telegram
2. En el buscador, escribe el nombre del bot (ejemplo: `@segundo_cerebro_pkm_bot`)
3. Abre la conversación con el bot

#### Paso 2: Enviar Tu Primer Mensaje

Escribe algo simple como:

```
Hola
```

**Respuesta esperada del bot**:
```
🧠 Segundo Cerebro

Hola! Estoy aquí para ayudarte a organizar tus tareas, proyectos, ideas y contactos.
¿Qué necesitas hacer hoy?
```

¡Funciona! Ahora vamos a probar algo más útil.

#### Paso 3: Guardar Tu Primera Tarea

Escribe:

```
Nueva tarea: Comprar leche mañana
```

**Respuesta esperada del bot**:
```
🧠 Segundo Cerebro

✅ TAREA: Comprar leche - Guardado
Prioridad: media
Fecha: 2026-01-18
```

¡Felicidades! Has guardado tu primera tarea. El sistema:
- Entendió que querías crear una tarea
- Identificó el título ("Comprar leche")
- Interpretó "mañana" como fecha
- Asignó prioridad automáticamente

### Verificar que Funciona

Ahora vamos a recuperar lo que guardaste. Escribe:

```
¿Qué tareas tengo?
```

**Respuesta esperada**:
```
🧠 Segundo Cerebro

📊 1 resultado:
1. Comprar leche (id: 1) - Prioridad: media, Vence: 2026-01-18
```

Perfecto. El sistema está funcionando correctamente.

### Limpiar Datos de Prueba (Opcional)

Antes de empezar a usar el sistema con tus datos reales, puedes borrar las pruebas que hiciste:

```
Borrar la tarea de comprar leche
```

El bot te pedirá confirmación:
```
¿Estás seguro que quieres eliminar la tarea "Comprar leche"?
```

Responde:
```
Sí
```

Y el bot confirmará:
```
🗑️ Eliminado: Comprar leche
```

**Nota técnica**: Si prefieres limpiar toda la base de datos de una vez (tareas, proyectos, ideas, personas), consulta la sección **"Limpiar Base de Datos"** en `PRIMEROS_PASOS.md`.

---

## Casos de Uso Detallados

### 1. Capturar Tareas

Las **tareas** son acciones concretas que necesitas hacer. El sistema las organiza por prioridad y fecha.

#### Crear una Tarea Simple

**Entrada**:
```
Nueva tarea: Llamar al dentista
```

**Resultado**:
```
✅ TAREA: Llamar al dentista - Guardado
Prioridad: media
```

#### Crear una Tarea con Fecha

**Entrada**:
```
Comprar regalo para María el viernes
```

**Resultado**:
```
✅ TAREA: Comprar regalo para María - Guardado
Prioridad: media
Fecha: 2026-01-23 (viernes)
```

**Fechas que el sistema entiende**:
- "mañana" → día siguiente
- "pasado mañana" → dos días después
- "el viernes" → próximo viernes
- "en 3 días" → fecha calculada
- "2026-01-20" → fecha específica

#### Crear una Tarea Urgente

**Entrada**:
```
URGENTE: Enviar informe al jefe antes de las 5pm
```

**Resultado**:
```
✅ TAREA: Enviar informe al jefe antes de las 5pm - Guardado
Prioridad: urgente
Fecha: 2026-01-17 (hoy)
```

El sistema detecta palabras clave como "URGENTE", "YA", "AHORA" para asignar prioridad alta.

#### Ver Todas las Tareas

**Entrada** (cualquiera de estas frases funciona):
```
lista de tareas
dame las tareas
qué tareas tengo
ver mis tareas
```

**Resultado**:
```
📊 3 resultados:
1. Enviar informe al jefe (id: 1) - Prioridad: urgente, Vence: 2026-01-17
2. Comprar regalo para María (id: 2) - Prioridad: media, Vence: 2026-01-23
3. Llamar al dentista (id: 3) - Prioridad: media
```

**Nota**: Las tareas se ordenan automáticamente por:
1. Prioridad (urgente → alta → media → baja)
2. Fecha de vencimiento (más próximas primero)

#### Actualizar una Tarea

**Situación**: Quieres cambiar la prioridad de "Llamar al dentista" a urgente.

**Entrada**:
```
Cambiar la tarea llamar al dentista a urgente
```

**El bot busca la tarea**:
```
Encontré la tarea:
- Llamar al dentista (id: 3)

¿Es correcto?
```

**Confirmas**:
```
Sí
```

**Resultado**:
```
🔄 Actualizado: Llamar al dentista ahora es urgente
```

#### Marcar una Tarea como Completada

**Entrada**:
```
Marcar tarea enviar informe como completada
```

**Resultado**:
```
🔄 Actualizado: Enviar informe al jefe - Estado: completada
```

**Importante**: Las tareas completadas NO aparecen en la lista normal. Esto mantiene tu vista limpia.

#### Eliminar una Tarea

**Entrada**:
```
Borrar la tarea de llamar al dentista
```

**Resultado**:
```
🗑️ Eliminado: Llamar al dentista
```

**Precaución**: La eliminación es permanente. El bot NO pide confirmación adicional si la tarea es única y clara.

---

### 2. Gestionar Proyectos

Los **proyectos** son esfuerzos más grandes que requieren múltiples tareas. Tienen un objetivo final y una fecha límite.

#### Crear un Proyecto

**Entrada**:
```
Nuevo proyecto: Rediseño del sitio web para Q2 2026
```

**Resultado**:
```
✅ PROYECTO: Rediseño del sitio web - Guardado
Estado: activo
Fecha límite: 2026-06-30 (Q2 2026)
```

El sistema:
- Identificó "Rediseño del sitio web" como nombre
- Interpretó "Q2 2026" como segundo trimestre de 2026
- Asignó estado "activo" por defecto

#### Ver Todos los Proyectos

**Entrada**:
```
lista de proyectos
dame los proyectos
```

**Resultado**:
```
📊 2 resultados:
1. Rediseño del sitio web (id: 1) - Estado: activo, Límite: 2026-06-30
2. Migración a nuevo servidor (id: 2) - Estado: en_espera, Límite: 2026-03-15
```

**Estados posibles**:
- **activo**: Proyecto en progreso activo
- **en_espera**: Pausado temporalmente
- **completado**: Proyecto finalizado (no aparece en lista normal)

#### Cambiar Estado de un Proyecto

**Entrada**:
```
Marcar proyecto migración como activo
```

**Resultado**:
```
🔄 Actualizado: Migración a nuevo servidor - Estado: activo
```

#### Actualizar Fecha Límite

**Entrada**:
```
Cambiar fecha límite del proyecto rediseño web al 30 de mayo
```

**Resultado**:
```
🔄 Actualizado: Rediseño del sitio web - Nueva fecha: 2026-05-30
```

---

### 3. Capturar Ideas

Las **ideas** son pensamientos, recursos, aprendizajes que quieres guardar para después. No tienen fecha de vencimiento.

#### Guardar una Idea Simple

**Entrada**:
```
Idea: Artículo sobre cómo la IA está transformando el trabajo
```

**Resultado**:
```
✅ IDEA: Artículo sobre IA y trabajo - Guardado
Tipo: nota
```

#### Guardar un Recurso

**Entrada**:
```
Recurso: Tutorial de n8n en YouTube - https://youtube.com/watch?v=ejemplo
```

**Resultado**:
```
✅ IDEA: Tutorial de n8n - Guardado
Tipo: recurso
Tags: ["youtube", "n8n", "tutorial"]
```

El sistema:
- Detectó que es un recurso (video, enlace, documento)
- Extrajo tags relevantes del contenido
- Guardó la URL en el contenido

#### Guardar un Aprendizaje

**Entrada**:
```
Aprendizaje: Los hooks de React permiten usar estado en componentes funcionales sin necesidad de clases
```

**Resultado**:
```
✅ IDEA: React Hooks - Estado en componentes funcionales - Guardado
Tipo: aprendizaje
Tags: ["react", "hooks", "programming"]
```

#### Ver Todas las Ideas

**Entrada**:
```
qué ideas tengo
ver mis ideas
```

**Resultado**:
```
📊 3 resultados:
1. React Hooks - Estado en componentes funcionales (id: 3) - Tipo: aprendizaje
2. Tutorial de n8n (id: 2) - Tipo: recurso
3. Artículo sobre IA y trabajo (id: 1) - Tipo: nota
```

**Nota**: Las ideas se ordenan por fecha de creación (más recientes primero).

#### Actualizar una Idea

**Entrada**:
```
Actualizar la idea del artículo IA: agregar sección sobre automatización
```

**Resultado**:
```
🔄 Actualizado: Artículo sobre IA y trabajo
Nuevo contenido: "Cómo la IA está transformando el trabajo. Agregar sección sobre automatización."
```

---

### 4. Registrar Personas

Las **personas** son contactos importantes: clientes, proveedores, amigos, colegas, familia.

#### Guardar una Persona

**Entrada**:
```
Contacto: Juan García, cliente potencial, email: juan.garcia@empresa.com, teléfono: +34 600 123 456
```

**Resultado**:
```
✅ PERSONA: Juan García - Guardado
Relación: cliente
Contacto: {"email": "juan.garcia@empresa.com", "telefono": "+34 600 123 456"}
```

#### Guardar un Proveedor

**Entrada**:
```
Proveedor: María López - Diseñadora freelance - maria@diseño.com
```

**Resultado**:
```
✅ PERSONA: María López - Guardado
Relación: proveedor
Contacto: {"email": "maria@diseño.com"}
```

#### Ver Todas las Personas

**Entrada**:
```
lista de personas
mis contactos
```

**Resultado**:
```
📊 2 resultados:
1. Juan García (id: 1) - Relación: cliente, Email: juan.garcia@empresa.com
2. María López (id: 2) - Relación: proveedor, Email: maria@diseño.com
```

**Relaciones posibles**:
- cliente
- proveedor
- amigo
- colega
- familia
- otro

#### Actualizar Información de Contacto

**Entrada**:
```
Actualizar contacto Juan García: nuevo teléfono +34 600 999 888
```

**Resultado**:
```
🔄 Actualizado: Juan García
Nuevo contacto: {"email": "juan.garcia@empresa.com", "telefono": "+34 600 999 888"}
```

---

## Tipos de Respuestas del Bot

El bot usa diferentes formatos para comunicarse contigo:

### ✅ Guardado Exitoso

```
✅ TAREA: Comprar leche - Guardado
Prioridad: media
Fecha: 2026-01-18
```

**Significado**: El registro se creó correctamente en la base de datos.

### 🔄 Actualización Exitosa

```
🔄 Actualizado: Comprar leche ahora es urgente
```

**Significado**: El campo se modificó correctamente.

### 🗑️ Eliminación Exitosa

```
🗑️ Eliminado: Comprar leche
```

**Significado**: El registro se borró permanentemente.

### 📊 Consulta con Resultados

```
📊 3 resultados:
1. Tarea 1 (id: 1)
2. Tarea 2 (id: 2)
3. Tarea 3 (id: 3)
```

**Significado**: Se encontraron registros que coinciden con tu búsqueda.

### ℹ️ Sin Resultados

```
No hay tareas registradas
```

**Significado**: La categoría está vacía. Es una respuesta válida, no un error.

### ⚠️ Necesita Aclaración

```
Encontré 3 tareas con "leche". ¿Cuál quieres actualizar?
1. Comprar leche (id: 5)
2. Revisar precio de leche (id: 8)
3. Leche para el gato (id: 12)
```

**Significado**: El bot necesita que seas más específico.

**Cómo responder**:
```
la del id 5
```
O simplemente:
```
5
```

### ❌ Error o Problema

```
No entendí qué querías hacer. ¿Puedes ser más específico?
```

**Significado**: El bot no pudo interpretar tu mensaje.

**Qué hacer**:
- Reformula tu mensaje con más claridad
- Usa frases de ejemplo de este manual
- Consulta la sección "Mejores Prácticas"

---

## Mejores Prácticas

### 1. Sé Específico

❌ **Evita**: "leche"
✅ **Mejor**: "Comprar leche mañana"

**Por qué**: El sistema necesita contexto para clasificar correctamente.

### 2. Usa Lenguaje Natural

❌ **No necesitas**: "TAREA: comprar leche | PRIORIDAD: alta | FECHA: 2026-01-18"
✅ **Puedes decir**: "Comprar leche urgente para mañana"

**Por qué**: La IA está entrenada para entender conversación natural.

### 3. Incluye Fechas Cuando Sea Relevante

✅ **Bien**:
- "Enviar informe el viernes"
- "Reunión con cliente el 25 de enero"
- "Llamar al proveedor mañana por la mañana"

**Por qué**: Las fechas ayudan al sistema a priorizar automáticamente.

### 4. Usa Palabras Clave para Urgencia

**Palabras que el sistema detecta como urgentes**:
- URGENTE
- YA
- AHORA
- INMEDIATO
- HOY

**Ejemplo**:
```
URGENTE: Revisar contrato antes de firma
```
→ Prioridad: urgente, Fecha: hoy

### 5. Confirma Cuando el Bot Te Pregunta

Cuando el bot encuentra múltiples coincidencias:

```
Bot: ¿Cuál tarea quieres modificar?
1. Comprar leche (id: 5)
2. Leche para el gato (id: 12)
```

**Responde claramente**:
```
5
```
O:
```
la del id 5
```

**NO** ignores la pregunta o envíes un mensaje diferente, o el bot se confundirá.

### 6. Un Mensaje a la Vez

❌ **Evita**:
```
Nueva tarea comprar leche también agregar proyecto web y guardar contacto juan
```

✅ **Mejor**:
```
Nueva tarea: Comprar leche
```
*(esperar respuesta)*
```
Nuevo proyecto: Rediseño web
```
*(esperar respuesta)*
```
Contacto: Juan García, cliente
```

**Por qué**: El sistema procesa un comando a la vez de forma más confiable.

### 7. Revisa Periódicamente

**Sugerencia**: Una vez por semana, revisa tus listas:

```
qué tareas tengo
```
```
lista de proyectos
```

Esto te ayuda a mantener el sistema limpio y actualizado.

### 8. Elimina Tareas Obsoletas

Si una tarea ya no es relevante:

```
Borrar la tarea de comprar leche
```

**Por qué**: Mantiene tu lista enfocada en lo que realmente importa.

---

## Arquitectura del Sistema

### Cómo Funciona (Versión Simple)

Cuando envías un mensaje al bot, sucede lo siguiente:

1. **Telegram recibe tu mensaje** y lo envía al servidor
2. **n8n (el orquestador) lo registra** en un log de auditoría
3. **Gemini 2.5 Flash (la IA) analiza** el mensaje y decide:
   - ¿Es una tarea, proyecto, idea o persona?
   - ¿Cuál es la prioridad?
   - ¿Hay fechas o datos específicos?
4. **MySQL guarda la información** de forma estructurada
5. **El bot te responde** confirmando la acción

**Latencia esperada**: 1-3 segundos (depende de la complejidad del mensaje)

### Dónde se Guardan Tus Datos

- **Base de datos**: MySQL (auto-hospedada en servidor privado)
- **Memoria conversacional**: PostgreSQL (para recordar contexto)
- **Tus mensajes NO van a Google**: Solo el texto se procesa por Gemini API, no se almacena en servidores de Google

### Privacidad y Seguridad

✅ **Tus datos están seguros porque**:
- El sistema está auto-hospedado (no usa clouds de terceros)
- Solo usuarios autorizados tienen acceso al bot
- La base de datos está protegida con credenciales
- Se hacen backups regulares

⚠️ **Ten en cuenta**:
- **No envíes contraseñas** o información extremadamente sensible
- **Usa el bot solo en chats privados**, no en grupos públicos
- **Los mensajes de voz NO están implementados** (próxima versión)

---

## Troubleshooting

### Problema 1: "El bot no responde"

**Síntomas**:
- Envías un mensaje y no recibes respuesta
- El mensaje aparece como "enviado" pero el bot está silencioso

**Solución**:
1. **Espera 30 segundos**: A veces el servidor está procesando y tarda un poco
2. **Verifica conexión a internet**: El bot necesita conexión activa
3. **Reinicia Telegram**: Cierra y abre la app
4. **Contacta al administrador**: Si el problema persiste, puede ser un problema del servidor

**Prevención**: Evita enviar múltiples mensajes consecutivos muy rápido.

---

### Problema 2: "Se guardó en la categoría incorrecta"

**Síntomas**:
- Enviaste "Proyecto rediseño web" y se guardó como tarea

**Solución inmediata**:
1. Elimina el registro incorrecto:
   ```
   Borrar la tarea rediseño web
   ```
2. Vuelve a enviar con más claridad:
   ```
   Nuevo proyecto: Rediseño del sitio web
   ```

**Prevención**: Usa palabras clave explícitas:
- "Nueva **tarea**:"
- "Nuevo **proyecto**:"
- "**Idea**:"
- "**Contacto**:"

---

### Problema 3: "El bot malinterpretó la fecha"

**Síntomas**:
- Dijiste "mañana" y guardó fecha incorrecta

**Solución**:
1. Actualiza la fecha:
   ```
   Cambiar fecha de la tarea al 18 de enero
   ```

**Prevención**: Usa fechas explícitas cuando sea crítico:
- ❌ "la próxima semana" (ambiguo)
- ✅ "el 25 de enero" (específico)

---

### Problema 4: "Quiero borrar datos de prueba"

**Síntomas**:
- Probaste el sistema y ahora quieres empezar limpio

**Solución**:

**Opción 1 - Manual (borra uno por uno)**:
```
Borrar la tarea de prueba
```
Repite para cada registro de prueba.

**Opción 2 - Script SQL (borra todo de una vez)**:
Consulta el archivo `scripts/limpiar_base_datos.sql` y pide al administrador que lo ejecute.

**Recomendación**: Si tienes menos de 10 registros de prueba, usa Opción 1. Si son muchos, usa Opción 2.

---

### Problema 5: "El bot respondió algo extraño"

**Ejemplo**:
```
Usuario: "Comprar leche"
Bot: "No entendí qué querías hacer"
```

**Solución**:
Reformula con más contexto:
```
Nueva tarea: Comprar leche
```

**Por qué pasa**: Mensajes muy cortos sin verbo de acción pueden confundir al sistema.

---

### Problema 6: "Quiero cambiar el nombre de un proyecto pero no recuerdo el ID"

**Solución**:
1. Primero lista los proyectos:
   ```
   lista de proyectos
   ```
2. El bot te mostrará:
   ```
   📊 2 resultados:
   1. Rediseño web (id: 5)
   2. Migración servidor (id: 8)
   ```
3. Ahora actualiza usando el nombre o el ID:
   ```
   Renombrar proyecto rediseño web a Portal Cliente
   ```

**Tip**: No necesitas memorizar IDs. El bot los busca por ti cuando usas el nombre.

---

## Preguntas Frecuentes

### ¿Cuánto tarda en responder el bot?

**Respuesta normal**: 1-3 segundos
**Consultas complejas**: 5-7 segundos
**Si tarda más de 30 segundos**: Revisa tu conexión o contacta al administrador

---

### ¿Mis datos están seguros?

Sí. El sistema está auto-hospedado en un servidor privado. Solo usuarios autorizados pueden acceder al bot. Se hacen backups regulares de la base de datos.

**Recomendación**: Aun así, evita enviar contraseñas, números de tarjetas de crédito u otra información extremadamente sensible.

---

### ¿Qué pasa si el bot se equivoca?

Si el bot guarda algo en la categoría incorrecta o con datos mal interpretados:

1. **Borra el registro incorrecto**:
   ```
   Borrar [lo que sea]
   ```
2. **Vuelve a intentar con más claridad**:
   ```
   Nueva tarea: [descripción más clara]
   ```

El sistema aprende de tus patrones de uso con el tiempo (gracias a la memoria conversacional).

---

### ¿Puedo exportar mis datos?

Actualmente **no hay interfaz de exportación automática**, pero el administrador puede ejecutar un query SQL para exportar tus datos a CSV o JSON.

**Roadmap futuro**: Comando `/export` que te enviará un archivo con todos tus datos.

---

### ¿Hay límite de registros?

No hay límite técnico. La base de datos puede manejar **millones de registros** sin problemas.

**Recomendación**: Mantén tu sistema limpio eliminando tareas completadas antiguas y archivando proyectos finalizados.

---

### ¿Funciona sin internet?

No. El bot necesita conexión a internet para:
- Comunicarse con Telegram
- Procesar mensajes con la IA (Gemini)
- Guardar en la base de datos

**Modo offline**: No disponible (y no está planeado).

---

### ¿Puedo usar el bot desde múltiples dispositivos?

Sí. Telegram sincroniza automáticamente entre todos tus dispositivos:
- Teléfono móvil (iOS/Android)
- Desktop (Windows/Mac/Linux)
- Web (web.telegram.org)

Tus conversaciones con el bot estarán disponibles en todos tus dispositivos.

---

### ¿El bot recuerda conversaciones anteriores?

Sí, hasta cierto punto. El sistema tiene **memoria conversacional** que recuerda las últimas **15 interacciones**.

**Ejemplo**:
```
Tú: "Nueva tarea: Comprar leche"
Bot: ✅ Guardado
Tú: "Cambiarla a urgente"  ← El bot recuerda que acabas de crear una tarea de leche
Bot: 🔄 Actualizado
```

**Límite**: Después de 15 mensajes, la memoria más antigua se olvida.

---

### ¿Puedo enviar mensajes de voz?

**Actualmente**: No. Solo mensajes de texto.

**Próxima versión (v019)**: Soporte de mensajes de voz con transcripción automática vía Gemini.

---

### ¿Qué pasa si borro algo por error?

⚠️ **La eliminación es permanente**. No hay papelera de reciclaje.

**Recomendación**: Cuando borres algo importante, verifica primero el ID:
```
lista de tareas
```
Luego borra específicamente:
```
Borrar la tarea con id 5
```

**Backup**: El administrador hace backups regulares de la base de datos. Si borras algo crítico, contacta al administrador.

---

### ¿Puedo compartir el bot con otras personas?

Depende de la configuración del administrador. Por defecto, el bot **requiere autorización** para nuevos usuarios.

Si quieres que un amigo use el sistema:
1. Pídele al administrador que autorice al nuevo usuario
2. Comparte el nombre del bot
3. El nuevo usuario sigue la guía "Primeros Pasos" de este manual

---

### ¿El bot mejora con el tiempo?

**Memoria conversacional**: Sí. El bot recuerda tus últimas 15 interacciones.

**Aprendizaje de patrones**: El modelo de IA (Gemini 2.5 Flash) **no se re-entrena** con tus datos, pero la memoria conversacional le ayuda a entender tu contexto reciente.

**Actualizaciones del sistema**: El administrador puede actualizar el workflow de n8n para mejorar funcionalidades sin que tú hagas nada.

---

### ¿Cómo puedo dar feedback o reportar bugs?

Contacta al administrador del sistema por:
- Telegram directo
- Email (si está configurado)
- GitHub Issues (si el proyecto es público)

**Información útil para reportar bugs**:
- Qué mensaje enviaste
- Qué esperabas que pasara
- Qué pasó realmente
- Captura de pantalla (si es posible)

---

## Recursos Adicionales

### Documentos Relacionados

- **GUIA_RAPIDA.md**: Cheatsheet de una página con comandos esenciales
- **PRIMEROS_PASOS.md**: Instalación y configuración inicial
- **FAQ.md**: Preguntas frecuentes extendidas
- **CHANGELOG.md**: Historial de versiones y cambios

### Contacto

**Administrador del Sistema**: [Tu nombre o contacto]
**GitHub**: [URL del repositorio]
**Documentación técnica**: Ver `README.md` en el repositorio

---

## Conclusión

¡Felicidades! Ahora sabes cómo usar el Sistema de Segundo Cerebro con IA.

**Recuerda**:
- 🧠 **Captura sin pensar**: Envía mensajes naturales al bot
- 🤖 **Confía en la IA**: El sistema clasifica automáticamente
- 📊 **Revisa periódicamente**: Mantén tu sistema limpio
- 🔄 **Actualiza cuando sea necesario**: El bot es flexible
- 🗑️ **Elimina lo obsoleto**: Mantén enfoque en lo importante

**Próximo paso**: Empieza a usar el sistema hoy mismo. Envía tu primera tarea real y experimenta la libertad de externalizar tu memoria.

---

**Versión del manual**: v018
**Última actualización**: 17 de Enero de 2026
**Autor**: Sistema Segundo Cerebro
**Licencia**: [Tu licencia]
