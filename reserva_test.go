package reservas

import "testing"

func TestSeSuperponen(t *testing.T) {
    pruebas := []struct {
        nombre   string
        a, b     Reserva
        esperado bool
    }{
        {
            nombre: "Horarios superpuestos",
            a: Reserva{Inicio: 10, Fin: 12},
            b: Reserva{Inicio: 11, Fin: 13},
            esperado: true,
        },
        {
            nombre: "Horarios consecutivos",
            a: Reserva{Inicio: 10, Fin: 12},
            b: Reserva{Inicio: 12, Fin: 13},
            esperado: false,
        },
        {
            nombre: "Horarios separados",
            a: Reserva{Inicio: 8, Fin: 9},
            b: Reserva{Inicio: 11, Fin: 12},
            esperado: false,
        },
        {
            nombre: "Horarios iguales",
            a: Reserva{Inicio: 10, Fin: 12},
            b: Reserva{Inicio: 10, Fin: 12},
            esperado: true,
        },
        {
            nombre: "Reserva dentro de otra",
            a: Reserva{Inicio: 9, Fin: 15},
            b: Reserva{Inicio: 11, Fin: 13},
            esperado: true,
        },
    }

    for _, p := range pruebas {
        t.Run(p.nombre, func(t *testing.T) {
            obtenido := SeSuperponen(p.a, p.b)
            if obtenido != p.esperado {
                t.Errorf("obtenido %v; esperado %v", obtenido, p.esperado)
            }
        })
    }
}
