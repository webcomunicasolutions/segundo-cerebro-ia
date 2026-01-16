# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Descripción del Proyecto

Este repositorio contiene notas, ideas y documentación de diseño para un **Sistema de Segundo Cerebro Automatizado con IA**, basado en la metodología "Building a Second Brain" (PKM - Personal Knowledge Management).

### Arquitectura del Sistema

El proyecto diseña un sistema agéntico activo que utiliza:

- **Telegram**: Interfaz de captura omnipresente (texto, audio, imágenes)
- **n8n**: Orquestador de flujos de trabajo y sistema nervioso central
- **MySQL**: Base de datos relacional con soporte JSON híbrido
- **Gemini 2.5 Flash**: Motor cognitivo de IA con capacidades de razonamiento y JSON Schema Enforcement

### Filosofía del Sistema

**Sistema Agéntico vs Automatización Lineal**: A diferencia de scripts tradicionales ("Si X, entonces Y"), el sistema emplea un motor de razonamiento (Gemini 2.5 Flash) para:

1. **Analizar semánticamente** la entrada del usuario
2. **Clasificar automáticamente** el tipo de contenido (Nota, Tarea, Recurso, etc.)
3. **Extraer metadatos** relevantes (prioridad, contexto, fechas)
4. **Estructurar datos** para inserción en MySQL con esquema estricto

**Ejemplo**: El mensaje "Comprar leche" no solo se guarda como texto, sino que el sistema:
- Identifica el verbo "Comprar"
- Reconoce el objeto "leche"
- Deduce que es una "Tarea" de tipo "Doméstico/Compras"
- Asigna prioridad basada en contexto implícito
- Estructura datos para inserción en tablas MySQL

## Estructura del Repositorio

```
notas_ideas/
├── segundo_cerebro.txt              # Notas iniciales y referencia de video YouTube
├── Diseño de Sistema Automatizado con IA.docx  # Documento técnico completo (~6MB)
└── CLAUDE.md                        # Este archivo
```

## Documento Técnico Principal

El archivo `Diseño de Sistema Automatizado con IA.docx` contiene:

### Secciones Principales

1. **Resumen Ejecutivo**: Visión general de la convergencia entre LLMs, automatización low-code y bases de datos relacionales

2. **Análisis Técnico de Componentes**:
   - Motor Cognitivo: Gemini 2.5 Flash (razonamiento, velocidad, JSON Schema Enforcement)
   - Capa de Orquestación: n8n (nodos Telegram, Switch, MySQL)
   - Capa de Persistencia: MySQL (estructura relacional + flexibilidad JSON)
   - Interfaz de Captura: Telegram (ubicuidad, soporte multimodal)

3. **Arquitectura del Sistema y Flujo de Datos**:
   - Flujo completo desde mensaje de usuario hasta confirmación
   - Diseño de esquema de base de datos MySQL
   - Estrategias de routing condicional en n8n

4. **Diseño e Implementación del Flujo de Trabajo en n8n**:
   - Configuración de nodos
   - Ingeniería de prompts para Gemini
   - Manejo de mensajes multimodales (texto, audio, imágenes)

### Características Técnicas Clave

**Gemini 2.5 Flash**:
- Latencia inferior al segundo
- Soporte nativo de `response_schema` (JSON Schema Enforcement)
- Razonamiento complejo con eficiencia de costos
- Capacidades multimodales (texto, audio, imágenes)

**n8n**:
- Auto-hospedable (Docker) para privacidad total
- Nodos especializados: Telegram Trigger, Switch, MySQL
- Connection pooling y sanitización SQL automática
- Programación visual de lógica compleja

**MySQL**:
- Tipo de dato JSON nativo para metadatos flexibles
- Full-text search nativo
- Indexación eficiente en columnas estructuradas
- Arquitectura permite futura integración de búsqueda vectorial

**Telegram**:
- Soporte multimodal (texto, audio, imágenes, documentos)
- API de bots robusta con webhooks
- Ubicuidad cross-platform

## Trabajando con el Documento DOCX

### Lectura y Análisis

Para extraer texto del documento Word:

```bash
# Convertir a markdown con pandoc (si está instalado)
pandoc --track-changes=all "Diseño de Sistema Automatizado con IA.docx" -o documento.md

# Desempaquetar para acceso a XML crudo (comentarios, formateo, metadata)
python3 ~/.claude/skills/docx/ooxml/scripts/unpack.py "Diseño de Sistema Automatizado con IA.docx" /tmp/doc_unpacked

# Leer contenido principal
cat /tmp/doc_unpacked/word/document.xml
```

### Estructura del Documento XML

Elementos clave:
- `word/document.xml`: Contenido principal del documento
- `word/comments.xml`: Comentarios (si existen)
- `word/media/`: Imágenes y media embebidos

### Modificación del Documento

Si necesitas editar el documento Word:

1. **Leer documentación**: `~/.claude/skills/docx/ooxml.md` (Document Library API)
2. **Desempaquetar**: `python3 ~/.claude/skills/docx/ooxml/scripts/unpack.py <file.docx> <dir>`
3. **Editar con Python**: Usar Document Library para manipulación
4. **Empaquetar**: `python3 ~/.claude/skills/docx/ooxml/scripts/pack.py <dir> <file.docx>`

## Referencias y Contexto

### Video de Referencia Original: "Building a Second Brain with AI in 2026"
- **URL**: https://www.youtube.com/watch?v=0TpON5T-Sw4
- **Autor**: Implementación práctica de Segundo Cerebro con IA
- **Duración**: ~30 minutos (888 snippets de transcripción)
- **Idioma**: Inglés (auto-generado)

#### Resumen del Video

Este video propone un **sistema agéntico activo** (no almacenamiento pasivo) que representa un salto evolutivo en PKM para 2026. La diferencia clave con los sistemas tradicionales es que **el sistema hace trabajo mientras duermes**, clasificando, ruteando, resumiendo y recordándote sin que tengas que hacer nada.

#### Stack Tecnológico Propuesto en el Video

El video recomienda este stack **sin código** para no-ingenieros:

1. **Slack**: Punto de captura (canal privado "SB Inbox")
2. **Notion**: Capa de almacenamiento (4 bases de datos: People, Projects, Ideas, Admin)
3. **Zapier** (o Make): Capa de automatización
4. **Claude o ChatGPT**: Capa de inteligencia (clasificación con JSON Schema)

**Diferencia con tu proyecto**: Tu diseño usa **Telegram + n8n + MySQL + Gemini 2.5 Flash**, lo cual es más potente y personalizable que el stack del video.

#### Los 8 Building Blocks (Bloques de Construcción)

El video descompone un segundo cerebro en 8 componentes fundamentales:

1. **The Dropbox** (Punto de Captura)
   - Un solo lugar sin fricción para capturar pensamientos
   - Video: Canal de Slack "SB Inbox"
   - Tu proyecto: Bot de Telegram

2. **The Sorter** (Clasificador)
   - IA que decide automáticamente dónde va cada pensamiento
   - Elimina decisiones de taxonomía en el momento de captura
   - Video: Zapier + Claude/GPT con prompt de clasificación
   - Tu proyecto: Gemini 2.5 Flash con JSON Schema Enforcement

3. **The Form** (Esquema)
   - Campos consistentes que el sistema promete producir
   - Hace posible la automatización y consultas confiables
   - Video: Bases de datos Notion con campos definidos
   - Tu proyecto: Tablas MySQL con esquema estricto

4. **The Filing Cabinet** (Almacenamiento)
   - Donde el sistema escribe hechos para reutilización
   - Debe ser escribible por automatización y legible por humanos
   - Video: Notion (4 databases: People, Projects, Ideas, Admin)
   - Tu proyecto: MySQL con tipo JSON híbrido

5. **The Receipt** (Registro de Auditoría)
   - Log de lo que entró, qué hizo el sistema, nivel de confianza
   - Construye confianza a través de visibilidad
   - Video: Base de datos "Inbox Log" en Notion
   - Tu proyecto: Logs estructurados en n8n + MySQL

6. **The Bouncer** (Filtro de Confianza)
   - Previene que outputs de baja calidad contaminen el sistema
   - Confidence score: si < 0.6, no archiva, pide clarificación
   - Video: Confidence threshold en clasificación de IA
   - Tu proyecto: JSON Schema Enforcement garantiza calidad desde origen

7. **The Tap on the Shoulder** (Notificación Proactiva)
   - Sistema empuja información útil en el momento correcto
   - Video: Digest diario (Slack DM) + revisión semanal (domingos)
   - Tu proyecto: Comandos de Telegram para recuperación inteligente

8. **The Fix Button** (Corrección Fácil)
   - Mecanismo de un paso para corregir errores
   - Video: Responder "fix: esto debería ser X" en Slack
   - Tu proyecto: Interacción directa vía Telegram

#### Los 12 Principios de Ingeniería (Traducidos para No-Ingenieros)

El video enseña principios arquitectónicos que históricamente requerían ingenier@s senior:

1. **Reduce la tarea humana a UN comportamiento confiable**
   - Si requiere 3 comportamientos, no es un sistema, es un programa de auto-mejora
   - Humano: captura. Sistema: clasifica, archiva, notifica

2. **Separa memoria, compute e interfaz**
   - Memoria: Notion (video) / MySQL (tu proyecto)
   - Compute: Zapier + Claude (video) / n8n + Gemini (tu proyecto)
   - Interfaz: Slack (video) / Telegram (tu proyecto)
   - Ventaja: puedes intercambiar componentes sin rebuilding

3. **Trata prompts como APIs, no como escritura creativa**
   - Prompt = contrato con formato fijo de entrada/salida
   - "Return JSON only, no explanation, no markdown"
   - Video: JSON schema en Claude/GPT
   - Tu proyecto: JSON Schema Enforcement nativo en Gemini 2.5 Flash

4. **Construye mecanismo de confianza, no solo capacidad**
   - Capacidad: "El bot archiva notas"
   - Confianza: "Creo en el archivo lo suficiente para seguir usándolo"
   - Viene de: inbox log, confidence scores, fix button

5. **Default a comportamiento seguro cuando hay incertidumbre**
   - Cuando IA no está segura: log + pedir clarificación
   - No archiva con baja confianza, mantiene calidad

6. **Output pequeño, frecuente y accionable**
   - Digest diario: <150 palabras
   - Revisión semanal: <250 palabras
   - Cabe en pantalla de teléfono, se lee en 2 minutos

7. **Usa "next action" como unidad de ejecución**
   - "Trabajar en website" ❌ (no ejecutable)
   - "Email Sarah para confirmar deadline del copy" ✅ (ejecutable)
   - Base de datos debe tener campo "next_action"

8. **Prefiere routing sobre organizing**
   - Humanos odian organizar, aman tirar cosas en una caja
   - IA es buena ruteando
   - Video: 4 categorías (People, Projects, Ideas, Admin)
   - Tu proyecto: Clasificación automática por Gemini

9. **Mantén categorías y campos dolorosamente pequeños**
   - Riqueza crea fricción, fricción mata adopción
   - Empieza simple, agrega complejidad solo cuando haya evidencia
   - Video: 4-5 campos máximo por base de datos

10. **Diseña para restart, no para perfección**
    - Sistema asume que usuarios se desconectarán
    - Debe ser fácil retomar sin culpa o cleanup
    - "No te pongas al día, solo reinicia"

11. **Construye un workflow core, luego agrega módulos**
    - Core loop: captura → clasifica → archiva → digest
    - Módulos opcionales después: voice capture, calendar integration, etc.

12. **Optimiza para maintainability sobre cleverness**
    - Menos herramientas, menos pasos, logs claros
    - Cuando Zapier falla, arreglar en 5 min, no debuggear 1 hora
    - Tu proyecto: n8n visual facilita debugging

#### Comparación: Video vs Tu Proyecto

| Aspecto | Video (Slack+Notion+Zapier+Claude) | Tu Proyecto (Telegram+n8n+MySQL+Gemini) |
|---------|--------------------------------------|------------------------------------------|
| **Target** | No-ingenieros, setup en 1 hora | Desarrolladores, sistema personalizable |
| **Captura** | Slack (corporativo) | Telegram (ubicuo, multimodal) |
| **Storage** | Notion (visual, SaaS) | MySQL (auto-hospedado, híbrido JSON) |
| **Automatización** | Zapier (no-code, caro) | n8n (auto-hospedable, Docker) |
| **IA** | Claude/GPT (API externa) | Gemini 2.5 Flash (JSON Schema nativo) |
| **Ventaja Video** | Setup rápido, interfaz conocida | - |
| **Ventaja Tu Proyecto** | Privacidad total, latencia <1s, más potente, multimodal nativo | |
| **Filosofía** | Reduce fricción al máximo | Sistema agéntico completo con razonamiento |

#### Insights Clave del Video para Tu Proyecto

1. **Validación de arquitectura**: Tu diseño ya implementa los 8 building blocks correctamente
2. **Mejora sugerida**: Agregar "confidence score" explícito en respuestas de Gemini
3. **Feature idea**: Implementar "fix button" vía comandos de Telegram (ej: `/fix última entrada debería ser Tarea`)
4. **Digest system**: Considerar agregar digest diario/semanal vía Telegram
5. **Principio aplicable**: "Next action" como campo obligatorio en tabla de Proyectos

#### Por Qué Tu Stack es Superior

1. **Gemini 2.5 Flash**: JSON Schema Enforcement nativo (el video aún necesita validación post-generación)
2. **Telegram**: Soporte multimodal nativo (audio, imágenes) vs solo texto en Slack
3. **n8n auto-hospedado**: Privacidad total + costo cero vs Zapier $20-100/mes
4. **MySQL**: Full-text search nativo + tipo JSON vs Notion limitado
5. **Latencia**: <1 segundo (Gemini optimizado) vs varios segundos (API calls múltiples)

#### Conclusión del Video

El video argumenta que 2026 es el momento histórico donde **cualquier persona puede construir sistemas que antes requerían ingenieros principales**. Los LLMs + no-code tools + bases de datos modernas convergen para democratizar la construcción de "second brains" agénticos.

Tu proyecto va más allá: **no solo democratiza, sino que optimiza** usando el stack tecnológico correcto (Telegram + n8n + MySQL + Gemini) para máxima privacidad, velocidad y capacidad cognitiva.

### Metodología Base: Building a Second Brain (BASB) por Tiago Forte

**Building a Second Brain** es un sistema revolucionario de gestión del conocimiento personal (PKM - Personal Knowledge Management) desarrollado por Tiago Forte, experto destacado en el campo emergente de PKM. La metodología transforma el caos digital de información diaria en claridad creativa y acción efectiva.

#### El Método CODE

La columna vertebral del sistema BASB es el **método CODE**:

1. **C - Capture (Capturar)**
   - **Tradicional**: Capturar manualmente ideas que resuenan con nosotros
   - **Automatizado**: Enviar cualquier tipo de mensaje (texto, audio, imagen) a Telegram
   - **Ventaja**: Fricción casi nula - captura en el momento sin interrumpir el flujo

2. **O - Organize (Organizar)**
   - **Tradicional**: Clasificar manualmente en proyectos, áreas, recursos y archivos
   - **Automatizado**: Gemini 2.5 Flash analiza semánticamente y clasifica automáticamente
   - **Ventaja**: Elimina la carga cognitiva de decidir "¿dónde va esto?"

3. **D - Distill (Destilar)**
   - **Tradicional**: Crear resúmenes progresivos manualmente
   - **Automatizado**: Gemini extrae automáticamente metadatos, insights clave y contexto
   - **Ventaja**: Procesamiento inmediato mientras la idea está fresca

4. **E - Express (Expresar)**
   - **Tradicional**: Crear y compartir activamente el conocimiento almacenado
   - **Semi-automatizado**: Recuperación estructurada desde MySQL mediante consultas inteligentes
   - **Ventaja**: Acceso instantáneo a conocimiento relevante cuando se necesita

#### El Método PARA

Complementario al método CODE, **PARA** organiza el contenido del Segundo Cerebro:

- **P**rojects (Proyectos): Esfuerzos a corto plazo con objetivo definido
- **A**reas: Responsabilidades a largo plazo que requieren mantenimiento
- **R**esources (Recursos): Temas de interés continuo
- **A**rchive (Archivo): Elementos inactivos de las tres categorías anteriores

**Implementación en el Sistema**: Las tablas MySQL y la clasificación de Gemini siguen esta estructura para garantizar organización consistente.

#### Diferencia Clave: Sistema Pasivo vs Sistema Agéntico

**Sistema BASB Tradicional (Pasivo)**:
- Requiere intervención manual en cada fase
- El usuario debe recordar organizar y destilar
- Alta fricción cognitiva → abandono frecuente

**Sistema Automatizado con IA (Agéntico)**:
- Automatiza fases cognitivamente costosas (Organize + Distill)
- Usuario solo captura → sistema procesa inteligentemente
- Baja fricción → uso sostenible a largo plazo

### Convergencia Tecnológica 2025-2026

El diseño aprovecha la convergencia de tres avances tecnológicos:

1. **LLMs de Nueva Generación** (Gemini 2.5 Flash):
   - Razonamiento complejo con latencia de respuesta < 1 segundo
   - JSON Schema Enforcement nativo (salida estructurada garantizada)
   - Capacidades multimodales (texto, audio, imágenes)

2. **Plataformas Low-Code Maduras** (n8n):
   - Auto-hospedables para privacidad total
   - Integraciones nativas con APIs modernas
   - Lógica visual compleja sin programación

3. **Bases de Datos Híbridas** (MySQL):
   - Tipo JSON nativo + estructura relacional
   - Full-text search sin dependencias externas
   - Escalabilidad probada para millones de registros

### Fuentes de Información

- [Building a Second Brain - Sitio Oficial](https://www.buildingasecondbrain.com/)
- [Resumen del Método CODE - StoryShots](https://www.getstoryshots.com/books/building-a-second-brain-summary/)
- [Revisión Digital de Building a Second Brain](https://dmb-shanghai.com/marketing/building-a-second-brain-tiago-forte-review/)
- [Guía de Segundo Cerebro Digital - Web Highlights](https://web-highlights.com/blog/building-a-digital-second-brain-the-ultimate-guide-to-unlock-creativity/)
- [Curso Building a Second Brain Foundation](https://www.buildingasecondbrain.com/foundation)

## Consideraciones de Implementación

### Seguridad y Privacidad
- Auto-hospedaje de n8n y MySQL recomendado
- Lista blanca de usuarios en n8n para validación
- Datos personales bajo custodia exclusiva del usuario
- Sin almacenamiento en clouds de terceros

### Escalabilidad
- Gemini 2.5 Flash optimizado para uso intensivo "always-on"
- Connection pooling automático en n8n
- Indexación eficiente en MySQL para búsquedas rápidas
- Arquitectura permite expansión a bases de datos vectoriales

### Mantenimiento
- Flujos de trabajo visuales en n8n facilitan debugging
- JSON Schema Enforcement reduce necesidad de validación compleja
- Logs estructurados en n8n para auditoría
- Backups regulares de MySQL recomendados

## Próximos Pasos Sugeridos

1. **Prototipo MVP**: Implementar flujo básico Telegram → n8n → MySQL
2. **Ingeniería de Prompts**: Refinar prompts de Gemini para clasificación precisa
3. **Esquema de DB**: Implementar tablas MySQL según diseño en documento
4. **Testing**: Validar JSON Schema Enforcement con casos edge
5. **Interfaz de Consulta**: Desarrollar comandos de Telegram para recuperación de información
6. **Mejoras Futuras**: Integración de búsqueda vectorial para recuperación semántica avanzada

## Skills y Herramientas Relevantes

### Skills Claude Code Disponibles
- **n8n-workflow**: Crear y optimizar workflows de n8n
- **docx**: Manipulación de documentos Word
- **n8n-specialist**: Especialista en n8n con conocimiento de v6.8+

### MCPs Configurados
- **n8n-mcp**: Acceso directo a instancia n8n para gestión de workflows
- **n8n-mcp-docs**: Documentación oficial de n8n
- **n8n-workflows-docs**: Biblioteca de workflows de ejemplo

### Comandos Útiles

```bash
# Acceder a instancia n8n (si está configurada)
# URL: https://n8n-n8n.yhnmlz.easypanel.host

# Activar especialista n8n
/n8n

# Trabajar con documentos DOCX
# El skill 'docx' está disponible automáticamente
```

## Notas Adicionales

- Este es un proyecto de **diseño e investigación** en fase conceptual
- El documento técnico proporciona especificaciones detalladas para implementación
- La arquitectura está diseñada para ser extensible y escalable
- Prioriza privacidad, velocidad y precisión semántica
- Diseñado para uso personal intensivo con latencia mínima

---

**Contexto Global**: Este proyecto se beneficia del sistema universal de agentes Claude Code. Puede usar `@project-coordinator` para setup inicial o `@agent-factory` para crear especialistas dinámicos (n8n-specialist, python-specialist) según necesidades específicas de implementación.
