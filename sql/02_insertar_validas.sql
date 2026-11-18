-- Ejecutar después de 01_crear_esquema.sql.
INSERT INTO xp_demo.reservas (recurso_id, inicio, fin) VALUES (1, 10, 12);
INSERT INTO xp_demo.reservas (recurso_id, inicio, fin) VALUES (1, 12, 13);
INSERT INTO xp_demo.reservas (recurso_id, inicio, fin) VALUES (2, 11, 13);

SELECT id, recurso_id, inicio, fin, periodo
FROM xp_demo.reservas
ORDER BY recurso_id, inicio;
