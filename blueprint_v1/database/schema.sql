-- ======================================================
-- SCRIPT DE CREACIÓN: SISTEMA SEGUNDO CEREBRO (v1.0)
-- Descripción: Creación de tablas para el Core Loop (MVP)
-- Arquitecto: Gemini Agent
-- ======================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- 1. TABLA DE AUDITORÍA: inbox_log
-- Guarda el rastro de todo lo que entra al sistema.
CREATE TABLE IF NOT EXISTS inbox_log (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    fecha_recepcion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    canal_origen VARCHAR(50) DEFAULT 'telegram',
    usuario_id VARCHAR(100),
    mensaje_crudo TEXT,
    payload_json JSON,
    estado ENUM('pendiente', 'procesado', 'error', 'requiere_revision') DEFAULT 'pendiente',
    categoria_asignada VARCHAR(50),
    confianza_ia DECIMAL(4,3),
    razonamiento_ia TEXT,
    error_log TEXT,
    INDEX idx_estado (estado),
    INDEX idx_fecha (fecha_recepcion)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2. TABLA: personas
-- CRM Ligero para gestión de contactos y clientes.
CREATE TABLE IF NOT EXISTS personas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    relacion VARCHAR(100),
    ultimo_contacto DATETIME,
    datos_contacto JSON,
    perfil_ia JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FULLTEXT INDEX idx_fulltext_nombre (nombre)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 3. TABLA: proyectos
-- Contenedores para agrupar tareas e ideas.
CREATE TABLE IF NOT EXISTS proyectos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    estado ENUM('activo', 'en_espera', 'completado', 'cancelado') DEFAULT 'activo',
    fecha_limite DATE,
    persona_relacionada_id INT,
    metadata JSON,
    resumen_ia TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_proyecto_persona FOREIGN KEY (persona_relacionada_id) 
        REFERENCES personas(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 4. TABLA: ideas
-- Repositorio de conocimiento, recursos y notas personales.
CREATE TABLE IF NOT EXISTS ideas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    contenido TEXT,
    tipo ENUM('nota', 'recurso', 'aprendizaje', 'diario') DEFAULT 'nota',
    tags JSON,
    origen_url VARCHAR(512),
    proyecto_relacionado_id INT,
    procesado_vectorial BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_idea_proyecto FOREIGN KEY (proyecto_relacionado_id) 
        REFERENCES proyectos(id) ON DELETE SET NULL,
    FULLTEXT INDEX idx_fulltext_idea (titulo, contenido)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 5. TABLA: tareas
-- Acciones ejecutables (Next Actions).
CREATE TABLE IF NOT EXISTS tareas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    estado ENUM('pendiente', 'en_progreso', 'completada', 'descartada') DEFAULT 'pendiente',
    prioridad ENUM('baja', 'media', 'alta', 'urgente') DEFAULT 'media',
    fecha_vencimiento DATETIME,
    persona_relacionada_id INT,
    proyecto_relacionado_id INT,
    contexto_adicional JSON,
    completada_en TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_tarea_persona FOREIGN KEY (persona_relacionada_id) 
        REFERENCES personas(id) ON DELETE SET NULL,
    CONSTRAINT fk_tarea_proyecto FOREIGN KEY (proyecto_relacionado_id) 
        REFERENCES proyectos(id) ON DELETE SET NULL,
    FULLTEXT INDEX idx_fulltext_tarea (titulo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SET FOREIGN_KEY_CHECKS = 1;
