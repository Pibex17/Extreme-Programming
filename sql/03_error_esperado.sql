-- Ejecutar DESPUES de 01 y 02, por separado.
-- Error esperado: SQLSTATE 23P01, conflicting key value violates exclusion constraint.
-- Demuestra que NO se puede guardar 11-13 en el recurso 1 porque ya existe 10-12.
INSERT INTO xp_demo.reservas (recurso_id, inicio, fin) VALUES (1, 11, 13);
