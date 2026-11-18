-- DEMO OPCIONAL POSTGRESQL. Ejecutar en Query Tool de pgAdmin.
-- Este SQL NO es obligatorio para las pruebas TDD en Go.
-- ADVERTENCIA: reinicia solo la tabla xp_demo.reservas de esta práctica.
-- La extensión btree_gist puede requerir permisos para instalarse.
CREATE EXTENSION IF NOT EXISTS btree_gist;
CREATE SCHEMA IF NOT EXISTS xp_demo;
DROP TABLE IF EXISTS xp_demo.reservas;

CREATE TABLE xp_demo.reservas (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    recurso_id INTEGER NOT NULL,
    inicio INTEGER NOT NULL,
    fin INTEGER NOT NULL,
    periodo INT4RANGE GENERATED ALWAYS AS (int4range(inicio, fin, '[)')) STORED,
    CONSTRAINT horas_validas CHECK (inicio >= 0 AND fin <= 24 AND inicio < fin),
    CONSTRAINT sin_superposiciones EXCLUDE USING gist (
        recurso_id WITH =,
        periodo WITH &&
    )
);

-- Mismo recurso: no se permiten horarios cruzados.
-- Recursos diferentes: sí pueden coincidir en horario.
