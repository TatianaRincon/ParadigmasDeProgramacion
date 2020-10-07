object agencia {
	const property contratistas = #{veronica,marcos,francisca,jacques,raul,carla,venancio}
	
	method contratarEmpleado(contratista) = {contratistas.add(contratista)}.apply()
	method despedirEmpleado(contratista) = {contratistas.remove(contratista)}.apply()
	method presupuestoContratistas(contratista,casa) = {contratista.costoPorTrabajo(casa)}.apply()
	method fechaContratacion(contratista) = contratista.fechaContratacion(new Date())
}

object veronica {
	var property fechaContratacion
	var property tarifa = 100000	
	method costoPorTrabajo(casa) = tarifa * casa.pisos()
}

object marcos {
	var property fechaContratacion
	var property tarifa = 50000
	
	method costoPorTrabajo(casa) = tarifa * casa.cantidadAmbientes() + if (casa.esComplicada()) {(tarifa * casa.cantidadAmbientes()) * 0.20} else 0 
}

object francisca {
	var property fechaContratacion
	var property tarifa = 100
	
	method costoPorTrabajo(casa) = if (casa.esComplicada()) {casa.cantidadAmbientes() * 200} else {casa.cantidadAmbientes() * tarifa}
}

object jacques {
	var property fechaContratacion
	var property tarifa = 100
	
	method costoPorTrabajo(casa) = casa.cantidadAmbientes() * tarifa + if (casa.cantidadAmbientes() > 3) {(casa.cantidadAmbientes() * tarifa) * 0.10} else 0
}

object raul {
	var property fechaContratacion
	var property tarifa = 70
	var property precioPintura = pinturaEnLata.precio(casaAldo.superficie()) // Está setteado por default con el precio de pintura en lata para que no de null, pero es fácilmente actualizable utilizando el método usarPintura()
	
	method usarPintura(metrosCuadrados) = {precioPintura = metrosCuadrados}.apply() 
	method manoDeObra(metrosCuadrados) = tarifa * metrosCuadrados
	method costoPorTrabajo(casa) = self.manoDeObra(casa.superficie()) + precioPintura
}

object carla {
	var property fechaContratacion
	var property tarifa = 45
	
	method coeficienteDeSuperficie(metrosCuadrados) = if (metrosCuadrados <= 25) 2 else 1.50 
	method costoPorTrabajo(casa) = tarifa * casa.superficie() * self.coeficienteDeSuperficie(casa.superficie())
}

object venancio {
	var property fechaContratacion
	var property tarifa = 43
	var property precioPintura = pinturaEnLata.precio(casaAldo.superficie())
	
	method usarPintura(metrosCuadrados) = {precioPintura = metrosCuadrados}.apply() 
	method manoDeObra(metrosCuadrados) = tarifa * metrosCuadrados
	method costoPorTrabajo(casa) = self.manoDeObra(casa.superficie()) + 1/2 * precioPintura
}

object pinturaEnLata {
	const precioLata = 500
	const rendimientoLata = 50
	
	method latasNecesarias(metrosCuadrados) = (metrosCuadrados / rendimientoLata).roundUp()
	method precio(metrosCuadrados) = self.latasNecesarias(metrosCuadrados) * precioLata
}

object pinturaPorMayor {
	const precioLitro = 12
	const rendimientoLitro = 2
	
	method precio(metrosCuadrados) = precioLitro * (metrosCuadrados / rendimientoLitro).roundUp()
}

object aldo {
	var property ahorros = 11000
	var property gastos = 0
	const property fechaHoy = new Date()
	const property empleadosContratados = []

	method presupuestoMaximo() = ahorros * 0.20
	method nuevosAhorros(dineroExtra) = {ahorros = ahorros + dineroExtra}.apply()
	method puedeContratarA(contratista) = contratista.costoPorTrabajo(casaAldo) <= self.presupuestoMaximo()
	method contratarServicioDe(contratista) = if (self.puedeContratarA(contratista)) {
		ahorros = ahorros - contratista.costoPorTrabajo(casaAldo);
		agencia.fechaContratacion(contratista);
		empleadosContratados.add(contratista)} else {return "No hay presupuesto suficiente, vas a tener que ahorrar"}	
	method gastosUltimaSemana() = 
		empleadosContratados.map {contratista => if (fechaHoy - contratista.fechaContratacion() <= 7) {
		gastos = gastos + contratista.costoPorTrabajo(casaAldo);
		return gastos} else 0 }
}

object casaAldo {
	var property pisos = 2
	var property ambientes = [habitacion,cocina]
	var property superficies = [habitacion.superficie(),cocina.superficie()]
	
	method esComplicada() = pisos > 2
	method cantidadAmbientes() = ambientes.size()
	method superficie() = superficies.sum()
}

object habitacion {
	method superficie() = 20
}

object cocina {
	const anchoCocina = 1
	const largoCocina = 2
	const alturaCocina = 3.5

	method superficie() = (anchoCocina + largoCocina ) * 2 * alturaCocina
}