# Práctica XP: reservas superpuestas

Proyecto demostrativo para **Tema 3 — Extreme Programming: calidad técnica y modelado evolutivo**.
La guía de exposición del equipo explica el guion de las diapositivas. Este directorio incluye **código Go ejecutable**, tres estados TDD y **SQL opcional** para PostgreSQL.

## Lo que se necesita

- Go 1.22 o superior (comprobar con `go version`).
- Visual Studio Code o cualquier editor y una terminal.
- Para la evidencia de integración continua: Git, una cuenta y un repositorio de GitHub.
- PostgreSQL + pgAdmin **solo si quieren ejecutar el ejemplo SQL opcional**. No se necesita para Go.

## Paso a paso: práctica principal en Go

**Importante:** antes de cada etapa, abrir una terminal en la carpeta principal `Practica_XP_Reservas`.

### 1) ROJO — fallo intencional

En Git Bash de Windows, macOS o Linux:

```bash
bash scripts/cambiar_etapa.sh rojo
```

Se copia la versión incorrecta de la función al archivo raíz `reserva.go`, se ejecutan las cinco pruebas y se espera que **FALLEN tres**. Captura 1: terminal con `FAIL` y los casos superpuestos. En esta etapa el comando acaba con código de salida 1: es normal.

### 2) VERDE — solución correcta

```bash
bash scripts/cambiar_etapa.sh verde
```

Se activa una función correcta con dos condiciones. Deben pasar las cinco pruebas. Captura 2: terminal con `PASS`.

### 3) REFACTOR — mismo comportamiento, código más simple

```bash
bash scripts/cambiar_etapa.sh refactor
```

Se cambia por una expresión lógica única. Deben seguir pasando las cinco pruebas. Captura 3: mostrar el antes/después y la ejecución correcta.

### 4) Mostrar el resultado en consola (opcional)

```bash
go run ./cmd/demo
```

Con la versión final debe indicar `true` en el cruce 10–12 / 11–13 y `false` en el horario consecutivo 10–12 / 12–13.

### 5) Ejecutar pruebas de forma manual

```bash
go test -count=1 -v ./...
```

`-count=1` evita usar resultados cacheados de pruebas.

## Integración continua (CI)

El archivo `.github/workflows/pruebas.yml` ejecuta las pruebas automáticamente al hacer `push` o abrir un `pull_request` en GitHub.

**Dejar activa la etapa REFACTOR antes de subir el código.**

```bash
bash scripts/cambiar_etapa.sh refactor
git init
git add .
git commit -m "Agregar demostracion XP con TDD"
git branch -M main
```

Luego, crear en GitHub un repositorio **vacío**, copiar su URL real y ejecutar (sustituir la URL):

```bash
git remote add origin https://github.com/TU-USUARIO/xp-reservas-demo.git
git push -u origin main
```

Ir a la pestaña **Actions** en GitHub, abrir la ejecución `Pruebas XP con Go` y hacer una captura real del resultado. Si `git commit` reclama identidad, configurar `git config --global user.name "Nombre"` y `git config --global user.email "correo@example.com"` con datos propios.

## SQL opcional con pgAdmin (PostgreSQL)

No hay conexión entre `reserva.go` y la base SQL; son **dos maneras independientes de mostrar la misma regla**. El SQL es una demostración adicional, no lo exige el código Go de la guía.

**Opción fácil (un solo archivo):** abrir `sql/00_demo_completa.sql` en pgAdmin y ejecutarlo. Crea la tabla de prueba, inserta los tres casos válidos, verifica que la reserva superpuesta sea rechazada y muestra resultados. Revisar el aviso `PRUEBA OK` en la pestaña Messages. Para una captura de ERROR explícito, ejecutar por separado `sql/03_error_esperado.sql` después del archivo completo.

**Opción paso a paso:**

1. En pgAdmin, conectar a una base de datos de pruebas; no ejecutar sobre una base productiva.
2. En Query Tool, abrir y ejecutar **`sql/01_crear_esquema.sql`**. Crea la tabla `xp_demo.reservas` con restricción de no solapamiento. **Reinicia esa tabla si ya existía.**
3. Ejecutar **`sql/02_insertar_validas.sql`**: deben insertarse tres reservas válidas.
4. Ejecutar **`sql/03_error_esperado.sql`** por separado: debe mostrar un error de restricción (`23P01`) al intentar guardar una reserva que choca con otra del mismo recurso. **Ese error es intencional**; guardar una captura.
5. Ejecutar **`sql/04_verificar_sin_error.sql`** por separado para revisar los conflictos sin provocar errores.

La restricción SQL usa `INT4RANGE` con intervalos semiabiertos `[inicio, fin)`, el operador `&&` y la extensión `btree_gist` para controlar el recurso. Un recurso diferente puede tener un horario coincidente.

## Qué entregar / capturas

- **Captura 1:** prueba Go fallida (ROJO).
- **Captura 2:** pruebas Go aprobadas (VERDE).
- **Captura 3:** cambio de código antes/después (REFACTOR) y pruebas aprobadas.
- **Captura 4:** ejecución real en GitHub Actions (CI).
- Registro de parejas: llenar `registro_parejas.txt` con nombres y acciones **reales**.
- SQL: opcional; agregar captura del error SQL solo si lo realizaron.
- Completar síntesis de 1–2 páginas, nombres, aportes, bibliografía, repositorio y grabación de 5–7 minutos según consigna.

## Referencias oficiales

- Go, pruebas: https://go.dev/doc/tutorial/add-a-test
- GitHub Actions, Go: https://docs.github.com/en/actions/tutorials/build-and-test-code/go
- PostgreSQL, rangos: https://www.postgresql.org/docs/current/rangetypes.html
- PostgreSQL, restricciones: https://www.postgresql.org/docs/current/ddl-constraints.html

**No presenta pruebas como ejecutadas por los integrantes**: las capturas deben obtenerlas ustedes y consignar fechas y roles reales.
