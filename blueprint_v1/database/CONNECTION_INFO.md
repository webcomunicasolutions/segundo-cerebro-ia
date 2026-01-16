# 🔌 Información de Conexión MySQL - Segundo Cerebro

**Fecha de Setup**: 13 de enero de 2026
**Estado**: ✅ Operativo y validado

---

## 📊 Detalles del Servidor

```yaml
Host: 188.213.5.193
Puerto: 3306
Base de Datos: segundo_cerebro
Usuario: mysql
Charset: utf8mb4
Collation: utf8mb4_unicode_ci
```

**⚠️ Nota de Seguridad**: La contraseña NO está incluida en este repositorio por razones de seguridad. Se encuentra almacenada de forma segura.

---

## 🗄️ Estructura de Base de Datos

### Tablas Creadas (5 tablas)

| # | Tabla | Propósito | Registros Test |
|---|-------|-----------|----------------|
| 1 | `inbox_log` | Auditoría de todo lo que entra al sistema | 2 |
| 2 | `personas` | CRM ligero de contactos y clientes | 2 |
| 3 | `proyectos` | Contenedores de esfuerzos a corto plazo | 2 |
| 4 | `ideas` | Repositorio de conocimiento y recursos | 2 |
| 5 | `tareas` | Acciones ejecutables (Next Actions) | 3 |

**Total de registros de prueba**: 11

---

## ✅ Validaciones Realizadas

### 1. Creación de Tablas
```sql
✅ inbox_log    - Tabla de auditoría con JSON y ENUM
✅ personas     - CRM con FULLTEXT index
✅ proyectos    - Contenedores con Foreign Keys
✅ ideas        - Repositorio con FULLTEXT index
✅ tareas       - Acciones con Foreign Keys múltiples
```

### 2. Tipos de Datos Especiales
```sql
✅ JSON nativo        - datos_contacto, perfil_ia, metadata, tags, contexto_adicional
✅ ENUM              - estado, prioridad, tipo
✅ FULLTEXT INDEX    - nombre (personas), titulo+contenido (ideas), titulo (tareas)
✅ Foreign Keys      - Relaciones entre personas, proyectos y tareas
✅ Timestamps        - created_at, updated_at con AUTO UPDATE
```

### 3. Inserciones de Prueba
Datos insertados correctamente:
- ✅ 2 entradas en `inbox_log` (captura de mensajes)
- ✅ 2 personas (Juan García - Cliente, María López - Proveedor)
- ✅ 2 proyectos (Sistema Segundo Cerebro, Migración Cloud)
- ✅ 2 ideas (Metodología BASB, Feature calendario)
- ✅ 3 tareas (Comprar leche, Email a Juan, Workflow n8n)

### 4. Relaciones (JOINs) Funcionando
```sql
SELECT t.titulo, t.prioridad, p.nombre AS persona, pr.nombre AS proyecto
FROM tareas t
LEFT JOIN personas p ON t.persona_relacionada_id = p.id
LEFT JOIN proyectos pr ON t.proyecto_relacionado_id = pr.id
ORDER BY t.prioridad DESC;
```

**Resultado**:
| Tarea | Prioridad | Persona | Proyecto |
|-------|-----------|---------|----------|
| Crear workflow de Telegram en n8n | urgente | NULL | Sistema Segundo Cerebro con IA |
| Enviar email a Juan García con propuesta | alta | Juan García | Sistema Segundo Cerebro con IA |
| Comprar leche | media | NULL | NULL |

---

## 🔗 String de Conexión (para n8n)

```
mysql://mysql:[PASSWORD]@188.213.5.193:3306/segundo_cerebro
```

**Variables para n8n Credentials**:
```yaml
Type: MySQL
Host: 188.213.5.193
Port: 3306
Database: segundo_cerebro
User: mysql
Password: [ALMACENADO DE FORMA SEGURA]
SSL: false
```

---

## 📝 Comandos Útiles

### Conectar desde CLI
```bash
mysql -h 188.213.5.193 -P 3306 -u mysql -p segundo_cerebro
```

### Backup de la Base de Datos
```bash
mysqldump -h 188.213.5.193 -P 3306 -u mysql -p segundo_cerebro > backup_segundo_cerebro_$(date +%Y%m%d).sql
```

### Restaurar desde Backup
```bash
mysql -h 188.213.5.193 -P 3306 -u mysql -p segundo_cerebro < backup_segundo_cerebro_YYYYMMDD.sql
```

### Verificar Estado de Tablas
```bash
mysql -h 188.213.5.193 -P 3306 -u mysql -p segundo_cerebro -e "SHOW TABLES; SELECT COUNT(*) FROM inbox_log; SELECT COUNT(*) FROM personas; SELECT COUNT(*) FROM proyectos; SELECT COUNT(*) FROM ideas; SELECT COUNT(*) FROM tareas;"
```

---

## 🚀 Próximos Pasos (FASE 2)

Con la base de datos operativa, ahora podemos proceder a:

1. **Crear Bot de Telegram** (BotFather)
2. **Configurar credenciales en n8n**
3. **Crear primer workflow**: Telegram → n8n → MySQL
4. **Probar inserción desde Telegram** a tabla `inbox_log`

---

## 📊 Capacidades Actuales del Sistema

| Capacidad | Estado | Detalles |
|-----------|--------|----------|
| Almacenamiento estructurado | ✅ | 5 tablas con esquema completo |
| Soporte JSON | ✅ | Campos JSON nativos funcionando |
| Búsqueda full-text | ✅ | Índices FULLTEXT en nombres y contenido |
| Relaciones entre entidades | ✅ | Foreign Keys operativas |
| Auditoría completa | ✅ | Tabla inbox_log registra todo |
| Soft delete | ✅ | Campo completada_en en tareas |
| Timestamps automáticos | ✅ | created_at y updated_at |
| Soporte multiidioma | ✅ | UTF8MB4 con emojis 🎉 |

---

**FASE 1 (Cimientos): ✅ COMPLETADA**

Base de datos segundo_cerebro creada, validada y lista para producción.
