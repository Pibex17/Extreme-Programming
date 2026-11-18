-- Prueba SQL sin provocar un error: predice el conflicto antes de insertar.
WITH casos(nombre, recurso_id, inicio, fin) AS (
    VALUES
      ('Superpuesta 11-13, recurso 1', 1, 11, 13),
      ('Consecutiva 13-14, recurso 1', 1, 13, 14),
      ('Otro recurso 11-13', 3, 11, 13)
)
SELECT c.nombre,
       EXISTS (
           SELECT 1
           FROM xp_demo.reservas r
           WHERE r.recurso_id = c.recurso_id
             AND r.periodo && int4range(c.inicio, c.fin, '[)')
       ) AS habria_conflicto
FROM casos c;
