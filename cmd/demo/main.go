package main

import (
    "fmt"
    reservas "example.com/xp-reservas"
)

func main() {
    casos := []struct{
        nombre string
        a, b reservas.Reserva
    }{
        {"Cruce 10-12 / 11-13", reservas.Reserva{Inicio:10, Fin:12}, reservas.Reserva{Inicio:11, Fin:13}},
        {"Consecutivas 10-12 / 12-13", reservas.Reserva{Inicio:10, Fin:12}, reservas.Reserva{Inicio:12, Fin:13}},
    }
    for _, c := range casos {
        fmt.Printf("%s -> ¿superpuestas?: %v\n", c.nombre, reservas.SeSuperponen(c.a, c.b))
    }
}
