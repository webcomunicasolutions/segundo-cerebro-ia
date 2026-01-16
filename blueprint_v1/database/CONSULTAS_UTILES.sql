-- ======================================================
-- CONSULTAS ÚTILES: SISTEMA SEGUNDO CEREBRO
-- ======================================================

-- 1. VER TODAS LAS TAREAS DE UN PROYECTO CON SUS RESPONSABLES
SELECT
    t.titulo AS tarea,
    t.prioridad,
    t.estado,
    DATE_FORMAT(t.fecha_vencimiento, '%d/%m/%Y %H:%i') AS vencimiento,
    COALESCE(p.nombre, '(Sin asignar)') AS responsable,
    pr.nombre AS proyecto
FROM tareas t
LEFT JOIN personas p ON t.persona_relacionada_id = p.id
LEFT JOIN proyectos pr ON t.proyecto_relacionado_id = pr.id
WHERE pr.id = 1  -- Cambiar por el ID del proyecto
ORDER BY t.prioridad DESC, t.fecha_vencimiento ASC;

-- 2. VER TODOS LOS PROYECTOS DE UN CLIENTE/PERSONA
SELECT
    p.nombre AS cliente,
    p.relacion,
    pr.nombre AS proyecto,
    pr.estado,
    pr.fecha_limite,
    COUNT(t.id) AS total_tareas,
    SUM(CASE WHEN t.estado = 'completada' THEN 1 ELSE 0 END) AS tareas_completadas,
    SUM(CASE WHEN t.estado = 'pendiente' THEN 1 ELSE 0 END) AS tareas_pendientes
FROM personas p
LEFT JOIN proyectos pr ON pr.persona_relacionada_id = p.id
LEFT JOIN tareas t ON t.proyecto_relacionado_id = pr.id
WHERE p.id = 1  -- Cambiar por el ID de la persona
GROUP BY p.id, pr.id
ORDER BY pr.estado, pr.fecha_limite;

-- 3. DASHBOARD: RESUMEN COMPLETO POR PROYECTO
SELECT
    pr.nombre AS proyecto,
    pr.estado AS estado_proyecto,
    p.nombre AS cliente,
    COUNT(t.id) AS total_tareas,
    SUM(CASE WHEN t.estado = 'completada' THEN 1 ELSE 0 END) AS completadas,
    SUM(CASE WHEN t.estado = 'pendiente' THEN 1 ELSE 0 END) AS pendientes,
    SUM(CASE WHEN t.estado = 'en_progreso' THEN 1 ELSE 0 END) AS en_progreso,
    SUM(CASE WHEN t.prioridad = 'urgente' THEN 1 ELSE 0 END) AS urgentes,
    ROUND(
        (SUM(CASE WHEN t.estado = 'completada' THEN 1 ELSE 0 END) * 100.0) /
        NULLIF(COUNT(t.id), 0),
        2
    ) AS porcentaje_completado
FROM proyectos pr
LEFT JOIN personas p ON pr.persona_relacionada_id = p.id
LEFT JOIN tareas t ON t.proyecto_relacionado_id = pr.id
WHERE pr.estado IN ('activo', 'en_espera')
GROUP BY pr.id
ORDER BY porcentaje_completado DESC;

-- 4. TAREAS VENCIDAS O POR VENCER (próximas 48 horas)
SELECT
    t.titulo AS tarea,
    t.prioridad,
    DATE_FORMAT(t.fecha_vencimiento, '%d/%m/%Y %H:%i') AS vence,
    TIMESTAMPDIFF(HOUR, NOW(), t.fecha_vencimiento) AS horas_restantes,
    p.nombre AS responsable,
    pr.nombre AS proyecto
FROM tareas t
LEFT JOIN personas p ON t.persona_relacionada_id = p.id
LEFT JOIN proyectos pr ON t.proyecto_relacionado_id = pr.id
WHERE t.estado IN ('pendiente', 'en_progreso')
    AND t.fecha_vencimiento IS NOT NULL
    AND t.fecha_vencimiento <= DATE_ADD(NOW(), INTERVAL 48 HOUR)
ORDER BY t.fecha_vencimiento ASC;

-- 5. BUSCAR TAREAS POR PALABRA CLAVE (FULLTEXT)
SELECT
    t.titulo,
    t.prioridad,
    t.estado,
    p.nombre AS responsable,
    pr.nombre AS proyecto,
    MATCH(t.titulo) AGAINST('workflow' IN NATURAL LANGUAGE MODE) AS relevancia
FROM tareas t
LEFT JOIN personas p ON t.persona_relacionada_id = p.id
LEFT JOIN proyectos pr ON t.proyecto_relacionado_id = pr.id
WHERE MATCH(t.titulo) AGAINST('workflow' IN NATURAL LANGUAGE MODE)
ORDER BY relevancia DESC;

-- 6. HISTORIAL DE TAREAS COMPLETADAS POR PERSONA
SELECT
    p.nombre AS persona,
    COUNT(t.id) AS tareas_completadas,
    MIN(t.completada_en) AS primera_completada,
    MAX(t.completada_en) AS ultima_completada
FROM personas p
INNER JOIN tareas t ON t.persona_relacionada_id = p.id
WHERE t.estado = 'completada'
GROUP BY p.id
ORDER BY tareas_completadas DESC;

-- 7. IDEAS RELACIONADAS CON UN PROYECTO
SELECT
    i.titulo AS idea,
    i.tipo,
    i.tags,
    i.origen_url,
    pr.nombre AS proyecto
FROM ideas i
INNER JOIN proyectos pr ON i.proyecto_relacionado_id = pr.id
WHERE pr.id = 1  -- Cambiar por el ID del proyecto
ORDER BY i.created_at DESC;

-- 8. AUDITORIA: ÚLTIMOS MENSAJES PROCESADOS
SELECT
    fecha_recepcion,
    mensaje_crudo,
    categoria_asignada,
    confianza_ia,
    estado,
    razonamiento_ia
FROM inbox_log
ORDER BY fecha_recepcion DESC
LIMIT 10;

-- 9. TODAS LAS TAREAS DE UNA PERSONA (independiente de proyecto)
SELECT
    t.titulo AS tarea,
    t.prioridad,
    t.estado,
    DATE_FORMAT(t.fecha_vencimiento, '%d/%m/%Y') AS vencimiento,
    COALESCE(pr.nombre, '(Sin proyecto)') AS proyecto
FROM tareas t
LEFT JOIN proyectos pr ON t.proyecto_relacionado_id = pr.id
WHERE t.persona_relacionada_id = 1  -- Cambiar por el ID de la persona
    AND t.estado IN ('pendiente', 'en_progreso')
ORDER BY t.prioridad DESC, t.fecha_vencimiento ASC;

-- 10. ESTADÍSTICAS GENERALES DEL SISTEMA
SELECT
    'Total Personas' AS metrica, COUNT(*) AS valor FROM personas
UNION ALL
SELECT 'Total Proyectos Activos', COUNT(*) FROM proyectos WHERE estado = 'activo'
UNION ALL
SELECT 'Total Tareas Pendientes', COUNT(*) FROM tareas WHERE estado = 'pendiente'
UNION ALL
SELECT 'Total Ideas', COUNT(*) FROM ideas
UNION ALL
SELECT 'Mensajes en Inbox Log', COUNT(*) FROM inbox_log;
