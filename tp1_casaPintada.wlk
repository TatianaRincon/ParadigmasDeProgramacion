object raul {
	var property tarifaPorMetroCuadrado = 70
	var property metrosCuadradosAPintar = aldo.superficieTotalAPintar()
	
	method manoDeObra() = tarifaPorMetroCuadrado * metrosCuadradosAPintar
	method costoDePinturaComun() = pinturaEnLata.costoTotalPinturaEnLata()
	method tarifaTotalPorTrabajoRealizado() = self.manoDeObra() + self.costoDePinturaComun()
	method tarifaTotalPorTrabajoRealizadoConPinturaAGranel() = self.manoDeObra() + pinturaPorMayor.costoTotalPinturaPorMayor()
}

object carla {
	var property tarifaPorMetroCuadrado = 45
	var property metrosCuadradosAPintar = aldo.superficieTotalAPintar()
	
	method costoExtraSegunCantidadDeMetrosCuadrados() = if (metrosCuadradosAPintar <= 25) 2 else 1.50 
	method tarifaTotalPorTrabajoRealizado() = tarifaPorMetroCuadrado * metrosCuadradosAPintar * self.costoExtraSegunCantidadDeMetrosCuadrados()
}

object venancio {
	var property tarifaPorMetroCuadrado = 43
	var property metrosCuadradosAPintar = aldo.superficieTotalAPintar()
	
	method manoDeObra() = tarifaPorMetroCuadrado * metrosCuadradosAPintar
	method costoDePinturaComun() = pinturaEnLata.costoTotalPinturaEnLata()
	method tarifaTotalPorTrabajoRealizado() = self.manoDeObra() + 1/2 * self.costoDePinturaComun()
}

object pinturaEnLata {
	var property precio = 500
	var property rendimiento = 50
	var property metrosCuadradosAPintar = aldo.superficieTotalAPintar()
	
	method cantidadDeLatasAUtilizar() = (metrosCuadradosAPintar / rendimiento).roundUp()
	method costoTotalPinturaEnLata() = precio * self.cantidadDeLatasAUtilizar()
}

object pinturaPorMayor {
	var property precioLitro = 12
	var property rendimientoLitro = 2
	var property metrosCuadradosAPintar = aldo.superficieTotalAPintar()
	
	method costoTotalPinturaPorMayor() = precioLitro * (metrosCuadradosAPintar / rendimientoLitro).roundUp()
}

object aldo {
	var property ahorros = 11000
	var property metrosCuadradosHabitacion = 20
	var property anchoParedCocina = 1
	var property largoParedCocina = 2
	var property alturaParedCocina = 3.5
	
	method habitacionMetrosCuadradosAPintar() = metrosCuadradosHabitacion
	method cocinaMetrosCuadradosAPintar() = (anchoParedCocina + largoParedCocina ) * 2 * alturaParedCocina
	method superficieTotalAPintar() = self.habitacionMetrosCuadradosAPintar() + self.cocinaMetrosCuadradosAPintar()
	method presupuestoMaximo() = ahorros * 0.20
	method nuevoPresupuestoMaximo(dineroExtra) = (ahorros + dineroExtra) * 0.20
}
