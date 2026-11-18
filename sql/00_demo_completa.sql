-- DEMOSTRACION COMPLETA SQL PARA PGADMIN (POSTGRESQL)
-- Ejecutar todo este archivo en Query Tool dentro de una base DE PRUEBAS.
-- No se conecta con el programa de Go: es una demostracion adicional de la misma regla.
-- Requiere PostgreSQL con la extension btree_gist disponible.
-- IMPORTANTE: reinicia solamente la tabla xp_demo.reservas.

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

-- Caso valido 1: reserva de 10 a 12 en recurso 1.
INSERT INTO xp_demo.reservas(recurso_id, inicio, fin) VALUES (1, 10, 12);
-- Caso valido 2: de 12 a 13, contigua pero no superpuesta.
INSERT INTO xp_demo.reservas(recurso_id, inicio, fin) VALUES (1, 12, 13);
-- Caso valido 3: otro recurso, puede tener horario coincidente.
INSERT INTO xp_demo.reservas(recurso_id, inicio, fin) VALUES (2, 11, 13);

-- PRUEBA AUTOMATIZADA EN SQL: la insercion cruzada DEBE ser rechazada.
-- Capturar la pestaña Messages: se espera NOTICE "PRUEBA OK".
DO $$
BEGIN
    BEGIN
        INSERT INTO xp_demo.reservas(recurso_id, inicio, fin)
        VALUES (1, 11, 13);
        RAISE EXCEPTION 'PRUEBA FALLIDA: PostgreSQL acepto un horario superpuesto';
    EXCEPTION WHEN exclusion_violation THEN
        RAISE NOTICE 'PRUEBA OK: PostgreSQL rechazo la reserva superpuesta (SQLSTATE 23P01)';
    END;
END;
$$;

-- Reservas que si quedaron guardadas:
SELECT id, recurso_id, inicio, fin, periodo
FROM xp_demo.reservas
ORDER BY recurso_id, inicio;

-- Prueba de prediccion de choques sin intentar insertar:
WITH casos(nombre, recurso_id, inicio, fin) AS (
    VALUES
        ('Cruce 11-13, recurso 1', 1, 11, 13),
        ('Consecutiva 13-14, recurso 1', 1, 13, 14),
        ('Otro recurso 11-13', 3, 11, 13)
)
SELECT c.nombre,
       EXISTS (
           SELECT 1 FROM xp_demo.reservas r
           WHERE r.recurso_id = c.recurso_id
           AND r.periodo && int4range(c.inicio, c.fin, '[)')
       ) AS habria_conflicto
FROM casos c;
