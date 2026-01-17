# FAQ - Preguntas Frecuentes

**Segundo Cerebro con IA**

**Versión**: v018 | **Última actualización**: 17 Enero 2026

---

## 📋 Índice

1. [Uso General](#uso-general)
2. [Rendimiento](#rendimiento)
3. [Privacidad y Seguridad](#privacidad-y-seguridad)
4. [Funcionalidades](#funcionalidades)
5. [Troubleshooting](#troubleshooting)
6. [Roadmap](#roadmap)

---

## Uso General

### ¿Cómo empiezo a usar el sistema?

Sigue la guía `PRIMEROS_PASOS.md`. En resumen:

1. Busca el bot en Telegram
2. Envía "Hola" para probar
3. Empieza a guardar tareas: `Nueva tarea: [descripción]`

**Tiempo de setup**: ~5-10 minutos.

---

### ¿Necesito saber programar para usarlo?

**NO**. El sistema está diseñado para usuarios finales sin conocimientos técnicos. Solo necesitas:
- Saber enviar mensajes en Telegram
- Escribir en lenguaje natural

**Ejemplo**: En lugar de aprender comandos complejos, simplemente dices:
```
Comprar leche mañana
```

Y el sistema entiende automáticamente.

---

### ¿Qué pasa si escribo mal o con faltas de ortografía?

El sistema **tolera errores leves**. Gemini 2.5 Flash está entrenado para entender lenguaje natural imperfecto.

**Ejemplos que funcionan**:
- `comprar lehe mañana` → Funciona (tolera "lehe")
- `proyeto diseño web` → Funciona (tolera "proyeto")

**Límite**: Si el mensaje es incomprensible, el bot pedirá aclaración.

---

### ¿Puedo usar el bot en otro idioma (inglés, francés, etc.)?

Actualmente está optimizado para **español**, pero Gemini 2.5 Flash es multilingüe.

**Prueba**: Envía mensajes en otro idioma y verifica si funciona.

**Recomendación**: Si planeas usarlo regularmente en otro idioma, contacta al administrador para ajustar el system prompt.

---

### ¿Cuántos mensajes puedo enviar por día?

**Sin límite técnico**. Puedes enviar tantos mensajes como necesites.

**Recomendación de uso saludable**:
- Captura ideas cuando surjan (no las acumules)
- Revisa listas 1-2 veces al día
- No sobre-organices (confía en la IA)

---

## Rendimiento

### ¿Cuánto tarda el bot en responder?

**Latencia típica**:
- Mensaje simple (guardar tarea): **1-3 segundos**
- Consulta (lista de tareas): **2-4 segundos**
- Actualización (cambiar prioridad): **2-3 segundos**
- Consulta compleja con múltiples filtros: **5-7 segundos**

**Si tarda más de 30 segundos**: Verifica tu conexión a internet o contacta al administrador.

---

### ¿Funciona sin internet?

**NO**. El bot necesita conexión a internet para:
- Comunicarse con Telegram
- Procesar mensajes con Gemini AI
- Guardar en la base de datos MySQL

**Modo offline**: No disponible (y no está planeado).

---

### ¿Puedo usar el bot desde múltiples dispositivos a la vez?

**SÍ**. Telegram sincroniza automáticamente entre:
- Teléfono móvil (iOS/Android)
- Desktop (Windows/Mac/Linux)
- Web (web.telegram.org)

**Ventaja**: Captura rápido en el móvil, revisa listas en la computadora.

---

## Privacidad y Seguridad

### ¿Dónde se guardan mis datos?

Tus datos se guardan en:

1. **Base de datos MySQL**: Auto-hospedada en servidor privado del administrador
2. **Memoria conversacional**: PostgreSQL (últimas 15 interacciones)
3. **Telegram**: Mensajes en tu chat (no se borran automáticamente)

**NO se guarda en**:
- Servidores de Google (Gemini procesa pero no almacena)
- Clouds públicos (AWS, Azure, etc.)

---

### ¿Mis datos son privados?

**SÍ**, con estas consideraciones:

✅ **Privado del público general**: Solo tú y el administrador del sistema tienen acceso.

✅ **Auto-hospedado**: No usa servicios cloud de terceros.

⚠️ **Procesamiento por IA**: Gemini API procesa tus mensajes (pero Google no los almacena según su política).

⚠️ **Acceso del administrador**: El administrador del servidor tiene acceso técnico a la base de datos (necesario para mantenimiento).

---

### ¿Puedo enviar información sensible?

**Recomendación**: **NO** envíes:
- Contraseñas
- Números de tarjetas de crédito
- Datos médicos privados
- Secretos corporativos críticos

**SÍ** puedes enviar:
- Tareas personales generales
- Contactos de trabajo
- Ideas y proyectos
- Información no-confidencial

**Razón**: Aunque el sistema es privado, es mejor prevenir que curar.

---

### ¿Se hacen backups de mis datos?

**SÍ**, el administrador hace backups regulares de la base de datos MySQL.

**Frecuencia típica**: Diario o semanal (depende de la configuración del administrador).

**Importante**: Si borras algo por error, contacta al administrador. Puede recuperarlo del backup (si es reciente).

---

## Funcionalidades

### ¿El bot recuerda conversaciones anteriores?

**SÍ**, hasta cierto punto. El sistema tiene **memoria conversacional** que recuerda las últimas **15 interacciones**.

**Ejemplo**:
```
Tú: "Nueva tarea: Comprar leche"
Bot: ✅ Guardado
Tú: "Cambiarla a urgente"  ← El bot recuerda que acabas de crear "Comprar leche"
Bot: 🔄 Actualizado
```

**Límite**: Después de 15 mensajes, la memoria más antigua se olvida.

---

### ¿Puedo enviar mensajes de voz?

**Actualmente (v018)**: **NO**. Solo mensajes de texto.

**Próxima versión (v019)**: Soporte de mensajes de voz con transcripción automática vía Gemini 2.5 Flash.

**Esperado**: Latencia <10 segundos para audio de 1 minuto.

---

### ¿Puedo enviar imágenes (fotos, capturas de pantalla)?

**Actualmente (v018)**: **NO**. Solo texto.

**Roadmap futuro (v020+)**: Procesamiento de imágenes con Gemini Vision (OCR, análisis de contenido).

---

### ¿Hay límite de tareas/proyectos/ideas que puedo guardar?

**NO** hay límite técnico. La base de datos MySQL puede manejar **millones de registros** sin problemas.

**Recomendación práctica**: Mantén tu sistema limpio:
- Marca tareas como completadas cuando termines
- Archiva proyectos finalizados
- Elimina ideas obsoletas

**Por qué**: Listas largas son difíciles de revisar y pierden valor.

---

### ¿Puedo exportar mis datos a Excel o PDF?

**Actualmente**: **NO** hay interfaz de exportación automática.

**Workaround**: El administrador puede ejecutar un query SQL para exportar tus datos a:
- CSV (importable en Excel)
- JSON (para programadores)

**Roadmap futuro (v020+)**: Comando `/export` que te enviará un archivo con todos tus datos.

---

### ¿Puedo compartir tareas o proyectos con otras personas?

**Actualmente**: **NO**. El sistema está diseñado para uso personal individual.

**Roadmap futuro (v021+)**: Colaboración multi-usuario (tareas compartidas, proyectos en equipo).

---

## Troubleshooting

### El bot no responde a mis mensajes

**Diagnóstico**:

1. **Espera 30 segundos**: A veces el servidor está ocupado.
2. **Verifica internet**: ¿Tienes conexión activa?
3. **Reinicia Telegram**: Cierra y abre la app.
4. **Verifica autorización**: ¿El administrador te autorizó?

**Solución**:
- Si el problema persiste después de 1 minuto, contacta al administrador.
- El bot puede estar desactivado temporalmente por mantenimiento.

---

### El bot guardó algo en la categoría incorrecta

**Ejemplo**: Enviaste "Proyecto rediseño web" y se guardó como tarea.

**Solución inmediata**:
1. Borra el registro incorrecto:
   ```
   Borrar la tarea rediseño web
   ```
2. Vuelve a enviar con palabra clave explícita:
   ```
   Nuevo proyecto: Rediseño del sitio web
   ```

**Prevención**: Usa palabras clave claras al inicio:
- `Nueva tarea:`
- `Nuevo proyecto:`
- `Idea:`
- `Contacto:`

---

### El bot malinterpretó la fecha

**Ejemplo**: Dijiste "mañana" y guardó fecha incorrecta.

**Solución**:
```
Cambiar fecha de la tarea al 18 de enero
```

**Prevención**: Usa fechas explícitas para cosas críticas:
- ❌ `la próxima semana` (ambiguo)
- ✅ `el 25 de enero` (específico)

---

### Quiero borrar todos los datos de prueba

**Opción 1 - Manual** (borra uno por uno):
```
Borrar la tarea de prueba
```
Repite para cada registro.

**Opción 2 - Script SQL** (borra todo de una vez):
Consulta `PRIMEROS_PASOS.md` → Sección "Limpiar Datos de Prueba" → Opción 2.

**Requiere**: Acceso a la base de datos o ayuda del administrador.

---

### El bot respondió algo confuso o sin sentido

**Ejemplo**:
```
Bot: "Procesando... [mensaje raro]"
```

**Solución**:
1. Ignora el mensaje raro
2. Reformula tu mensaje con más contexto:
   ```
   Nueva tarea: [descripción clara]
   ```

**Por qué pasa**: A veces el LLM genera texto inesperado. Es raro pero puede ocurrir.

---

### Borré algo por error, ¿puedo recuperarlo?

**Respuesta**: Depende.

**SI acabas de borrarlo** (hace <1 hora):
- Contacta al administrador
- Puede recuperarlo del backup más reciente

**SI pasaron varios días**:
- Probablemente NO se puede recuperar
- Los backups antiguos se sobrescriben

**Prevención**: Cuando borres algo importante, verifica primero:
```
lista de tareas
```
Confirma el ID antes de eliminar:
```
Borrar la tarea con id 5
```

---

## Roadmap

### ¿Qué nuevas funcionalidades están planeadas?

**v019 (Próximamente)**:
- ✨ Soporte de **mensajes de voz** con transcripción automática
- 🎤 Latencia <10 segundos para audio de 1 minuto

**v020+ (Backlog)**:
- `/fix` → Comando de corrección rápida de clasificación
- **Confidence scoring** → Prevención de datos de baja calidad
- **Búsqueda semántica** → Encuentra información por significado, no solo keywords
- **Relaciones entre entidades** → Vincular tareas con proyectos
- **Digest diario/semanal** → Resúmenes automáticos vía Telegram

**v021+ (Futuro lejano)**:
- Procesamiento de **imágenes** (OCR, análisis con Gemini Vision)
- Colaboración **multi-usuario**
- Comando `/export` → Exportar datos a CSV/JSON/PDF
- Integración con **calendarios** (Google Calendar, Outlook)

---

### ¿Cómo puedo sugerir nuevas funcionalidades?

**Contacta al administrador** con tu sugerencia.

**Formato recomendado**:
```
Título: [Descripción corta]

Problema que resuelve:
[Explica qué problema tienes actualmente]

Solución propuesta:
[Cómo te imaginas que funcionaría]

Ejemplo de uso:
[Caso de uso concreto]
```

**Nota**: No todas las sugerencias se implementarán (depende de complejidad y valor).

---

### ¿El sistema mejora con el tiempo?

**Memoria conversacional**: Sí. El bot recuerda tus últimas 15 interacciones.

**Aprendizaje del modelo de IA**: No. Gemini 2.5 Flash **no se re-entrena** con tus datos.

**Actualizaciones del sistema**: Sí. El administrador puede actualizar el workflow de n8n para agregar funcionalidades sin que tú hagas nada.

---

## 📞 Soporte

### ¿Cómo reporto un bug o problema?

**Información útil para reportar**:
1. Qué mensaje enviaste
2. Qué esperabas que pasara
3. Qué pasó realmente
4. Captura de pantalla (si es posible)
5. Fecha y hora aproximada

**Contacto**:
- **Administrador**: [Contacto del administrador]
- **GitHub Issues**: [URL del repositorio]/issues (si es público)

---

### ¿Dónde puedo ver el código fuente?

Si el proyecto es **open source**:
- **GitHub**: [URL del repositorio]
- **Workflow n8n**: Archivo JSON exportado incluido en el repositorio

Si el proyecto es **privado**:
- Consulta al administrador

---

## 📚 Documentación Adicional

- **Manual completo**: `MANUAL_DE_USUARIO.md` (guía extensa ~100 páginas)
- **Guía rápida**: `GUIA_RAPIDA.md` (cheatsheet de comandos)
- **Primeros pasos**: `PRIMEROS_PASOS.md` (setup inicial)
- **Changelog**: `CHANGELOG.md` (historial de versiones)
- **Documentación técnica**: `README.md` (para desarrolladores)

---

## 🎓 Consejos Finales

### Para usuarios nuevos:
1. Lee `PRIMEROS_PASOS.md` primero
2. Usa `GUIA_RAPIDA.md` como referencia rápida
3. Experimenta sin miedo (puedes borrar lo que guardes)

### Para usuarios avanzados:
1. Revisa `MANUAL_DE_USUARIO.md` completo
2. Explora casos de uso avanzados
3. Sugiere mejoras al administrador

### Para todos:
- **Captura sin pensar** (la IA organiza por ti)
- **Revisa semanalmente** (mantén el sistema limpio)
- **Confía en el sistema** (está diseñado para ser tu segundo cerebro)

---

**¿Tienes más preguntas?** Consulta el `MANUAL_DE_USUARIO.md` o contacta al administrador.

**Última actualización**: 17 Enero 2026 | **Versión**: v018
