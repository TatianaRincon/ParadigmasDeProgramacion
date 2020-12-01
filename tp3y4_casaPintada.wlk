// Agencia y contratistas
object agencia {
	const property contratistas = #{veronica,marcos,francisca,jacques,raul,carla,venancio,viktor,judith,dodain}
	const property clientes = #{aldo,milena,damian,greta,valeria}

	method contratarEmpleado(contratista) = contratistas.add(contratista)
	
	method despedirEmpleado(contratista) = contratistas.remove(contratista)
	
	method presupuestoContratistas(contratista,casa) = contratista.costoPorTrabajo(casa)
	
	method leHizoUnTrabajo(contratista) = clientes.filter {cliente => cliente.listaDeContratados().contains(contratista)}

}	
                           
class Combo {
	const property contratistas = []

	method descuento() = if (contratistas.size().rem(2) == 0) 0.90 else 0.95
	method costoPorTrabajo(casa) = contratistas.sum {contratista => contratista.costoPorTrabajo(casa)}
	method costoTotal(casa) = self.costoPorTrabajo(casa) * self.descuento()
}

class Arquitecto {
	var property tarifa
	
	method costoPorTrabajo(casa) = tarifa * casa.pisos()
}

class MaestroMayorDeObra {
	var property tarifa = numeros.alAzar()
	
	method recargo(casa) = if (casa.esComplicada()) 1.20 else 1
	method costoPorTrabajo(casa) = tarifa * casa.cantidadAmbientes() * self.recargo(casa) 
}

class Albanil {
	var property tarifa = 100
	var property horasPorAmbiente 
	
	method costoPorTrabajo(casa) = horasPorAmbiente * casa.cantidadAmbientes() * tarifa	
}

const veronica = new Arquitecto (tarifa = 100000)

const viktor = new Arquitecto (tarifa = 75000)

const marcos = new MaestroMayorDeObra (tarifa = 50000)

const judith = new MaestroMayorDeObra()

const dodain = new Albanil (horasPorAmbiente = 8)

object francisca {
	
	method tarifa(casa) = if (casa.esComplicada()) 200 else 100
	method costoPorTrabajo(casa) = casa.cantidadAmbientes() * self.tarifa(casa)
}

object jacques {
	var property tarifa = 100
	
	method recargo(casa) = if (casa.cantidadAmbientes() > 3) 1.10 else 1
	method costoPorTrabajo(casa) = casa.cantidadAmbientes() * tarifa * self.recargo(casa)
}

object raul {
	var property tarifa = 70
	var property precioPintura
	
	method usarPintura(pintura,casa) {precioPintura = pintura.costo(casa)} 
	method manoDeObra(casa) = tarifa * casa.superficie()
	method costoPorTrabajo(casa) = self.manoDeObra(casa) + precioPintura
}

object carla {
	var property tarifa = 45
	
	method coeficienteDeSuperficie(casa) = if (casa.superficie() <= 25) 2 else 1.50 
	method costoPorTrabajo(casa) = tarifa * casa.superficie() * self.coeficienteDeSuperficie(casa)
}

object venancio {
	var property tarifa = 43
	var property precioPintura
	
	method usarPintura(pintura,casa) {precioPintura = pintura.costo(casa)} 
	method manoDeObra(casa) = tarifa * casa.superficie()
	method costoPorTrabajo(casa) = self.manoDeObra(casa) + 1/2 * precioPintura
}

// Pinturas
class Pintura {
	var property precio
	var property rendimiento	
	
	method cantidadNecesaria(casa) = (casa.superficie() / rendimiento).roundUp()
	method costo(casa) = self.cantidadNecesaria(casa) * precio 
}

const pinturaEnLata = new Pintura (precio = 500 , rendimiento = 50)
const pinturaPorMayor = new Pintura (precio = 12 , rendimiento = 2)

// Casas y habitaciones
class Casa {
	var property pisos
	var property cantidadAmbientes
	
	method superficie() = 41
	method esComplicada() = pisos > 2
}

object casaAldo inherits Casa(pisos = 2) {
	const property ambientes = [habitacion,cocina]
	
	override method cantidadAmbientes() = ambientes.size()
	override method superficie() = ambientes.sum {ambiente => ambiente.superficie()}
}

const casaDamian = new Casa (pisos = 4, cantidadAmbientes = 4)

object habitacion {
	method superficie() = 20
}

object cocina {
	const anchoCocina = 1
	const largoCocina = 2
	const alturaCocina = 3.5

	method superficie() = (anchoCocina + largoCocina ) * 2 * alturaCocina
}

// Definición de clientes
class Cliente {
	var property ahorros = 11000
	var property gastos = 0
	var property casa = casaAldo
	var property tipoDeCliente = criterioActual
	var property porcentajeParaInvertir = 0.20
	
	method agregarServicioAprobado(contratista) = porcentaje.serviciosAprobados().add(new Servicio( cliente = self, fecha = new Date(), monto = contratista.costoPorTrabajo(casa), contratista = contratista))
	
	method agregarServicioRechazado(contratista) = porcentaje.serviciosRechazados().add(new Servicio( cliente = self, fecha = new Date(), monto = contratista.costoPorTrabajo(casa), contratista = contratista))
	
	method presupuestoMaximo() = ahorros * porcentajeParaInvertir
	
	method nuevosAhorros(dineroExtra) {ahorros = ahorros + dineroExtra}
	
	method puedeContratarA(contratista) = tipoDeCliente.loContrataSi(contratista,casa,self)
	
	method modificarAhorros(contratista) {ahorros = ahorros - contratista.costoPorTrabajo(casa)}
	
	method contratarServicioDe(contratista) = if (self.puedeContratarA(contratista)) {
		self.agregarServicioAprobado(contratista)
		self.modificarAhorros(contratista) } else {
			self.agregarServicioRechazado(contratista)
			throw new DomainException(message = "La contratación no pasó la validación requerida")
		}	
	
	method serviciosAprobados() = porcentaje.serviciosAprobados().filter {servicio => servicio.cliente() == self} 
	
	method serviciosUltimaSemana() = self.serviciosAprobados().filter {servicio => servicio.fecha().between(new Date().minusDays(7), new Date())}
	
	method gastosUltimaSemana() {gastos = gastos + self.serviciosUltimaSemana().sum {servicio => servicio.monto()} }
	
	method listaDeContratados() = self.serviciosAprobados().map {servicio => servicio.contratista()}
	
	method esDescuidado() = self.serviciosAprobados().any {servicio => servicio.monto() > 5000}
}

object aldo inherits Cliente {}

object milena inherits Cliente {}

object greta inherits Cliente {}

object valeria inherits Cliente {}

object damian inherits Cliente (casa = casaDamian, ahorros = 250000) {
	
	override method esDescuidado() = super() && casa.pisos() < 3
}

// Criterios para definir los tipos de clientes

object criterioActual {	
	method loContrataSi(contratista,casa,cliente) = contratista.costoPorTrabajo(casa) <= cliente.presupuestoMaximo()	
}

class Inseguro {
	var property deHumor = false

	method estaDeHumor() {
		deHumor = !deHumor
		return deHumor
	}
	
	method loContrataSi(contratista,casa,cliente) = self.estaDeHumor() && contratista.costoPorTrabajo(casa) <= cliente.ahorros()
}

object derrochon {
	method loContrataSi(contratista,casa,cliente) = contratista.costoPorTrabajo(casa) > cliente.presupuestoMaximo()
}

object complicon {
	method loContrataSi(contratista,casa,cliente) = contratista.costoPorTrabajo(casa) % 7 == 0
}

// Definición de los servicios, números al azar y porcentaje de aprobados (clientes y contratistas)
class Servicio {
	var property cliente
	var property fecha
	var property monto
	var property contratista
}

object numeros {
	var property min = 30000
	var property max = 40000
	
	method alAzar() = min.randomUpTo(max) 
}

object porcentaje {
	const property contratistas = agencia.contratistas()
	const property clientes = agencia.clientes()
	var property serviciosAprobados = []
	var property serviciosRechazados = []
	
	method aprobados(persona) = if (contratistas.contains(persona)) {
		serviciosAprobados.filter {servicio => servicio.contratista() == persona}
		} else {
			serviciosAprobados.filter {servicio => servicio.cliente() == persona}
	}

	method rechazados(persona) = if (contratistas.contains(persona)) {
		serviciosRechazados.filter {servicio => servicio.contratista() == persona}
		} else {
			serviciosRechazados.filter {servicio => servicio.cliente() == persona}
	}
	
	method serviciosSolicitados(persona) = self.aprobados(persona) + self.rechazados(persona)
	
	method reglaTresSimples(persona) = self.aprobados(persona).size() * 100 / self.serviciosSolicitados(persona).size()
	
	method calcularPresupuestosAprobados(persona) = "Tiene un " + self.reglaTresSimples(persona).truncate(2) + "% de presupuestos aprobados." 
}
