object raul {
	var property tarifaPorMetroCuadrado = 70
	
	method manoDeObra(habitacion) = tarifaPorMetroCuadrado * habitacion.metrosCuadradosAPintar()
	method tarifaTotalPorTrabajoRealizado(habitacion) = self.manoDeObra(habitacion) + pinturaEnLata.costoTotalPinturaEnLata(habitacion) // Delega en el objeto pinturaEnLata los cálculos del costo de la misma
	method tarifaTotalPorTrabajoRealizadoConPinturaAGranel(habitacion) = self.manoDeObra(habitacion) + pinturaPorMayor.costoTotalPinturaPorMayor(habitacion) // En este caso se delegan los cálculos de los costos de pintura a granel en el objeto pinturaPorMayor
}

object carla {
	var property tarifaPorMetroCuadrado = 45
	
	method costoExtraSegunCantidadDeMetrosCuadrado(habitacion) = if (habitacion.metrosCuadradosAPintar() <= 25) 2 else 1.50 
	method tarifaTotalPorTrabajoRealizado(habitacion) = tarifaPorMetroCuadrado * habitacion.metrosCuadradosAPintar() * self.costoExtraSegunCantidadDeMetrosCuadrado(habitacion)
}

object venancio {
	var property tarifaPorMetroCuadrado = 43
	
	method manoDeObra(habitacion) = tarifaPorMetroCuadrado * habitacion.metrosCuadradosAPintar()
	method tarifaTotalPorTrabajoRealizado(habitacion) = self.manoDeObra(habitacion) + 1/2 * pinturaEnLata.costoTotalPinturaEnLata(habitacion)
}

object pinturaEnLata {
	var property precio = 500
	var property rendimiento = 50
	
	method cantidadDeLatasAUtilizar(habitacion) = (habitacion.metrosCuadradosAPintar() / rendimiento).roundUp()
	method costoTotalPinturaEnLata(habitacion) = precio * self.cantidadDeLatasAUtilizar(habitacion)
}

object pinturaPorMayor {
	var property precioLitro = 12
	var property rendimientoLitro = 2
	
	method costoTotalPinturaPorMayor(habitacion) = precioLitro * (habitacion.metrosCuadradosAPintar() / rendimientoLitro).roundUp()
}

/* En todos los objetos antes descriptos se utiliza el método metrosCuadradosAPintar() que pertenece al objeto anónimo 
definido en los test como parte de un "factory method", y aca nombrado como "habitación". Dicho método es polimórfico
ya que más allá de estar definidos con el mismo nombre, responden al mismo mensaje y realizan diferentes acciones de 
acuerdo al contexto en que son llamados. */

object aldo {
	var property ahorros = 11000
	var property anchoParedCocina = 1
	var property largoParedCocina = 2
	var property alturaParedCocina = 3.5	
	var property metrosCuadradosHabitacion = 20
	
	method cocinaMetrosCuadradosAPintar() = (anchoParedCocina + largoParedCocina ) * 2 * alturaParedCocina
	method superficieTotalAPintar() = metrosCuadradosHabitacion + self.cocinaMetrosCuadradosAPintar()
	method presupuestoMaximo() = ahorros * 0.20
	method nuevoPresupuestoMaximo(dineroExtra) = (ahorros + dineroExtra) * 0.20
}
