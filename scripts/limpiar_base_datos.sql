-- =====================================================
-- Script de Limpieza de Base de Datos
-- Segundo Cerebro - v018
-- =====================================================
--
-- ADVERTENCIA: Este script ELIMINA TODOS LOS DATOS
-- de las tablas de usuario. Úsalo solo si quieres
-- empezar de cero con datos reales.
--
-- BACKUP RECOMENDADO ANTES DE EJECUTAR:
-- mysqldump -u root -p segundo_cerebro > backup_$(date +%Y%m%d_%H%M%S).sql
--
-- INSTRUCCIONES DE USO:
-- 1. Hacer backup (comando arriba)
-- 2. Editar este archivo y descomentar las líneas TRUNCATE
-- 3. Ejecutar: mysql -u root -p segundo_cerebro < scripts/limpiar_base_datos.sql
--
-- =====================================================

USE segundo_cerebro;

-- Verificar conexión y base de datos actual
SELECT DATABASE() as 'Base de datos activa';

-- =====================================================
-- PASO 1: Mostrar cantidad de registros ANTES de borrar
-- =====================================================

SELECT
    '=====================================' as separador;

SELECT
    'ANTES DE BORRAR' as momento,
    (SELECT COUNT(*) FROM tareas) as tareas,
    (SELECT COUNT(*) FROM proyectos) as proyectos,
    (SELECT COUNT(*) FROM ideas) as ideas,
    (SELECT COUNT(*) FROM personas) as personas,
    (SELECT COUNT(*) FROM inbox_log) as inbox_log;

SELECT
    '=====================================' as separador;

-- =====================================================
-- PASO 2: BORRAR DATOS (DESCOMENTAR PARA EJECUTAR)
-- =====================================================

-- ⚠️ IMPORTANTE: Descomenta las siguientes líneas SOLO si estás seguro

-- TRUNCATE TABLE tareas;
-- TRUNCATE TABLE proyectos;
-- TRUNCATE TABLE ideas;
-- TRUNCATE TABLE personas;
-- TRUNCATE TABLE inbox_log;

-- =====================================================
-- PASO 3: Mostrar cantidad de registros DESPUÉS de borrar
-- =====================================================

-- Descomenta las siguientes líneas después de ejecutar TRUNCATE:

-- SELECT
--     '=====================================' as separador;
--
-- SELECT
--     'DESPUÉS DE BORRAR' as momento,
--     (SELECT COUNT(*) FROM tareas) as tareas,
--     (SELECT COUNT(*) FROM proyectos) as proyectos,
--     (SELECT COUNT(*) FROM ideas) as ideas,
--     (SELECT COUNT(*) FROM personas) as personas,
--     (SELECT COUNT(*) FROM inbox_log) as inbox_log;
--
-- SELECT
--     '=====================================' as separador;

-- =====================================================
-- PASO 4: Resetear auto_increment (OPCIONAL)
-- =====================================================

-- Resetea los contadores de ID a 1 para empezar desde cero
-- Descomenta si quieres que los nuevos registros empiecen en id=1

-- ALTER TABLE tareas AUTO_INCREMENT = 1;
-- ALTER TABLE proyectos AUTO_INCREMENT = 1;
-- ALTER TABLE ideas AUTO_INCREMENT = 1;
-- ALTER TABLE personas AUTO_INCREMENT = 1;
-- ALTER TABLE inbox_log AUTO_INCREMENT = 1;

-- =====================================================
-- MENSAJE FINAL
-- =====================================================

SELECT 'Script cargado correctamente.' as estado;
SELECT 'Descomenta las líneas TRUNCATE para ejecutar el borrado.' as instruccion;
SELECT 'Recuerda hacer backup antes de ejecutar!' as advertencia;

-- =====================================================
-- INFORMACIÓN ADICIONAL
-- =====================================================

-- Para verificar que las tablas están vacías después del borrado,
-- ejecuta desde el bot de Telegram:
--
-- "qué tareas tengo"
-- "lista de proyectos"
-- "ver mis ideas"
-- "lista de personas"
--
-- Todas deberían responder: "No hay [categoría] registradas"

-- =====================================================
-- EJEMPLO DE USO COMPLETO
-- =====================================================

-- 1. Hacer backup:
--    mysqldump -u root -p segundo_cerebro > backup_antes_limpiar.sql
--
-- 2. Ejecutar este script SIN modificarlo (muestra estadísticas):
--    mysql -u root -p segundo_cerebro < scripts/limpiar_base_datos.sql
--
-- 3. Editar este archivo y descomentar líneas TRUNCATE
--
-- 4. Ejecutar de nuevo:
--    mysql -u root -p segundo_cerebro < scripts/limpiar_base_datos.sql
--
-- 5. Verificar desde Telegram:
--    "qué tareas tengo" → debe decir "No hay tareas registradas"

-- =====================================================
-- TROUBLESHOOTING
-- =====================================================

-- Problema: "ERROR 1227 (42000): Access denied"
-- Solución: Usa el usuario root o un usuario con permisos TRUNCATE:
--           mysql -u root -p segundo_cerebro < scripts/limpiar_base_datos.sql

-- Problema: "ERROR 1146 (42S02): Table doesn't exist"
-- Solución: Verifica que estás en la base de datos correcta:
--           USE segundo_cerebro;
--           SHOW TABLES;

-- Problema: "No puedo conectarme a MySQL"
-- Solución: Verifica que MySQL esté corriendo:
--           sudo systemctl status mysql
--           sudo systemctl start mysql

-- =====================================================
-- FIN DEL SCRIPT
-- =====================================================
